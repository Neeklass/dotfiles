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
