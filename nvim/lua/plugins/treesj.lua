return {
  "Wansmer/treesj",
  keys = { "<C-j>" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("treesj").setup({
      use_default_keymaps = false,
    })

    vim.keymap.set("n", "<C-j>", require("treesj").split)
  end,
}
