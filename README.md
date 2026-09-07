# Book Cricket

The last-bench game from an Indian school in the late 90s: flip to a random page of a rough
notebook, and the last digit of the page number decides the ball. You bat 20 balls against a
bench rival, set a target, then watch him chase it.

One file, no build step, no dependencies. Open `index.html` in a browser and it runs.

## House rules

| Last digit | Outcome |
|---|---|
| 2 / 4 / 6 | that many runs |
| 8 | 1 run — 8 is banned, too lucky |
| 0 | out |
| 1, 3, 5, 7, 9 | dot ball |

Pages run from 10 to 199. Each innings ends at 20 balls or 4 wickets. Your score plus one is
the target.

## Rough book numbers

Every match is stamped with a book number, and that number seeds the page sequence. Book 4821
always deals the same twenty pages in the same order, against the same rival. Open the game with
`?book=4821` and you get that exact match, ball for ball. The teacher interruptions and the
commentary stay random, so a replay still feels live.

Because book cricket involves no skill, a shared book is for replaying and arguing, not for
beating a score — the result is identical for everyone who opens it.

## Publishing

The share button copies a `?book=` link, which needs a real URL to be useful. Opened straight
from disk (`file://`) it falls back to copying just the book number. Turning on GitHub Pages
fixes that:

    Settings -> Pages -> Source: deploy from branch -> main -> / (root)

Your game then lives at `https://<your-username>.github.io/book-cricket/`.

## Scripts

- `./setup-github.sh [repo-name]` — first-time setup: git init, first commit, create the GitHub
  repo, push, and offer to switch on Pages. Needs the GitHub CLI, signed in with `gh auth login`.
- `./autopush.sh` — watches the folder and commits and pushes each time a file changes. Leave it
  running in a terminal tab; Ctrl-C stops it.

## Built with

Vanilla HTML, CSS and JavaScript. Sounds are generated at runtime with the Web Audio API, so
there are no audio files. The share image is drawn on a canvas. Handwriting fonts come from
Google Fonts, with cursive fallbacks so it degrades gracefully offline.
