-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Leader keys (set before lazy so mappings use them)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Core
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Plugin spec: lazy auto-loads every file under lua/plugins/*.lua
require("lazy").setup("plugins", {
  install = { colorscheme = { "tokyonight" } },
  checker = { enabled = false },
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "matchit", "netrwPlugin",
        "tarPlugin", "tohtml", "tutor", "zipPlugin",
      },
    },
  },
})

vim.cmd("colorscheme tokyonight-night")