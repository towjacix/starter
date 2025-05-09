local lint = require "lint"
local lint_augroup = vim.api.nvim_create_augroup("lint", {clear = true})

lint.linters_by_ft = {
    markdown = {"markdownlint", "textlint", "write-good"},
    python = {"ruff", "flake8", "vulture"},
    lua = {"luacheck"},
    json = {"jsonlint"},
    typescript = {"eslint_d"}
}

vim.api.nvim_create_autocmd({"BufEnter", "BufWritePost", "InsertLeave"}, {
    pattern = {"*.py", "*.lua", "*.js", "*.ts"},
    group = lint_augroup,
    callback = function()
        -- try_lint without arguments runs the linters defined in `linters_by_ft`
        -- for the current filetype
        lint.try_lint()
        -- You can call `try_lint` with a linter name or a list of names to always
        -- run specific linters, independent of the `linters_by_ft` configuration
    end
})

lint.linters.vulture.args = {
    "min-confidence=80",
    "--config=" .. vim.fn.expand "~/.config/nvim/tools/python" ..
        "/pyproject.toml"
}

lint.linters.ruff.args = {
    "--fix", "--show-fixes",
    "--config=" .. vim.fn.expand "~/.config/nvim/tools/python" .. "/ruff.toml"
}

local lint_progress = function()
    local linters = require("lint").get_running()
    if #linters == 0 then return "󰦕" end
    return "󱉶 " .. table.concat(linters, ", ")
end
