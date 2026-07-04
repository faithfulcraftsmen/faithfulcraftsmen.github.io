# Runbook — Cloudflare Email Routing aliases for faithfulcraftsmen.com

**Goal:** stand up email aliases on `faithfulcraftsmen.com` that forward to
`kris@hybridsolutions.cloud`, including a dedicated `shop@` address to register the Etsy
store. Cloudflare Email Routing is free and forward-only (it does not send/host mailboxes).

> This is an **external-service change**. Do it in the Cloudflare dashboard (or via the API
> with confirmation). No Cloudflare tokens are committed to this repo.

## Prerequisites

- `faithfulcraftsmen.com` is an active zone in the Cloudflare account (DNS managed by Cloudflare).
- Access to the `kris@hybridsolutions.cloud` inbox to click the one-time verification link.

## Aliases to create

| Alias | Purpose | Forwards to |
|---|---|---|
| `shop@faithfulcraftsmen.com` | Register + run the Etsy store; order/customer mail | `kris@hybridsolutions.cloud` |
| `hello@faithfulcraftsmen.com` | Primary public contact (used across the site) | `kris@hybridsolutions.cloud` |
| `contact@faithfulcraftsmen.com` | Secondary public contact | `kris@hybridsolutions.cloud` |
| *(catch-all)* | Anything else `@faithfulcraftsmen.com` (incl. legacy `info@`) | `kris@hybridsolutions.cloud` |

The site standardizes its visible contact address on **`hello@`**. The **catch-all** ensures the
previously-used `info@faithfulcraftsmen.com` (and any typo) still reaches the inbox.

## Steps (dashboard)

1. **Cloudflare dashboard → your account → the `faithfulcraftsmen.com` zone.**
2. Left nav: **Email → Email Routing** (newer accounts: **Compute (Workers) → Email Service → Email Routing**).
3. If not enabled: **Get started / Enable Email Routing**. Cloudflare will add the required DNS
   records automatically — review then confirm:
   - **MX** records pointing mail to Cloudflare
   - **TXT (SPF)**: `v=spf1 include:_spf.mx.cloudflare.net ~all`
   - **TXT (DKIM)** for authentication
4. **Destination Addresses → Add → `kris@hybridsolutions.cloud`.** Open the verification email in
   that inbox and click **Verify**. (Do this once; all routes reuse it.)
5. **Routing rules → Create address** for each custom alias (`shop`, `hello`, `contact`):
   - Custom address = `shop` (etc.), Action = **Send to an email**, Destination =
     `kris@hybridsolutions.cloud`. Save. Repeat for `hello` and `contact`.
6. **Catch-all** (Routing rules → Catch-all address → Edit): set Action = **Send to an email** →
   `kris@hybridsolutions.cloud`, and **Enable**.

## After setup

- **Register the Etsy store** using `shop@faithfulcraftsmen.com` (see
  `PROJECT-PLAN-2026-07-...md`, Workstream B). Store `ETSY_API_KEY` in Key Vault + as a GitHub
  Actions **secret**, and set `ETSY_SHOP_NAME` as a repo **variable**.
- **Verify delivery:** send a test message to `shop@`, `hello@`, `contact@`, and a random
  `nobody@faithfulcraftsmen.com`; confirm all four land in `kris@hybridsolutions.cloud`.

## Notes / cautions

- Email Routing is **forward-only** — to *send as* `shop@faithfulcraftsmen.com` (e.g. replying to
  Etsy customers from that address), add it as a "Send mail as" identity in the destination mailbox
  (Gmail/Microsoft 365) using that provider's SMTP; Cloudflare alone won't send.
- The **MX records** Cloudflare adds mean the domain can't simultaneously use another mail host on
  the apex. That's fine here (no existing mailbox on the domain), but confirm before enabling.
- Keep DNS for `www` / GitHub Pages untouched — Email Routing only touches MX/TXT, not the site's
  A/CNAME records.
