local actions = require "telescope.actions"
local open_with_trouble = require("trouble.sources.telescope").open
local add_to_trouble = require("trouble.sources.telescope").add

-- This is your opts table
require("telescope").setup {
    defaults = {
        mappings = { n = { ["<leader>to"] = open_with_trouble } },
        layout_config = { horizontal = { preview_cutoff = 0 } }
    },

    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {
                -- even more opts
                telescope = { style = "bordered" },
                require("telescope.themes").get_cursor {}
            }
        }
    }
}

-- To get ui-select loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension "ui-select"
require("telescope").load_extension "lazy"
