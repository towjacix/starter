local mason = require "mason"

mason.setup {
    log_level = vim.log.levels.DEBUG,
    max_concurrent_installers = 5,
    providers = { "mason.providers.registry-api", "mason.providers.client" },
    pip = {
        ---@since 1.0.0
        -- Whether to upgrade pip to the latest version in the virtual environment before installing packages.
        upgrade_pip = true,

        ---@since 1.0.0
        -- These args will be added to `pip install` calls. Note that setting extra args might impact intended behavior
        -- and is not recommended.
        --
        -- Example: { "--proxy", "https://proxyserver" }
        install_args = {}
    }
}
require("mason-lspconfig").setup {}
