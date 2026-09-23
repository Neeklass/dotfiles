# Neovim configuration

A portable Lua configuration for Neovim on Windows, Linux, and macOS. It works
in a terminal and includes a few Neovide-specific settings when Neovide is in
use.

## Features

- `lazy.nvim` plugin management with a committed lockfile
- Catppuccin Mocha theme
- nvim-tree file explorer
- Telescope file and text search
- lualine status line
- gitsigns change markers
- Reusable bottom terminal
- System clipboard and familiar GUI-style shortcuts

Neovim, Git, and ripgrep are required. A Nerd Font is recommended for icons,
and `fd` is optional for faster file discovery.

## Install on Windows

From the repository root, run:

```powershell
.\scripts\install-neovim.ps1
```

The script installs Neovim, Git, and ripgrep with `winget`, backs up any
existing Neovim configuration, and creates a junction from the standard
Neovim config directory to this folder. Because the default is a junction,
changes made in this repository are immediately active.

To install a standalone copy instead:

```powershell
.\scripts\install-neovim.ps1 -InstallMode Copy
```

To configure the files without installing packages:

```powershell
.\scripts\install-neovim.ps1 -SkipPackages
```

The script accepts `-ConfigSource` if this config is stored outside the normal
repository layout. Use `Get-Help .\scripts\install-neovim.ps1 -Full` for all
options.

Existing configurations are renamed to a timestamped sibling such as
`nvim.backup-YYYYMMDD-HHMMSS`; they are never silently deleted. Add `-WhatIf`
to preview every action without changing the system.

## Install manually

Neovim reads its configuration from the directory returned by:

```vim
:echo stdpath('config')
```

Copy this folder there, or link that directory to this folder. Common paths
are:

- Windows: `%LOCALAPPDATA%\nvim`
- Linux and macOS: `${XDG_CONFIG_HOME:-~/.config}/nvim`

Example for Linux or macOS:

```sh
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}"
ln -s /path/to/dotfiles/config/nvim "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
```

On first launch, `lazy.nvim` bootstraps itself and installs the plugins pinned
in `lazy-lock.json`. Internet access is required for that first launch.

## Key mappings

| Mapping | Action |
|---|---|
| `Ctrl+B` or `<leader>e` | Toggle file explorer |
| `<leader>eo` | Open or focus file explorer |
| `<leader>ef` | Reveal current file in explorer |
| `Ctrl+P` or `<leader>ff` | Find files |
| `Ctrl+Shift+F` or `<leader>fg` | Search project text |
| `<leader>fb` | Find open buffers |
| `<leader>fc` | Find commands |
| `Ctrl+J` or `<leader>t` | Toggle bottom terminal |
| `Esc Esc` | Leave terminal input mode |
| `Ctrl+S` | Save |

The leader key is Space. Some terminals cannot distinguish every Ctrl+Shift
combination; the leader mappings provide reliable alternatives.

## Customization

The entry point is `init.lua`. Settings are split by purpose under
`lua/user/`, and plugin specifications are under `lua/user/plugins/`.

Neovide uses `JetBrainsMono NFM` at size 12 by default. Change `guifont` in
`lua/user/gui.lua` if that font is unavailable. Terminal fonts are configured
in the terminal application, not in Neovim.

The system clipboard setting may require `wl-clipboard`, `xclip`, or `xsel` on
Linux.

## Verify

After installation, start Neovim and run `:checkhealth`. For a non-interactive
startup check:

```powershell
nvim --headless +qa
```
