local lint = require("lint")
local lint_augroup = vim.api.nvim_create_augroup("lint", {clear = true})

lint.linters_by_ft = {
  markdown = {"markdownlint"},
  python = { "ruff" },
  python = {"pylint"},
  lua = { "luacheck" },
  json = { "jsonlint" },
  typescript = { "eslint_d" }
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged"}, {
  pattern = {"*.py", "*.md", "*.lua", "*.js", "*.ts"},
  group = lint_augroup,
  callback = function()
    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    lint.try_lint("pylint")
    lint.try_lint("ruff")

    -- You can call `try_lint` with a linter name or a list of names to always
    -- run specific linters, independent of the `linters_by_ft` configuration
  end,
})
