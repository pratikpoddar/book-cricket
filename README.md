# Book Cricket

The last-bench game from an Indian school in the late 90s: flip to a random page of a rough
notebook, and the last digit of the page number decides the ball. You bat 20 balls against a
bench rival, set a target, then watch him chase it.

Play it: **https://bookcricketindia.netlify.app/**

One HTML file, no build step, no framework. Open `index.html` in a browser and it runs.
(`preview.png` sits alongside it purely so shared links get a picture.)

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

Your own matches leave the URL alone, so every visit and every reload deals a fresh book. Only a
link somebody sent you replays a fixed one, and hitting Rematch drops the number from the URL —
you are back to new books from then on.

Because book cricket involves no skill, a shared book is for replaying and arguing, not for
beating a score — the result is identical for everyone who opens it.

## Publishing

The live game is on Netlify at https://bookcricketindia.netlify.app/. There is nothing to build —
Netlify serves the folder as it stands, with the repo root as the publish directory. With the
site connected to this repo, a push to `main` is the whole deploy.

The share button copies a `?book=` link, which needs a real URL to be useful — from the live
site it copies something like `https://bookcricketindia.netlify.app/?book=8541`. Opened straight
from disk (`file://`) it falls back to copying just the book number.

Because sharing is the only way anybody arrives, the page carries Open Graph and Twitter card
tags so those links unfurl into a preview in WhatsApp, iMessage, Slack and X instead of showing
a bare URL. When the scorecard is shared through the Web Share API the link travels in the `url`
field rather than inline in the caption — pasted as text it unfurls into a second preview card,
so the message arrived carrying two images. Platforms that will not take `url` alongside a file
fall back to the inline link, so it is never dropped, and the clipboard copy always keeps it
inline because a pasted message has no `url` field. The preview art is `preview.png` (1200x630). The tags hardcode the Netlify origin,
so if the site ever moves, `og:image`, `og:url` and `twitter:image` in the `<head>` need the new
one — a relative path will not do, unfurlers require absolute URLs.

## Scripts

- `./setup-github.sh [repo-name]` — first-time setup: git init, first commit, create the GitHub
  repo and push. Already done for this repo, so it now exits early and does nothing. Needs the
  GitHub CLI, signed in with `gh auth login`.
- `./autopush.sh` — watches the folder and commits and pushes each time a file changes. Leave it
  running in a terminal tab; Ctrl-C stops it.

## Built with

Vanilla HTML, CSS and JavaScript. Sounds are generated at runtime with the Web Audio API, so
there are no audio files. The share image is drawn on a canvas. Handwriting fonts come from
Google Fonts, with cursive fallbacks so it degrades gracefully offline.

Hit counts come from [GoatCounter](https://www.goatcounter.com) — one async script, no cookies
and no personal data, so there is nothing to put a consent banner in front of. Stats live at
`https://pratikpoddar.goatcounter.com`.
