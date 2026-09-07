#!/usr/bin/env bash
# First-time setup: turn this folder into a git repo and put it on GitHub.
# Run once:  ./setup-github.sh            (repo named book-cricket)
#            ./setup-github.sh my-name    (repo named my-name)

set -euo pipefail
cd "$(dirname "$0")"

REPO="${1:-book-cricket}"
VISIBILITY="${VISIBILITY:-public}"   # VISIBILITY=private ./setup-github.sh

command -v git >/dev/null || { echo "git is not installed."; exit 1; }
if ! command -v gh >/dev/null; then
  cat <<'MSG'
The GitHub CLI (gh) is not installed. Either install it:

  macOS:    brew install gh
  Windows:  winget install GitHub.cli
  Linux:    see https://github.com/cli/cli#installation

...or create the repo yourself on github.com and connect it by hand:

  git init -b main
  git add -A && git commit -m "Book Cricket"
  git remote add origin https://github.com/<you>/<repo>.git
  git push -u origin main
MSG
  exit 1
fi

# gh prompts for sign-in in its own browser flow; nothing is typed here.
gh auth status >/dev/null 2>&1 || { echo "Sign in first:  gh auth login"; exit 1; }

if [ -d .git ]; then
  echo "This folder is already a git repo. Nothing to set up."
else
  git init -b main
  git add -A
  git commit -m "Book Cricket: rough book, 1998"
fi

if git remote get-url origin >/dev/null 2>&1; then
  echo "A remote called origin already exists: $(git remote get-url origin)"
  git push -u origin main
else
  gh repo create "$REPO" --"$VISIBILITY" --source=. --remote=origin --push
fi

SLUG="$(gh repo view --json nameWithOwner -q .nameWithOwner)"

echo
echo "Done. Repo: https://github.com/$SLUG"
echo
echo "To put it online, connect the repo to Netlify: netlify.com -> Add new site ->"
echo "Import an existing project. There is no build command and the publish"
echo "directory is the repo root; every push to main then deploys itself."
echo
echo "For hands-off commits, run:  ./autopush.sh"
