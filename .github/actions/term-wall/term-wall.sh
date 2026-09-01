#!/usr/bin/env bash
# term-wall.sh — names this organisation does not use, refused everywhere.
#
# The wall scans a change for names that must not appear here: not
# affirmed, not negated, not cited. It never spells the names it refuses
# — the pattern below would otherwise be its own first hit — and it masks
# every hit it prints, so the log does not carry what the tree may not.
#
# Surfaces, in order:
#   1. tracked file content (case-insensitive, binaries skipped)
#   2. tracked file paths
#   3. the commit messages of the change (PR: base...head; push: before...after)
#   4. the pull request title and body
#   5. the branch name
#
# Exit 0 clean. Exit 1 on any hit. A surface that could not be read is a
# hit too — "could not look" is never "found nothing".
#
# Outside GitHub Actions (no GITHUB_EVENT_PATH) only surfaces 1 and 2 run,
# against the current directory; that is the self-test's mode.
set -uo pipefail

pat='s[c]ient[ _-]?db|u[s]cient'
rc=0
mask() { sed -E "s/($pat)/[forbidden name]/Ig"; }
hit() { printf '::error::term wall: %s\n' "$1"; rc=1; }
scan() {  # scan <surface> <text> — text as an argument, never a pipe: a hit must
          # set rc in this shell, and a pipeline's stages run in subshells.
    local surface=$1 text=$2 found
    found=$(printf '%s\n' "$text" | grep -i -n -E "$pat" 2>/dev/null | mask | head -40 || true)
    if [[ -n $found ]]; then
        printf '%s\n' "$found" | sed "s/^/  $surface: /"
        hit "forbidden name in $surface"
    fi
}

# 1. tracked content
content=$(git ls-files -z 2>/dev/null | xargs -0 -r grep -I -i -n -E "$pat" -- 2>/dev/null || true)
if [[ -n $content ]]; then
    printf '%s\n' "$content" | mask | head -40 | sed 's/^/  content: /'
    hit "forbidden name in tracked content"
fi

# 2. tracked paths
scan "path" "$(git ls-files 2>/dev/null)"

# 3-5. the change itself, when running under Actions
if [[ -n ${GITHUB_EVENT_PATH:-} && -f ${GITHUB_EVENT_PATH:-} ]]; then
    event=${GITHUB_EVENT_NAME:-}
    repo=${GITHUB_REPOSITORY:?GITHUB_REPOSITORY unset}
    case $event in
        pull_request|pull_request_target)
            base=$(jq -r '.pull_request.base.sha' "$GITHUB_EVENT_PATH")
            head=$(jq -r '.pull_request.head.sha' "$GITHUB_EVENT_PATH")
            scan "pull request title/body" "$(jq -r '.pull_request.title, (.pull_request.body // "")' "$GITHUB_EVENT_PATH")"
            scan "branch name" "${GITHUB_HEAD_REF:-}"
            ;;
        push)
            base=$(jq -r '.before' "$GITHUB_EVENT_PATH")
            head=$(jq -r '.after' "$GITHUB_EVENT_PATH")
            scan "branch name" "${GITHUB_REF_NAME:-}"
            ;;
        *)
            base=""; head="";;
    esac
    if [[ -n $head ]]; then
        if [[ -z $base || $base =~ ^0+$ ]]; then
            msgs=$(git log -1 --format=%B "$head" 2>/dev/null) || msgs=""
            [[ -n $msgs ]] || hit "could not read the commit message of $head (UNREACHABLE is not a pass)"
        else
            if ! msgs=$(gh api "repos/$repo/compare/$base...$head?per_page=250" --jq '.commits[].commit.message' 2>/tmp/term-wall.api.err); then
                hit "could not read commit messages $base...$head via the API — $(head -c 200 /tmp/term-wall.api.err) (UNREACHABLE is not a pass)"
                msgs=""
            fi
        fi
        scan "commit messages" "$msgs"
    fi
fi

if [[ $rc -eq 0 ]]; then
    echo "term wall: clean — $(git ls-files 2>/dev/null | wc -l) tracked files, the change's messages, title, body and branch name carry no forbidden name"
fi
exit "$rc"
