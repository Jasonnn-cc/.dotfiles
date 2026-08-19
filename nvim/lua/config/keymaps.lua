-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local wk = require("which-key")
local yank = require("config.controllers.yank")

wk.add({ "<leader>y", icon = "󰅌", group = "yank" })
vim.keymap.set("n", "<leader>yf", yank.absolute_filepath, { desc = "Absolute filepath" })

wk.add({ "g<C-s>", mode = "x", icon = "" })
vim.keymap.set("x", "g<C-s>", ":sort<CR>", { desc = "Sort selected asc" })
