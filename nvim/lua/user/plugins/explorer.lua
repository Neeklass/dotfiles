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
      {
        "<leader>eo",
        function()
          local api = require("nvim-tree.api")
          api.tree.open()
          api.tree.focus()
        end,
        mode = "n",
        desc = "Open/focus file explorer",
      },
      {
        "<leader>ef",
        function()
          require("nvim-tree.api").tree.find_file({ open = true, focus = true, update_root = false })
        end,
        mode = "n",
        desc = "Reveal current file in explorer",
      },
    },
    opts = {
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        api.config.mappings.default_on_attach(bufnr)

        vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
      end,
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
