#!/usr/bin/env bash
# Watch this folder and push to GitHub whenever a file changes.
# Run it in a spare terminal tab:  ./autopush.sh     (Ctrl-C to stop)
#
# Needs a file watcher:
#   macOS:  brew install fswatch
#   Linux:  sudo apt install inotify-tools
# Without one it falls back to polling every 10 seconds.

set -uo pipefail
cd "$(dirname "$0")"

DEBOUNCE="${DEBOUNCE:-2}"   # seconds to wait after a change, so a burst of saves is one commit

[ -d .git ] || { echo "Not a git repo yet. Run ./setup-github.sh first."; exit 1; }
git remote get-url origin >/dev/null 2>&1 || { echo "No origin remote. Run ./setup-github.sh first."; exit 1; }

BRANCH="$(git symbolic-ref --short HEAD 2>/dev/null || echo main)"

push_if_changed() {
  git add -A
  if git diff --cached --quiet; then
    return 0
  fi
  local files
  files="$(git diff --cached --name-only | head -3 | paste -sd', ' -)"
  git commit -q -m "Update ${files} ($(date '+%d %b %H:%M'))"
  if git push -q origin "$BRANCH" 2>/dev/null; then
    echo "$(date '+%H:%M:%S')  pushed: ${files}"
  else
    echo "$(date '+%H:%M:%S')  committed, but the push failed. Check your connection, then: git push"
  fi
}

echo "Watching $(pwd) -> origin/$BRANCH. Ctrl-C to stop."
push_if_changed

if command -v fswatch >/dev/null 2>&1; then
  fswatch -o -r --exclude '\.git' . | while read -r _; do
    sleep "$DEBOUNCE"; push_if_changed
  done
elif command -v inotifywait >/dev/null 2>&1; then
  while inotifywait -qq -r -e modify,create,delete,move --exclude '\.git' .; do
    sleep "$DEBOUNCE"; push_if_changed
  done
else
  echo "(no file watcher found, polling every 10s)"
  while true; do sleep 10; push_if_changed; done
fi
