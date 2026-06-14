local group = vim.api.nvim_create_augroup("UserConfig", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  desc = "Briefly highlight copied text",
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  desc = "Return to the last edit position when reopening files",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)

    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = group,
  desc = "Make terminal buffers less editor-like",
  pattern = "term://*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.cmd.startinsert()
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  desc = "Leave Insert mode when focusing the file explorer",
  callback = function()
    if vim.bo.filetype == "NvimTree" then
      -- Mouse-first usage can move focus from an editable file to nvim-tree
      -- while Insert mode is still active; nvim-tree is intentionally read-only.
      vim.cmd.stopinsert()
    end
  end,
})
