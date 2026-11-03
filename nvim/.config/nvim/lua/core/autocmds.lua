-- Autocommands (grouped)
local aug = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Highlight yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = aug,
  callback = function() vim.highlight.on_yank({ higroup = "Visual", timeout = 200 }) end,
})

-- Auto-create parent dirs on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = aug,
  callback = function(args)
    local dir = vim.fn.expand("<afile>:p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- Disable 'o' continuing comment chains
vim.api.nvim_create_autocmd("FileType", {
  group = aug,
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove("o")
  end,
})

-- Quit with 'q' in special windows
vim.api.nvim_create_autocmd("FileType", {
  group = aug,
  pattern = { "qf", "help", "man", "lspinfo", "startuptime" },
  callback = function(args)
    vim.keymap.set("n", "q", ":close<CR>", { buffer = args.buf, silent = true })
  end,
})

-- Soft-wrap long lines in markdown (no horizontal scrolling)
vim.api.nvim_create_autocmd("FileType", {
  group = aug,
  pattern = { "markdown", "markdown.pandoc", "md" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true -- break at word boundaries, not mid-word
    vim.opt_local.breakindent = true
  end,
})

-- Terminal: start in insert mode, easy escape
vim.api.nvim_create_autocmd("TermOpen", {
  group = aug,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.signcolumn = "no"
    vim.keymap.set("t", "<C-q>", "<C-\\><C-n>", { silent = true, buffer = 0 })
  end,
})