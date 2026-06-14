if not vim.g.neovide then
  return
end

-- Keep font choice personal and easy to change. Enable this only after choosing
-- a font that exists on both the Windows and future Linux setup.
-- vim.opt.guifont = "Cascadia Code:h12"

vim.g.neovide_scale_factor = 1.0
vim.g.neovide_hide_mouse_when_typing = false
vim.g.neovide_cursor_animation_length = 0.04
vim.g.neovide_cursor_trail_size = 0.2
