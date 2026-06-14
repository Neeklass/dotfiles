# Neovim Config

This is a clean Neovim Lua configuration.

## Current Scope

- Vanilla Neovim only
- Windows-first
- Neovide-aware
- Terminal-compatible fallback
- Future Linux compatibility considered
- Mouse enabled
- Absolute line numbers only
- Relative line numbers disabled
- 4-space indentation
- Tabs converted to spaces
- Word wrap enabled
- Mode display kept visible
- Minimal plugin layer for file explorer and statusline

## Intentionally Not Included Yet

- Git signs
- Picker/search UI
- Treesitter
- LSP
- Autocomplete
- Debugging
- Custom Neovim UI
- Theme plugin
- Terminal management plugin

## Plugins

Phase 2 adds a small plugin layer:

- `lazy.nvim` manages plugins.
- `nvim-tree.lua` provides the left-side file explorer.
- `lualine.nvim` provides the bottom statusline.
- `nvim-web-devicons` provides optional file/statusline icons.
- `gitsigns.nvim` provides lightweight Git change markers in the sign column.
- `telescope.nvim` provides file, text, buffer, and command pickers.

`nvim-web-devicons` is only for appearance. The config still works without a
Nerd Font, but icons may appear as boxes or unknown glyphs until Neovide or the
terminal uses a Nerd Font.

If `lazy-lock.json` is generated, commit it with the dotfiles. It pins plugin
versions and makes future installs more reproducible.

## Ctrl+C Tradeoff

`Ctrl+C` is only mapped for copying in Visual and Select mode. It is left alone
in Normal, Insert, Command, and Terminal modes so Neovim can still use it for
cancel/interrupt behavior. This is less VS Code-like, but safer and easier to
refine later.

## Maintenance Notes

`clipboard = "unnamedplus"` uses the system clipboard. On Linux this may require
a clipboard provider such as `wl-clipboard`, `xclip`, or `xsel`.

`Ctrl+V` is intentionally mapped to paste. This means it no longer starts Vim's
blockwise Visual mode. That matches the mouse-first, VS Code-like Phase 1 goal.

`Ctrl+Z` in Insert mode may return to Normal mode after undo. This is an
accepted simple Phase 1 tradeoff and can be refined after real usage testing.

Repo-local test commands require the `runtimepath` command shown below until
this folder is installed as the real Neovim config folder.

## Installation

Keep machine-specific paths out of the Lua config. Local setup should connect
the platform's normal Neovim config path to this repository folder.

### Current Windows Machine

The active Neovim config path on this machine is:

```text
C:\Users\Niklas\AppData\Local\nvim
```

That path is a Windows junction pointing to:

```text
C:\Users\Niklas\_repos\dotfiles\nvim
```

This is not a desktop shortcut. It is a filesystem link. Neovim and Neovide use
`AppData\Local\nvim` as the normal Windows config path, while the repository
folder remains the real source of truth.

Verify the junction:

```powershell
Get-Item "$env:LOCALAPPDATA\nvim" | Format-List FullName,LinkType,Target
```

Expected result:

```text
FullName : C:\Users\Niklas\AppData\Local\nvim
LinkType : Junction
Target   : C:\Users\Niklas\_repos\dotfiles\nvim
```

### Blank Windows Laptop Setup

PowerShell is enough on Windows. Bash is not required.

Install required tools:

- Git
- Neovim
- Neovide
- ripgrep

Optional:

- fd

Example using `winget`:

```powershell
winget install --id Git.Git
winget install --id Neovim.Neovim
winget install --id Neovide.Neovide
winget install --id BurntSushi.ripgrep.MSVC
winget install --id sharkdp.fd
```

Clone the dotfiles repository:

```powershell
New-Item -ItemType Directory -Force "$env:USERPROFILE\_repos" | Out-Null
git clone https://github.com/Neeklass/dotfiles "$env:USERPROFILE\_repos\dotfiles"
```

Back up an existing Neovim config if one exists:

```powershell
if (Test-Path "$env:LOCALAPPDATA\nvim") {
  $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
  Rename-Item -LiteralPath "$env:LOCALAPPDATA\nvim" -NewName "nvim.backup-$timestamp"
}
```

Create the AppData junction:

```powershell
New-Item -ItemType Junction `
  -Path "$env:LOCALAPPDATA\nvim" `
  -Target "$env:USERPROFILE\_repos\dotfiles\nvim"
```

Start Neovide normally:

```powershell
neovide
```

If `neovide` is not on `PATH`, launch the installed executable directly.

Inside Neovide, verify:

```vim
:echo $MYVIMRC
```

Expected result:

```text
C:\Users\<you>\AppData\Local\nvim\init.lua
```

That AppData path is correct because it is a junction to the repo config.

Undo the Windows junction:

```powershell
Remove-Item -LiteralPath "$env:LOCALAPPDATA\nvim"
```

For a junction, this removes the link, not the repository target.

Restore a backup:

```powershell
Rename-Item -LiteralPath "$env:LOCALAPPDATA\nvim.backup-YYYYMMDD-HHMMSS" -NewName "nvim"
```

Replace `YYYYMMDD-HHMMSS` with the actual backup timestamp.

### Fedora/Linux Setup

Install required tools:

```sh
sudo dnf install git neovim ripgrep fd-find
```

