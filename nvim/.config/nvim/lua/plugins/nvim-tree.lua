return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
      { "<leader>o", "<cmd>NvimTreeFindFileToggle<CR>", desc = "Reveal file in tree" },
    },
    opts = {
      hijack_cursor = true,
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = { enable = true, update_root = true },
      git = { enable = true, ignore = false },
      filters = { dotfiles = false, git_ignored = false },
      renderer = {
        group_empty = true,
        highlight_git = true,
        highlight_opened_files = "name",
        root_folder_label = ":~:s?$?/..?",
        icons = { show = { git = true } },
      },
      view = {
        width = 32,
        side = "left",
        preserve_window_proportions = true,
      },
      actions = {
        open_file = { quit_on_open = false, resize_window = true },
      },
    },
    config = function(_, opts)
      -- netrw is already disabled in init.lua (performance.rtp.disabled_plugins),
      -- which is what nvim-tree wants.
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      require("nvim-tree").setup(opts)

      -- Auto-open tree when opening a directory: `nvim .` / `nvim ~/repo`
      local aug = vim.api.nvim_create_augroup("NvimTreeAutoOpen", { clear = true })
      vim.api.nvim_create_autocmd("VimEnter", {
        group = aug,
        callback = function(data)
          local stat = vim.loop.fs_stat(data.file or "")
          if stat and stat.type == "directory" then
            require("nvim-tree.api").tree.open()
          end
        end,
      })
    end,
  },
}
