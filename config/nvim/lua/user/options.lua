local platform = require("user.utils.platform")

vim.opt.mouse = "a"
vim.opt.mousemodel = "popup_setpos"

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.showmode = true
vim.opt.ruler = true

vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.clipboard = "unnamedplus"

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = false

vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 8
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.confirm = true

vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.completeopt = { "menu", "menuone", "noselect" }

if platform.is_windows then
  local shell = platform.default_windows_shell()
  if shell then
    vim.opt.shell = shell.name
    vim.opt.shellcmdflag = shell.cmdflag
    vim.opt.shellquote = ""
    vim.opt.shellxquote = ""
  end
elseif vim.env.SHELL and vim.env.SHELL ~= "" then
  vim.opt.shell = vim.env.SHELL
end
