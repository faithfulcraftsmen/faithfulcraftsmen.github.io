# Handoff

## Etsy + photos + email + standards initiative (2026-07-04)

Branch: **`feature/etsy-photos-email-standards`** — committed, ready for PR.
Plan: `pmo/PROJECT-PLAN-2026-07-etsy-photos-email-standards.md`.

### What shipped (Workstreams A–D)

- **D — Standards (done):** `AGENTS.md` + `CLAUDE.md` shim + 8-file `.ai/` workspace;
  `LICENSE` holder fixed (upstream attribution kept); `README.md` completed;
  `package.json` identity; PS7 headers on all `.claude/hooks/*.ps1` + fixed the
  `{{REPO_ROOT}}` placeholder bug in log-tokens/summarize-session; removed dead hooks
  (format-on-write no-op, check-context duplicate); CI `validate` job (`astro check` +
  `npm audit`); `public/CNAME` = www.faithfulcraftsmen.com.
- **A — Photos (done):** gitignored `intake/` drop zone + `intake/README.md`;
  `scripts/Optimize-Intake.ps1` + `scripts/optimize-image.mjs` (sharp → webp, EXIF
  stripped, full+card variants); fixed `custom-bowls.md` (was a verbatim copy of
  custom-pen).
- **B — Etsy (done, needs credentials):** `scripts/Sync-EtsyListings.ps1` (v3 API, API-key
  auth, generates `etsy-<id>.md`, downloads photos); `store/index.astro` wired to the
  collection with empty-state; `store/[slug].astro` → `StoreItemLayout`; `featured` added
  to blog+project schemas; demo store items removed; CI sync step + daily cron.
- **C — Email (site done, Cloudflare pending):** all `info@` → `hello@` across the site;
  `pmo/RUNBOOK-cloudflare-email-aliases.md`.

### Verification status

- **PowerShell scripts:** parse-checked under pwsh 7.6; preflights tested (friendly errors
  without Node / without ETSY_API_KEY); YAML escaper unit-checked. ✅
- **Astro build / `astro check`:** NOT run — **Node.js is not installed on this machine**.
  The site build, `astro check`, and the intake/Etsy scripts' happy paths are unverified
  locally. First real verification happens in the CI `validate`/`build` jobs on push.
  Watch that run.

### Owner actions still required (external)

1. Register a free Etsy developer app → get the API keystring. Add `ETSY_API_KEY`
   (GitHub Actions **secret**) and `ETSY_SHOP_NAME` (repo **variable**). Until then the
   store shows its empty state and CI skips the sync.
2. Cloudflare Email Routing: follow `pmo/RUNBOOK-cloudflare-email-aliases.md` to create
   `shop@`/`hello@`/`contact@` + catch-all → `kris@hybridsolutions.cloud`, then register
   the Etsy store with `shop@`.
3. Confirm the GitHub Pages custom-domain setting still matches `public/CNAME`
   (`www.faithfulcraftsmen.com`) after the first deploy from this branch.
4. Drop real photos via the intake pipeline for `custom-bowls`, `wooden-toys`, and to
   replace root placeholders.

### Deferred (needs a Node/build env)

- Workstream E design polish (dividers, hero, faith accents) and the `<img>` → `<Image>`
  refactor on `index.astro` / `projects/[slug].astro` — do these where the build can be
  run and visually verified.
