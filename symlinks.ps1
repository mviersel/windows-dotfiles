# --- Config ---
$Dotfiles = "$HOME\windows-dotfiles"

$Links = @{
  # Home
  "$HOME\.gitconfig" = "$Dotfiles\.gitconfig"

  # GlazeWM
  "$HOME\.glzr\glazewm\config.yaml" = "$Dotfiles\.glzr\glazewm\config.yaml"

  # .config (fastfetch + yasb)
  "$HOME\.config\fastfetch\config.jsonc" = "$Dotfiles\.config\fastfetch\config.jsonc"
  "$HOME\.config\yasb"                   = "$Dotfiles\.config\yasb"

  # PowerShell profile (juiste bron!)
  "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" = "$Dotfiles\Powershell\Microsoft.PowerShell_profile.ps1"

  # LocalAppData
  "$env:LOCALAPPDATA\alacritty" = "$Dotfiles\alacritty"
  "$env:LOCALAPPDATA\nvim"      = "$Dotfiles\nvim"
}

function Ensure-ParentDir([string]$Path) {
    $parent = Split-Path -Path $Path -Parent
    if ($parent -and !(Test-Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
}

function Is-Link([string]$Path) {
    try {
        $item = Get-Item -LiteralPath $Path -Force
        return [bool]$item.LinkType
    } catch {
        return $false
    }
}

function Backup-Existing([string]$Target) {
    if (Test-Path $Target) {
        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $backup = "$Target.backup-$timestamp"
        Write-Host "Backup: $Target -> $backup"
        Move-Item -LiteralPath $Target -Destination $backup -Force
    }
}

function Same-Drive([string]$A, [string]$B) {
    try {
        return ((Split-Path -Qualifier $A) -eq (Split-Path -Qualifier $B))
    } catch {
        return $false
    }
}

foreach ($Target in $Links.Keys) {
    $Source = $Links[$Target]

    # Normalize (haal trailing slashes weg)
    $Target = $Target.TrimEnd('\')
    $Source = $Source.TrimEnd('\')

    # Source must exist
    if (!(Test-Path $Source)) {
        Write-Host "Bron bestaat niet, skip: $Source" -ForegroundColor Yellow
        continue
    }

    Ensure-ParentDir $Target

    # Als target bestaat: link -> verwijderen, anders backup
    if (Test-Path $Target) {
        if (Is-Link $Target) {
            Write-Host "Verwijder bestaande link: $Target"
            Remove-Item -LiteralPath $Target -Force -Recurse
        } else {
            Backup-Existing $Target
        }
    }

    $srcItem = Get-Item -LiteralPath $Source -Force

    Write-Host "Link maken: $Target -> $Source"

    if ($srcItem.PSIsContainer) {
        # Directory: Junction werkt zonder admin
        cmd /c "mklink /J `"$Target`" `"$Source`"" | Out-Null
    } else {
        # File: probeer hardlink (no admin, zelfde drive), anders symlink (kan admin/dev mode vereisen)
        if (Same-Drive $Target $Source) {
            cmd /c "mklink /H `"$Target`" `"$Source`"" | Out-Null
        } else {
            # fallback: symlink
            try {
                New-Item -ItemType SymbolicLink -Path $Target -Target $Source | Out-Null
            } catch {
                Write-Host "Kon geen hardlink maken (andere drive) en symlink faalde. Run als Admin of zet Developer Mode aan." -ForegroundColor Red
                Write-Host "Target: $Target" -ForegroundColor Red
                Write-Host "Source: $Source" -ForegroundColor Red
            }
        }
    }
}

Write-Host "Klaar." -ForegroundColor Green
