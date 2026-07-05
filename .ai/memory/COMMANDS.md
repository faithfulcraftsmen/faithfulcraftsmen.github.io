# Commands

How to build, test, and operate this repo.

## Local development (Astro)

```powershell
npm install
npm run dev        # local dev server
npm run build      # production build (must pass before merging to main)
npm run preview    # preview the production build locally
```

## Load session secrets

```powershell
. E:\git\platform\scripts\Load-HCSEnvironment.ps1
```

## Photo intake pipeline (planned — Workstream A)

```powershell
# Drop raw photos into intake/<slug>/, then run:
pwsh scripts/Optimize-Intake.ps1
```

Converts/resizes to `.webp` (long edge ~1600px + a smaller card variant), strips EXIF,
and writes to `public/projects/<slug>/` (and/or `public/store/<slug>/`). Prints the exact
`heroImage:` path to paste into frontmatter. **Not yet implemented** — see
`.ai/state/CURRENT_TASK.md` and the project plan in `pmo/`.

## Etsy listing sync (planned — Workstream B)

```powershell
# Requires ETSY_API_KEY in the environment (KV locally; GitHub Actions secret in CI).
pwsh scripts/Sync-EtsyListings.ps1
```

Calls the Etsy Open API v3 (`getListingsByShop`, `getListingImages`) and generates one
markdown file per active listing into `src/content/store/`, downloading hero images to
`public/store/<listing_id>/`. Removes stale files so delistings drop off. Intended to run
as a CI step before `astro build`, on a daily cron. **Not yet implemented.**

## Commits

`type(scope): short description` with an `AB#<id>` reference. Types: `feat`, `fix`, `docs`,
`chore`, `refactor`, `test`.

## Deploy

Push to `main` triggers `.github/workflows/deploy.yml`, which builds and publishes to
GitHub Pages at `www.faithfulcraftsmen.com`. This is a production deployment — do not push
to `main` without explicit user confirmation.
