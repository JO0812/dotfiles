return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSInstallSync", "TSUpdate", "TSUninstall" },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.config").setup({})
      -- Enable built-in treesitter highlighting/indent/folding per buffer
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang or vim.treesitter.language.get_lang
          lang = (vim.treesitter.language.get_lang and vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)) or vim.bo[args.buf].filetype
          local ok = pcall(vim.treesitter.start, args.buf, lang)
          if ok then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },
}