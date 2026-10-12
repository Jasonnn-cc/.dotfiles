return {
  "GRVYDEV/worky.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  cmd = "Worky",
  keys = {
    {
      "<leader>gw",
      function()
        require("worky").pick()
      end,
      desc = "Git Worktrees",
    },
  },
  opts = {},
}
