#Requires -Version 7.0

<#
.SYNOPSIS
    Mirror an Etsy shop's active listings into the Astro `store` content collection.

.DESCRIPTION
    Calls the Etsy Open API v3 (read-only, API-key auth — no OAuth) to fetch every
    active listing for the shop, then generates one Markdown file per listing under
    src/content/store/ (filenames prefixed `etsy-<listing_id>.md`) and downloads each
    listing's primary photo to public/store/etsy-<listing_id>/. Each item's checkoutUrl
    and custom_link point at the live Etsy listing, so the static site links out to Etsy
    for checkout.

    Generated files are regenerated on every run (existing `etsy-*.md` are removed first),
    so delisted items drop off the site. Hand-authored store items (without the `etsy-`
    prefix) are left untouched.

    Requires an Etsy app API keystring. Register a free app at
    https://www.etsy.com/developers/your-apps and set ETSY_API_KEY (locally via Key Vault
    / Load-HCSEnvironment.ps1, in CI as a GitHub Actions secret). The shop name is the
    handle in your shop URL (etsy.com/shop/<ShopName>).

.PARAMETER ShopName
    Etsy shop handle. Defaults to $env:ETSY_SHOP_NAME.

.PARAMETER ApiKey
    Etsy app keystring. Defaults to $env:ETSY_API_KEY.

.PARAMETER MaxListings
    Safety cap on how many listings to import (default 250).

.EXAMPLE
    pwsh scripts/Sync-EtsyListings.ps1 -ShopName FaithfulCraftsmen
#>
[CmdletBinding()]
param(
    [string]$ShopName = $env:ETSY_SHOP_NAME,
    [string]$ApiKey   = $env:ETSY_API_KEY,
    [int]$MaxListings = 250
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($ShopName)) {
    throw "ShopName not provided. Pass -ShopName or set ETSY_SHOP_NAME."
}
if ([string]::IsNullOrWhiteSpace($ApiKey)) {
    throw "ETSY_API_KEY not set. Register an Etsy app and set the keystring (KV locally, GitHub Actions secret in CI)."
}

$repoRoot = Split-Path $PSScriptRoot -Parent
$storeDir = Join-Path $repoRoot 'src/content/store'
$imgRoot  = Join-Path $repoRoot 'public/store'
$apiBase  = 'https://openapi.etsy.com/v3/application'
$headers  = @{ 'x-api-key' = $ApiKey }

# YAML double-quoted scalar escaping: backslash, quote, and collapse newlines.
function ConvertTo-YamlString {
    param([string]$Value)
    if ($null -eq $Value) { return '' }
    $v = $Value -replace '\\', '\\' -replace '"', '\"'
    $v = $v -replace '\r?\n', ' '
    return $v.Trim()
}

# --- resolve shop id -------------------------------------------------------
Write-Host "Resolving Etsy shop '$ShopName'..." -ForegroundColor Cyan
$shopUri  = "$apiBase/shops?shop_name=$([uri]::EscapeDataString($ShopName))"
$shopResp = Invoke-RestMethod -Uri $shopUri -Headers $headers -Method Get
$shop = if ($shopResp.PSObject.Properties.Name -contains 'results') { $shopResp.results | Select-Object -First 1 } else { $null }
if (-not $shop) { throw "Shop '$ShopName' not found via Etsy API." }
$shopId = $shop.shop_id
Write-Host "  shop_id = $shopId" -ForegroundColor DarkGray

# --- fetch active listings (paginated, images included) --------------------
$listings = @()
$offset = 0
do {
    $uri  = "$apiBase/shops/$shopId/listings/active?limit=100&offset=$offset&includes=Images"
    $resp = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get
    $batch = if ($resp.PSObject.Properties.Name -contains 'results') { @($resp.results) } else { @() }
    $listings += $batch
    $offset += 100
} while ($batch.Count -eq 100 -and $listings.Count -lt $MaxListings)

if ($listings.Count -gt $MaxListings) { $listings = $listings[0..($MaxListings - 1)] }
Write-Host "Fetched $($listings.Count) active listing(s)." -ForegroundColor Green

# --- clean previously-generated files --------------------------------------
if (-not (Test-Path $storeDir)) { New-Item -ItemType Directory -Path $storeDir -Force | Out-Null }
Get-ChildItem -Path $storeDir -Filter 'etsy-*.md' -File -ErrorAction SilentlyContinue | Remove-Item -Force
Get-ChildItem -Path $imgRoot -Directory -Filter 'etsy-*' -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force

# --- generate one markdown file per listing --------------------------------
$written = 0
foreach ($listing in $listings) {
    $id    = $listing.listing_id
    $title = ConvertTo-YamlString $listing.title
    $descRaw = [string]$listing.description
    $descShort = ConvertTo-YamlString (($descRaw -split '\r?\n' | Where-Object { $_.Trim() } | Select-Object -First 1))
    if ($descShort.Length -gt 200) { $descShort = $descShort.Substring(0, 197) + '...' }

    # price object: { amount, divisor, currency_code }
    $pricing = ''
    if ($listing.PSObject.Properties.Name -contains 'price' -and $listing.price) {
        $amount   = [double]$listing.price.amount / [double]$listing.price.divisor
        $currency = [string]$listing.price.currency_code
        $pricing  = if ($currency -eq 'USD') { '${0:N2}' -f $amount } else { '{0:N2} {1}' -f $amount, $currency }
    }

    $listingUrl = if ($listing.PSObject.Properties.Name -contains 'url' -and $listing.url) {
        [string]$listing.url
    } else {
        "https://www.etsy.com/listing/$id"
    }

    # updated date from last_modified_timestamp (unix seconds)
    $updated = (Get-Date).ToString('yyyy-MM-dd')
    if ($listing.PSObject.Properties.Name -contains 'last_modified_timestamp' -and $listing.last_modified_timestamp) {
        $updated = [DateTimeOffset]::FromUnixTimeSeconds([long]$listing.last_modified_timestamp).ToString('yyyy-MM-dd')
    }

    # primary image → public/store/etsy-<id>/hero.jpg
    $heroLine = ''
    $images = if ($listing.PSObject.Properties.Name -contains 'images') { @($listing.images) } else { @() }
    if ($images.Count -gt 0) {
        $imgUrl = $images[0].url_fullxfull
        if ($imgUrl) {
            $itemImgDir = Join-Path $imgRoot "etsy-$id"
            if (-not (Test-Path $itemImgDir)) { New-Item -ItemType Directory -Path $itemImgDir -Force | Out-Null }
            $imgFile = Join-Path $itemImgDir 'hero.jpg'
            try {
                Invoke-WebRequest -Uri $imgUrl -OutFile $imgFile -UseBasicParsing
                $heroLine = "heroImage: `"/store/etsy-$id/hero.jpg`"`n"
            } catch {
                Write-Warning "  Could not download image for listing ${id}: $($_.Exception.Message)"
            }
        }
    }

    $frontmatter = @"
---
title: "$title"
description: "$descShort"
custom_link_label: "View on Etsy"
custom_link: "$listingUrl"
checkoutUrl: "$listingUrl"
updatedDate: "$updated"
pricing: "$pricing"
badge: "Etsy"
$heroLine---

$descRaw

[View this item on Etsy]($listingUrl)
"@

    $outFile = Join-Path $storeDir "etsy-$id.md"
    Set-Content -Path $outFile -Value $frontmatter -Encoding UTF8
    $written++
}

Write-Host "Wrote $written store item file(s) to src/content/store/." -ForegroundColor Green
