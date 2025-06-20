-- require("nvchad.configs.lspconfig").defaults()
local servers = {
    "html", "cssls", "clangd", "pylsp", "lua_ls", "ts_lsp", "taplo", "marksman",
    "eslint", "qmlls"
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

vim.lsp.config("qmlls", {
    filetype = { "qmljs", "qml" },
    cmd = { "qmlls6" },
    root_dir = function()
        return vim.fs.dirname(
            vim.fs.find(".git", { path = fname, upward = true })[1])
    end,
    single_file_support = true,
    docs = {
        description = [[
https://doc.qt.io/qt-6/qtqml-tooling-qmlls.html

> QML Language Server is a tool shipped with Qt that helps you write code in your favorite (LSP-supporting) editor.

Source in the [QtDeclarative repository](https://code.qt.io/cgit/qt/qtdeclarative.git/)
        ]]
    }
})

vim.lsp.config("*", {
    on_attach = function(client, bufnr)
        require("illuminate").on_attach(client)
        require("navigator.lspclient.mapping").setup {
            bufnr = bufnr,
            client = client
        }
        require("navigator.dochighlight").documentHighlight(bufnr)
        require("navigator.codeAction").code_action_prompt(client, bufnr)
    end
})
