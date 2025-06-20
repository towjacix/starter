require("navigator").setup {

    debug = true, -- log output, set to true and log path: ~/.cache/nvim/gh.log
    -- slowdownd startup and some actions
    width = 0.75, -- max width ratio (number of cols for the floating window) / (window width)
    height = 0.3, -- max list window height, 0.3 by default
    preview_height = 0.35, -- max height of preview windows
    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }, -- border style, can be one of 'none', 'single', 'double',
    -- 'shadow', or a list of chars which defines the border
    -- mason = false,
    default_mapping = true, -- set to false if you will remap every key
    ts_fold = {
        enable = false,
        comment = true,                                                         -- ts fold text object
        max_lines_scan_comments = 2000,                                         -- maximum lines to scan for comments
        disable_filetypes = { "help", "text", "markdown" }                      -- disable ts fold for specific filetypes
    },
    keymaps = { { key = "gK", func = vim.lsp.declaration, desc = "declaration" } }, -- a list of key maps
    -- this kepmap gK will override "gD" mapping function declaration()  in default kepmap
    -- please check mapping.lua for all keymaps
    -- rule of overriding: if func and mode ('n' by default) is same
    -- the key will be overridden
    treesitter_analysis = true,          -- treesitter variable context
    treesitter_navigation = true,        -- bool|table false: use lsp to navigate between symbol ']r/[r', table: a list of
    -- lang using TS navigation
    treesitter_analysis_max_num = 100,   -- how many items to run treesitter analysis
    treesitter_analysis_condense = true, -- condense form for treesitter analysis
    -- this value prevent slow in large projects, e.g. found 100000 reference in a project
    transparency = 50,                   -- 0 ~ 100 blur the main window, 100: fully transparent, 0: opaque,  set to nil or 100 to disable it

    lsp_signature_help = false,          -- if you would like to hook ray-x/lsp_signature plugin in navigator
    -- setup here. if it is nil, navigator will not init signature help
    signature_help_cfg = nil,            -- if you would like to init ray-x/lsp_signature plugin in navigator, and pass in your own config to signature help
    icons = {                            -- refer to lua/navigator.lua for more icons config
        -- requires nerd fonts or nvim-web-devicons
        icons = true,
        -- Code Action (gutter, floating window)
        code_action_icon = "🏏",

        -- Code Lens (gutter, floating window)
        code_lens_action_icon = "👓",

        -- Diagnostics (gutter)
        diagnostic_head = "🐛", -- prefix for other diagnostic_* icons
        diagnostic_err = "📛",
        diagnostic_warn = "👎",
        diagnostic_info = [[👩]],
        diagnostic_hint = [[💁]],

        -- Diagnostics (floating window)
        diagnostic_head_severity_1 = "🈲",
        diagnostic_head_severity_2 = "🛠️",
        diagnostic_head_severity_3 = "🔧",
        diagnostic_head_description = "👹", -- suffix for severities
        diagnostic_virtual_text = "🦊", -- floating text preview (set to empty to disable)
        diagnostic_file = "🚑", -- icon in floating window, indicates the file contains diagnostics

        -- Values (floating window)
        value_definition = "🐶🍡", -- identifier defined
        value_changed = "📝", -- identifier modified
        context_separator = " " -- separator between text and value
    },
    lsp = {
        enable = false, -- skip lsp setup, and only use treesitter in navigator.
        mason = true,
        disable_lsp = "all",
        -- disable_lsp = "all",
        -- Use this if you are not using LSP servers, and only want to enable treesitter support.
        -- If you only want to prevent navigator from touching your LSP server configs,
        -- use `disable_lsp = "all"` instead.
        -- If disabled, make sure add require('navigator.lspclient.mapping').setup({bufnr=bufnr, client=client}) in your
        -- own on_attach
        code_action = {
            enable = true,
            sign = true,
            sign_priority = 40,
            virtual_text = true,
            virtual_text_icon = true
        },
        code_lens_action = {
            enable = true,
            sign = true,
            sign_priority = 40,
            virtual_text = true
        },
        document_highlight = true, -- LSP reference highlight,
        -- it might already supported by you setup, e.g. LunarVim
        diagnostic = {
            enable = true,
            underline = true,
            virtual_text = { spacing = 3, source = true }, -- show virtual for diagnostic message
            update_in_insert = false,                    -- update diagnostic message in insert mode
            severity_sort = { reverse = true },
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = ""
            }
        },
        definition = { enable = true },
        call_hierarchy = { enable = true },
        implementation = { enable = true },
        workspace = { enable = true },
        hover = {
            enable = true,
            -- fallback if hover failed
            -- go = function()
            --   local w = vim.fn.expand('<cWORD>')
            --   w = w:gsub('*', '')
            --   vim.cmd('GoDoc ' .. w)
            -- end,
            python = function()
                local w = vim.fn.expand "<cWORD>"
                local setup = { "pydoc", w }
                return vim.fn.jobstart(setup, {
                    on_stdout = function(_, data, _)
                        if not data or
                            (#data == 1 and vim.fn.empty(data[1]) == 1) then
                            return
                        end
                        local close_events = {
                            "CursorMoved", "CursorMovedI", "BufHidden",
                            "InsertCharPre"
                        }
                        local config = {
                            close_events = close_events,
                            focusable = true,
                            border = "single",
                            width = 80,
                            zindex = 100
                        }
                        vim.lsp.util.open_floating_preview(data, "python",
                            config)
                    end
                })
            end,
            default = function()
                local w = vim.fn.expand "<cword>"
                print("default " .. w)
                vim.lsp.buf.workspace_symbol(w)
            end
            -- },
            -- },
        }, -- bind hover action to keymap; there are other options e.g. noice, lspsaga provides lsp hover
        side_panel = {
            section_separator = "󰇜",
            line_num_left = "",
            line_num_right = "",
            inner_node = "├○",
            outer_node = "╰○",
            bracket_left = "⟪",
            bracket_right = "⟫",
            tab = "󰌒"
        },
        fold = { prefix = "⚡", separator = "" },

        -- Treesitter
        -- Note: many more node.type or kind may be available
        match_kinds = {
            var = " ", -- variable -- "👹", -- Vampaire
            const = "󱀍 ",
            method = "ƒ ", -- method --  "🍔", -- mac
            -- function is a keyword so wrap in ['key'] syntax
            ["function"] = "󰡱 ", -- function -- "🤣", -- Fun
            parameter = "  ", -- param/arg -- Pi
            parameters = "  ", -- param/arg -- Pi
            required_parameter = "  ", -- param/arg -- Pi
            associated = "🤝", -- linked/related
            namespace = "🚀", -- namespace
            type = "󰉿", -- type definition
            field = "🏈", -- field definition
            module = "📦", -- module
            flag = "🎏" -- flag
        },
        format_on_save = true, -- {true|false} set to false to disasble lsp code format on save (if you are using prettier/efm/formater etc)
        -- table: {enable = {'lua', 'go'}, disable = {'javascript', 'typescript'}} to enable/disable specific language
        -- enable: a whitelist of language that will be formatted on save
        -- disable: a blacklist of language that will not be formatted on save
        -- function: function(bufnr) return true end to enable/disable lsp format on save
        format_options = { async = false } -- async: disable by default, the option used in vim.lsp.buf.format({async={true|false}, name = 'xxx'})
    },
    ctags = {
        cmd = "ctags",
        tagfile = "tags",
        options = "-R --exclude=.git --exclude=node_modules --exclude=test --exclude=vendor --excmd=number"
    }
}
