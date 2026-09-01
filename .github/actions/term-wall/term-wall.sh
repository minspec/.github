#!/usr/bin/env bash
# term-wall.sh — names this organisation does not use, refused everywhere.
#
# The pattern is configuration, never tree content: it is read only from
# the TERM_WALL environment variable (in CI the composite action takes it
# from the org-level Actions variable vars.TERM_WALL). An unset or empty
# pattern is a refusal, exit 2 — the wall never passes vacuously. Every
# hit it prints is masked, so the log does not carry what the tree may not.
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
# [forbidden name]>"; a surface that could not be read (fetch failed,
# payload unreadable) is itself a hit — could-not-look is never a pass.
# Exit 2 refusal: stdout empty, one line on stderr shaped
# "class: expected …; found …; needed …".
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
    || refuse 'worktree: expected to run inside a git work tree; found none; needed a checkout (CI) or a repository directory (local)'

rc=0
mask() { sed -E "s/($pat)/[forbidden name]/Ig"; }

emit() {  # emit <surface> <location> <masked line> — one hit. Called only
          # from the main shell, never from a pipeline stage, so the exit
          # code it sets survives.
    printf '%s: %s: %s\n' "$1" "$2" "$3"
    rc=1
}

scan() {  # scan <surface> <text> — text as an argument, never a pipe: a hit
          # must set rc in this shell, and a pipeline's stages run in subshells.
    local surface=$1 text=$2 found line
    [[ -n $text ]] || return 0
    found=$(printf '%s\n' "$text" | grep -i -n -E -- "$pat" 2>/dev/null | mask || true)
    [[ -n $found ]] || return 0
    while IFS= read -r line; do
        emit "$surface" "${line%%:*}" "${line#*:}"
    done <<< "$found"
}

# 1. tracked content
content=$(git ls-files -z 2>/dev/null | xargs -0 -r grep -I -H -i -n -E -- "$pat" 2>/dev/null | mask || true)
if [[ -n $content ]]; then
    while IFS= read -r line; do
        file=${line%%:*}; rest=${line#*:}
        emit "content" "$file:${rest%%:*}" "${rest#*:}"
    done <<< "$content"
fi

# 2. tracked paths
scan "path" "$(git ls-files 2>/dev/null)"

# 3-5. the change itself, when running under Actions
if [[ -n ${GITHUB_EVENT_PATH:-} && -f ${GITHUB_EVENT_PATH:-} ]]; then
    event=${GITHUB_EVENT_NAME:-}
    base="" head="" want_messages=0
    case $event in
        pull_request|pull_request_target)
            base=$(jq -r '.pull_request.base.sha // empty' "$GITHUB_EVENT_PATH" 2>/dev/null) || base=""
            head=$(jq -r '.pull_request.head.sha // empty' "$GITHUB_EVENT_PATH" 2>/dev/null) || head=""
            if title_body=$(jq -r '.pull_request.title, (.pull_request.body // "")' "$GITHUB_EVENT_PATH" 2>/dev/null); then
                scan "pull request title/body" "$title_body"
            else
                emit "pull request title/body" "$GITHUB_EVENT_PATH" "could not read the event payload (could-not-look is never a pass)"
            fi
            scan "branch name" "${GITHUB_HEAD_REF:-}"
            want_messages=1
            ;;
        push)
            base=$(jq -r '.before // empty' "$GITHUB_EVENT_PATH" 2>/dev/null) || base=""
            head=$(jq -r '.after // empty' "$GITHUB_EVENT_PATH" 2>/dev/null) || head=""
            scan "branch name" "${GITHUB_REF_NAME:-}"
            want_messages=1
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
                    msgs=$(git log -1 --format=%B "$head" 2>/dev/null); log_rc=$?
                else
                    range="$base..$head"
                    msgs=$(git log --format=%B "$base..$head" 2>/dev/null); log_rc=$?
                fi
                if [[ $log_rc -eq 0 ]]; then
                    scan "commit messages" "$msgs"
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
