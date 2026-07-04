# Faithful Craftsmen — Site Upgrade, Etsy Integration, Email & Standards Plan

> **Status:** Active — approved 2026-07-04. This is the committed working copy of the project plan.
> Owner: Kristopher Turner (kris@hybridsolutions.cloud). Track work as ADO items (`AB#`) per workstream.

---

## Context

We have a growing library of photos of handmade work by the Turner sons (pens, toys, bowls, boxes,
puzzles, board games). Two needs drive this effort:

1. **The photos are the core asset** — they feed the **projects/portfolio** first, and the **shop**
   second. There must be a low-friction "drop photos here" intake that doesn't clutter the repo.
2. **The shop should mirror the full Etsy catalog** ("everything we have in Etsy"), not a hand-picked
   few, and link out to Etsy for checkout — while the site stays static, free (GitHub Pages), and
   family-friendly.

Alongside that: create **Cloudflare email aliases** on `faithfulcraftsmen.com` (a dedicated address to
register the Etsy store and a public contact address), and bring the repo into **full compliance** with
HCS platform standards. The existing `TODO.md` design/branding items are folded in (see the tracker
at the end of this document).

**Framework decision — stay on Astro.** The repo is Astro 5 (Astrofy template) with content
collections, daisyUI (incl. a custom `wood` theme), Tailwind, sitemap, RSS, and `astro:assets` image
optimization already wired. This is an ideal, zero-cost stack for a photo-driven portfolio + Etsy-linked
shop on GitHub Pages. A `store` content collection with `checkoutUrl`/`pricing` fields and "Buy Now"
buttons **already exists but is disconnected**. This work *finishes what's here* — no replatform.

---

## Decisions locked

| Topic | Decision |
|---|---|
| Framework | **Stay on Astro 5** — no replatform |
| Etsy display | Mirror the **full Etsy catalog** (all active listings), auto-synced at build. Photos also feed projects/portfolio independently. |
| Email aliases | `hello@` / `contact@`, `shop@`, plus a **catch-all** on `faithfulcraftsmen.com` |
| Mail forwards to | `kris@hybridsolutions.cloud` |
| Standards scope | **Full compliance** (AGENTS.md, CLAUDE.md shim, `.ai/` workspace, LICENSE, README, PS7 headers, package.json, CI validation) |

---

## Workstream A — Photo intake pipeline (feeds projects + shop)

**Goal:** a "drop it and forget it" folder that never bloats the repo or the build, and a one-command
step that turns raw phone photos into optimized, correctly-placed `.webp` assets.

- **Gitignored intake folder** `intake/` at repo root (raw drop zone, lives only on disk).
  - `.gitignore`: `intake/*` + `!intake/README.md` so the folder + README are tracked but raw photos
    are never committed. Astro only builds `src/` and `public/`, so a root `intake/` is invisible to the
    build — it "won't get in the way."
  - `intake/README.md` documents the workflow (drop photos into `intake/<slug>/`, run the script, review,
    commit).
- **`scripts/Optimize-Intake.ps1`** (PowerShell 7, HCS header):
  - Reads each `intake/<slug>/` subfolder, converts/resizes to `.webp` (long edge ~1600px + a smaller
    card variant), strips EXIF, writes to `public/projects/<slug>/` (and/or `public/store/<slug>/`).
  - Uses `sharp` (already a dependency) via a small Node helper.
  - Prints the exact `heroImage:` path to paste into frontmatter.
- **Fix existing image gaps:** `custom-bowls.md` heroImage wrongly points at `custom-pen/pen1.webp` and
  its copy is pen text; `custom-bowls` and `wooden-toys` have no image folder; replace root placeholders
  (`itemPreview.webp`, `post_img.webp`, `profile.webp`).
- **Normalize rendering:** switch `src/pages/projects/[slug].astro` and `src/pages/index.astro` from raw
  `<img>` to `astro:assets` `<Image>`.

**Key files:** `intake/README.md`, `scripts/Optimize-Intake.ps1`, `.gitignore`,
`src/content/projects/custom-bowls.md`, `src/pages/projects/[slug].astro`, `src/pages/index.astro`.

---

## Workstream B — Etsy store integration (mirror full catalog, static)

**Goal:** `/store` reflects the **entire Etsy shop**, auto-updates, and every item deep-links to its Etsy
listing — no backend, no committed secrets.

**Approach — build-time sync via Etsy Open API v3 (read-only, API-key auth).** `getListingsByShop`
(state=active) returns public listings with just an app **API keystring** (`x-api-key`) — no per-user
OAuth, which makes a static/CI build viable.

- **`scripts/Sync-EtsyListings.ps1`** (PowerShell 7, HCS header): reads `ETSY_API_KEY` from env (KV
  locally; GitHub Actions **secret** in CI). Calls `getListingsByShop` + `getListingImages`, generates
  one markdown file per active listing into `src/content/store/` (title, description, `pricing`,
  `heroImage` downloaded to `public/store/<listing_id>/`, `checkoutUrl` = Etsy listing URL). Removes
  stale files so delistings drop off.
