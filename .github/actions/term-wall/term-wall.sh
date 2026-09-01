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
#   1. tracked file content (case-insensitive, binaries skipped)
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

# 1. tracked content
content=$(git ls-files -z 2>/dev/null | xargs -0 -r grep -I -H -i -n -E -- "$pat" 2>/dev/null | mask || true)
if [[ -n $content ]]; then
    while IFS= read -r line; do
        file=${line%%:*}; rest=${line#*:}
        emit "content" "$file line ${rest%%:*}" "${rest#*:}"
    done <<< "$content"
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
