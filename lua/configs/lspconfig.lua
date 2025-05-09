-- require("nvchad.configs.lspconfig").defaults()
local servers = {
    "html", "cssls", "clangd", "pylsp", "lua_ls", "ts_lsp", "taplo", "marksman",
    "eslint"
}

vim.lsp.enable(servers)

-- config table
vim.lsp.config("pylsp", {
    filetype = { ".py" },
    root_markers = { "requirements.txt", "main.py", "pyproject.toml" },
    settings = {
        ["pylsp"] = {
            plugins = {
                pylint = { enabled = true },
                rope_completion = { enabled = true, eager = true },
                rope_autoimport = { true },
                pydocstyle = { enabled = true },
                pycodestyle = {
                    enabled = true,
                    ignore = { "W391", "E111", "W291", "E501" }, -- Added E111 and W291
                    indentSize = 4
                },
                pylsp_rope = { rename = { enabled = true } },
                jedi_rename = { enabled = false }
            }
        }
    }
})
