<#
Master setup script for new Windows install.
Run this as Administrator in PowerShell:

    Set-ExecutionPolicy Bypass -Scope Process -Force
    .\setup.ps1
#>

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root

Write-Host "== Windows dotfiles setup starting =="

# 1) Allow scripts for this process (safe)
Write-Host "Step 1: Setting execution policy (Process: Bypass)..."
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# 2) (Optional) disable PS1 security script if it exists
$disablePs1 = Join-Path $root "playground\windows\disable-ps1-security.ps1"
if (Test-Path $disablePs1) {
    Write-Host "Step 2: Running disable-ps1-security.ps1..."
    & $disablePs1
} else {
    Write-Host "Step 2: Skipping disable-ps1-security.ps1 (not found at $disablePs1)" -ForegroundColor Yellow
}

# 3) Install Winget packages
$wingetScript = Join-Path $root "install\install-winget.ps1"
if (Test-Path $wingetScript) {
    Write-Host "Step 3: Installing Winget packages..."
    & $wingetScript
} else {
    Write-Host "Step 3: Skipping Winget install (script not found)" -ForegroundColor Yellow
}

# 4) Install global Node/NPM packages
$nodeScript = Join-Path $root "install\install-node.ps1"
if (Test-Path $nodeScript) {
    Write-Host "Step 4: Installing global Node/NPM packages..."
    & $nodeScript
} else {
    Write-Host "Step 4: Skipping Node install (script not found)" -ForegroundColor Yellow
}

# 5) Create symlinks/junctions/hardlinks for dotfiles
$symlinksScript = Join-Path $root "symlinks.ps1"
if (Test-Path $symlinksScript) {
    Write-Host "Step 5: Linking dotfiles..."
    & $symlinksScript
} else {
    Write-Host "Step 5: Skipping symlinks (symlinks.ps1 not found)" -ForegroundColor Yellow
}

# 6) Enable old context menu
$ctxMenuScript = Join-Path $root "enable-old-context-menu.ps1"
if (Test-Path $ctxMenuScript) {
    Write-Host "Step 6: Enabling old context menu..."
    & $ctxMenuScript
} else {
    Write-Host "Step 6: Skipping old context menu (script not found)" -ForegroundColor Yellow
}

Write-Host "== All done! You may want to reboot to ensure all settings are applied. ==" -ForegroundColor Green