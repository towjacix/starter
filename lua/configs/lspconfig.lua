require("nvchad.configs.lspconfig").defaults()

local servers = {
    "html", "cssls", "clangd", "pylsp", "lua_ls", "ts_lsp", "taplo", "marksman",
    "eslint"
}

vim.lsp.enable(servers)
