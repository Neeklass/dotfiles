if not vim.g.neovide then
  return
end

-- JetBrainsMono NFM is the installed JetBrainsMono Nerd Font Mono family.
-- If the font is missing, Neovide should still start, but icons may look wrong.
vim.opt.guifont = "JetBrainsMono NFM:h12"

vim.g.neovide_scale_factor = 1.0
vim.g.neovide_hide_mouse_when_typing = false
vim.g.neovide_cursor_animation_length = 0.04
vim.g.neovide_cursor_trail_size = 0.2
