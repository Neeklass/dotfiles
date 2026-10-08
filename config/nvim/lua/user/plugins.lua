local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local config_root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h:h")

if not vim.uv.fs_stat(lazypath) then
  local output = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Failed to install lazy.nvim. Check Git and your network connection.\n" .. output)
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "user.plugins.theme" },
  { import = "user.plugins.explorer" },
  { import = "user.plugins.statusline" },
  { import = "user.plugins.git" },
  { import = "user.plugins.picker" },
}, {
  lockfile = config_root .. "/lazy-lock.json",
  change_detection = {
    notify = false,
  },
})
