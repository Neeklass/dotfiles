local map = vim.keymap.set

local function opts(desc)
  return { noremap = true, silent = true, desc = desc }
end

map({ "n", "i", "v", "s" }, "<C-s>", function()
  vim.cmd.write()
end, opts("Save file"))

map("n", "<C-a>", "ggVG", opts("Select all"))
map("i", "<C-a>", "<Esc>ggVG", opts("Select all"))
map({ "v", "s" }, "<C-a>", "<Esc>ggVG", opts("Select all"))

-- Keep Ctrl+C available for Neovim cancel/interrupt in Normal, Insert, Command,
-- and Terminal modes. Visual/Select mode copy is the safer VS Code-like case.
map({ "v", "s" }, "<C-c>", '"+y', opts("Copy selection to system clipboard"))
map({ "v", "s" }, "<C-x>", '"+d', opts("Cut selection to system clipboard"))

map("n", "<C-v>", '"+p', opts("Paste from system clipboard"))
map({ "v", "s" }, "<C-v>", '"+p', opts("Replace selection with system clipboard"))
map("i", "<C-v>", "<C-r>+", opts("Paste from system clipboard"))
map("c", "<C-v>", "<C-r>+", opts("Paste from system clipboard"))

map({ "v", "s" }, "<C-Insert>", '"+y', opts("Copy selection to system clipboard"))
map({ "i", "c" }, "<S-Insert>", "<C-r>+", opts("Paste from system clipboard"))

map("n", "<C-z>", "u", opts("Undo"))
map({ "i", "v", "s" }, "<C-z>", "<Esc>u", opts("Undo"))
map("n", "<C-y>", "<C-r>", opts("Redo"))
map({ "i", "v", "s" }, "<C-y>", "<Esc><C-r>", opts("Redo"))

map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts("Clear search highlight"))

map("n", "<C-Left>", "<C-w>h", opts("Focus left window"))
map("n", "<C-Down>", "<C-w>j", opts("Focus lower window"))
map("n", "<C-Up>", "<C-w>k", opts("Focus upper window"))
map("n", "<C-Right>", "<C-w>l", opts("Focus right window"))

map("t", "<Esc><Esc>", "<C-\\><C-n>", opts("Leave terminal input mode"))
