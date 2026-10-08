<#
.SYNOPSIS
Applies a VS Code settings preset and installs the listed extensions on Windows.

.DESCRIPTION
Backs up existing settings before replacing them; settings are not merged.
Keybindings and snippets are left alone. Supports -WhatIf and -Confirm.

.PARAMETER DotfilesRoot
Folder containing the settings presets and extensions.txt. Defaults to this folder.

.PARAMETER VSCodeUser
VS Code user directory. Defaults to %APPDATA%\Code\User.

.PARAMETER SettingsVariant
Full applies settings.json; Minimal applies settings.minimal.json.

.PARAMETER SkipExtensions
Applies only settings, without invoking the VS Code CLI.

.EXAMPLE
.\config\vscode\install.ps1 -WhatIf

.EXAMPLE
.\config\vscode\install.ps1 -SettingsVariant Minimal -SkipExtensions
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$DotfilesRoot = $PSScriptRoot,
    [string]$VSCodeUser,
    [ValidateSet('Full', 'Minimal')]
    [string]$SettingsVariant = 'Full',
    [switch]$SkipExtensions
)

# Keep the function available when the script is dot-sourced.
function Install-VSCodeDotfiles {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string]$DotfilesRoot = $PSScriptRoot,
        [string]$VSCodeUser,
        [ValidateSet('Full', 'Minimal')]
        [string]$SettingsVariant = 'Full',
        [switch]$SkipExtensions
    )

    $ErrorActionPreference = 'Stop'

    if ([Environment]::OSVersion.Platform -ne [PlatformID]::Win32NT) {
        throw 'This installer targets Windows. See config/vscode/README.md for manual setup.'
    }
    if (-not $VSCodeUser) {
        if (-not $env:APPDATA) { throw 'APPDATA is not defined; pass -VSCodeUser explicitly.' }
        $VSCodeUser = Join-Path $env:APPDATA 'Code\User'
    }

    $DotfilesRoot = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($DotfilesRoot)
    $VSCodeUser = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($VSCodeUser)
    $settingsName = if ($SettingsVariant -eq 'Minimal') { 'settings.minimal.json' } else { 'settings.json' }
    $source = Join-Path $DotfilesRoot $settingsName
    $destination = Join-Path $VSCodeUser 'settings.json'
    $extensionsFile = Join-Path $DotfilesRoot 'extensions.txt'

    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
        throw "Settings file not found: $source"
    }
    # Validate the repository's plain JSON without parsing or rewriting the user's JSONC.
    Get-Content -LiteralPath $source -Raw | ConvertFrom-Json | Out-Null
    if ($VSCodeUser.TrimEnd('\') -ieq $DotfilesRoot.TrimEnd('\') -or
        $VSCodeUser.StartsWith($DotfilesRoot.TrimEnd('\') + '\', [StringComparison]::OrdinalIgnoreCase)) {
        throw 'The VS Code user directory must be outside the source folder.'
    }
    $existing = Get-Item -LiteralPath $destination -Force -ErrorAction SilentlyContinue
    if ($existing -and ($existing.PSIsContainer -or ($existing.Attributes -band [IO.FileAttributes]::ReparsePoint))) {
        throw "Expected a regular settings file; manage this directory or link manually: $destination"
    }

    $backup = "$destination.bak-$(Get-Date -Format 'yyyyMMdd-HHmmss-fffffff')"
    $action = "Apply $settingsName"
    if ($existing) { $action += " after backing up existing settings to $backup" }

    # Backup and replacement are one operation: declining it cannot overwrite settings.
    if ($PSCmdlet.ShouldProcess($destination, $action)) {
        New-Item -ItemType Directory -Path $VSCodeUser -Force -Confirm:$false | Out-Null
        if ($existing) {
            if (Test-Path -LiteralPath $backup) { throw "Backup already exists: $backup" }
            Copy-Item -LiteralPath $destination -Destination $backup -Confirm:$false
            Write-Host "Existing settings backed up to: $backup"
        }
        Copy-Item -LiteralPath $source -Destination $destination -Force -Confirm:$false
        Write-Host "Applied $settingsName to: $destination"
    }

    if (-not $SkipExtensions) {
        $codeCommand = Get-Command code -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
        if (-not (Test-Path -LiteralPath $extensionsFile -PathType Leaf)) {
            Write-Warning 'No extensions.txt found. Skipping extensions.'
        } elseif (-not $codeCommand -and -not $WhatIfPreference) {
            Write-Warning "VS Code CLI 'code' was not found. Add it to PATH and rerun to install extensions."
        } else {
            $extensions = Get-Content -LiteralPath $extensionsFile |
                ForEach-Object { $_.Trim() } |
                Where-Object { $_ -and -not $_.StartsWith('#') } |
                Select-Object -Unique
            foreach ($extension in $extensions) {
                if ($PSCmdlet.ShouldProcess($extension, 'Install VS Code extension')) {
                    & $codeCommand.Source --install-extension $extension
                    if ($LASTEXITCODE -ne 0) {
                        throw "Failed to install extension $extension (exit code $LASTEXITCODE). Settings may already have been applied."
                    }
                }
            }
        }
    }

    if ($WhatIfPreference) { Write-Host 'Dry run complete; no changes were made.' }
}

if ($MyInvocation.InvocationName -ne '.') {
    Install-VSCodeDotfiles @PSBoundParameters
}