- **Wire the store page:** replace the "coming soon" block in `src/pages/store/index.astro` with
  `getCollection("store")` → `HorizontalCard.astro` (already renders a "Buy Now" from `checkoutUrl`).
  Create `src/pages/store/[slug].astro` → the already-built `StoreItemLayout.astro`. Delete the
  Lorem-ipsum demos `src/content/store/item{1,2,3}.md`.
- **Schema fix:** add `featured: z.boolean().optional()` to `projectSchema` **and** `blogSchema` in
  `src/content/config.ts` (pages read `.data.featured` but Zod strips it today).
- **Refresh cadence:** scheduled GitHub Actions run (daily `cron`) rebuilds so new Etsy items appear.
  Sync runs as a CI step **before** `astro build`; generated content is ephemeral (not committed).

**Fallbacks (documented, not default):** public RSS `etsy.com/shop/<shop>/rss` (newest ~10) if the
API-key path is unavailable; manual featured cards always remain available.

**Prerequisite:** register a free Etsy developer app for the API keystring; confirm exact shop name/URL.

**Key files:** `scripts/Sync-EtsyListings.ps1`, `src/pages/store/index.astro`,
`src/pages/store/[slug].astro`, `src/content/config.ts`, `.github/workflows/deploy.yml`,
delete `src/content/store/item{1,2,3}.md`.

---

## Workstream C — Cloudflare email aliases (`faithfulcraftsmen.com`)

**Goal:** a dedicated store address + public contact address, forwarding to `kris@hybridsolutions.cloud`.

> Requires the domain on Cloudflare with Email Routing enabled. Creating aliases is an external-service
> change → **confirm before applying**.

| Alias | Type | Forwards to |
|---|---|---|
| `shop@faithfulcraftsmen.com` | Custom address | `kris@hybridsolutions.cloud` |
| `hello@faithfulcraftsmen.com` | Custom address | `kris@hybridsolutions.cloud` |
| `contact@faithfulcraftsmen.com` | Custom address | `kris@hybridsolutions.cloud` |
| *(any other)* | **Catch-all** → forward | `kris@hybridsolutions.cloud` |

Steps: verify `kris@hybridsolutions.cloud` as a destination address → onboard the domain (Cloudflare adds
MX + SPF + DKIM) → create the three custom rules → enable catch-all. Then register the Etsy store with
`shop@`, and point the site's contact page/footer at `hello@`.

- **Site wiring:** update `src/pages/contact.astro` and `src/components/Footer.astro` to use
  `hello@faithfulcraftsmen.com`.

**Key files:** `src/pages/contact.astro`, `src/components/Footer.astro`; Cloudflare dashboard actions.

---

## Workstream D — HCS standards: full compliance

| # | Gap | Fix |
|---|---|---|
| 1 | No `AGENTS.md` | Add `AGENTS.md` with the MCP-first block (canonical multi-model layout) |
| 2 | `CLAUDE.md` is a full context doc | Convert to a thin shim delegating to `AGENTS.md` / `.ai/` |
| 3 | No `.ai/` workspace | Create the 8-file `.ai/` session-protocol workspace incl. `.ai/state/CURRENT_TASK.md` |
| 4 | `LICENSE` wrong holder | `Copyright (c) 2022 Manuel Ernesto Garcia` → Kristopher Turner / Hybrid Cloud Solutions LLC (keep MIT) |
| 5 | `README.md` unfinished template | Fill all `{{placeholders}}`; real prerequisites (Node 20, npm), quick start, resolve License to MIT |
| 6 | Hook scripts lack PS7 header | Add `#Requires -Version 7.0`, `Set-StrictMode -Version Latest`, `$ErrorActionPreference = 'Stop'` to every `.claude/hooks/*.ps1` and new `scripts/*.ps1` |
| 7 | Hooks on disk but not wired | Wire `format-on-write.ps1` + `check-context.ps1` in `.claude/settings.json`, or remove |
| 8 | `package.json` still `"astrofy"` | Set `name`/`description`/author to Faithful Craftsmen identity |
| 9 | CI has no validation stage | Add lint / `astro check` / `npm audit` before deploy in `deploy.yml` |
| 10 | Missing `CNAME` | Add `public/CNAME` = `www.faithfulcraftsmen.com` (verify current Pages setting first) |

**Key files:** `AGENTS.md`, `CLAUDE.md`, `.ai/**` (8 files), `LICENSE`, `README.md`,
`.claude/hooks/*.ps1`, `.claude/settings.json`, `package.json`, `.github/workflows/deploy.yml`,
`public/CNAME`.

---

## Workstream E — Design & content polish (folds in `TODO.md`)

- **Layout:** finish section dividers (reuse `public/woodgrain-divider.svg`); striking homepage hero
  (banner + tagline + CTA to Store/Projects); responsive grids for projects/team.
