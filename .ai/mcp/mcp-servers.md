# MCP servers

Human-readable inventory of the MCP servers this repo uses. No connection secrets here —
per-tool config files (`.mcp.json`, `.codex/config.toml`, etc.) hold the wiring.

## HCS Governance MCP

This repo **consumes** the HCS Governance MCP (hosted in the `platform` repo, not here).

- **Purpose:** source of truth for standards, hard rules, scope resolution, orchestration
  guidance, the repo registry, and validation profiles. Exposes tools including
  `which_standards_apply`, `get_standard`, `get_guidance`, `find_repos`, `get_repo`,
  `validate`, `get_auth_token`, `get_kv_secret`, `bootstrap`, and `check_drift`.
- **Endpoint:** `https://mcp.hybridsolutions.cloud/mcp`
- **Transport:** Streamable HTTP (remote).
- **Auth:** the server hosts its own OAuth 2.1 flow brokered to Microsoft Entra. The Entra
  app (`hcs-governance-mcp`) sets `appRoleAssignmentRequired=true`; only members of
  `sg-hcs-mcp-users` can sign in. Every client prompts for the Entra sign-in on first connect.
- **Bootstrap:** call `bootstrap(repo="faithfulcraftsmen.github.io", client="<your client>")` at session start.
- **Per-tool config:** `.mcp.json` (Claude Code, if present in this repo), `.codex/config.toml`
  (Codex), `.gemini/settings.json` (Gemini), `.cursor/mcp.json` (Cursor), `.vscode/mcp.json`
  (VS Code Copilot). If a tool's config file is not yet present in this repo, it has not been
  wired up here — fall back to the offline digest in `AGENTS.md` until it is.
- **Ops/design:** see the `platform` repo's `mcp-server/docs/CONNECT.md`,
  `mcp-server/docs/AUTH-CLAUDE.md`, `mcp-server/docs/OPERATIONS.md`.

## Microsoft Learn MCP

Available to the `faithfulcraftsmen.github.io-engineer` subagent (and other Claude Code
sessions in this repo) for grounding answers in official Microsoft/Azure documentation —
`microsoft_docs_search`, `microsoft_docs_fetch`, `microsoft_code_sample_search`. This repo
has no Azure infrastructure of its own; this MCP is used for adjacent questions (e.g. GitHub
Pages, DNS/CDN topics that touch Azure-hosted tooling elsewhere in the estate), not for a
day-to-day dependency of the site itself.
