#!/usr/bin/env bash
# term-wall.sh — names this organisation does not use, refused everywhere.
#
# The pattern is configuration, never tree content: it is read only from
# the TERM_WALL environment variable (in CI the calling step passes it,
# `env: TERM_WALL: ${{ vars.TERM_WALL }}` — a composite action cannot
# read `vars` itself, so the action declares no default). An unset or
# empty pattern is a refusal, exit 2 — the wall never passes vacuously.
# Every hit it prints is masked, so the log does not carry what the tree
# may not.
#
# Surfaces, in order:
#   1. tracked file content — every blob the scanned commit's tree
#      tracks, read from the object store, never from the working tree,
#      and scanned bytewise (case-insensitive): nothing tracked is
#      unscannable. A symlink entry is scanned as the blob it is — its
#      target path text — and never followed. A blob that is not valid
#      UTF-8 reports each hit with "[binary blob]" in place of the line.
#   2. tracked file paths
#   3. the commit messages of the change — pull_request: base..head;
#      push: before..head, or only the head commit when before is all
#      zeros — read from git, fetching what the checkout lacks; never
#      from an API: the action needs no token and declares none
#   4. the pull request title and body (from the event payload)
#   5. the branch name (GITHUB_HEAD_REF for a PR, GITHUB_REF_NAME for a push)
#
# Exit 0 clean, one summary line on stdout. Exit 1 on any hit, every hit
# on stdout as "<surface>: <location>: <line with each match replaced by
# [forbidden name]>" — the location never contains a colon; a surface
# that could not be read (fetch failed, payload unreadable) is itself a
# hit — could-not-look is never a pass. Exit 2 refusal: stdout empty,
# one line on stderr shaped "class: expected …; found …; needed …".
#
# Outside GitHub Actions (no GITHUB_EVENT_PATH) only surfaces 1 and 2
# run, against the current directory.
set -uo pipefail

refuse() { printf '%s\n' "$1" >&2; exit 2; }

pat=${TERM_WALL:-}
[[ -n $pat ]] || refuse 'pattern: expected TERM_WALL set; found empty; needed the org variable (CI) or ops/bin/term-wall.conf (local)'

# A pattern grep or sed cannot use would make every scan silently vacuous
# and could leak raw text past the mask — refuse it up front.
printf '' | grep -i -E -- "$pat" >/dev/null 2>&1
[[ $? -le 1 ]] || refuse 'pattern: expected TERM_WALL to be an extended regular expression grep accepts; found one it rejects; needed a working pattern in the org variable (CI) or ops/bin/term-wall.conf (local)'
printf '' | sed -E "s/($pat)/[forbidden name]/Ig" >/dev/null 2>&1 \
    || refuse 'pattern: expected TERM_WALL usable in a sed substitution; found one sed rejects (an unescaped "/"?); needed a working pattern in the org variable (CI) or ops/bin/term-wall.conf (local)'

git rev-parse --is-inside-work-tree >/dev/null 2>&1 \
    || refuse 'git work tree: expected to run inside a git work tree; found none; needed a checkout (CI) or a repository directory (local)'

rc=0
mask() { sed -E "s/($pat)/[forbidden name]/Ig"; }

emit() {  # emit <surface> <location> <masked line> — one hit. Called only
          # from the main shell, never from a pipeline stage, so the exit
          # code it sets survives.
    printf '%s: %s: %s\n' "$1" "$2" "$3"
    rc=1
}

scan() {  # scan <surface> <location prefix> <text> — text as an argument,
          # never a pipe: a hit must set rc in this shell, and a pipeline's
          # stages run in subshells. Each hit's location is
          # "<prefix>line <n>".
    local surface=$1 prefix=$2 text=$3 found line
    [[ -n $text ]] || return 0
    found=$(printf '%s\n' "$text" | grep -i -n -E -- "$pat" 2>/dev/null | mask || true)
    [[ -n $found ]] || return 0
    while IFS= read -r line; do
        emit "$surface" "${prefix}line ${line%%:*}" "${line#*:}"
    done <<< "$found"
}

scan_name() {  # scan_name <surface> <value> — for surfaces whose location
               # is the (masked) value itself: a path, a branch name.
    local surface=$1 value=$2 masked
    [[ -n $value ]] || return 0
    printf '%s\n' "$value" | grep -i -E -- "$pat" >/dev/null 2>&1 || return 0
    masked=$(printf '%s\n' "$value" | mask)
    emit "$surface" "$masked" "$masked"
}

