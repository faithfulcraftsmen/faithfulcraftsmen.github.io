#Requires -Version 7.0

<#
.SYNOPSIS
    Turn raw photos dropped in intake/<slug>/ into web-ready .webp assets under public/.

.DESCRIPTION
    For every image in intake/<slug>/ this writes two optimized WebP files to
    public/<Target>/<slug>/:
      <name>.webp       full size  (long edge ~1600px) — detail pages
      <name>-card.webp  thumbnail  (long edge ~800px)  — cards/listings
    EXIF metadata (including location) is stripped. Prints the heroImage path to
    paste into the piece's Markdown frontmatter.

    Requires Node.js and the `sharp` dependency (run `npm install` once first).

.PARAMETER Target
    Destination collection: 'projects' (default) or 'store'.

.PARAMETER Slug
    Optional. Process only intake/<Slug>/ instead of every subfolder.

.PARAMETER Quality
    WebP quality 1-100 (default 82).

.EXAMPLE
    pwsh scripts/Optimize-Intake.ps1
.EXAMPLE
    pwsh scripts/Optimize-Intake.ps1 -Target store -Slug walnut-bowl
#>
[CmdletBinding()]
param(
    [ValidateSet('projects', 'store')]
    [string]$Target = 'projects',

    [string]$Slug,

    [ValidateRange(1, 100)]
    [int]$Quality = 82
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot   = Split-Path $PSScriptRoot -Parent
$intakeRoot = Join-Path $repoRoot 'intake'
$helper     = Join-Path $PSScriptRoot 'optimize-image.mjs'
$publicRoot = Join-Path $repoRoot "public/$Target"

# --- preflight -------------------------------------------------------------
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    throw "Node.js is not on PATH. Install Node 20+ and run 'npm install' before using this script."
}
if (-not (Test-Path (Join-Path $repoRoot 'node_modules/sharp'))) {
    throw "The 'sharp' package is not installed. Run 'npm install' from the repo root first."
}
if (-not (Test-Path $intakeRoot)) {
    throw "No intake/ folder found at $intakeRoot."
}

# --- gather slug folders ---------------------------------------------------
if ($Slug) {
    $slugDirs = @(Get-Item (Join-Path $intakeRoot $Slug) -ErrorAction Stop)
} else {
    $slugDirs = @(Get-ChildItem -Path $intakeRoot -Directory)
}

if ($slugDirs.Count -eq 0) {
    Write-Host "Nothing to do — drop photos into intake/<slug>/ first." -ForegroundColor Yellow
    return
}

$imageExt = @('.jpg', '.jpeg', '.png', '.webp', '.heic', '.tif', '.tiff')
$totalImages = 0
$heroPaths = [ordered]@{}

foreach ($dir in $slugDirs) {
    $slugName  = $dir.Name
    $sources   = @(Get-ChildItem -Path $dir.FullName -File |
                   Where-Object { $imageExt -contains $_.Extension.ToLower() } |
                   Sort-Object Name)

    if ($sources.Count -eq 0) {
        Write-Host "  (no images in intake/$slugName/)" -ForegroundColor DarkGray
        continue
    }

    $outDir = Join-Path $publicRoot $slugName
    if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir -Force | Out-Null }

    Write-Host "intake/$slugName/  ->  public/$Target/$slugName/" -ForegroundColor Cyan

    foreach ($src in $sources) {
        $base    = [System.IO.Path]::GetFileNameWithoutExtension($src.Name).ToLower() -replace '[^a-z0-9]+', '-'
        $full    = Join-Path $outDir "$base.webp"
        $card    = Join-Path $outDir "$base-card.webp"

        & node $helper $src.FullName $full 1600 $Quality
        if ($LASTEXITCODE -ne 0) { throw "Optimizer failed on $($src.FullName)" }
        & node $helper $src.FullName $card 800 $Quality
        if ($LASTEXITCODE -ne 0) { throw "Optimizer failed on $($src.FullName)" }

        $totalImages++
        if (-not $heroPaths.Contains($slugName)) {
            $heroPaths[$slugName] = "/$Target/$slugName/$base.webp"
        }
    }
}

# --- summary ---------------------------------------------------------------
Write-Host ""
Write-Host "Done: $totalImages image(s) optimized." -ForegroundColor Green
if ($heroPaths.Count -gt 0) {
    Write-Host "Suggested heroImage frontmatter:" -ForegroundColor Green
    foreach ($k in $heroPaths.Keys) {
        Write-Host ("  {0,-20} heroImage: `"{1}`"" -f $k, $heroPaths[$k])
    }
}
