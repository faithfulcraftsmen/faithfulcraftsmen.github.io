# Open questions

- **Exact Etsy shop name/URL is not yet confirmed**, and it is unconfirmed whether
  `getListingsByShop` (active-listing reads) works with **API-key-only** auth for this
  specific shop, or whether it requires full OAuth. Register the free Etsy developer app,
  capture the shop identifier, and test a read before building
  `scripts/Sync-EtsyListings.ps1` against it. If API-key-only reads don't work, fall back
  to the shop's public RSS feed (`etsy.com/shop/<shop>/rss`, ~10-item cap) or manual
  featured cards.

- **Confirm `faithfulcraftsmen.com` is on Cloudflare with Email Routing available** before
  creating the `shop@` / `hello@` / `contact@` / catch-all aliases (Workstream C). This is
  an external-service change and requires explicit confirmation before applying per the
  project plan and the repo's hard rules on external API calls.

- **Confirm the current GitHub Pages custom-domain setting** (repo Settings → Pages) before
  adding `public/CNAME` = `www.faithfulcraftsmen.com`. If the domain is currently set only
  via the GitHub UI (no `CNAME` file in the published output), adding the file should be
  safe and is the more durable approach, but verify first to avoid a deploy that
  temporarily drops the custom domain.
