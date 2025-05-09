local options = {
    ensure_installed = {
        "bash", "fish", "lua", "luadoc", "markdown", "printf", "toml", "vim",
        "vimdoc", "yaml", "python", "bash", "nu", "javascript", "typescript",
        "json", "jsonc", "rust", "c", "cpp", "go", "requirements", "csv",
        "qmldir", "scss", "css", "make", "cmake", "dockerfile", "qmljs",
        "kotlin"
    },

    highlight = {enable = true, use_languagetree = true},

    indent = {enable = true}
}

require("nvim-treesitter.configs").setup(options)
