return {
  -- Git signs in the signcolumn + hunks
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" }, change = { text = "▎" },
        delete = { text = "" }, topdelete = { text = "" },
        changedelete = { text = "▎" }, untracked = { text = "▎" },
      },
      signs_staged_enable = false,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(m, l, r, d) vim.keymap.set(m, l, r, { buffer = bufnr, desc = "Git: " .. d, silent = true }) end
        map("n", "]h", function() gs.next_hunk() end, "Next hunk")
        map("n", "[h", function() gs.prev_hunk() end, "Prev hunk")
        map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
        map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage selection")
        map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset selection")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
        map("n", "<leader>hp", gs.preview_hunk_inline, "Preview hunk")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>hd", gs.diffthis, "Diff this")
        map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff this ~")
        map("n", "<leader>htb", gs.toggle_current_line_blame, "Toggle line blame")
        map("n", "<leader>htd", gs.toggle_deleted, "Toggle deleted")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Inner hunk (textobj)")
      end,
    },
  },

  -- Fugitive: full Git porcelain
  { "tpope/vim-fugitive", cmd = { "Git", "G", "Gvdiffsplit" } },

  -- Lazygit floating terminal launched via toggleterm
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    keys = { { "<leader>gg", "<cmd>LazyGit<CR>", desc = "Lazygit" } },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}