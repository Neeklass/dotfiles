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

#### External Tools And Source Repositories

These links are for source/project transparency. On Windows, install with
`winget` unless there is a specific reason not to. On Linux/Fedora, package names
may differ from Windows `winget` IDs. The Neovim Lua config should not depend on
hardcoded machine-specific paths.

| Tool | Windows winget package | Source repository | Notes |
|---|---|---|---|
| Git for Windows | `Git.Git` | https://github.com/git-for-windows/git | Windows Git package used by winget. Upstream Git is https://github.com/git/git |
| Neovim | `Neovim.Neovim` | https://github.com/neovim/neovim | Editor core |
| Neovide | `Neovide.Neovide` | https://github.com/neovide/neovide | GUI client for Neovim |
| ripgrep | `BurntSushi.ripgrep.MSVC` | https://github.com/BurntSushi/ripgrep | Required for Telescope live grep |
| fd | `sharkdp.fd` | https://github.com/sharkdp/fd | Optional; improves file finding |

Example using `winget`:

```powershell
winget install --id Git.Git
winget install --id Neovim.Neovim
winget install --id Neovide.Neovide
winget install --id BurntSushi.ripgrep.MSVC
winget install --id sharkdp.fd
```

Clone the dotfiles repository anywhere you want. `_repos` is only a personal
convention, not a requirement.

```powershell
git clone https://github.com/Neeklass/dotfiles "PATH_TO_YOUR_CLONED_DOTFILES_REPO"
```

Set setup variables:

```powershell
$repoRoot = "PATH_TO_YOUR_CLONED_DOTFILES_REPO"
$live = "$env:LOCALAPPDATA\nvim"
$repo = Join-Path $repoRoot "nvim"
```

Back up an existing Neovim config if one exists:

```powershell
if (Test-Path $live) {
  $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
  Rename-Item -LiteralPath $live -NewName "nvim.backup-$timestamp"
}
```

Create the AppData junction:

```powershell
New-Item -ItemType Junction `
  -Path $live `
  -Target $repo
```

Verify the junction:

```powershell
Get-Item $live | Format-List FullName,LinkType,Target
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

#### Windows PATH Troubleshooting

After installing tools with `winget`, close and reopen PowerShell before testing
commands. `winget` may show a package as installed even if the command is not
available in the current shell's `PATH` yet.

Check versions:

```powershell
git --version
nvim --version
rg --version
neovide --version
```

Check command locations:

```powershell
where.exe git
where.exe nvim
where.exe rg
where.exe neovide
```

If `neovide --version` fails, try the installed executable directly:

```powershell
& "C:\Program Files\Neovide\neovide.exe" --version
```

If that works, Neovide is installed but not available as a `PATH` command.
Normal Neovide can still be launched with the full executable path:

```powershell
& "C:\Program Files\Neovide\neovide.exe"
```

Bash is not required on Windows. PowerShell is enough for this setup.

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

## Nerd Font And Icons

Phase 6 uses the installed JetBrainsMono Nerd Font Mono family for Neovide.

The active Neovide GUI font is configured in `nvim/lua/user/gui.lua` inside:

```lua
if vim.g.neovide then
  -- ...
end
```

Current setting:

```lua
vim.opt.guifont = "JetBrainsMono NFM:h12"
```

This is not a machine-specific path. If the font is missing on another machine,
Neovide should still start, but icons from `nvim-web-devicons` may look broken
until a Nerd Font is installed.

### Why The Name Is `JetBrainsMono NFM`

The installed font files are the Nerd Font Mono variants:

- `JetBrainsMonoNerdFontMono-Regular.ttf`
- `JetBrainsMonoNerdFontMono-Italic.ttf`
- `JetBrainsMonoNerdFontMono-SemiBold.ttf`
- `JetBrainsMonoNerdFontMono-SemiBoldItalic.ttf`

Windows registered these as the font family:

```text
JetBrainsMono NFM
```

Therefore Neovide must use:

```text
JetBrainsMono NFM
```

not:

- `JetBrainsMono Nerd Font`
- `JetBrainsMono Nerd Font Mono`
- `Cascadia Mono NF`
- `Cascadia Code`

### Why This Font Is Used

- It is a Nerd Font, so it includes icon glyphs used by `nvim-web-devicons`,
  nvim-tree, lualine, and Telescope.
- It is the Mono variant, which is appropriate for code.
- It avoids the Microsoft Cascadia font choice.
- Font files are installed locally on the machine, not committed to the repo.

Any Nerd Font should work if `vim.opt.guifont` matches the installed font family.

Install on Windows:

1. Download JetBrainsMono from Nerd Fonts:
   https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/JetBrainsMono
   or from the Nerd Fonts releases page:
   https://github.com/ryanoasis/nerd-fonts/releases
2. Use the TTF package.
3. Install the JetBrainsMono Nerd Font Mono files, for example:
   - `JetBrainsMonoNerdFontMono-Regular.ttf`
   - `JetBrainsMonoNerdFontMono-Italic.ttf`
   - `JetBrainsMonoNerdFontMono-SemiBold.ttf`
   - `JetBrainsMonoNerdFontMono-SemiBoldItalic.ttf`
4. Restart Neovide if it was already running.

Do not commit font files or font binaries to this repository.

### Verify On Windows

Check the installed font registry entries:

```powershell
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /f JetBrains /s
reg query "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /f JetBrains /s
```

On this machine, `HKCU` showed `JetBrainsMono NFM`. If another machine registers
a different family name, update `vim.opt.guifont` accordingly.

### Icon Test

- Restart Neovide.
- Open the explorer with `Ctrl+B`.
- Open Telescope with `Ctrl+P`.
- Check that file, folder, and filetype icons are no longer boxed or broken.

### Terminal Note

Neovide uses `vim.opt.guifont`. Terminal Neovim does not. Terminal fonts must be
configured separately in Windows Terminal or the terminal emulator, for example
Windows Terminal -> profile font -> `JetBrainsMono NFM`.

On Linux, install a Nerd Font through your distro, package manager, or manual
font install, then configure the terminal emulator or GUI client to use it.

Explorer navigation polish is intentionally not part of Phase 6. nvim-tree
already has useful defaults:

- `Enter` / `o` opens a node.
- Double-click opens a node.
- `-` goes up.
- `P` moves to the parent directory.
- `W` collapses all folders.
- `g?` opens nvim-tree help.

Further explorer navigation polish belongs in Phase 11 or a later small polish
phase.

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
