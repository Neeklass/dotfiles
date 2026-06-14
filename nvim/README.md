# Neovim Config

This is a clean Phase 1 Neovim Lua configuration.

## Current Scope

- Vanilla Neovim only
- Plugin-free
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

## Intentionally Not Included Yet

- Plugin manager
- File explorer
- Statusline plugin
- Git signs
- Picker/search UI
- Treesitter
- LSP
- Autocomplete
- Debugging
- Custom Neovim UI

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

## Test In Terminal Neovim

From this repository:

```powershell
nvim --clean --cmd "set runtimepath^=.\nvim" -u .\nvim\init.lua
```

For a startup-only check:

```powershell
nvim --headless --clean --cmd "set runtimepath^=.\nvim" -u .\nvim\init.lua +qa
```
