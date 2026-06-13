-- ============================================================================
-- NEOVIM INIT.LUA - MINIMAL, MOUSE-FRIENDLY, CROSS-PLATFORM
-- ============================================================================
-- Location:
--   Windows: C:\Users\Niklas\AppData\Local\nvim\init.lua
--   Linux:   ~/.config/nvim/init.lua
-- ============================================================================

-- 1. GLOBAL SETTINGS ----------------------------------------------------------
-- Set leader keys before plugin/keymap setup
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.mouse = "a"                 -- Enable mouse in all modes
vim.opt.clipboard = "unnamedplus"   -- Use the system clipboard for y/p
vim.opt.mousemodel = "popup_setpos" -- Right-click sets the cursor and opens the menu
vim.opt.selectmode = "mouse"       -- Make mouse selection behave more like an editor
vim.opt.number = true              -- Line numbers
vim.opt.relativenumber = true      -- Relative line numbers
vim.opt.tabstop = 4                -- Tab = 4 spaces
vim.opt.shiftwidth = 4             -- Indent = 4 spaces
vim.opt.expandtab = true           -- Tabs -> spaces
vim.opt.ignorecase = true          -- Ignore case
vim.opt.smartcase = true           -- Respect uppercase in search terms
vim.opt.termguicolors = true       -- Terminal color support
vim.opt.undofile = true            -- Persist undo history
vim.opt.hlsearch = false           -- Disable search highlighting
vim.opt.incsearch = true           -- Incremental search
vim.opt.scrolloff = 8              -- Keep 8 lines around the cursor
vim.opt.cursorline = true          -- Highlight the current line
vim.opt.signcolumn = "yes"         -- Reserve space for Git/LSP signs
vim.opt.splitright = true          -- Open vertical splits on the right
vim.opt.splitbelow = true          -- Open horizontal splits below
vim.opt.laststatus = 3             -- Global statusline
vim.opt.showtabline = 2            -- Always show tabs

local function is_executable(cmd)
  return vim.fn.executable(cmd) == 1
end

local function can_restore_view()
  return vim.bo.buftype == "" and vim.fn.expand("%") ~= ""
end

local function save_view()
  if can_restore_view() then
    pcall(vim.cmd, "mkview")
  end
end

local function load_view()
  if can_restore_view() then
    pcall(vim.cmd, "silent! loadview")
  end
end

-- 2. PLATFORM-SPECIFIC SETTINGS ----------------------------------------------
if vim.fn.has("win32") == 1 then
  -- Windows: prefer PowerShell when available
  if is_executable("pwsh") then
    vim.o.shell = "pwsh.exe"
    vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
    vim.o.shellquote = ""
    vim.o.shellxquote = ""
    vim.g.powershell_cmd = "pwsh.exe -NoLogo"
  elseif is_executable("powershell") then
    vim.o.shell = "powershell.exe"
    vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
    vim.o.shellquote = ""
    vim.o.shellxquote = ""
    vim.g.powershell_cmd = "powershell.exe -NoLogo"
  else
    vim.o.shell = "cmd.exe"
    vim.o.shellcmdflag = "/s /c"
    vim.g.powershell_cmd = "cmd.exe"
  end
  -- Windows terminal commands
  if is_executable("bash.exe") then
    vim.g.git_bash_cmd = "bash.exe"
  end
  vim.g.cmd_cmd = "cmd.exe"
else
  -- Linux/macOS: default shell
  vim.o.shell = vim.env.SHELL or "bash"
end

-- 3. LAZY.NVIM (Plugin manager) -----------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

