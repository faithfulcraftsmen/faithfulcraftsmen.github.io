# Gotchas

- **`featured` is read but not schema-validated.** `src/pages/blog/index.astro` and
  `src/pages/projects.astro` read `.data.featured` to pick a hero card, and several
  content files (`our-workshop.md`, `custom-bowls.md`, `custom-pen.md`, `wooden-toys.md`,
  etc.) set `featured: true/false` in frontmatter — but `blogSchema`/`projectSchema` in
  `src/content/config.ts` do not declare a `featured` field. Astro's Zod-based content
  collections strip unknown keys, so `featured` is silently dropped at build time and the
  "featured" pick effectively degrades to "first item" behavior. Fix: add
  `featured: z.boolean().optional()` to both schemas.

- **`custom-bowls.md` has the wrong image and the wrong copy.** Its `heroImage` points at
  `/projects/custom-pen/pen1.webp` (a pen photo, not a bowl), and the body text is
  pasted-over pen copy ("Our custom wood pens are made with care..."). There is no
  `public/projects/custom-bowls/` folder at all yet.

- **The `store` collection and `StoreItemLayout.astro` exist but are unwired.**
  `src/content/store/` only has three Lorem-ipsum demo items (`item1.md`, `item2.md`,
  `item3.md`), and no page in `src/pages/store/` calls `getCollection("store")` —
  `src/pages/store/index.astro` currently has a "coming soon" placeholder and a `TODO`
  comment. There is also no `src/pages/store/[slug].astro` to route to
  `StoreItemLayout.astro`, so that layout is currently dead code.

- **Several pages use raw `<img>` instead of `astro:assets`'s `<Image>`.** At least
  `src/components/Header.astro`, `src/pages/about.astro`, `src/pages/index.astro`, and
  `src/pages/projects/[slug].astro` render plain `<img>` tags, bypassing Astro's build-time
  image optimization even though `sharp` is already a dependency.

- **No `CNAME` file in `public/`.** The custom domain (`www.faithfulcraftsmen.com`, also
  set as `site` in `astro.config.mjs`) is presumably configured directly in the GitHub
  Pages repo settings rather than via a committed `CNAME` file. GitHub Pages resets the
  custom-domain setting to whatever `CNAME` file (or lack thereof) is in the published
  output on some deploy paths — verify the current Pages custom-domain setting before
  adding `public/CNAME`, to avoid accidentally dropping or conflicting with it.

- **`package.json` still identifies as the upstream template.** `name: "astrofy"` and the
  generic Astrofy description are inherited from the template this site was built from,
  not yet updated to Faithful Craftsmen identity.
