return {

    { "junegunn/fzf" }, {
    "m4xshen/hardtime.nvim",
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
        restriction_mode = "hint",
        disable_mouse = false,
        disabled_keys = { ["<Right>"] = false, ["<Left>"] = false }
    }
}, {
    "lewis6991/hover.nvim",
    config = function()
        require("hover").setup {
            init = function() require "hover.providers.lsp" end,
            preview_opts = { border = "single" },
            mouse_providers = { "LSP" },
            mouse_delay = 1000,
            vim.keymap.set("n", "<MouseMove>", require("hover").hover_mouse,
                { desc = "hover.nvim" })
        }
        vim.o.mousemoveevent = true
    end
}, { "hrsh7th/nvim-cmp", enabled = false }, {
    "saghen/blink.cmp",
    lazy = false,
    prority = 1000,
    version = "1.*",
    event = { "InsertEnter", "CmdLineEnter" },

    opts_extend = { "sources.default" },

    opts = function() return require "nvchad.blink.config" end,
    dependencies = {
        "mikavilpas/blink-ripgrep.nvim", "rafamadriz/friendly-snippets", {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = {
            history = true,
            updateevents = "TextChanged,TextChangedI"
        },
        config = function(_, opts)
            require("luasnip").config.set_config(opts)
            require "nvchad.configs.luasnip"
        end
    }, {
        "windwp/nvim-autopairs",
        opts = {
            fast_wrap = {},
            disable_filetype = { "TelescopePrompt", "vim" }
        }
    }
    }
}, {
    "ray-x/navigator.lua",
    lazy = false,
    dependencies = {
        { "ray-x/guihua.lua",     run = "cd lua/fzy && make" },
        { "neovim/nvim-lspconfig" }, { "nvim-tree/nvim-web-devicons" }
    },
    config = function() require "configs.navigator" end
}, {
    "sindrets/diffview.nvim",
    lazy = false,
    config = function() require "configs.diff" end
}, {
    "RRethy/vim-illuminate",     -- default configuration
    config = function()
        require("illuminate").configure {
            -- providers: provider used to get references in the buffer, ordered by priority
            providers = { "lsp", "treesitter", "regex" },
            -- delay: delay in milliseconds
            delay = 100,
            -- filetype_overrides: filetype specific overrides.
            -- The keys are strings to represent the filetype while the values are tables that
            -- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
            filetype_overrides = {},
            -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
            filetypes_denylist = { "dirbuf", "dirvish", "fugitive" },
            -- filetypes_allowlist: filetypes to illuminate, this is overridden by filetypes_denylist
            -- You must set filetypes_denylist = {} to override the defaults to allow filetypes_allowlist to take effect
            filetypes_allowlist = {},
            -- modes_denylist: modes to not illuminate, this overrides modes_allowlist
            -- See `:help mode()` for possible values
            modes_denylist = {},
            -- modes_allowlist: modes to illuminate, this is overridden by modes_denylist
            -- See `:help mode()` for possible values
            modes_allowlist = {},
            -- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
            -- Only applies to the 'regex' provider
            -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
            providers_regex_syntax_denylist = {},
            -- providers_regex_syntax_allowlist: syntax to illuminate, this is overridden by providers_regex_syntax_denylist
            -- Only applies to the 'regex' provider
            -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
            providers_regex_syntax_allowlist = {},
            -- under_cursor: whether or not to illuminate under the cursor
            under_cursor = true,
            -- large_file_cutoff: number of lines at which to use large_file_config
            -- The `under_cursor` option is disabled when this cutoff is hit
            large_file_cutoff = 10000,
            -- large_file_config: config to use for large files (based on large_file_cutoff).
            -- Supports the same keys passed to .configure
            -- If nil, vim-illuminate will be disabled for large files.
            large_file_overrides = nil,
            -- min_count_to_highlight: minimum number of matches required to perform highlighting
            min_count_to_highlight = 1,
            -- should_enable: a callback that overrides all other settings to
            -- enable/disable illumination. This will be called a lot so don't do
            -- anything expensive in it.
            should_enable = function(bufnr) return true end,
            -- case_insensitive_regex: sets regex case sensitivity
            case_insensitive_regex = false,
            -- disable_keymaps: disable default keymaps
            disable_keymaps = false
        }
    end
}, {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        lazy = true,
        config = function()
            require "configs.treesitter-textobjects"
        end
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function() require "configs.treesitter" end
}, {
    "stevearc/resession.nvim",
    lazy = false,
    prority = 1000,
    config = function()
        local resession = require "resession"
        resession.setup {
            options = {
                "binary", "bufhidden", "buflisted", "cmdheight", "diff",
                "filetype", "modifiable", "previewwindow", "readonly",
                "scrollbind", "winfixheight", "winfixwidth"
            }
        }
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                -- Only load the session if nvim was started with no args
                if vim.fn.argc(-1) == 0 then
                    -- Save these to a different directory, so our manual sessions don't get polluted
                    resession.load(vim.fn.getcwd(), {
                        dir = "dirsession",
                        silence_errors = true
                    })
                end
            end,
            nested = true
        })
        vim.api.nvim_create_autocmd("VimLeavePre", {
            callback = function()
                resession.save(vim.fn.getcwd(),
                    { dir = "dirsession", notify = true })
            end
        })
    end
}, {
    "stevearc/conform.nvim",
    cmd = "ConformInfo",
    event = { "BufWritePre", "BufWritePost" },
    opts = require "configs.conform"
}, {
    "folke/zen-mode.nvim",
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    }
}, {
    "mfussenegger/nvim-lint",
    prority = 1000,
    lazy = false,
    event = { "BufReadPre", "BufNewFile" },
    config = function() require "configs.lint" end
}, {
    "https://github.com/folke/snacks.nvim",
    lazy = false,
    prority = 1000,
    opts = {
        bigfile = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        statuscolumn = { enabled = true },
        image = { enabled = true },
        picker = {
            projects = {
                patterns = {
                    ".git", ".ropeproject", "requirements.txt", ".env",
                    ".venv", "Makefile", "package.json", ".gitignore"
                }
            },
            undo = {
                finder = "vim_undo",
                format = "undo",
                preview = "diff",
                confirm = "item_action",
                win = {
                    preview = {
                        wo = {
                            number = true,
                            relativenumber = false,
                            signcolumn = "no"
                        }
                    },
                    input = {
                        keys = {
                            ["<c-y>"] = { "yank_add", mode = { "n", "i" } },
                            ["<c-s-y>"] = { "yank_del", mode = { "n", "i" } }
                        }
                    }
                },
                actions = {
                    yank_add = { action = "yank", field = "added_lines" },
                    yank_del = { action = "yank", field = "removed_lines" }
                },
                icons = { tree = { last = "┌╴" } }, -- the tree is upside down
                diff = {
                    ctxlen = 4,
                    ignore_cr_at_eol = true,
                    ignore_whitespace_change_at_eol = true,
                    indent_heuristic = true
                }
            }
        },
        words = {
            debounce = 200,              -- time in ms to wait before updating
            notify_jump = false,         -- show a notification when jumping
            notify_end = true,           -- show a notification when reaching the end
            foldopen = true,             -- open folds after jumping
            jumplist = true,             -- set jump point before jumping
            modes = { "n", "i", "c" },   -- modes to show references
            filter = function(buf)       -- what buffers to enable `snacks.words`
                return vim.g.snacks_words ~= false and
                    vim.b[buf].snacks_words ~= false
            end
        }
    },
    keys = {
        {
            "<leader><space>",
            function() Snacks.picker.smart() end,
            desc = "Smart Find Files"
        },

        {
            "<leader>.",
            function() Snacks.scratch() end,
            desc = "Toggle Scratch Buffer"
        }, {
        "<leader>fn",
        function() Snacks.picker.notifications() end,
        desc = "Notification"
    },

        {
            "<leader>fp",
            function() Snacks.picker.projects() end,
            desc = "Projects"
        },

        { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
        { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
        {
            "<leader>sp",
            function() Snacks.picker.lazy() end,
            desc = "Search for Plugin Spec"
        },
        {
            "<leader>sk",
            function() Snacks.picker.keymaps() end,
            desc = "Keymaps"
        },
        {
            "<leader>sC",
            function() Snacks.picker.commands() end,
            desc = "Commands"
        }, {
        "<leader>sc",
        function() Snacks.picker.command_history() end,
        desc = "Command History"
    },
        {
            "<leader>sH",
            function() Snacks.picker.highlights() end,
            desc = "Highlights"
        },
        {
            "<leader>sM",
            function() Snacks.picker.man() end,
            desc = "Man Pages"
        },
        {
            "<leader>sR",
            function() Snacks.picker.resume() end,
            desc = "Resume"
        },
        {
            "<leader>su",
            function() Snacks.picker.undo() end,
            desc = "Undo History"
        }, { "<leader>j", function() Snacks.picker.zoxide() end }
    }
}, {
    "mason-org/mason.nvim",
    dependencies = {
        "mfussenegger/nvim-dap", "jay-babu/mason-nvim-dap.nvim",
        "mason-org/mason-lspconfig.nvim"
    },
    config = function() require "configs.mason" end
},

    {
        "neovim/nvim-lspconfig",
        config = function() require "configs.lspconfig" end
    }, {
    "azratul/live-share.nvim",
    dependencies = { "jbyuki/instant.nvim" },
    config = function()
        ---@diagnostic disable-next-line: 112
        vim.g.instant_username = "towjacix"
        require("live-share").setup {
            port_internal = 8765,
            max_attempts = 40,     -- 10 seconds
            service = "serveo.net"
        }
    end
}, {
    "barrett-ruth/live-server.nvim",
    build = "pnpm add -g live-server",
    cmd = { "LiveServerStart", "LiveServerStop" },
    config = true
}, { "nvzone/typr" }, { "nvzone/timerly", cmd = "TimerlyToggle" }, {
    "nvzone/showkeys",
    lazy = false,
    cmd = "ShowkeysToggle",
    opts = { timeout = 2, maxkeys = 6 }
}, {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim", "ravitemer/codecompanion-history.nvim",
        "nvim-treesitter/nvim-treesitter", {
        "ravitemer/mcphub.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim"         -- Required for Job and HTTP requests
        },
        -- cmd = "MCPHub", -- lazily start the hub when `MCPHub` is called
        build = "npm install -g mcp-hub@latest",         -- Installs required mcp-hub npm module
        config = function()
            require("mcphub").setup {
                -- Required options
                port = 37373,                                       -- Port for MCP Hub server
                auto_approve = true,
                config = vim.fn.expand "~/mcpservers.json",         -- Absolute path to config file

                extensions = {
                    codecompanion = {
                        show_result_in_chat = true,
                        make_vars = true
                    }
                },

                -- Optional options
                on_ready = function(hub)
                    -- Called when hub is ready
                end,
                on_error = function(err)
                    -- Called on errors
                end,
                log = {
                    level = vim.log.levels.WARN,
                    to_file = false,
                    file_path = nil,
                    prefix = "MCPHub"
                }
            }
        end
    }, {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "codecompanion" }
    },                                            -- Optional: For prettier markdown rendering
        { "stevearc/dressing.nvim", opts = {} }   -- Optional: Improves `vim.ui.select`
    },
    config = function() require "configs.code_companion" end
}, {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "tsakirist/telescope-lazy.nvim", "scottmckendry/pick-resession.nvim"
    },
    config = function()
        require("telescope").setup {
            extensions = {
                resession = {
                    prompt_title = "Find Sessions",
                    dir = "session"
                }
            }
        }
    end
}, {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }
}, {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
        "neovim/nvim-lspconfig", "mfussenegger/nvim-dap",
        "mfussenegger/nvim-dap-python",     -- optional
        {
            "nvim-telescope/telescope.nvim",
            branch = "0.1.x",
            dependencies = { "nvim-lua/plenary.nvim" }
        }
    },
    lazy = false,
    branch = "regexp",     -- This is the regexp branch, use this for the new version
    config = function() require("venv-selector").setup() end,
    keys = { { ",v", "<cmd>VenvSelect<cr>" } }
}, {
    "doctorfree/cheatsheet.nvim",
    event = "VeryLazy",
    dependencies = {
        { "nvim-telescope/telescope.nvim" }, { "nvim-lua/popup.nvim" },
        { "nvim-lua/plenary.nvim" }
    },
    config = function()
        local ctactions = require "cheatsheet.telescope.actions"
        require("cheatsheet").setup {
            bundled_cheetsheets = {
                enabled = {
                    "default", "lua", "markdown", "regex", "netrw",
                    "unicode"
                },
                disabled = { "nerd-fonts" }
            },
            bundled_plugin_cheatsheets = {
                enabled = {
                    "auto-session", "goto-preview", "octo.nvim",
                    "telescope.nvim", "vim-easy-align", "vim-sandwich"
                },
                disabled = { "gitsigns" }
            },
            include_only_installed_plugins = true,
            telescope_mappings = {
                ["<CR>"] = ctactions.select_or_fill_commandline,
                ["<A-CR>"] = ctactions.select_or_execute,
                ["<C-Y>"] = ctactions.copy_cheat_value,
                ["<C-E>"] = ctactions.edit_user_cheatsheet
            }
        }
    end
}, {
    "iamcco/markdown-preview.nvim",
    cmd = {
        "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop"
    },
    build = "cd app && yarn install",
    init = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = { "markdown" }
}, {
    "lervag/vimtex",
    lazy = false,
    init = function() vim.g.vimtex_view_method = "zathura" end
}, {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter",
    run = ":TSUpdate"
}, {
    "TobinPalmer/rayso.nvim",
    lazy = false,
    cmd = { "Rayso" },
    config = function()
        require("rayso").setup {
            open_cmd = "zen-browser",
            options = {
                background = true,
                dark_mode = true,
                paddings = 64,
                themes = "Midnight",
                title = "Untitled"
            }
        }
    end
}, {
    "nvim-telescope/telescope-ui-select.nvim",
    lazy = false,
    dependecies = { "nvim-telescope/telescope.nvim" },
    require("telescope").setup {
        extensions = {
            ["ui-select"] = {
                require("telescope.themes").get_dropdown {
                    -- even more opts
                }

                -- pseudo code / specification for writing custom displays, like the one
                -- for "codeactions"
                -- specific_opts = {
                --   [kind] = {
                --     make_indexed = function(items) -> indexed_items, width,
                --     make_displayer = function(widths) -> displayer
                --     make_display = function(displayer) -> function(e)
                --     make_ordinal = function(e) -> string
                --   },
                --   -- for example to disable the custom builtin "codeactions" display
                --      do the following
                --   codeactions = false,
                -- }
            }
        }
    }
}, {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    lazy = false,
    opts = function(_, opts)
        return vim.tbl_deep_extend("force", opts or {}, {
            picker = {
                actions = require("trouble.sources.snacks").actions,
                win = {
                    input = {
                        keys = {
                            ["<c-t>"] = { "trouble_open", mode = { "n", "i" } }
                        }
                    }
                }
            }
        })
    end
}, {
    "kylechui/nvim-surround",
    version = "*",     -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup {
            -- Configuration here, or leave empty to use defaults
        }
    end
}, { "AckslD/muren.nvim", config = true, lazy = false }, {
    "echasnovski/mini.nvim",
    version = false,
    lazy = false,
    config = function()
        require("mini.comment").setup {
            options = {
                -- Function to compute custom 'commentstring' (optional)
                custom_commentstring = nil,

                -- Whether to ignore blank lines when commenting
                ignore_blank_line = false,

                -- Whether to ignore blank lines in actions and textobject
                start_of_line = false,

                -- Whether to force single space inner padding for comment parts
                pad_comment_parts = true
            },

            -- Module mappings. Use `''` (empty string) to disable one.
            mappings = {
                -- Toggle comment (like `gcip` - comment inner paragraph) for both
                -- Normal and Visual modes
                comment = "gc",

                -- Toggle comment on current line
                comment_line = "gcc",

                -- Toggle comment on visual selection
                comment_visual = "gc",

                -- Define 'comment' textobject (like `dgc` - delete whole comment block)
                -- Works also in Visual mode if mapping differs from `comment_visual`
                textobject = "gc"
            },

            -- Hook functions to be executed at certain stage of commenting
            hooks = {
                -- Before successful commenting. Does nothing by default.
                pre = function() end,
                -- After successful commenting. Does nothing by default.
                post = function() end
            }
        }

        require("mini.move").setup {
            -- Module mappings. Use `''` (empty string) to disable one.
            mappings = {
                -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
                left = "<M-h>",
                right = "<M-l>",
                down = "<M-j>",
                up = "<M-k>",

                -- Move current line in Normal mode
                line_left = "<M-h>",
                line_right = "<M-l>",
                line_down = "<M-j>",
                line_up = "<M-k>"
            },

            -- Options which control moving behavior
            options = {
                -- Automatically reindent selection during linewise vertical move
                reindent_linewise = true
            }
        }

        require("mini.splitjoin").setup()
    end
}, {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = require "configs.noice",
    dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",     -- OPTIONAL:
        --   `nvim-notify` is only needed, if you want to use the notification view.
        --   If not available, we use `mini` as the fallback
        "rcarriga/nvim-notify"
    }
}, { "stevearc/dressing.nvim", lazy = false,   opts = {} }, {
    "mfussenegger/nvim-dap",
    config = function()
        local dap = require "dap"
        dap.adapters.cppdbg = {
            id = "cppdbg",
            type = "executable",
            command = "C:\\Users\\manhp\\Downloads\\cpptools\\extension\\debugAdapters\\bin\\OpenDebugAD7.exe",
            options = { detached = false }
        }
        dap.configurations.cpp = {
            {
                name = "Launch file",
                type = "cppdbg",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ",
                        vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopAtEntry = true
            }, {
            name = "Attach to gdbserver :1234",
            type = "cppdbg",
            request = "launch",
            MIMode = "gdb",
            miDebuggerServerAddress = "localhost:1234",
            miDebuggerPath = "/usr/bin/gdb",
            cwd = "${workspaceFolder}",
            program = function()
                return vim.fn.input("Path to executable: ",
                    vim.fn.getcwd() .. "/", "file")
            end
        }
        }
    end,
    lazy = false
}, {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    lazy = false
}, {     -- This plugin
    "Zeioth/compiler.nvim",
    lazy = false,
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    dependencies = { "stevearc/overseer.nvim" },
    opts = {}
}, {     -- The task runner we use
    "stevearc/overseer.nvim",
    -- commit = "400e762648b70397d0d315e5acaf0ff3597f2d8b",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    opts = {
        task_list = {
            direction = "bottom",
            min_height = 25,
            max_height = 25,
            default_detail = 1
        }
    }
}, {
    "folke/flash.nvim",
    event = "VeryLazy",
    -- @type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
        {
            "s",
            mode = { "n", "x", "o" },
            function() require("flash").jump() end,
            desc = "Flash"
        }, {
        "S",
        mode = { "n", "x", "o" },
        function() require("flash").treesitter() end,
        desc = "Flash Treesitter"
    }, {
        "r",
        mode = "o",
        function() require("flash").remote() end,
        desc = "Remote Flash"
    }, {
        "R",
        mode = { "o", "x" },
        function() require("flash").treesitter_search() end,
        desc = "Treesitter Search"
    }, {
        "<c-s>",
        mode = { "c" },
        function() require("flash").toggle() end,
        desc = "Toggle Flash Search"
    }
    }
}, { "pocco81/auto-save.nvim", event = "VeryLazy" }, {
    "roobert/surround-ui.nvim",
    lazy = false,
    dependencies = { "kylechui/nvim-surround", "folke/which-key.nvim" },
    config = function() require("surround-ui").setup { root_key = "S" } end
}, {
    "piersolenski/wtf.nvim",
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
    keys = {
        {
            "gw",
            mode = { "n", "x" },
            function() require("wtf").ai() end,
            desc = "Debug diagnostic with AI"
        }, {
        mode = { "n" },
        "gW",
        function() require("wtf").search() end,
        desc = "Search diagnostic with Google"
    }
    }
},     -- Install a plugin
    {
        "max397574/better-escape.nvim",
        event = "InsertEnter",
        config = function() require("better_escape").setup() end
    }
}
