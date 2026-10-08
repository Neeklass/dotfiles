# VS Code

My editing and layout preferences, with Catppuccin Mocha in the full preset.

## Files

| File | Purpose |
| --- | --- |
| [`settings.json`](settings.json) | Full setup, including Catppuccin theme and icons and telemetry disabled |
| [`settings.minimal.json`](settings.minimal.json) | Same editing and layout settings, without the two theme selections or the telemetry override |
| [`extensions.txt`](extensions.txt) | Catppuccin color theme and icon theme extension IDs |
| [`install.ps1`](install.ps1) | Windows installer with backups and dry-run support |

Both presets are standalone files you can copy directly into VS Code. Their
shared settings are intentionally repeated so neither needs a generator or
merge step. Keep common preferences in sync when editing them. The minimal
preset still disables AI features, like the full preset.

## Install on Windows

Install VS Code first, close its windows, then run from the repository root
in PowerShell 5.1 or newer:

```powershell
.\config\vscode\install.ps1 -WhatIf
.\config\vscode\install.ps1
```

The default preset is `Full`. To use the minimal preset without installing
the theme extensions:

```powershell
.\config\vscode\install.ps1 -SettingsVariant Minimal -SkipExtensions
```

The installer backs up existing settings as
`settings.json.bak-YYYYMMDD-HHMMSS-fffffff` in the same directory before
replacing them. It copies the original file as-is, including any comments;
it does **not** merge your settings with the preset. A failed backup stops
replacement. Keybindings, snippets, and other user files are left alone.
Linked settings files are refused so their targets cannot be overwritten.

`-WhatIf` previews settings and extension operations without creating folders,
backups, or installing anything. `-Confirm` prompts before each operation.
Extension failures are reported; settings may already have been applied.
Without the `code` CLI, settings are still applied and extensions are skipped
with a warning. `-SkipExtensions` explicitly skips them.

Use `-VSCodeUser` for a different user directory or `-DotfilesRoot` for another
source folder. The default destination is `%APPDATA%\Code\User`; named profiles,
Insiders, and portable installations may use other locations. VS Code Settings
Sync can also change or propagate settings, so review its state first.

To restore, close VS Code and copy the desired backup over `settings.json`.
Extensions are managed separately in VS Code. For all script options:

```powershell
Get-Help .\config\vscode\install.ps1 -Full
```

## Manual setup and other platforms

In VS Code, run **Preferences: Open User Settings (JSON)** from the Command
Palette. Back up that file, then copy either preset or just the settings you
want. This also lets you keep existing JSON comments and unrelated preferences.
Install the extensions from `extensions.txt` through the Extensions view if
you want the Catppuccin theme and icons.

The settings can be used on Windows, Linux, and macOS; the installer is Windows
only. UI behavior can vary with platform and VS Code version.
