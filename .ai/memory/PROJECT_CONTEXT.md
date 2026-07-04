# Project context

**faithfulcraftsmen.github.io** is the public-facing static site for the Faithful
Craftsmen family — a woodworking portfolio and Etsy-linked shop run by the Turner sons.
It is a real product repo (not a platform/hub repo): it ships application code and
deploys to production on every push to `main`.

## Stack

- **Astro 5** (built on the Astrofy template — `package.json` still carries the
  upstream template's name/description; that is a known gap, see `GOTCHAS.md`).
- **Content collections** (`src/content/config.ts`, Zod-validated): `blog`, `projects`,
  `store`.
- **Styling:** Tailwind CSS + daisyUI, including a custom `wood` theme.
- **Images:** intended to go through `astro:assets` (`<Image>`); several pages still use
  raw `<img>` — see `GOTCHAS.md`.
- **Integrations wired in `astro.config.mjs`:** `@astrojs/mdx`, `@astrojs/sitemap`,
  `@astrojs/tailwind`. `site` is set to `https://www.faithfulcraftsmen.com`.
- **Deploy:** GitHub Pages via `.github/workflows/deploy.yml`, triggered on push to
  `main`. Custom domain is `www.faithfulcraftsmen.com` (no `public/CNAME` committed yet
  — see `GOTCHAS.md`).

## Collections

- `blog` (`src/content/blog/`) — posts, `pubDate`, optional `heroImage`/`badge`/`tags`.
- `projects` (`src/content/projects/`) — the portfolio: pens, bowls, toys, keepsake
  boxes, name puzzles, board games. Optional `heroImage`/`badge`/`tags`.
- `store` (`src/content/store/`) — designed for Etsy-style listings (`pricing`,
  `checkoutUrl`, `custom_link`), currently populated only with Lorem-ipsum demo items
  and **not wired** into `src/pages/store/index.astro` (see `GOTCHAS.md`).

## Current initiative

Executing **`pmo/PROJECT-PLAN-2026-07-etsy-photos-email-standards.md`** (approved
2026-07-04, owner Kristopher Turner). Five workstreams:

1. **Photo intake pipeline** — a gitignored `intake/` drop folder + `scripts/Optimize-Intake.ps1`
   to turn raw photos into optimized `.webp` assets that feed the projects/portfolio first.
2. **Etsy integration** — build-time full-catalog sync via `scripts/Sync-EtsyListings.ps1`
   (Etsy Open API v3, API-key auth) to wire the `store` collection to the real shop,
   static, with a documented RSS/manual fallback.
3. **Cloudflare email aliases** on `faithfulcraftsmen.com` (`shop@`, `hello@`, `contact@`,
   catch-all), forwarding to `kris@hybridsolutions.cloud`.
4. **HCS standards compliance** — this workstream: `AGENTS.md`, the `CLAUDE.md` shim,
   the `.ai/` workspace, `LICENSE`/`README.md` fixes, PS7 script headers, CI validation,
   `public/CNAME`.
5. **Design/content polish** — folds in the pre-existing `TODO.md` branding backlog.

See the full plan for sequencing, decisions, and the progress tracker:
`pmo/PROJECT-PLAN-2026-07-etsy-photos-email-standards.md`.
