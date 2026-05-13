return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      tailwindcss = {
        settings = {
          tailwindCSS = {
            classFunctions = { "cva", "cx", "cn" },
            colorDecorators = false,
          },
        },
      },
    },
  },
}
