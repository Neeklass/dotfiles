local M = {}

local terminal_bufnr = nil
local terminal_winid = nil

local function is_valid_buffer(bufnr)
  return bufnr and vim.api.nvim_buf_is_valid(bufnr)
end

local function is_valid_window(winid)
  return winid and vim.api.nvim_win_is_valid(winid)
end

local function focus_terminal()
  if is_valid_window(terminal_winid) then
    vim.api.nvim_set_current_win(terminal_winid)
    vim.cmd.startinsert()
    return true
  end

  return false
end

local function open_terminal_window()
  vim.cmd("botright split")
  vim.cmd("resize 12")
  terminal_winid = vim.api.nvim_get_current_win()
end

function M.toggle()
  if focus_terminal() then
    vim.api.nvim_win_hide(terminal_winid)
    terminal_winid = nil
    return
  end

  open_terminal_window()

  -- Reuse the terminal buffer so hiding the window does not kill the shell.
  if is_valid_buffer(terminal_bufnr) then
    vim.api.nvim_win_set_buf(terminal_winid, terminal_bufnr)
  else
    vim.cmd.terminal(vim.o.shell)
    terminal_bufnr = vim.api.nvim_get_current_buf()
  end

  vim.cmd.startinsert()
end

vim.keymap.set({ "n", "t" }, "<C-j>", function()
  M.toggle()
end, { noremap = true, silent = true, desc = "Toggle bottom terminal" })

vim.keymap.set("n", "<leader>t", function()
  M.toggle()
end, { noremap = true, silent = true, desc = "Toggle bottom terminal" })

return M