- **Color/branding:** lean on the `wood` daisyUI theme; faith accent palette (soft blue/gold/cream);
  single accent color for links/icons; subtle faith iconography in footer/about.
- **Content correctness:** rewrite copy-pasted descriptions (pens vs bowls); real hero photo per project;
  consistent card layouts.

---

## Sequencing

1. **Foundation (D + intake):** standards remediation + `intake/` + `Optimize-Intake.ps1`.
2. **Photos → Projects (A):** run photos through the pipeline; fix wrong/missing images; rewrite copy.
3. **Etsy (B):** register Etsy app; `Sync-EtsyListings.ps1`; wire store pages; schema fix; CI sync + cron.
4. **Email (C):** create Cloudflare aliases; register Etsy store with `shop@`; wire contact/footer.
5. **Polish (E):** design/branding pass.

---

## Verification

- **Intake:** drop a test photo in `intake/test/`, run `pwsh scripts/Optimize-Intake.ps1`, confirm an
  optimized `.webp` in `public/projects/test/` renders via `npm run dev`.
- **Etsy sync:** run `pwsh scripts/Sync-EtsyListings.ps1` with a real `ETSY_API_KEY`; confirm one file per
  active listing, `npm run build` passes, `/store` lists them, each "Buy Now" opens the right Etsy URL.
- **Email:** send test mail to `shop@`, `hello@`, `contact@`, and a random `x@faithfulcraftsmen.com`;
  confirm all arrive at `kris@hybridsolutions.cloud`.
- **Standards:** `AGENTS.md`, `.ai/` (8 files), `public/CNAME`, corrected `LICENSE`/`README` exist;
  `astro check` passes in CI; governance drift findings clear.
- **Deploy:** push to `main`; confirm GitHub Pages builds and `www.faithfulcraftsmen.com` serves with the
  custom domain intact.

---

## Prerequisites & risks (confirm during execution)

- **Etsy API key** — register a free Etsy developer app; confirm exact shop name/URL. If active-listing
  reads need OAuth for this shop, fall back to RSS (10-item cap) or manual featured cards. *(Verify first.)*
- **Cloudflare** — `faithfulcraftsmen.com` must be on Cloudflare with Email Routing available; confirm
  before applying.
- **CNAME/custom domain** — verify the current GitHub Pages custom-domain setting before adding
  `public/CNAME`.
- **Secrets** — `ETSY_API_KEY` lives in KV + GitHub Actions secrets only; never committed.

---

## Progress tracker

### Foundation & standards (D)
- [ ] `AGENTS.md` added with MCP-first block
- [ ] `CLAUDE.md` converted to thin shim
- [ ] `.ai/` workspace (8 files) created
- [ ] `LICENSE` holder corrected
- [ ] `README.md` completed
- [ ] PS7 headers on all `.claude/hooks/*.ps1` + `scripts/*.ps1`
- [ ] Unwired hooks wired or removed
- [ ] `package.json` identity updated
- [ ] CI validation stage (`astro check` + audit)
- [ ] `public/CNAME` added

### Photo pipeline (A)
- [ ] `intake/` folder + `.gitignore` rules + `intake/README.md`
- [ ] `scripts/Optimize-Intake.ps1`
- [ ] Fix `custom-bowls.md` (image + copy)
- [ ] Real photos for `custom-bowls`, `wooden-toys`
- [ ] Replace root placeholder images
- [ ] `[slug].astro` + `index.astro` use `<Image>`

### Etsy (B)
- [ ] Register Etsy developer app; capture shop name/URL
- [ ] `scripts/Sync-EtsyListings.ps1`
- [ ] Wire `store/index.astro` to the collection
- [ ] `store/[slug].astro` → `StoreItemLayout`
- [ ] `featured` added to schemas
- [ ] Delete demo store items
- [ ] CI sync step + daily cron

### Email (C)
- [ ] Verify destination `kris@hybridsolutions.cloud`
- [ ] Create `shop@`, `hello@`, `contact@` + catch-all
- [ ] Register Etsy store with `shop@`
- [ ] Wire contact page + footer to `hello@`

### Design polish (E — migrated from TODO.md)
- [ ] Section dividers (woodgrain SVG)
- [ ] Striking homepage hero (banner + tagline + CTA)
- [ ] Responsive grids for project/team sections
- [ ] Warm wood tones as accents/backgrounds
- [ ] Faith accent palette (soft blue, gold, cream)
- [ ] Woodgrain texture/pattern for wood theme
- [ ] Single branded color for primary buttons
- [ ] Single accent color for links/icons/highlights
- [ ] Wood truck logo used consistently (header, favicon, OG)
- [ ] Simplified/monochrome logo for small sizes
- [ ] Sans-serif body + warm serif/script headings
- [ ] Faith iconography in footer/about
- [ ] Replace placeholder images with real photos
- [ ] Rounded corners + soft shadows on images
- [ ] Custom SVG icons for nav/social/theme
- [ ] Warm, inviting, family-oriented headings/CTAs
