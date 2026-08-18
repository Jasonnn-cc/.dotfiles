-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local wk = require("which-key")

vim.keymap.set("x", "g<C-s>", ":sort<CR>", { desc = "Sort selected asc" })
wk.add({ "g<C-s>", mode = "x", icon = "" })
