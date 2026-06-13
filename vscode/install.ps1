# VS Code Dotfiles Installer for Windows
# Installs extensions and applies VS Code user settings.

function Install-VSCodeDotfiles {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [string]$DotfilesRoot = $PSScriptRoot,
        [string]$VSCodeUser = (Join-Path $env:APPDATA 'Code\User')
    )

    if (-not $DotfilesRoot) {
        $DotfilesRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
    }

    if (-not (Test-Path $DotfilesRoot)) {
        throw "Dotfiles root not found: $DotfilesRoot"
    }

    $Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $SettingsMinimal = Join-Path $DotfilesRoot 'settings.minimal.json'
    $SettingsFull = Join-Path $DotfilesRoot 'settings.json'
    $Keybindings = Join-Path $DotfilesRoot 'keybindings.json'
    $Snippets = Join-Path $DotfilesRoot 'snippets'
    $ExtensionsFile = Join-Path $DotfilesRoot 'extensions.txt'

    Write-Host ""
    Write-Host "============================================="
    Write-Host " VS Code Dotfiles Installer"
    Write-Host "============================================="
    Write-Host ""

    New-Item -ItemType Directory -Force -Path $VSCodeUser | Out-Null

    $CodeCommand = Get-Command code -ErrorAction SilentlyContinue
    if (-not $CodeCommand) {
        Write-Warning "VS Code CLI command 'code' was not found. Extension installation will be skipped."
    }

    Write-Host "Creating backups..."

    if (Test-Path (Join-Path $VSCodeUser 'settings.json')) {
        Copy-Item (Join-Path $VSCodeUser 'settings.json') (Join-Path $VSCodeUser "settings.json.bak-$Timestamp") -Force
        Write-Host "Backed up settings.json"
    }

    if (Test-Path (Join-Path $VSCodeUser 'keybindings.json')) {
        Copy-Item (Join-Path $VSCodeUser 'keybindings.json') (Join-Path $VSCodeUser "keybindings.json.bak-$Timestamp") -Force
        Write-Host "Backed up keybindings.json"
    }

    if (Test-Path (Join-Path $VSCodeUser 'snippets')) {
        Copy-Item (Join-Path $VSCodeUser 'snippets') (Join-Path $VSCodeUser "snippets.bak-$Timestamp") -Recurse -Force
        Write-Host "Backed up snippets"
    }

    Write-Host ""

    if (Test-Path $SettingsFull) {
        if ($PSCmdlet.ShouldProcess($VSCodeUser, "Copy settings.json")) {
            Copy-Item $SettingsFull (Join-Path $VSCodeUser 'settings.json') -Force
            Write-Host "Applied settings.json"
        }
    } elseif (Test-Path $SettingsMinimal) {
        if ($PSCmdlet.ShouldProcess($VSCodeUser, "Copy settings.minimal.json")) {
            Copy-Item $SettingsMinimal (Join-Path $VSCodeUser 'settings.json') -Force
            Write-Host "Applied settings.minimal.json"
        }
    } else {
        Write-Warning "No settings file found. Skipping settings."
    }

    Write-Host ""

    if ($CodeCommand -and (Test-Path $ExtensionsFile)) {
        Write-Host "Installing extensions from extensions.txt..."
        Write-Host ""

        Get-Content $ExtensionsFile |
            ForEach-Object { $_.Trim() } |
            Where-Object { $_ -and -not $_.StartsWith("#") } |
            ForEach-Object {
                if ($PSCmdlet.ShouldProcess("VS Code", "Install extension $_")) {
                    Write-Host "Installing extension: $_"
                    code --install-extension $_ --force
                }
            }

        Write-Host ""
        Write-Host "Finished extension installation."
    } elseif (-not (Test-Path $ExtensionsFile)) {
        Write-Warning "No extensions.txt found. Skipping extensions."
    }

    Write-Host ""

    if (Test-Path $Keybindings) {
        if ($PSCmdlet.ShouldProcess($VSCodeUser, "Copy keybindings.json")) {
            Copy-Item $Keybindings (Join-Path $VSCodeUser 'keybindings.json') -Force
            Write-Host "Applied keybindings.json"
        }
    }

    if (Test-Path $Snippets) {
        if ($PSCmdlet.ShouldProcess($VSCodeUser, "Copy snippets")) {
            Remove-Item (Join-Path $VSCodeUser 'snippets') -Recurse -Force -ErrorAction SilentlyContinue
            Copy-Item $Snippets (Join-Path $VSCodeUser 'snippets') -Recurse -Force
            Write-Host "Applied snippets."
        }
    }

    Write-Host ""
    Write-Host "============================================="
    Write-Host " Done."
    Write-Host "============================================="
    Write-Host ""
    Write-Host "VS Code user folder:"
    Write-Host $VSCodeUser
    Write-Host ""
}

if ($MyInvocation.InvocationName -ne '.') {
    Install-VSCodeDotfiles
}
