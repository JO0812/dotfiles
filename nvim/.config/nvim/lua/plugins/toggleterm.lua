return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec", "ToggleTermOpenAll" },
    keys = {
      { "<C-\\>",   "<cmd>ToggleTerm direction=float<CR>",  desc = "Terminal (float)" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", desc = "Terminal (float)" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Terminal (horizontal)" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", desc = "Terminal (vertical)" },
      { "<leader>tt", function()
          local count = vim.v.count == 0 and 1 or vim.v.count
          vim.cmd(count .. "ToggleTerm direction=horizontal")
        end, "Toggle terminal" },
    },
    opts = {
      open_mapping = false,
      direction = "float",
      float_opts = { border = "rounded", winblend = 5 },
      highlights = { NormalFloat = { link = "Normal" }, FloatBorder = { link = "FloatBorder" } },
      shade_terminals = false,
      size = function(term)
        if term.direction == "horizontal" then return math.floor(vim.o.lines * 0.30)
        elseif term.direction == "vertical" then return math.floor(vim.o.columns * 0.40) end
      end,
    },
  },
}