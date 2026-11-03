return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VimEnter",
    keys = {
      { "-", "<cmd>Oil<CR>", desc = "Open parent (oil)" },
    },
    opts = {
      default_file_explorer = false,
      view_options = { show_hidden = true, natural_order = true, is_always_hidden = function(name) return name == ".." end },
      keymaps = {
        ["<C-h>"] = false,
        ["q"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["<CR>"] = "actions.select",
        ["<C-t>"] = "actions.select_tab",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-s>"] = "actions.select_split",
        ["/"] = "actions.open_cmdline",
        ["g?"] = "actions.show_help",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.close",
      },
      use_default_keymaps = true,
      win_options = { signcolumn = "yes" },
      float = { padding = 2, border = "rounded" },
    },
  },
}