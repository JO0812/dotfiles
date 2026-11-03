-- Utils: run the current file in a terminal split based on filetype/shbang
local M = {}

local function is_exec(path)
  if vim.fn.executable(path) == 1 then return true end
  local f = io.open(path, "r")
  if not f then return false end
  local first = f:read(2)
  f:close()
  return first == "#!"
end

function M.run()
  local ft = vim.bo.filetype
  local file = vim.fn.expand("%:p")
  local stem = vim.fn.expand("%:p:r")
  local dir = vim.fn.expand("%:p:h")
  if file == "" then return end

  local cmds = {
    python = function() return { "python3", file } end,
    sh = function() return { "bash", file } end,
    bash = function() return { "bash", file } end,
    zsh = function() return { "zsh", file } end,
    lua = function() return { "lua", file } end,
    javascript = function() return { "node", file } end,
    typescript = function() return { "npx", "--yes", "tsx", file } end,
    go = function() return { "go", "run", file } end,
    rust = function() return { "cargo", "run" } end,
    c = function() return { "gcc", file, "-o", stem, "&&", stem } end,
    cpp = function() return { "g++", file, "-o", stem, "&&", stem } end,
    java = function()
      local base = vim.fn.fnamemodify(file, ":t:r")
      return { "javac", file, "&&", "java", base }
    end,
    make = function() return { "make" } end,
    markdown = function() return { "glow", file } end,
  }

  local fn = cmds[ft] or (is_exec(file) and function() return { file } end) or nil
  if not fn then
    vim.notify("No runner for filetype '" .. ft .. "'", vim.log.levels.WARN)
    return
  end

  local parts = fn()
  -- Join with shell so '&&' works; cd into file dir
  local joined = table.concat(parts, " ")
  local cmd = string.format('cd %s && %s', vim.fn.shellescape(dir), joined)

  vim.cmd('botright 14split | terminal ' .. cmd)
  vim.opt_local.winfixheight = true
  vim.cmd('startinsert')
end

return M