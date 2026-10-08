# Dotfiles

My personal editor and desktop configuration: Catppuccin Mocha in Neovim and
VS Code, with a quiet, glassy Windows desktop. A small collection of files I
use and adjust over time.

[neeklass.dev](https://neeklass.dev)

## The setup

| Configuration | What's included | Platform |
| --- | --- | --- |
| [Neovim](config/nvim/README.md) | Lua, lazy.nvim, Telescope, nvim-tree, lualine, gitsigns, and a bottom terminal | Windows, Linux, macOS |
| [VS Code](config/vscode/README.md) | Editor preferences, Catppuccin theme and icons, and an extension list | Settings across platforms; installer for Windows |
| [Windhawk](config/windhawk/README.md) | Taskbar sizing, taskbar styling, and Start menu styling | Windows 11 |
| [Wallpapers](wallpapers/README.md) | A place for future desktop backgrounds; no images yet | Any |

## Layout

```text
config/
  nvim/                  Lua configuration and pinned plugins
  vscode/                Settings presets, extensions, and installer
  windhawk/              Settings for three Windows customization mods
scripts/
  install-neovim.ps1      Windows Neovim setup
wallpapers/              Future backgrounds and attribution
```

Each configuration can be used on its own.

## Getting started

Clone the repository with Git, then read the settings you want to use:

```sh
git clone https://github.com/Neeklass/dotfiles.git
cd dotfiles
```

On Windows, use PowerShell 5.1 or newer from the repository root. Preview
either installer first:

```powershell
.\scripts\install-neovim.ps1 -WhatIf
.\config\vscode\install.ps1 -WhatIf
```

Run only the setup you want, without `-WhatIf`, to apply it:

```powershell
.\scripts\install-neovim.ps1
.\config\vscode\install.ps1
```

- **Neovim:** installs Neovim, Git, and ripgrep with `winget`, then backs up
  `%LOCALAPPDATA%\nvim` and links it to this checkout. Existing packages are
  not upgraded. Keep the checkout in place, or use `-InstallMode Copy` for
  an independent copy. Use `-SkipPackages` if dependencies are already installed.
- **VS Code:** requires VS Code to be installed. Backs up and **replaces**
  `%APPDATA%\Code\User\settings.json`; it does not merge settings. Installs
  the extensions in `extensions.txt` when `code` is on PATH. Review the
  [presets and manual setup](config/vscode/README.md) to apply individual settings.
- **Windhawk:** import each YAML file into its matching mod using the
  [setup instructions](config/windhawk/README.md).

Both scripts support `-Confirm` and keep timestamped backups next to the
original configuration. Close the relevant editor before applying settings.
If PowerShell blocks a script, review it and follow your machine's execution
policy; these instructions do not require a machine-wide policy change.

## Make it yours

Neovim settings live under [`config/nvim/lua/user/`](config/nvim/lua/user/),
with plugin options in `plugins/`. Its [README](config/nvim/README.md) covers
dependencies, keybindings, fonts, and manual installation on Linux and macOS.
The committed `lazy-lock.json` records plugin versions; review changes to it
when updating plugins.

VS Code's [full preset](config/vscode/settings.json) includes my theme and
privacy preferences. The [minimal preset](config/vscode/settings.minimal.json)
keeps the same editing and layout choices without selecting themes or setting
telemetry. Both are complete, editable settings files.

The PowerShell installers target Windows. Neovim also has Unix shell and
clipboard support; fonts and clipboard tools depend on the host. Windhawk
styles depend on Windows 11 and the installed mod versions.

Future wallpapers can go directly in [`wallpapers/`](wallpapers/README.md).
When there are real screenshots to share, keep them beside the relevant
configuration and link them from its README.

No repository-wide license has been selected yet. Any future wallpaper
entries should carry their own source, attribution, and reuse terms.
