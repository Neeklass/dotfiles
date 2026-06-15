return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = false,
        integrations = {
          gitsigns = true,
          lualine = true,
          nvimtree = true,
          telescope = true,
        },
      })

      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
}
