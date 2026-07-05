# Photo intake — drop zone

This folder is a **staging area for raw photos**. Everything here except this README is
**gitignored** — raw phone photos never get committed. The optimizer turns them into
web-ready `.webp` files under `public/`, and only those optimized images are committed.

## Workflow

1. **Drop photos into a folder named for the piece (its "slug"):**

   ```text
   intake/
     custom-bowls/       ← slug = custom-bowls
       IMG_4821.jpg
       IMG_4822.jpg
     name-puzzle/
       puzzle-front.heic
   ```

   Use the same slug as the content file — e.g. photos for
   `src/content/projects/custom-bowls.md` go in `intake/custom-bowls/`.

2. **Run the optimizer** (PowerShell 7, from the repo root):

   ```powershell
   # Projects (default): writes to public/projects/<slug>/
   pwsh scripts/Optimize-Intake.ps1

   # Shop items: writes to public/store/<slug>/
   pwsh scripts/Optimize-Intake.ps1 -Target store

   # Just one slug:
   pwsh scripts/Optimize-Intake.ps1 -Slug custom-bowls
   ```

   For each source image it writes two optimized `.webp` files to
   `public/<target>/<slug>/`:
   - `<name>.webp` — full size (long edge ~1600px), for detail pages
   - `<name>-card.webp` — smaller (long edge ~800px), for cards/thumbnails

   EXIF metadata (including location) is stripped.

3. **Copy the printed `heroImage:` path** into the piece's Markdown frontmatter, e.g.:

   ```yaml
   heroImage: "/projects/custom-bowls/bowl1.webp"
   ```

4. **Review and commit** the new files under `public/` (the `intake/` originals stay
   local and are not committed).

## Notes

- Requires **Node.js** (the script uses the `sharp` library already in `package.json`).
  Run `npm install` once first so `node_modules/sharp` is present.
- Supported inputs: `.jpg`, `.jpeg`, `.png`, `.webp`, `.tif`/`.tiff`. `.heic` works only
  if your `sharp` build includes HEIF support — if it errors, convert iPhone photos to
  JPG first (Photos → Export, or set iPhone Camera to "Most Compatible").
- Re-running is safe — it overwrites the optimized outputs for the same source names.
