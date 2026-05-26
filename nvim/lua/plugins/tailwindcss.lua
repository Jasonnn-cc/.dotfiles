return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      tailwindcss = {
        settings = {
          tailwindCSS = {
            classAttributes = { "[\\w:.-]*ClassName[\\w:.-]*" },
            classFunctions = { "cva", "cx", "cn" },
            colorDecorators = false,
          },
        },
      },
    },
  },
}
