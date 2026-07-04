# Decisions

## Stay on Astro (no replatform)

- **Decision:** keep the existing Astro 5 (Astrofy-derived) stack — content collections,
  daisyUI `wood` theme, Tailwind, sitemap, RSS, `astro:assets` — rather than replatforming.
- **Why:** it is already an ideal, zero-cost stack for a photo-driven portfolio + Etsy-linked
  shop on GitHub Pages. The `store` collection with `checkoutUrl`/`pricing` and "Buy Now"
  buttons already exists; it only needs to be finished and wired, not rebuilt.
- **Date:** 2026-07-04

## Etsy integration: build-time full-catalog sync via API key, static, with fallback

- **Decision:** mirror the entire active Etsy catalog via a build-time sync
  (`scripts/Sync-EtsyListings.ps1`) against the Etsy Open API v3 `getListingsByShop`
  endpoint using an app **API keystring** (`x-api-key`), not per-user OAuth. Generated
  markdown lands in `src/content/store/` at build time (ephemeral, not committed).
  Documented, non-default fallbacks: the public Etsy shop RSS feed (10-item cap) or
  manual featured cards, if API-key-only reads turn out to be insufficient for this shop.
- **Why:** keeps the site static (no backend, no committed secrets) while still reflecting
  "everything we have in Etsy" rather than a hand-picked subset. API-key auth (vs OAuth)
  is what makes an unattended CI build viable.
- **Date:** 2026-07-04

## Photos feed projects first, shop second, via a gitignored intake folder

- **Decision:** raw phone photos are dropped into a gitignored `intake/<slug>/` folder at
  repo root, processed by `scripts/Optimize-Intake.ps1` (resize/convert to `.webp`, strip
  EXIF) into `public/projects/<slug>/` (and/or `public/store/<slug>/`), then reviewed and
  committed. The portfolio (`projects` collection) is the primary consumer of photos; the
  shop is secondary.
- **Why:** a "drop it and forget it" workflow that never bloats the repo or the build with
  raw, unoptimized originals, and keeps the projects/portfolio content authentic (fixing
  known gaps like `custom-bowls.md`'s mismatched hero image — see `GOTCHAS.md`).
- **Date:** 2026-07-04

## Email via Cloudflare Email Routing, forwarding to kris@hybridsolutions.cloud

- **Decision:** create `shop@`, `hello@`, `contact@`, and a catch-all rule on
  `faithfulcraftsmen.com` via Cloudflare Email Routing, all forwarding to
  `kris@hybridsolutions.cloud`. `shop@` registers the Etsy store; `hello@` is wired into
  the site's contact page and footer.
- **Why:** free, no mailbox to run, keeps a single real inbox as the destination while
  giving the business dedicated, professional-looking addresses. Requires the domain to
  already be on Cloudflare with Email Routing available — confirm before applying (see
  `.ai/state/OPEN_QUESTIONS.md`).
- **Date:** 2026-07-04
