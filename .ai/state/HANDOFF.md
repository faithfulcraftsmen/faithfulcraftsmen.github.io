# Handoff

## Multi-model canonical layout: AGENTS.md + CLAUDE.md shim + `.ai/` workspace (this session)

- **What changed and why:** brought this repo into the HCS canonical multi-model layout
  (Workstream D of `pmo/PROJECT-PLAN-2026-07-etsy-photos-email-standards.md`), modeled on
  the `platform` repo's dogfooded reference implementation.
- **Files touched:**
  - New: `AGENTS.md` (canonical cross-tool instructions — MCP bootstrap, offline fallback
    digest, session protocol, key facts, owner).
  - Overwritten: `CLAUDE.md` — converted from a full context doc into a thin shim that
    imports `AGENTS.md` via `@AGENTS.md` and keeps only Claude-Code-specific notes.
  - New: `.ai/mcp/mcp-servers.md`, `.ai/memory/PROJECT_CONTEXT.md`,
    `.ai/memory/DECISIONS.md`, `.ai/memory/COMMANDS.md`, `.ai/memory/GOTCHAS.md`,
    `.ai/state/CURRENT_TASK.md`, `.ai/state/HANDOFF.md` (this file),
    `.ai/state/OPEN_QUESTIONS.md`.
- **Commands / tests run:** none — this was a documentation-only pass. No `npm install`/
  `npm run build` run in this session.
- **Branch:** `feature/etsy-photos-email-standards` (per the project plan's owner —
  confirm the actual branch name in use before continuing; this handoff entry assumes it
  per the task brief). Not committed as of this entry — confirm with the operator before
  committing/pushing.
- **Blockers:** none for this workstream's remaining items, but see
  `.ai/state/OPEN_QUESTIONS.md` for items that block Workstreams B and C.
- **Exact next steps (remaining Workstream D items):**
  1. Fix `LICENSE` copyright holder (currently the upstream Astrofy template author).
  2. Fill in `README.md` placeholders (real prerequisites, quick start, resolve license
     section to MIT-only).
  3. Add PS7 headers (`#Requires -Version 7.0`, `Set-StrictMode -Version Latest`,
     `$ErrorActionPreference = 'Stop'`) to every `.claude/hooks/*.ps1` script.
  4. Decide: wire `format-on-write.ps1` + `check-context.ps1` into `.claude/settings.json`,
     or remove them if unused.
  5. Update `package.json` `name`/`description`/author away from the inherited `"astrofy"`
     template identity.
  6. Add a CI validation stage (lint / `astro check` / `npm audit`) to
     `.github/workflows/deploy.yml` before the deploy step.
  7. Add `public/CNAME` = `www.faithfulcraftsmen.com` — **only after** confirming the
     current GitHub Pages custom-domain setting (see `OPEN_QUESTIONS.md`).
  8. Then move on to Workstream A (photo intake pipeline).
