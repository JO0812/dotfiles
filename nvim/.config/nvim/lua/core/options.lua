-- Core editor options
local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.mouse = "a"
opt.showmode = false
opt.clipboard = "unnamedplus"
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true
opt.wrap = false
opt.breakindent = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true
opt.inccommand = "split"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 14
opt.splitright = true
opt.splitbelow = true
opt.termguicolors = true
opt.updatetime = 250
opt.timeoutlen = 400
opt.scrolloff = 6
opt.sidescrolloff = 8
opt.cursorline = true
opt.fillchars = { eob = " ", fold = " ", foldopen = "", foldsep = " ", foldclose = "" }
opt.list = true
opt.listchars = { tab = "→ ", trail = "•", nbsp = "␣", lead = "·", extends = "›", precedes = "‹" }
opt.undofile = true
opt.undolevels = 10000
opt.swapfile = false
opt.backup = false
opt.writebackup = true
opt.spelllang = "en"
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.foldmethod = "expr"
opt.foldlevelstart = 99
if vim.fn.has("nvim-0.10") == 1 then
  opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
end

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0