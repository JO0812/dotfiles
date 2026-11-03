return {
  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "tokyonight",
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { statusline = { "oil" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { { "b:gitsigns_head", icon = "" }, "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1, symbols = { modified = " ●", readonly = " ", unnamed = "[no name]" } } },
        lualine_x = { "encoding", "fileformat", { "filetype", icon_only = true } },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "fugitive", "toggleterm", "oil" },
    },
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope = { enabled = true, show_start = false, show_end = false },
      exclude = { filetypes = { "oil", "TelescopeResults", "TelescopePrompt", "lspinfo", "help", "alpha", "dashboard", "lazy", "mason", "toggleterm", "fugitive" } },
    },
  },

  -- Comment toggling
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = { toggle = { linewise = "gcc", blockwise = "gcb" } },
  },

  -- Surround
  { "kylechui/nvim-surround", version = "*", event = "BufReadPost", opts = {} },

  -- TODO/FIXME/NOTE highlighter + telescope picker
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope", "TodoLocList", "TodoQuickFix" },
    event = { "BufReadPost", "BufNewFile" },
    opts = { keywords = { FIX = { icon = " " }, TODO = { icon = " " }, HACK = { icon = " " }, WARN = { icon = " " }, PERF = { icon = "" }, NOTE = { icon = " " }, TEST = { icon = "⏲ " } } },
  },

  -- Sudo write for files needing elevation
  { "lambdalisue/suda.vim", cmd = { "SudaWrite", "SudaQuit", "SudaRead" } },

  -- Unix helpers (chmod, :Move, :Rename...)
  { "tpope/vim-eunuch", cmd = { "Chmod", "Mkdir", "Rename", "Move", "Copy", "Delete", "SudoWrite" } },

  -- Sets commentstring for embedded langs (HTML/Vue/Svelte)
  { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },

  -- Repeat plugin remaps (for surround)
  { "tpope/vim-repeat", event = "BufReadPost" },

  -- Auto-display available keymaps hint
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 400
    end,
    opts = {
      preset = "modern",
      plugins = { spelling = { enabled = true, suggestions = 15 } },
      win = { border = "single", wo = { winblend = 0 } },
    },
  },

  -- Dashboard
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        "  ███╗   ██╗ ██████╗ ██╗██╗   ██╗███████╗██╗     ██╗███╗   ███╗   ██╗",
        "  ████╗  ██║██╔═══██╗██║██║   ██║██╔═══╝██║     ██║████╗ ████║   ██║",
        "  ██╔██╗ ██║██║   ██║██║██║   ██║█████╗  ██║     ██║██╔████╔██║   ██║",
        "  ██║╚██╗██║██║   ██║██║╚██╗ ██╔╝██╔══╝  ██║     ██║██║╚██╔╝██║   ██║",
        "  ██║ ╚████║╚██████╔╝██║ ╚████╔╝ ███████╗███████╗██║██║ ╚═╝ ██║██╗██╗",
        "  ╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═══╝  ╚══════╝╚══════╝╚═╝╝     ╚═╝╚═╝╚═╝",
      }
      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find files",  ":Telescope find_files<CR>"),
        dashboard.button("g", "  Live grep",    ":Telescope live_grep<CR>"),
        dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
        dashboard.button("e", "  File explorer", ":Oil<CR>"),
        dashboard.button("n", "  New file",      ":ene | startinsert<CR>"),
        dashboard.button("l", "  Lazy",          ":Lazy<CR>"),
        dashboard.button("m", "  Mason",         ":Mason<CR>"),
        dashboard.button("q", "  Quit",          ":qa<CR>"),
      }
      local version = vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
      dashboard.section.footer.val = { "  nvim " .. version }
      dashboard.config.layout = {
        { type = "padding", val = vim.fn.max({ 2, vim.fn.line("$") - 20 }) },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        dashboard.section.footer,
      }
      alpha.setup(dashboard.config)
    end,
  },
}