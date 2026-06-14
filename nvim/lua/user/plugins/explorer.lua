return {
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {},
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<C-b>", "<cmd>NvimTreeToggle<CR>", mode = "n", desc = "Toggle file explorer" },
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", mode = "n", desc = "Toggle file explorer" },
    },
    opts = {
      view = {
        side = "left",
        width = 32,
      },
      renderer = {
        group_empty = true,
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = false,
          },
        },
      },
      filters = {
        dotfiles = false,
      },
      git = {
        enable = false,
      },
      diagnostics = {
        enable = false,
      },
      actions = {
        open_file = {
          quit_on_open = false,
          window_picker = {
            enable = false,
          },
        },
      },
    },
  },
}
