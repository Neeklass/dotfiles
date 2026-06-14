local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local config_root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h:h")

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
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
