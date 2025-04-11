-- This is your opts table
require("telescope").setup {
  defaults = {
    layout_config = {
      horizontal = {
        preview_cutoff = 0,
      },
    },
  },

  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- even more opts
        telescope = { style = "borderless" },
        require("telescope.themes").get_cursor {},
      },
    },
  },
}

local harpoon = require "harpoon"
harpoon:setup {}

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers")
    .new({}, {
      prompt_title = "Harpoon",
      finder = require("telescope.finders").new_table {
        results = file_paths,
      },
      previewer = conf.file_previewer {},
      sorter = conf.generic_sorter {},
    })
    :find()
end

vim.keymap.set("n", "<C-e>", function()
  toggle_telescope(harpoon:list())
end, { desc = "Open harpoon window" })

-- To get ui-select loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension "ui-select"
require("telescope").load_extension "media_files"
require("telescope").load_extension "bookmarks"
require("telescope").load_extension "lazy"
