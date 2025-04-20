local conform = require "conform"
local options = {
  formatters_by_ft = {
    lua = { "stylua", "lua-format" },
    markdown = { "mdformat", "mdsf", "cbfmt", "pyproject-fmt" },
    css = { "prettier" },
    cpp = { "clang-format" },
    html = { "prettier" },
    python = { "black", "isort", "yapf", "ruff" },
  },

  format_on_save = {
    --   -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
  },

  format_after_save = {
    async = true,
    lsp_format = "fallback",
  },

  log_level = vim.log.levels.DEBUG,
  inherit = true,
}

return options
