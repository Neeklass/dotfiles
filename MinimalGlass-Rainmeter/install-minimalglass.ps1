$ErrorActionPreference = "Stop"

$target = Join-Path $env:USERPROFILE "Documents\Rainmeter\Skins\MinimalGlass"
$source = Join-Path $PSScriptRoot "MinimalGlass.ini"

New-Item -ItemType Directory -Force -Path $target | Out-Null
Copy-Item -Force $source (Join-Path $target "MinimalGlass.ini")

Write-Host ""
Write-Host "MinimalGlass was installed to:" -ForegroundColor Green
Write-Host "  $target"
Write-Host ""
Write-Host "Next, in Rainmeter:"
Write-Host "  1. Right-click the Rainmeter tray icon -> Refresh all"
Write-Host "  2. Manage -> MinimalGlass -> MinimalGlass.ini -> Load"
Write-Host "  3. Drag the widget to the bottom-right corner"
Write-Host "  4. Turn Draggable OFF"
Write-Host "  5. Turn Keep on screen and Save position ON"
Write-Host ""
Write-Host "Note: The skin requires the FrostBehind plugin for acrylic blur."
