# faithfulcraftsmen.github.io

The public website for **Faithful Craftsmen** — a family woodworking organization. It's an
[Astro 5](https://astro.build) static site (portfolio, blog, and an Etsy-linked shop), published via
GitHub Pages at **[www.faithfulcraftsmen.com](https://www.faithfulcraftsmen.com)**.

> Agent/AI instructions live in [`AGENTS.md`](AGENTS.md) (imported by [`CLAUDE.md`](CLAUDE.md)).
> The active project plan lives in [`pmo/`](pmo/).

---

## Stack

- **Astro 5** (Astrofy template) with content collections: `blog`, `projects`, `store`
- **Tailwind CSS + daisyUI** — themes `light` / `dark` / `wood` (custom warm-wood palette)
- **MDX**, `@astrojs/sitemap`, `@astrojs/rss`, and `astro:assets` (sharp) image optimization
- Deployed by GitHub Actions (`.github/workflows/deploy.yml`) to GitHub Pages on push to `main`

---

## Prerequisites

- **Node.js 20+** and npm (`winget install OpenJS.NodeJS.LTS`)
- **PowerShell 7+** (`winget install Microsoft.PowerShell`) — for the automation in `scripts/`
- **Azure CLI** + **GitHub CLI** — only needed for HCS environment/secret loading and releases

Optional, for scripts that read secrets (e.g. the Etsy sync) — load the HCS environment first:

```powershell
. E:\git\platform\scripts\Load-HCSEnvironment.ps1
```

---

## Quick start

```powershell
# From the repo root
npm install        # install dependencies
npm run dev        # local dev server at http://localhost:4321
npm run build      # production build to ./dist
npm run preview    # preview the production build locally
```

---

## Repo structure

```text
faithfulcraftsmen.github.io/
├── AGENTS.md               # canonical cross-tool agent instructions
├── CLAUDE.md               # thin shim → AGENTS.md
├── .ai/                    # AI session workspace (memory + state)
├── pmo/                    # project plans
├── public/                 # static assets (images, CNAME, robots.txt)
├── scripts/                # PowerShell 7 automation (photo intake, Etsy sync)
├── src/
│   ├── components/         # HorizontalCard, Header, Footer, ...
│   ├── content/            # blog / projects / store collections + config.ts
│   ├── layouts/            # BaseLayout, PostLayout, StoreItemLayout
│   ├── pages/              # routes (index, projects, blog, store, ...)
│   └── lib/                # helpers
├── astro.config.mjs
└── tailwind.config.cjs
```

---

## Content

- **Projects / portfolio** — one Markdown file per piece in `src/content/projects/`, with photos under
  `public/projects/<slug>/`. New photos go through the intake pipeline (see `intake/README.md`).
- **Blog** — `src/content/blog/`.
- **Store** — `src/content/store/`; items link out to Etsy for checkout via each item's `checkoutUrl`.

---

## Contributing

1. Branch: `git checkout -b feature/short-description`
2. Follow the HCS [scripting](https://platform.hybridsolutions.cloud/standards/scripting/) and
   [documentation](https://platform.hybridsolutions.cloud/standards/documentation/) standards
   (PowerShell 7 for scripts, Markdown for docs).
3. Commit as `type(scope): description` and reference the ADO work item (`AB#<id>`).
4. Open a PR linked to the work item.

---

## License

MIT — see [LICENSE](LICENSE). Portions based on the [Astrofy](https://github.com/manuelernestog/astrofy)
template (MIT).

---

**Owner:** Kristopher Turner — kris@hybridsolutions.cloud
Hybrid Cloud Solutions LLC — [hybridsolutions.cloud](https://hybridsolutions.cloud)
