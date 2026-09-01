-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local wk = require("which-key")
local pathyank = require("config.controllers.pathyank")
local lspyank = require("config.controllers.lspyank")

wk.add({ "<leader>y", icon = "󰅌", group = "yank" })
vim.keymap.set("n", "<leader>yf", pathyank.absolute_filepath, { desc = "Absolute filepath" })
vim.keymap.set("n", "<leader>yg", pathyank.git_root_path, { desc = "Path to git root" })
vim.keymap.set("n", "<leader>yr", pathyank.git_relative_filepath, { desc = "Relative path from git root" })
vim.keymap.set("n", "<leader>yK", lspyank.hover_signature, { desc = "Hovered type signature" })

wk.add({ "<leader>y", mode = "x", icon = "󰅌", group = "yank" })
vim.keymap.set("x", "<leader>yf", pathyank.absolute_filepath_with_lines, { desc = "Absolute filepath + line(s)" })

wk.add({ "g<C-s>", mode = "x", icon = "" })
vim.keymap.set("x", "g<C-s>", ":sort<CR>", { desc = "Sort selected asc" })
