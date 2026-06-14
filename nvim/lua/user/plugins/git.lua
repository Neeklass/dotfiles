return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "_" },
        changedelete = { text = "~" },
        untracked = { text = "+" },
      },
      signs_staged_enable = false,
      current_line_blame = false,
      on_attach = function()
        -- Phase 4 is visual Git display only. Git commands stay in the terminal.
      end,
    },
  },
}
