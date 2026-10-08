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

Neovim **0.11.7 or newer with LuaJIT**, Git, and ripgrep are required by this
setup ([the pinned Telescope version](https://github.com/nvim-telescope/telescope.nvim/blob/7d324792b7943e4aa16ad007212e6acc6f9fe335/README.md#requirements)
requires Neovim 0.11.7). A Nerd Font is
recommended for icons, and `fd` is optional for faster file discovery.

## Install on Windows

From the repository root, use PowerShell 5.1 or newer. Preview first, then
apply with Neovim closed:

```powershell
.\scripts\install-neovim.ps1 -WhatIf
.\scripts\install-neovim.ps1
```

The script installs Neovim, Git, and ripgrep with `winget`, backs up any
existing Neovim configuration, and creates a junction from the standard
Neovim config directory to this folder. Because the default is a junction,
changes made in this repository are immediately active. Keep the checkout in
place. Existing packages are not upgraded; check `nvim --version` and update
an older installation separately. Package and source agreements are accepted
when running the package installation.

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
`nvim.backup-YYYYMMDD-HHMMSS-fffffff`; they are never silently deleted. An
existing junction is renamed without moving its target. Add `-WhatIf` to
preview every action without changing the system, or `-Confirm` to approve
operations individually. If activation fails after a backup, the script
reports where the previous configuration is preserved.

To restore a backup, close Neovim, move the current configuration aside, and
rename the chosen backup to `nvim`. If the current entry is a junction, remove
only the link, not the configuration folder it points to. Backups of junctions
preserve the link, not a snapshot of its target files.

The installer targets `%LOCALAPPDATA%\nvim`. For `XDG_CONFIG_HOME` or a custom
`NVIM_APPNAME`, use the manual instructions instead.

## Install manually

Neovim reads its configuration from the directory returned by:

```vim
:echo stdpath('config')
```

Copy this folder there, or link that directory to this folder. Common paths
are:

- Windows: `%LOCALAPPDATA%\nvim`
- Linux and macOS: `${XDG_CONFIG_HOME:-~/.config}/nvim`

On Linux or macOS, first back up any existing `nvim` file, directory, or link.
From the repository root, this example refuses to overwrite one:

```sh
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}"
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
if [ -e "$config_dir" ] || [ -L "$config_dir" ]; then
  printf 'Back up the existing configuration first: %s\n' "$config_dir"
else
  ln -s "$PWD/config/nvim" "$config_dir"
fi
```

On first launch, `lazy.nvim` bootstraps itself and installs the plugins pinned
in `lazy-lock.json`. Internet access is required for that first launch.
Use `:Lazy restore` to return installed plugins to the committed versions;
`:Lazy update` changes the lockfile. In junction mode, those lockfile changes
also affect this checkout.

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
startup check after plugins are installed:

```powershell
nvim --headless +qa
```
