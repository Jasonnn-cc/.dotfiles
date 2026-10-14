-- Run markdownlint-cli2 (via nvim-lint) with a global base config.
-- Notably this disables MD013 (line-length); per-project
-- .markdownlint-cli2.jsonc files still override the base config.
local config = vim.fn.expand("~/.config/markdownlint/.markdownlint-cli2.jsonc")
local args = vim.fn.filereadable(config) == 1 and { "--config", config, "-" } or { "-" }

return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        ["markdownlint-cli2"] = { args = args },
      },
    },
  },
}
