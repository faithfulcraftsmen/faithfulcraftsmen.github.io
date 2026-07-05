# Current task

Executing **`pmo/PROJECT-PLAN-2026-07-etsy-photos-email-standards.md`** (approved
2026-07-04). Five workstreams, sequenced as: Foundation (standards + intake) → Photos →
Etsy → Email → Design polish.

## Workstream status

| Workstream | Status |
|---|---|
| D — HCS standards: full compliance | **Done** — AGENTS.md, CLAUDE.md shim, `.ai/` workspace, LICENSE, README, package.json, PS7 hook headers (+ `{{REPO_ROOT}}` bug fix), dead-hook removal, CI validate job, `public/CNAME`. |
| A — Photo intake pipeline | **Done** — `intake/` + README, `Optimize-Intake.ps1` + `optimize-image.mjs`, custom-bowls copy fix. Owner still drops real photos. |
| B — Etsy store integration | **Done (needs credentials)** — `Sync-EtsyListings.ps1`, store pages wired, `featured` schema fix, demos removed, CI sync + cron. Owner registers Etsy app + sets `ETSY_API_KEY`/`ETSY_SHOP_NAME`. |
| C — Cloudflare email aliases | **Site done; Cloudflare pending** — site on `hello@`, runbook written. Owner creates aliases per `pmo/RUNBOOK-cloudflare-email-aliases.md`. |
| E — Design & content polish | **Done** — build-verified in WSL (Node 22). Woodgrain dividers (`WoodDivider.astro`), hero Store/Projects CTAs, banner moved to `src/assets` + `<Image>` (1030kB→98kB), project hero `<Image>`, faith accents, dynamic footer year. Deps: `npm audit fix` 22→4 vulns (both criticals + all highs cleared); CI audit now blocking at `--audit-level=critical`. |

Everything is on branch `feature/etsy-photos-email-standards` (PR #1). All five workstreams
(A–E) are now complete and build-verified in the WSL Node 22 env. Commits `d96f6f6` (UI),
`6bd9484` (deps), `4728f3c` (CI gate). **Deferred:** the Astro 5→7 major upgrade (unlocks the
last 4 low/dev-only vulns) is a separate replatform task. See `HANDOFF.md` for owner actions.

<!-- suggested-model: sonnet -->
