-- Core keymaps (leader-prefixed; plugin keymaps live with their plugins)
local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc, noremap = true, silent = true })
end

-- Better defaults
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", "Down (display)")
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", "Up (display)")
map("n", "<C-d>", "<C-d>zz", "Half-page down (centered)")
map("n", "<C-u>", "<C-u>zz", "Half-page up (centered)")
map("n", "n", "nzzzv", "Next match (centered)")
map("n", "N", "Nzzzv", "Prev match (centered)")
map("n", "<C-j>", "<C-i>", "Jump forward")
map("n", "<C-k>", "<C-o>", "Jump back")
map("i", "<C-c>", "<Esc>", "Escape")
map("n", "<leader>ww", ":w<CR>", "Save")
map("n", "<leader>wq", ":wq<CR>", "Save & quit")
map("n", "<leader>qq", ":qa<CR>", "Quit all")
map("n", "<leader>bd", ":bd<CR>", "Delete buffer")
map({ "n", "v" }, "<leader>y", '"+y', "Yank to system +")
map("n", "<leader>Y", '"+Y', "Yank line to system +")
map("x", "<leader>p", '"_dP', "Paste without overwriting +")

-- Move lines
map("x", "J", ":m '>+1<CR>gv=gv", "Move line down")
map("x", "K", ":m '<-2<CR>gv=gv", "Move line up")

-- Window splits
map("n", "<leader>wh", ":sp<CR>", "Split horizontal")
map("n", "<leader>wv", ":vsp<CR>", "Split vertical")
map("n", "<leader>wd", ":q<CR>", "Close window")
map("n", "<C-h>", "<C-w>h", "Window left")
map("n", "<C-l>", "<C-w>l", "Window right")

-- Run program/script
map("n", "<leader>rr", function() require("utils.runner").run() end, "Run file")
map("n", "<leader>rt", ":vsplit | term<CR>", "Open terminal (vsplit)")