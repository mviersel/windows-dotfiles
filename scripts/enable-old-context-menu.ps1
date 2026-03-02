# Enables classic (Windows 10-style) context menu in Windows 11
# Run PowerShell as Administrator

$regPath = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"

New-Item -Path $regPath -Force | Out-Null
Set-ItemProperty -Path $regPath -Name "(default)" -Value "" -Force

Write-Host "Classic context menu enabled. Restarting Explorer..." -ForegroundColor Green

Stop-Process -Name explorer -Force
Start-Process explorer