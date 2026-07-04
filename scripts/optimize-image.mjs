// optimize-image.mjs — resize + convert a single image to web-ready WebP.
// Usage: node scripts/optimize-image.mjs <input> <output.webp> <maxLongEdgePx> [quality]
// Uses the `sharp` dependency already in package.json. Metadata (incl. EXIF
// location) is stripped by default; orientation is baked in via .rotate().

import sharp from 'sharp';

const [, , input, output, maxEdgeRaw, qualityRaw] = process.argv;

if (!input || !output || !maxEdgeRaw) {
  console.error('Usage: node optimize-image.mjs <input> <output.webp> <maxLongEdgePx> [quality]');
  process.exit(2);
}

const maxEdge = Number(maxEdgeRaw);
const quality = qualityRaw ? Number(qualityRaw) : 82;

try {
  const info = await sharp(input)
    .rotate() // apply EXIF orientation, then drop metadata (default)
    .resize({ width: maxEdge, height: maxEdge, fit: 'inside', withoutEnlargement: true })
    .webp({ quality })
    .toFile(output);
  console.log(`  ${output}  (${info.width}x${info.height}, ${Math.round(info.size / 1024)} KB)`);
} catch (err) {
  console.error(`  ERROR processing ${input}: ${err.message}`);
  process.exit(1);
}
