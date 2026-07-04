# faithfulcraftsmen.github.io — Claude Code

@AGENTS.md

<!--
  This file is a thin shim. All cross-tool repo instructions — identity, hard rules,
  standards references, key facts, MCP bootstrap, and session protocol — live in
  AGENTS.md, imported above via Claude Code's @path syntax (inlined at session launch).
  Keep only genuinely Claude-Code-specific notes below.
-->

## Claude Code notes

- Use **plan mode** before broad, repo-wide changes.
- Follow the `.ai/` session protocol: read `.ai/state/*` at session start, and update `.ai/state/HANDOFF.md` before ending a session.
- The repo-level subagent is `faithfulcraftsmen.github.io-engineer` (model: sonnet) — deep knowledge of this repo's structure, conventions, and development workflow.
- User-level agents also available in every session: `triage-lookup`, `markdown-prose-editor`, `azurelocal-domain-expert`, `mkdocs-material-doctor`, `turner-module-scaffold-engineer`, `mms-2026-demo-presenter`.
- See the [agents standard](https://platform.hybridsolutions.cloud/standards/agents/) for the full multi-model model.

### Claude Code actions in this repo

**Run autonomously:**

- Read, search, and grep any file in this repo
- Write and edit files in this repo
- `git add`, `git commit`, `git push`
- `gh issue`, `gh pr`, `gh run` CLI commands
- `npm` build/preview commands for local development (`npm install`, `npm run dev`, `npm run build`, `npm run preview`)

**Always confirm before:**

- Creating or deleting Azure resources
- Any `az` CLI write operation that modifies Azure state
- Running destructive operations
- Making API calls to external services
- Triggering a GitHub Pages production deployment (push to `main`)
