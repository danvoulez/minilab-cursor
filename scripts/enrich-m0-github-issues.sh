#!/usr/bin/env bash
# Apply bodies from scripts/m0-issue-bodies/issue-N.md to GitHub issues 1–17.
# Usage: ./scripts/enrich-m0-github-issues.sh [repo default: danvoulez/minilab-cursor]

set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO="${1:-danvoulez/minilab-cursor}"

for n in $(seq 1 17); do
  f="$ROOT/scripts/m0-issue-bodies/issue-${n}.md"
  if [[ ! -f "$f" ]]; then
    echo "Missing $f" >&2
    exit 1
  fi
  gh issue edit "$n" -R "$REPO" --body-file "$f"
  echo "Updated issue #$n"
done

echo "Done: $REPO issues 1–17"
