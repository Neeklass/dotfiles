local function builtin(name)
  return function()
    require("telescope.builtin")[name]()
  end
end

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Telescope",
    keys = {
      { "<C-p>", builtin("find_files"), mode = "n", desc = "Find files" },
      { "<C-S-f>", builtin("live_grep"), mode = "n", desc = "Search project text" },
      { "<leader>ff", builtin("find_files"), mode = "n", desc = "Find files" },
      { "<leader>fg", builtin("live_grep"), mode = "n", desc = "Search project text" },
      { "<leader>fb", builtin("buffers"), mode = "n", desc = "Find open buffers" },
      { "<leader>fc", builtin("commands"), mode = "n", desc = "Find commands" },
    },
    opts = {
      defaults = {
        file_ignore_patterns = {
          "%.git/",
          "node_modules/",
        },
        layout_config = {
          horizontal = {
            preview_width = 0.55,
          },
        },
      },
    },
  },
}
