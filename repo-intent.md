# Repo intent — faithfulcraftsmen.github.io

**The public website for Faithful Craftsmen, a family woodworking business.**

## What this repo is

An Astro 5 static site — portfolio, blog, and an Etsy-linked shop — published via
GitHub Pages at www.faithfulcraftsmen.com. Built on the Astrofy template with
Tailwind CSS + daisyUI (a custom "wood" theme alongside standard light/dark).

## Shape

- Content collections: `blog`, `projects`, `store`
- MDX, sitemap, RSS, and Astro image optimization (sharp)
- `scripts/` — PowerShell automation, including an Etsy sync that reads secrets via
  the HCS environment loader
- `pmo/` — the active project plan
- Deployed by `.github/workflows/deploy.yml` on push to `main`

## What this repo is not

- Not a shop backend — Etsy is the actual store; this site links to/syncs with it,
  it doesn't run commerce itself

## Status

Active. Governed by the standard AGENTS.md/CLAUDE.md agent-instruction pair, same
pattern used across the rest of the HCS-adjacent estate.

## Where things are

- `pmo/` — current plan
- `AGENTS.md` (imported by `CLAUDE.md`) — agent instructions
