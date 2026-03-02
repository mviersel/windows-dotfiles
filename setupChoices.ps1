<#
Master setup script for Windows dotfiles.
Run in PowerShell (preferably as Administrator):

Set-ExecutionPolicy Bypass -Scope Process -Force
.\setup.ps1
#>

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root

function Invoke-Step {
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$ScriptPath
    )

    Write-Host "`n== $Name ==" -ForegroundColor Cyan

    if (-not (Test-Path $ScriptPath)) {
        Write-Host "SKIP: Script niet gevonden: $ScriptPath" -ForegroundColor Yellow
        return
    }

    try {
        & $ScriptPath
        if ($LASTEXITCODE -ne $null -and $LASTEXITCODE -ne 0) {
            Write-Host "WARN: Stap '$Name' gaf exit code $LASTEXITCODE" -ForegroundColor Yellow
        } else {
            Write-Host "OK: $Name" -ForegroundColor Green
        }
    } catch {
        Write-Host "ERROR in '$Name': $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Definieer je stappen 1x, en hergebruik ze overal
$steps = @{
    "1" = @{ Name="Disable PS1 security"; Script="$root\windows\disable-ps1-security.ps1" }
    "2" = @{ Name="Install Winget packages"; Script="$root\install\install-winget.ps1" }
    "3" = @{ Name="Install global Node/NPM packages"; Script="$root\install\install-node.ps1" }
    "4" = @{ Name="Enable old context menu"; Script="$root\enable-old-context-menu.ps1" }
}

function Show-Menu {
    Clear-Host
    Write-Host "== Windows dotfiles setup ==" -ForegroundColor White
    Write-Host ""
    Write-Host "Kies wat je wil uitvoeren:"
    Write-Host "  1) Disable PS1 security"
    Write-Host "  2) Install Winget packages"
    Write-Host "  3) Install global Node/NPM packages"
    Write-Host "  4) Enable old context menu"
    Write-Host ""
    Write-Host "  A) Alles draaien (1-4)"
    Write-Host "  C) Custom selectie (bv: 1,2,4)"
    Write-Host "  Q) Stoppen"
    Write-Host ""
}

function Run-Selection {
    param([string[]]$keys)

    foreach ($k in $keys) {
        $k = $k.Trim()
        if ($steps.ContainsKey($k)) {
            Invoke-Step -Name $steps[$k].Name -ScriptPath $steps[$k].Script
        } else {
            Write-Host "Onbekende keuze: '$k' (overgeslagen)" -ForegroundColor Yellow
        }
    }

    Write-Host "`nKlaar. Druk op Enter om terug te gaan naar het menu..." -ForegroundColor DarkGray
    [void](Read-Host)
}

while ($true) {
    Show-Menu
    $choice = (Read-Host "Je keuze").Trim().ToUpper()

    switch ($choice) {
        "1" { Run-Selection @("1") }
        "2" { Run-Selection @("2") }
        "3" { Run-Selection @("3") }
        "4" { Run-Selection @("4") }

        "A" { Run-Selection @("1","2","3","4") }

        "C" {
            $raw = Read-Host "Welke stappen? (bv: 1,2,4)"
            $list = $raw.Split(",") | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
            Run-Selection $list
        }

        "Q" { break }

        default {
            Write-Host "Ongeldige keuze. Druk op Enter..." -ForegroundColor Yellow
            [void](Read-Host)
        }
    }
}

Write-Host "`nBye 👋" -ForegroundColor DarkGray