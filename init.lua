vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
    local repo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system {
        "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath
    }
end

vim.opt.rtp:prepend(lazypath)
vim.opt.runtimepath:prepend(lazypath .. "/mcphub.nvim")
local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
    {"NvChad/NvChad", lazy = false, branch = "v2.5", import = "nvchad.plugins"},

    {import = "plugins"}
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")
-- require("base46").toggle_transparency()
require("base46").load_all_highlights()

require "options"
require "nvchad.autocmds"

vim.schedule(function() require "mappings" end)

require "myinit"
require("luasnip.loaders.from_vscode").lazy_load()

os.execute "python ~/.config/nvim/pywal/chadwal.py &> /dev/null &"

local autocmd = vim.api.nvim_create_autocmd

autocmd("Signal", {
    pattern = "SIGUSR1",
    callback = function() require("nvchad.utils").reload() end
})
