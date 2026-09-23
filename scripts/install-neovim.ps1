<#
.SYNOPSIS
Installs Neovim and activates the configuration included in this repository.

.DESCRIPTION
Installs Neovim, Git, and ripgrep through winget unless -SkipPackages is used.
It then backs up an existing Neovim configuration and either creates a
junction to the supplied configuration folder or copies that folder.

.PARAMETER ConfigSource
Path to the Neovim configuration to install. By default, this is resolved as
config\nvim relative to this script's parent directory.

.PARAMETER InstallMode
Junction keeps the installed configuration linked to the repository. Copy
creates an independent copy in the standard Neovim configuration directory.

.PARAMETER SkipPackages
Skips package installation and only activates the configuration.

.EXAMPLE
.\scripts\install-neovim.ps1

.EXAMPLE
.\scripts\install-neovim.ps1 -InstallMode Copy -SkipPackages
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter()]
    [string]$ConfigSource = (Join-Path (Split-Path -Parent $PSScriptRoot) "config\nvim"),

    [Parameter()]
    [ValidateSet("Junction", "Copy")]
    [string]$InstallMode = "Junction",

    [Parameter()]
    [switch]$SkipPackages
)

$ErrorActionPreference = "Stop"

if ([System.Environment]::OSVersion.Platform -ne [System.PlatformID]::Win32NT) {
    throw "This installer targets Windows. See config/nvim/README.md for manual installation on other platforms."
}

$source = [System.IO.Path]::GetFullPath($ConfigSource)
if (-not (Test-Path -LiteralPath $source -PathType Container)) {
    throw "Neovim configuration directory not found: $source"
}

if (-not (Test-Path -LiteralPath (Join-Path $source "init.lua") -PathType Leaf)) {
    throw "The configuration directory does not contain init.lua: $source"
}

if (-not $env:LOCALAPPDATA) {
    throw "LOCALAPPDATA is not defined; the standard Neovim configuration path cannot be determined."
}

$destination = Join-Path $env:LOCALAPPDATA "nvim"

if (-not $SkipPackages) {
    $winget = Get-Command winget.exe -ErrorAction SilentlyContinue
    if (-not $winget) {
        throw "winget is required to install packages. Install App Installer or rerun with -SkipPackages."
    }

    $packages = @(
        @{ Id = "Neovim.Neovim"; Name = "Neovim" },
        @{ Id = "Git.Git"; Name = "Git" },
        @{ Id = "BurntSushi.ripgrep.MSVC"; Name = "ripgrep" }
    )

    foreach ($package in $packages) {
        if ($PSCmdlet.ShouldProcess($package.Name, "Install with winget")) {
            Write-Host "Installing $($package.Name)..."
            & $winget.Source install --id $package.Id --exact --source winget `
                --accept-package-agreements --accept-source-agreements
            if ($LASTEXITCODE -ne 0) {
                throw "winget failed to install $($package.Name) (exit code $LASTEXITCODE)."
            }
        }
    }
}

$alreadyActive = $false
if (Test-Path -LiteralPath $destination) {
    $existing = Get-Item -LiteralPath $destination -Force
    if ($InstallMode -eq "Junction" -and $existing.LinkType -eq "Junction") {
        $target = [System.IO.Path]::GetFullPath([string]$existing.Target)
        $alreadyActive = $target.TrimEnd("\") -ieq $source.TrimEnd("\")
    }
}

if ($alreadyActive) {
    Write-Host "Neovim configuration is already linked to: $source"
} else {
    if (Test-Path -LiteralPath $destination) {
        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $backup = Join-Path (Split-Path -Parent $destination) "nvim.backup-$timestamp"
        if ($PSCmdlet.ShouldProcess($destination, "Move existing configuration to $backup")) {
            Move-Item -LiteralPath $destination -Destination $backup
            Write-Host "Existing configuration backed up to: $backup"
        }
    }

    if ($InstallMode -eq "Junction") {
        if ($PSCmdlet.ShouldProcess($destination, "Create junction to $source")) {
            New-Item -ItemType Junction -Path $destination -Target $source | Out-Null
        }
    } else {
        if ($PSCmdlet.ShouldProcess($destination, "Copy configuration from $source")) {
            Copy-Item -LiteralPath $source -Destination $destination -Recurse
        }
    }
}

if ($WhatIfPreference) {
    Write-Host "Dry run complete; no changes were made."
} else {
    Write-Host "Neovim configuration ready at: $destination"
    Write-Host "Start Neovim with 'nvim'. Plugins will be installed on the first launch."
}
