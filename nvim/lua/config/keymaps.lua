-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local wk = require("which-key")
wk.add({ "<Leader>y", icon = "󰅌", group = "yank" })

vim.keymap.set("n", "<Leader>y<C-g>", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Absolute filepath" })

vim.keymap.set("x", "gy", function()
  local path = vim.fn.expand("%:p")
  -- leave visual mode so '< and '> get set
  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "x", false)
  local lstart = vim.fn.line("'<")
  local lend = vim.fn.line("'>")
  local ref
  if lstart == lend then
    ref = string.format("%s:%d", path, lstart)
  else
    ref = string.format("%s:%d-%d", path, lstart, lend)
  end
  vim.fn.setreg("+", ref)
  vim.notify("Copied: " .. ref)
end, { desc = "Copy filepath + line(s) of selection" })
