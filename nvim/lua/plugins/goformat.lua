return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        go = { "gofumpt", "golines" },
      },
      formatters = {
        gofumpt = {
          prepend_args = { "-extra" },
        },
        golines = {},
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
}