-- 4. PLUGINS ------------------------------------------------------------------
require("lazy").setup({
  -- === VS CODE LOOK ===
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("vscode").setup({
        transparent = false,
        italic_comments = true,
      })
      vim.cmd.colorscheme("vscode")
    end,
  },

  -- === BUFFER TABS ===
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          numbers = "none",
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          left_mouse_command = "buffer %d",
          middle_mouse_command = nil,
          indicator = { style = "underline" },
          buffer_close_icon = "x",
          modified_icon = "*",
          close_icon = "x",
          left_trunc_marker = "<",
          right_trunc_marker = ">",
          show_buffer_icons = false,
          show_buffer_close_icons = true,
          show_close_icon = false,
          show_tab_indicators = true,
          separator_style = "thin",
          always_show_bufferline = true,
          offsets = {
            {
              filetype = "NvimTree",
              text = "Explorer",
              text_align = "left",
              separator = true,
            },
          },
        },
      })
    end,
  },

  -- === FILE TREE (nvim-tree) ===
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local function tree_on_attach(bufnr)
        local api = require("nvim-tree.api")
        api.config.mappings.default_on_attach(bufnr)

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        local function context_menu()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<LeftMouse>", true, false, true), "n", false)
          vim.ui.select({
            "Open",
            "New file/folder",
            "Rename",
            "Delete",
            "Copy",
            "Cut",
            "Paste",
            "Refresh",
          }, {
            prompt = "Explorer action",
          }, function(choice)
            if choice == "Open" then
              api.node.open.edit()
            elseif choice == "New file/folder" then
              api.fs.create()
            elseif choice == "Rename" then
              api.fs.rename()
            elseif choice == "Delete" then
              api.fs.remove()
            elseif choice == "Copy" then
              api.fs.copy.node()
            elseif choice == "Cut" then
              api.fs.cut()
            elseif choice == "Paste" then
              api.fs.paste()
            elseif choice == "Refresh" then
              api.tree.reload()
            end
          end)
        end

        vim.keymap.set("n", "<RightMouse>", context_menu, opts("Context Menu"))
      end

      require("nvim-tree").setup({
        on_attach = tree_on_attach,
        sort_by = "case_sensitive",
        view = {
          width = 30,
          side = "left",
        },
        renderer = {
          group_empty = true,
          icons = {
            glyphs = {
              folder = {
                arrow_closed = ">",
                arrow_open = "v",
              },
            },
          },
        },
        filters = {
          dotfiles = false,
          exclude = { ".git", "node_modules" },
        },
        actions = {
          open_file = {
            window_picker = {
              enable = false, -- Open the file in the current window
            },
          },
        },
      })
    end,
  },

  -- === TERMINALS (toggleterm) ===
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      local default_shell = vim.o.shell
      local terminal_specs = {
        { cmd = default_shell, direction = "horizontal" }, -- Default terminal
      }

      if vim.g.git_bash_cmd then
        table.insert(terminal_specs, { cmd = vim.g.git_bash_cmd, direction = "horizontal" })
      end

      if vim.g.powershell_cmd then
        table.insert(terminal_specs, { cmd = vim.g.powershell_cmd, direction = "horizontal" })
      end

      if vim.g.cmd_cmd then
        table.insert(terminal_specs, { cmd = vim.g.cmd_cmd, direction = "horizontal" })
      end

      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return math.max(12, math.floor(vim.o.lines * 0.28))
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<C-`>]],
        direction = "horizontal",
        shell = default_shell,
        start_in_insert = true,
        persist_size = true,
        close_on_exit = false,
        shade_terminals = false,
        auto_scroll = true,
        terminals = terminal_specs,
      })
      
      -- Keybindings for specific terminals
      local Terminal = require("toggleterm.terminal").Terminal
      local git_bash = vim.g.git_bash_cmd and Terminal:new({ cmd = vim.g.git_bash_cmd, direction = "horizontal" }) or nil
      local powershell = vim.g.powershell_cmd and Terminal:new({ cmd = vim.g.powershell_cmd, direction = "horizontal" }) or nil
      local cmd_shell = vim.g.cmd_cmd and Terminal:new({ cmd = vim.g.cmd_cmd, direction = "horizontal" }) or nil
      local terminal_1 = Terminal:new({ cmd = default_shell, id = 1, direction = "horizontal" })
      local terminal_2 = Terminal:new({ cmd = default_shell, id = 2, direction = "horizontal" })
      local terminal_3 = Terminal:new({ cmd = default_shell, id = 3, direction = "horizontal" })

      if git_bash then
        function _G.git_bash_toggle() git_bash:toggle() end
      end
      if powershell then
        function _G.powershell_toggle() powershell:toggle() end
      end
      if cmd_shell then
        function _G.cmd_toggle() cmd_shell:toggle() end
      end
      function _G.terminal_1_toggle() terminal_1:toggle() end
      function _G.terminal_2_toggle() terminal_2:toggle() end
      function _G.terminal_3_toggle() terminal_3:toggle() end
    end,
  },

  -- === GIT (fugitive + lazygit) ===
  { "tpope/vim-fugitive" }, -- Git commands in Vim
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("lazygit").setup({})
    end,
  },

  -- === FUZZY FINDER (telescope) ===
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { ".git/", "node_modules/", "%.exe", "%.dll", "%.so" },
          layout_strategy = "horizontal",
          layout_config = {
            height = 0.9,
            width = 0.9,
          },
        },
      })
    end,
  },

  -- === SYNTAX HIGHLIGHTING (nvim-treesitter) ===
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    config = function()
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if not ok then
        vim.notify("nvim-treesitter.configs nicht gefunden. Überspringe Setup.", vim.log.levels.WARN)
        return
      end
      local has_compiler = false
      for _, compiler in ipairs({ "cc", "gcc", "clang", "cl", "zig" }) do
        if vim.fn.executable(compiler) == 1 then
          has_compiler = true
          break
        end
      end
      local parsers = has_compiler and { "lua", "vim", "bash", "gitignore", "markdown", "javascript", "typescript", "python" } or {}
      if not has_compiler then
        vim.notify("Treesitter-Parser werden erst installiert, wenn ein C-Compiler im PATH ist.", vim.log.levels.WARN)
      end
      configs.setup({
        ensure_installed = parsers,
        sync_install = false,  -- Asynchrone Installation
        auto_install = has_compiler,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
      })
    end,
  },

  -- === LSP, MASON & AUTOCOMPLETION ===
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "ts_ls" },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })
      vim.lsp.config("pyright", { capabilities = capabilities })
      vim.lsp.config("ts_ls", { capabilities = capabilities })
      vim.lsp.enable({ "lua_ls", "pyright", "ts_ls" })
    end,
  },

  -- === STATUSLINE (lualine) ===
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          component_separators = { left = "|", right = "|" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },
})

-- 5. KEYMAPS ---------------------------------------------------------------
-- === FILE TREE ===
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- === TERMINALS ===
vim.keymap.set("n", "<C-`>", ":ToggleTerm<CR>", { noremap = true, silent = true })
vim.keymap.set("t", "<C-`>", [[<C-\><C-n>:ToggleTerm<CR>]], { noremap = true, silent = true })
vim.keymap.set("n", "<M-t>", ":ToggleTerm<CR>", { noremap = true, silent = true })
vim.keymap.set("t", "<M-t>", [[<C-\><C-n>:ToggleTerm<CR>]], { noremap = true, silent = true })
vim.keymap.set("n", "<C-t>", ":ToggleTerm<CR>", { noremap = true, silent = true })
vim.keymap.set("t", "<C-t>", [[<C-\><C-n>:ToggleTerm<CR>]], { noremap = true, silent = true })
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
vim.keymap.set("n", "<leader>t1", ":lua terminal_1_toggle()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>t2", ":lua terminal_2_toggle()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>t3", ":lua terminal_3_toggle()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tn", ":ToggleTerm direction=horizontal<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tx", ":ToggleTermToggleAll<CR>", { noremap = true, silent = true })
-- Specific terminals (Windows)
if vim.fn.has("win32") == 1 then
  vim.keymap.set("n", "<leader>gb", ":lua git_bash_toggle()<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>ps", ":lua powershell_toggle()<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>cm", ":lua cmd_toggle()<CR>", { noremap = true, silent = true })
