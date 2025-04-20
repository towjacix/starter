require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "clangd", "pyright", "lua_ls", "ts_lsp", "taplo" }

vim.lsp.enable(servers)