# 1. tracked content — every blob of the scanned commit's tree, from the
#    object store, bytewise (grep -a, never -I). A symlink entry (mode
#    120000) is a blob holding its target path and is never followed; a
#    gitlink (type commit) is not a blob and has no content here. A blob
#    the wall cannot read is a refusal — could-not-look is never a pass.
if git rev-parse -q --verify 'HEAD^{commit}' >/dev/null 2>&1; then
    git ls-tree -r HEAD >/dev/null 2>&1 \
        || refuse 'git work tree: expected a readable tree at HEAD; found git ls-tree cannot read it; needed the object'
    while IFS= read -r -d '' entry; do
        meta=${entry%%$'\t'*}
        path=${entry#*$'\t'}
        read -r _mode type oid <<< "$meta"
        [[ $type == blob ]] || continue
        if ! err=$(git cat-file -e "$oid" 2>&1); then
            err=$(printf '%s' "${err:-git cat-file cannot read $oid}" | tr '\n' ' ')
            refuse "$(printf 'git work tree: expected a readable blob at %s; found %s; needed the object' "$path" "$err" | mask)"
        fi
        if git cat-file blob "$oid" 2>/dev/null | iconv -f UTF-8 -t UTF-8 >/dev/null 2>&1; then
            # NUL is valid UTF-8 (U+0000) but a shell variable cannot hold
            # it — drop it before masking, never after.
            found=$(git cat-file blob "$oid" 2>/dev/null | grep -a -i -n -E -- "$pat" | tr -d '\000' | mask || true)
            [[ -n $found ]] || continue
            while IFS= read -r line; do
                emit "content" "$path line ${line%%:*}" "${line#*:}"
            done <<< "$found"
        else
            # Not valid UTF-8: never echo its bytes — only line numbers
            # (newline-separated segments, from 1) and "[binary blob]".
            found=$(git cat-file blob "$oid" 2>/dev/null | grep -a -i -n -E -- "$pat" | cut -d: -f1 || true)
            [[ -n $found ]] || continue
            while IFS= read -r n; do
                emit "content" "$path line $n" "[binary blob]"
            done <<< "$found"
        fi
    done < <(git ls-tree -r -z HEAD 2>/dev/null)
fi

# 2. tracked paths
paths=$(git ls-files 2>/dev/null | grep -i -E -- "$pat" 2>/dev/null | mask || true)
if [[ -n $paths ]]; then
    while IFS= read -r line; do
        emit "path" "$line" "$line"
    done <<< "$paths"
fi

# 3-5. the change itself, when running under Actions
if [[ -n ${GITHUB_EVENT_PATH:-} && -f ${GITHUB_EVENT_PATH:-} ]]; then
    event=${GITHUB_EVENT_NAME:-}
    payload_ok=1
    jq empty "$GITHUB_EVENT_PATH" >/dev/null 2>&1 || payload_ok=0
    if [[ $payload_ok -eq 0 ]]; then
        emit "event payload" "$GITHUB_EVENT_PATH" "could not read the event payload (could-not-look is never a pass)"
    fi
    base="" head="" want_messages=0
    case $event in
        pull_request|pull_request_target)
            if [[ $payload_ok -eq 1 ]]; then
                base=$(jq -r '.pull_request.base.sha // empty' "$GITHUB_EVENT_PATH" 2>/dev/null) || base=""
                head=$(jq -r '.pull_request.head.sha // empty' "$GITHUB_EVENT_PATH" 2>/dev/null) || head=""
                scan "pull request title" "" "$(jq -r '.pull_request.title // ""' "$GITHUB_EVENT_PATH" 2>/dev/null)"
                scan "pull request body" "" "$(jq -r '.pull_request.body // ""' "$GITHUB_EVENT_PATH" 2>/dev/null)"
                want_messages=1
            fi
            scan_name "branch name" "${GITHUB_HEAD_REF:-}"
            ;;
        push)
            if [[ $payload_ok -eq 1 ]]; then
                base=$(jq -r '.before // empty' "$GITHUB_EVENT_PATH" 2>/dev/null) || base=""
                head=$(jq -r '.after // empty' "$GITHUB_EVENT_PATH" 2>/dev/null) || head=""
                want_messages=1
            fi
            scan_name "branch name" "${GITHUB_REF_NAME:-}"
            ;;
    esac
    if [[ $want_messages -eq 1 ]]; then
        only_head=0
        [[ $event == push && ( -z $base || $base =~ ^0+$ ) ]] && only_head=1
        if [[ -z $head || ( $only_head -eq 0 && -z $base ) ]]; then
            emit "commit messages" "$event" "could not resolve the change's commits from the event payload (could-not-look is never a pass)"
        else
            refs=("$head"); [[ $only_head -eq 0 ]] && refs=("$base" "$head")
            # Fetch what the checkout lacks; a shallow clone would walk a
            # truncated history without erroring, so unshallow it.
            shallow=$(git rev-parse --is-shallow-repository 2>/dev/null) || shallow=false
            missing=0
            for ref in "${refs[@]}"; do
                git cat-file -e "$ref^{commit}" 2>/dev/null || missing=1
            done
            fetch_failed=0
            if [[ $shallow == true || $missing -eq 1 ]]; then
                fetch_opts=(--no-tags --quiet)
                [[ $shallow == true ]] && fetch_opts+=(--unshallow)
                if ! fetch_err=$(git fetch "${fetch_opts[@]}" origin "${refs[@]}" 2>&1); then
                    emit "commit messages" "${refs[*]}" "could not fetch the change from origin — $(printf '%s' "$fetch_err" | mask | tr '\n' ' ' | head -c 300) (could-not-look is never a pass)"
                    fetch_failed=1
                fi
            fi
            if [[ $fetch_failed -eq 0 ]]; then
                if [[ $only_head -eq 1 ]]; then
                    range=$head
                    shas=$(git rev-list -n 1 "$head" 2>/dev/null); list_rc=$?
                else
                    range="$base..$head"
                    shas=$(git rev-list "$base..$head" 2>/dev/null); list_rc=$?
                fi
                if [[ $list_rc -eq 0 ]]; then
                    while IFS= read -r sha; do
                        [[ -n $sha ]] || continue
                        if msg=$(git log -1 --format=%B "$sha" 2>/dev/null); then
                            scan "commit messages" "${sha:0:12} " "$msg"
                        else
                            emit "commit messages" "${sha:0:12}" "could not read the commit message from git (could-not-look is never a pass)"
                        fi
                    done <<< "$shas"
                else
                    emit "commit messages" "$range" "could not read the commit messages from git (could-not-look is never a pass)"
                fi
            fi
        fi
    fi
fi

if [[ $rc -eq 0 ]]; then
    echo "term wall: clean — $(git ls-files 2>/dev/null | wc -l) tracked files, their paths, and the change's messages, title, body and branch name carry no forbidden name"
fi
exit "$rc"
