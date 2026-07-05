# Faithful Craftsmen — Agent instructions

<!--
  AGENTS.md is the canonical, cross-tool instruction file for this repo.
  Codex CLI, Cursor, and VS Code Copilot read it natively; Claude Code
  imports it via CLAUDE.md; Gemini reads it via contextFileName.
-->

## What this repo is

This is the public-facing static site for the **Faithful Craftsmen** family — a
woodworking portfolio and Etsy-linked shop built by the Turner sons. It is a **product
repo**, not a platform repo: it contains real application code (an Astro 5 site) and is
deployed to production on every push to `main`. Content lives in three Astro content
collections (`blog`, `projects`, `store`); styling is Tailwind + daisyUI with a custom
`wood` theme; images go through `astro:assets`. The site is published via GitHub Pages
at the custom domain **www.faithfulcraftsmen.com**. When working here, think like a
site engineer for a small family business: content correctness, load-bearing images,
and not breaking the live deploy all matter more than architecture debates.

---

## Start here — connect to the HCS Governance MCP

This repo is governed by the **HCS Governance MCP server** (connection details in
[`.ai/mcp/mcp-servers.md`](.ai/mcp/mcp-servers.md)). It is the source of truth for
standards, hard rules, and orchestration guidance.

**At session start, call:**

```
bootstrap(repo="faithfulcraftsmen.github.io", client="<your client: claude-code | codex | gemini | cursor | vscode>")
```

It returns this repo's scope, the applicable hard rules, the index of applicable
standards, the `.ai/` session protocol, and orchestration guidance shaped for your
client's capability tier. **Prefer a live MCP answer over anything written in this file** —
this file is the offline fallback.

---

## Offline fallback (when the MCP server is unreachable)

**Standards scope:** `hcs`

**Hard rules digest:**

- No secrets, tokens, passwords, subscription/tenant/client IDs, or connection strings in any committed file.
- All scripts: PowerShell 7+ — `#Requires -Version 7.0`, `Set-StrictMode -Version Latest`, `$ErrorActionPreference = 'Stop'`. Never PS 5.1, never Bash.
- All documentation is Markdown only. No Word documents in any repo.
- Commit format: `type(scope): short description` — types `feat`, `fix`, `docs`, `chore`, `refactor`, `test` — with an `AB#<id>` work-item reference.

**Standards reference (public site — no auth required):**

- Governance — <https://platform.hybridsolutions.cloud/standards/governance/>
- Scripting — <https://platform.hybridsolutions.cloud/standards/scripting/>
- Automation — <https://platform.hybridsolutions.cloud/standards/automation/>
- Infrastructure — <https://platform.hybridsolutions.cloud/standards/infrastructure/>
- Testing — <https://platform.hybridsolutions.cloud/standards/testing/>
- Variables — <https://platform.hybridsolutions.cloud/standards/variables/>
- Naming — <https://platform.hybridsolutions.cloud/standards/naming/>
- Key Vault — <https://platform.hybridsolutions.cloud/standards/keyvault/>
- Documentation — <https://platform.hybridsolutions.cloud/standards/documentation/>
- Documentation platforms — <https://platform.hybridsolutions.cloud/standards/docs-platforms/>
- Agents (multi-model) — <https://platform.hybridsolutions.cloud/standards/agents/>
- AI workspace — <https://platform.hybridsolutions.cloud/standards/ai-workspace/>
- Full index — <https://platform.hybridsolutions.cloud/standards/>

---

## Session protocol

1. **Read `.ai/state/` first** — `CURRENT_TASK.md`, then `HANDOFF.md`, then `OPEN_QUESTIONS.md`.
2. Then read `.ai/memory/` for durable context (`PROJECT_CONTEXT.md`, `DECISIONS.md`, `COMMANDS.md`, `GOTCHAS.md`).
3. Summarise your believed state back to the operator before making changes.
4. **Before ending the session, update `.ai/state/HANDOFF.md`** — what changed, files touched, commands run and results, branch, blockers, next steps.

Full contract: the [AI workspace standard](https://platform.hybridsolutions.cloud/standards/ai-workspace/).

---

## Key facts

| Fact | Value |
|---|---|
| Azure login | <kris@hybridsolutions.cloud> |
| ADO org | <https://dev.azure.com/hybridcloudsolutions> |
| ADO project | Faithful Craftsmen |
| ADO area path | Platform Engineering\Onboarding |
| Key Vault | kv-hcs-vault-01 |
| GitHub org | faithfulcraftsmen |
| GitHub PAT secret in KV | hcs-platform-github-org-pat (loaded as `GITHUB_TOKEN`) |
| ADO PAT secret in KV | hcs-platform-ado-platform-pat (loaded as `AZURE_DEVOPS_EXT_PAT`) |
| Production domain | www.faithfulcraftsmen.com (GitHub Pages, custom domain) |
| Work item format | `AB#<id>` in commits and PRs |

No subscription ID, tenant ID, or other secret value is recorded in this repo — this is
a product repo, not the platform source-of-truth registry.

---

## Owner

**Kristopher Turner** — <kris@hybridsolutions.cloud>
Senior Product Technology Architect, TierPoint | Microsoft MVP (Azure) | MCT
Owner, Hybrid Cloud Solutions LLC — hybridsolutions.cloud | Blog — thisismydemo.cloud
