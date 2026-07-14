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

-- Case conversion utilities
local function split_words(s)
  s = s:gsub("([a-z0-9])([A-Z])", "%1 %2") -- camelCase boundary
  s = s:gsub("([A-Z]+)([A-Z][a-z])", "%1 %2") -- HTTPServer -> HTTP Server
  s = s:gsub("[_%-%s]+", " ")
  local words = {}
  for w in s:gmatch("%S+") do
    table.insert(words, w:lower())
  end
  return words
end

local converters = {
  kebab = function(w)
    return table.concat(w, "-")
  end,
  snake = function(w)
    return table.concat(w, "_")
  end,
  camel = function(w)
    local out = w[1]
    for i = 2, #w do
      out = out .. w[i]:gsub("^%l", string.upper)
    end
    return out
  end,
  pascal = function(w)
    local out = ""
    for _, x in ipairs(w) do
      out = out .. x:gsub("^%l", string.upper)
    end
    return out
  end,
  screaming = function(w)
    return table.concat(w, "_"):upper()
  end,
  title = function(w)
    local parts = {}
    for _, x in ipairs(w) do
      table.insert(parts, (x:gsub("^%l", string.upper)))
    end
    return table.concat(parts, " ")
  end,
}

-- Get visually selected text (or current WORD in normal mode)
local function get_text(mode)
  if mode == "v" then
    local save = vim.fn.getreg("z")
    vim.cmd('noautocmd normal! "zy')
    local txt = vim.fn.getreg("z")
    vim.fn.setreg("z", save)
    return txt
  else
    return vim.fn.expand("<cword>")
  end
end

local function yank_as(kind, mode)
  local txt = get_text(mode)
  local result = converters[kind](split_words(txt))
  vim.fn.setreg("+", result)
  vim.fn.setreg('"', result)
  vim.notify("Yanked: " .. result)
end

-- Keymaps: <leader>y + case letter
local map = vim.keymap.set
local kinds = {
  k = "kebab",
  s = "snake",
  c = "camel",
  p = "pascal",
  u = "screaming",
  t = "title",
}

for key, kind in pairs(kinds) do
  map("n", "<leader>y" .. key, function()
    yank_as(kind, "n")
  end, { desc = "Yank word as " .. kind .. "-case" })
  map("x", "<leader>y" .. key, function()
    yank_as(kind, "v")
  end, { desc = "Yank selection as " .. kind .. "-case" })
end
