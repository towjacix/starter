require("nvchad.configs.lspconfig").defaults()

local servers = {
    "html", "cssls", "clangd", "pylsp", "lua_ls", "ts_lsp", "taplo", "marksman",
    "eslint"
}

vim.lsp.enable(servers)

-- config table
vim.lsp.config("pylsp", {
    settings = {
        ["pylsp"] = {
            plugins = {
                rope_completion = {enabled = true, eager = true},
                pycodestyle = {
                    enabled = true,
                    ignore = {"W391", "E111", "W291", "E501"}, -- Added E111 and W291
                    indentSize = 4
                }
            }
        }
    }
})
