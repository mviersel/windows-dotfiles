# install-apps.ps1
# Leest apps.txt en installeert alles met winget

$ErrorActionPreference = "Stop"

$repoRoot = $PSScriptRoot
$appsFile = Join-Path $repoRoot "apps.txt"

if (-not (Test-Path $appsFile)) {
    Write-Error "apps.txt niet gevonden in $repoRoot"
    exit 1
}

# Lees alle regels, filter lege regels en comments
$apps = Get-Content $appsFile |
    Where-Object { $_ -and (-not $_.Trim().StartsWith("#")) } |
    ForEach-Object { $_.Trim() }

if (-not $apps) {
    Write-Warning "Geen apps gevonden in apps.txt (na filteren)."
    exit 0
}

foreach ($app in $apps) {
    Write-Host ""
    Write-Host "==> Installeer: $app" -ForegroundColor Cyan

    try {
        # -e = exact id
        # --silent = geen UI
        # accept-* = niet om bevestiging vragen
        winget install `
            --id $app `
            -e `
            --silent `
            --accept-source-agreements `
            --accept-package-agreements

        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Installatie van $app gaf exitcode $LASTEXITCODE"
        } else {
            Write-Host "OK: $app" -ForegroundColor Green
        }
    }
    catch {
        Write-Warning "Fout bij installeren van $app: $_"
    }
}

Write-Host ""
Write-Host "Klaar met winget-installaties." -ForegroundColor Green
