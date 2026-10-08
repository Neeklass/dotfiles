<#
.SYNOPSIS
Installs Neovim and activates the configuration included in this repository.

.DESCRIPTION
Installs Neovim, Git, and ripgrep through winget unless -SkipPackages is used.
Existing packages are not upgraded. Supports -WhatIf and -Confirm.
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

$source = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ConfigSource).TrimEnd('\')
if (-not (Test-Path -LiteralPath $source -PathType Container)) {
    throw "Neovim configuration directory not found: $source"
}

if (-not (Test-Path -LiteralPath (Join-Path $source "init.lua") -PathType Leaf)) {
    throw "The configuration directory does not contain init.lua: $source"
}

if (-not $env:LOCALAPPDATA) {
    throw "LOCALAPPDATA is not defined; the standard Neovim configuration path cannot be determined."
}

$destination = [System.IO.Path]::GetFullPath((Join-Path $env:LOCALAPPDATA "nvim"))
$comparison = [System.StringComparison]::OrdinalIgnoreCase
if ($source -ieq $destination -or
    $source.StartsWith($destination + '\', $comparison) -or
    $destination.StartsWith($source + '\', $comparison)) {
    throw "Source and destination must be separate, non-nested directories: $source and $destination"
}

# This script manages the default profile, not an XDG or NVIM_APPNAME override.
if ($env:XDG_CONFIG_HOME -or ($env:NVIM_APPNAME -and $env:NVIM_APPNAME -ne 'nvim')) {
    throw "A custom Neovim config path is active. Use the manual setup in config/nvim/README.md."
}

$existing = Get-Item -LiteralPath $destination -Force -ErrorAction SilentlyContinue
$alreadyActive = $false
if ($existing -and $InstallMode -eq "Junction" -and $existing.LinkType -eq "Junction") {
    $target = [System.IO.Path]::GetFullPath([string]$existing.Target)
    $alreadyActive = $target.TrimEnd('\') -ieq $source
}

if (-not $SkipPackages) {
    $winget = Get-Command winget.exe -ErrorAction SilentlyContinue
    if (-not $winget -and -not $WhatIfPreference) {
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
                --accept-package-agreements --accept-source-agreements --no-upgrade
            # WinGet reports an already-installed package as a nonzero HRESULT.
            if ($LASTEXITCODE -notin @(0, -1978335135)) { # 0x8A150061: PACKAGE_ALREADY_INSTALLED
                throw "winget failed to install $($package.Name) (exit code $LASTEXITCODE)."
            }
        }
    }
}

if ($alreadyActive) {
    Write-Host "Neovim configuration is already linked to: $source"
} else {
    $backup = "$destination.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss-fffffff')"
    $action = "Activate configuration from $source using $InstallMode"
    if ($existing) { $action += "; back up existing configuration to $backup" }

    # Confirm backup and activation together so declining cannot overwrite files.
    if (-not $PSCmdlet.ShouldProcess($destination, $action)) {
        if ($WhatIfPreference) { Write-Host "Dry run complete; no changes were made." }
        else { Write-Host "Configuration activation skipped." }
        return
    }

    if ($existing) {
        if (Test-Path -LiteralPath $backup) { throw "Backup already exists: $backup" }
        # Rename within the same parent; a junction's target is never moved.
        Rename-Item -LiteralPath $destination -NewName (Split-Path -Leaf $backup) -Confirm:$false
        Write-Host "Existing configuration backed up to: $backup"
    }

    try {
        if ($InstallMode -eq "Junction") {
            New-Item -ItemType Junction -Path $destination -Target $source -Confirm:$false | Out-Null
        } else {
            Copy-Item -LiteralPath $source -Destination $destination -Recurse -Confirm:$false
        }
    } catch {
        if ($existing) { Write-Warning "Activation failed. The previous configuration is preserved at: $backup" }
        throw
    }
}

if ($WhatIfPreference) {
    Write-Host "Dry run complete; no changes were made."
} else {
    Write-Host "Neovim configuration ready at: $destination"
    Write-Host "Start Neovim with 'nvim'. Plugins will be installed on the first launch."
}