Clone the dotfiles repository:

```sh
mkdir -p ~/repos
git clone https://github.com/Neeklass/dotfiles ~/repos/dotfiles
```

Back up an existing Neovim config if one exists:

```sh
if [ -e ~/.config/nvim ]; then
  mv ~/.config/nvim ~/.config/nvim.backup-$(date +%Y%m%d-%H%M%S)
fi
```

Create the symlink:

```sh
mkdir -p ~/.config
ln -s ~/repos/dotfiles/nvim ~/.config/nvim
```

Test Neovim:

```sh
nvim --headless +qa
```

Neovide installation depends on current Fedora packaging, Flatpak availability,
or the official Neovide binary. The Lua config should not contain
machine-specific paths for Windows, work PCs, or Linux.

## Test With Neovide On Windows

From this repository:

```powershell
neovide -- --clean --cmd "set runtimepath^=.\nvim" -u .\nvim\init.lua
```

Or install/symlink/copy this `nvim` folder to:

```text
C:\Users\<you>\AppData\Local\nvim
```

Then start Neovide normally.

After startup, lazy.nvim may install missing plugins automatically. Open the
plugin manager with:

```vim
:Lazy
```

Toggle the explorer:

```text
Ctrl+B
```

or:

```vim
<leader>e
```

## Test In Terminal Neovim

From this repository:

```powershell
nvim --clean --cmd "set runtimepath^=.\nvim" -u .\nvim\init.lua
```

For a startup-only check:

```powershell
nvim --headless --clean --cmd "set runtimepath^=.\nvim" -u .\nvim\init.lua +qa
```

## Phase 2 Manual Checks

- `:Lazy` opens the plugin manager.
- `Ctrl+B` toggles the left-side explorer in Normal mode.
- `<leader>e` also toggles the explorer.
- Mouse click and mouse wheel work in the explorer.
- Opening files from the explorer works.
- The bottom statusline shows mode, filename, filetype, and line/column.
- Git branch appears in the statusline when available, without adding a Git
  plugin.

## Bottom Terminal

Phase 3 uses Neovim's built-in terminal, not a terminal plugin.

Toggle the bottom terminal:

```text
Ctrl+J
```

Fallback from Normal mode:

```vim
<leader>t
```

The terminal opens in a bottom horizontal split and uses the shell configured by
the platform settings. On Windows this usually means `pwsh.exe` or
`powershell.exe`; on Linux it will use `$SHELL`, such as bash or zsh.

Hiding the terminal hides the window but keeps the terminal buffer and shell
process alive when possible. Reopening the terminal reuses that buffer.

Leave terminal input mode:

```text
Esc Esc
```

Plain `Esc` is intentionally not mapped in terminal mode because it can
interfere with terminal programs.

## Phase 3 Manual Checks

- `Ctrl+J` opens a bottom terminal.
- The terminal starts in input mode.
- PowerShell accepts commands on Windows.
- `Ctrl+J` hides the terminal without killing the shell process.
- `Ctrl+J` reopens the same terminal session.
- `<leader>t` toggles the terminal from Normal mode.
- `Esc Esc` leaves terminal input mode.
- Explorer and statusline still work.

## Git Display

Phase 4 adds lightweight Git display with `gitsigns.nvim`.

Configured signs:

```text
+  added or untracked line
~  changed line
_  deleted line marker
```

This is visual display only. There are no Git keymaps, hunk staging/reset
mappings, blame display, lazygit integration, GitHub integration, or full Git UI.
Run Git commands in the bottom terminal:

```powershell
git status
git add .
git commit
git push
```

`nvim-tree` Git integration and lualine diff integration are intentionally not
enabled yet.

## Phase 4 Manual Checks

- Open a file inside a Git repository.
- Edit an existing line and confirm `~` appears in the sign column.
- Add a new line and confirm `+` appears in the sign column.
- Delete a line and confirm `_` appears near the affected line.
- Confirm the lualine branch still appears.
- Confirm `Ctrl+B` still toggles the explorer.
- Confirm `Ctrl+J` still toggles the terminal.
- Run `git status` in the bottom terminal.

## Picker And Search

Phase 5 adds a minimal picker workflow with `telescope.nvim`.

GUI-friendly shortcuts:

```text
Ctrl+P        find files
Ctrl+Shift+F  project-wide text search
```

These are Neovide-first shortcuts. Terminal Neovim may not reliably detect
`Ctrl+Shift+F`, depending on the terminal emulator and keyboard layout.

Reliable fallback mappings:

```vim
<leader>ff  find files
<leader>fg  project-wide text search
<leader>fb  open buffer picker
<leader>fc  command picker
```

Project-wide text search uses `ripgrep` (`rg`). Install `rg` before using
`live_grep`. The `fd` tool is optional; it can improve file finding later but is
not required by this config.

## Phase 5 Manual Checks

- `Ctrl+P` opens the file picker in Neovide.
- `<leader>ff` opens the file picker.
- `Ctrl+Shift+F` opens project-wide text search in Neovide.
- `<leader>fg` opens project-wide text search.
- `<leader>fb` opens the buffer picker.
- `<leader>fc` opens the command picker.
- `Ctrl+B` still toggles the explorer.
- `Ctrl+J` still toggles the terminal.
- Git signs still appear in edited Git files.
