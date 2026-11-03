return {
  -- Mason: portable LSP/server installer
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = { ui = { border = "rounded" } },
  },

  -- Bridge Mason -> lspconfig (auto-enables servers installed by Mason)
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "lua_ls", "bashls", "pyright", "ts_ls", "clangd", "gopls", "rust_analyzer", "jdtls" },
      automatic_installation = true,
    },
  },

  -- Synchronous installer for LSP servers + formatters/linters
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
    opts = {
      ensure_installed = {
        "lua-language-server", "bash-language-server", "pyright",
        "typescript-language-server", "clangd", "gopls", "rust-analyzer",
        "stylua", "shfmt", "ruff", "prettierd", "clang-format", "jdtls",
      },
      auto_update = false,
      run_on_start = true,
    },
  },

  -- LSP config (nvim 0.11+ API: vim.lsp.config / vim.lsp.enable)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Global on_attach: keymaps for every LSP buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
        callback = function(args)
          local bufnr = args.buf
          local map = function(keys, cmd, desc)
            vim.keymap.set("n", keys, cmd, { buffer = bufnr, desc = "LSP: " .. desc, silent = true })
          end
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gr", vim.lsp.buf.references, "References")
          map("gD", vim.lsp.buf.declaration, "Declaration")
          map("gi", vim.lsp.buf.implementation, "Implementation")
          map("gt", vim.lsp.buf.type_definition, "Type definition")
          map("K", vim.lsp.buf.hover, "Hover doc")
          map("<C-k>", vim.lsp.buf.signature_help, "Signature help")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>cr", vim.lsp.buf.rename, "Rename")
          map("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format")
        end,
      })

      -- Diagnostic display
      vim.diagnostic.config({
        virtual_text = { prefix = "●", spacing = 4 },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = "if_many", header = "", prefix = "" },
      })
      vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
      vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev diagnostic" })
      vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
      vim.keymap.set("n", "<leader>cq", vim.diagnostic.setqflist, { desc = "Diagnostics to qf" })

      -- Per-server config via vim.lsp.config (nvim 0.11+ API)
      local servers = {
        lua_ls = {
          settings = { Lua = { diagnostics = { globals = { "vim" } }, workspace = { checkThirdParty = false } } },
        },
        bashls = {},
        pyright = {},
        ts_ls = {},
        clangd = {},
        gopls = {},
        rust_analyzer = {},
        jdtls = {},
      }
      for name, cfg in pairs(servers) do
        cfg.capabilities = capabilities
        vim.lsp.config(name, cfg)
        vim.lsp.enable(name)
      end
    end,
  },
}