end

-- === GIT ===
vim.keymap.set("n", "<leader>gs", ":Git status<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gd", ":Git diff<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gl", ":LazyGit<CR>", { noremap = true, silent = true })

-- === TELESCOPE (FILE SEARCH) ===
vim.keymap.set("n", "<C-f>", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { noremap = true, silent = true })

-- === MISC ===
vim.keymap.set("n", "<leader>w", ":w<CR>", { noremap = true, silent = true }) -- Save
vim.keymap.set("n", "<leader>q", ":q<CR>", { noremap = true, silent = true }) -- Close
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { noremap = true, silent = true }) -- Clear search highlight

-- === CLIPBOARD (Windows/VS Code-like) ===
vim.keymap.set({ "n", "v", "s" }, "<C-c>", '"+y', { noremap = true, silent = true, desc = "Copy to clipboard" })
vim.keymap.set({ "v", "s" }, "<C-x>", '"+d', { noremap = true, silent = true, desc = "Cut to clipboard" })
vim.keymap.set("n", "<C-v>", '"+p', { noremap = true, silent = true, desc = "Paste from clipboard" })
vim.keymap.set({ "v", "s" }, "<C-v>", '"+p', { noremap = true, silent = true, desc = "Replace with clipboard" })
vim.keymap.set("i", "<C-v>", '<C-r>+', { noremap = true, silent = true, desc = "Paste from clipboard" })
vim.keymap.set("c", "<C-v>", '<C-r>+', { noremap = true, silent = true, desc = "Paste from clipboard" })
vim.keymap.set({ "v", "s" }, "<C-Insert>", '"+y', { noremap = true, silent = true, desc = "Copy to clipboard" })
vim.keymap.set({ "i", "c" }, "<S-Insert>", '<C-r>+', { noremap = true, silent = true, desc = "Paste from clipboard" })
vim.keymap.set("n", "<C-q>", "<C-v>", { noremap = true, silent = true, desc = "Start block selection" })
vim.keymap.set("n", "<C-a>", "ggVG", { noremap = true, silent = true, desc = "Select all" })
vim.keymap.set("i", "<C-a>", "<Esc>ggVG", { noremap = true, silent = true, desc = "Select all" })
vim.keymap.set({ "v", "s" }, "<C-a>", "<Esc>ggVG", { noremap = true, silent = true, desc = "Select all" })
vim.keymap.set("n", "<C-z>", "u", { noremap = true, silent = true, desc = "Undo" })
vim.keymap.set({ "i", "v", "s" }, "<C-z>", "<Esc>u", { noremap = true, silent = true, desc = "Undo" })
vim.keymap.set("n", "<C-y>", "<C-r>", { noremap = true, silent = true, desc = "Redo" })
vim.keymap.set({ "i", "v", "s" }, "<C-y>", "<Esc><C-r>", { noremap = true, silent = true, desc = "Redo" })

-- === MOUSE ===
vim.keymap.set("n", "<2-LeftMouse>", "<LeftMouse>i", { noremap = true, silent = true, desc = "Edit on double-click" })
vim.keymap.set("i", "<RightMouse>", "<C-r>+", { noremap = true, silent = true, desc = "Right-click pastes" })

-- === LSP (VS Code-like) ===
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { noremap = true, silent = true })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>f", function()
  vim.lsp.buf.format({ async = true })
end, { noremap = true, silent = true })

-- 6. AUTOCMDS (e.g. for automatic view saving) --------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    save_view() -- Save cursor position
  end,
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWinEnter" }, {
  pattern = "*",
  callback = function()
    load_view() -- Restore cursor position
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.cmd("startinsert")
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  pattern = "term://*",
  callback = function()
    vim.cmd("startinsert")
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.schedule(function()
      vim.cmd("NvimTreeOpen")
      vim.cmd("ToggleTerm")
      vim.cmd("wincmd p")
    end)
  end,
})

-- ============================================================================
-- END OF CONFIGURATION
-- ============================================================================
    