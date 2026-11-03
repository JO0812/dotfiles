return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>",  desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>",  desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>",    desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>",   desc = "Help tags" },
      { "<leader>fo", "<cmd>Telescope oldfiles<CR>",    desc = "Recent files" },
      { "<leader>fc", "<cmd>Telescope command_history<CR>", desc = "Command history" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Document symbols" },
      { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<CR>", desc = "Workspace symbols" },
      { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
      { "<leader>fr", "<cmd>Telescope resume<CR>",      desc = "Resume last picker" },
      { "<leader>fk", "<cmd>Telescope keymaps<CR>",     desc = "Keymaps" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      defaults = {
        prompt_prefix = " ",
        selection_caret = "❯ ",
        path_display = { "truncate" },
        file_ignore_patterns = { "%.git/", "node_modules/", "%.o$", "%.a$", "%.class$" },
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<C-u>"] = false, -- clear prompt default is fine
            ["<M-u>"] = "preview_scrolling_up",
            ["<M-d>"] = "preview_scrolling_down",
            ["<C-q>"] = "send_to_qflist",
          },
        },
      },
      pickers = {
        find_files = { hidden = true, no_ignore = true },
        live_grep  = { additional_args = { "--hidden" } },
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)
      pcall(require("telescope").load_extension, "fzf")
      vim.keymap.set("n", "<leader><leader>", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
    end,
  },

  -- FZF sorter backend (faster, uses fzf which is already installed)
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
}