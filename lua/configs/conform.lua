local options = {
    formatters_by_ft = {
        lua = {"stylua", "lua-format"},
        markdown = {"mdformat", "mdsf", "cbfmt"},
        toml = {"pyproject-fmt"},
        css = {"prettier"},
        cpp = {"clang-format"},
        html = {"prettier"},
        python = {"black", "isort", "yapf", "ruff"}
    },

    format_after_save = {async = true, lsp_format = "fallback", bufnr = 0},

    log_level = vim.log.levels.DEBUG,
    inherit = true,

    formatters = {
        cbfmt = {
            command = "cbfmt",
            args = {"--config=" .. vim.fn.expand "~/.cbfmt.toml"}
        }
    }
}

return options
