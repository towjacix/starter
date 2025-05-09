return {

    {
        "ray-x/navigator.lua",
        lazy = false,
        dependencies = {
            {"ray-x/guihua.lua", run = "cd lua/fzy && make"},
            {"neovim/nvim-lspconfig"}
        },
        config = function()
            require("navigator").setup {
                debug = false, -- log output, set to true and log path: ~/.cache/nvim/gh.log
                -- slowdownd startup and some actions
                width = 0.75, -- max width ratio (number of cols for the floating window) / (window width)
                height = 0.3, -- max list window height, 0.3 by default
                preview_height = 0.35, -- max height of preview windows
                border = {
                    "╭", "─", "╮", "│", "╯", "─", "╰", "│"
                }, -- border style, can be one of 'none', 'single', 'double',
                -- 'shadow', or a list of chars which defines the border
                mason = false,
                default_mapping = true, -- set to false if you will remap every key
                keymaps = {
                    {
                        key = "gK",
                        func = vim.lsp.declaration,
                        desc = "declaration"
                    }
                }, -- a list of key maps
                -- this kepmap gK will override "gD" mapping function declaration()  in default kepmap
                -- please check mapping.lua for all keymaps
                -- rule of overriding: if func and mode ('n' by default) is same
                -- the key will be overridden
                treesitter_analysis = true, -- treesitter variable context
                treesitter_navigation = true, -- bool|table false: use lsp to navigate between symbol ']r/[r', table: a list of
                -- lang using TS navigation
                treesitter_analysis_max_num = 100, -- how many items to run treesitter analysis
                treesitter_analysis_condense = true, -- condense form for treesitter analysis
                -- this value prevent slow in large projects, e.g. found 100000 reference in a project
                transparency = 50, -- 0 ~ 100 blur the main window, 100: fully transparent, 0: opaque,  set to nil or 100 to disable it

                lsp_signature_help = false, -- if you would like to hook ray-x/lsp_signature plugin in navigator
                -- setup here. if it is nil, navigator will not init signature help
                signature_help_cfg = nil, -- if you would like to init ray-x/lsp_signature plugin in navigator, and pass in your own config to signature help
                icons = { -- refer to lua/navigator.lua for more icons config
                    -- requires nerd fonts or nvim-web-devicons
                    icons = true,
                    -- Code action
                    code_action_icon = "🏏", -- note: need terminal support, for those not support unicode, might crash
                    -- Diagnostics
                    diagnostic_head = "🐛",
                    diagnostic_head_severity_1 = "🈲",
                    fold = {
                        prefix = "⚡", -- icon to show before the folding need to be 2 spaces in display width
                        separator = "" -- e.g. shows   3 lines 
                    }
                },
                lsp = {
                    enable = true, -- skip lsp setup, and only use treesitter in navigator.
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
                        virtual_text = true
                    },
                    code_lens_action = {
                        enable = true,
                        sign = true,
                        sign_priority = 40,
                        virtual_text = true
                    },
                    document_highlight = true, -- LSP reference highlight,
                    -- it might already supported by you setup, e.g. LunarVim
                    format_on_save = true, -- {true|false} set to false to disasble lsp code format on save (if you are using prettier/efm/formater etc)
                    -- table: {enable = {'lua', 'go'}, disable = {'javascript', 'typescript'}} to enable/disable specific language
                    -- enable: a whitelist of language that will be formatted on save
                    -- disable: a blacklist of language that will not be formatted on save
                    -- function: function(bufnr) return true end to enable/disable lsp format on save
                    format_options = {async = false} -- async: disable by default, the option used in vim.lsp.buf.format({async={true|false}, name = 'xxx'})
                },
                ctags = {
                    cmd = "ctags",
                    tagfile = "tags",
                    options = "-R --exclude=.git --exclude=node_modules --exclude=test --exclude=vendor --excmd=number"
                }
            }
        end
    }, {
        "sindrets/diffview.nvim",
        lazy = false,
        config = function() require "configs.diff" end
    }, {
        "RRethy/vim-illuminate", -- default configuration
        config = function()
            require("illuminate").configure {
                -- providers: provider used to get references in the buffer, ordered by priority
                providers = {"lsp", "treesitter", "regex"},
                -- delay: delay in milliseconds
                delay = 100,
                -- filetype_overrides: filetype specific overrides.
                -- The keys are strings to represent the filetype while the values are tables that
                -- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
                filetype_overrides = {},
                -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
                filetypes_denylist = {"dirbuf", "dirvish", "fugitive"},
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
        "hat0uma/csvview.nvim",
        ---@module "csvview"
        ---@type CsvView.Options
        opts = {
            view = {
                ---@type CsvView.Options.View.DisplayMode
                display_mode = "border"
            },
            parser = {comments = {"#", "//"}},
            keymaps = {
                -- Text objects for selecting fields
                textobject_field_inner = {"if", mode = {"o", "x"}},
                textobject_field_outer = {"af", mode = {"o", "x"}},
                -- Excel-like navigation:
                -- Use <Tab> and <S-Tab> to move horizontally between fields.
                -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
                -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
                jump_next_field_end = {"<Tab>", mode = {"n", "v"}},
                jump_prev_field_end = {"<S-Tab>", mode = {"n", "v"}},
                jump_next_row = {"<Enter>", mode = {"n", "v"}},
                jump_prev_row = {"<S-Enter>", mode = {"n", "v"}}
            }
        },
        cmd = {"CsvViewEnable", "CsvViewDisable", "CsvViewToggle"}
    }, {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = require "configs.autopairs"
        -- use opts = {} for passing setup options
        -- this is equivalent to setup({}) function
    }, {
        "nvim-treesitter/nvim-treesitter",
        event = {"BufReadPre", "BufNewFile"},
        config = function() require "configs.treesitter" end
    }, {
        "stevearc/resession.nvim",
        lazy = false,
        config = function()
            local resession = require "resession"
            resession.setup {}
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
                                   {dir = "dirsession", notify = true})
                end
            })
        end
    }, {
        "stevearc/aerial.nvim",
        lazy = false,
        opts = require "configs.aerial",
        dependency = {
            "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons"
        }
    }, {
        "stevearc/conform.nvim",
        cmd = "ConformInfo",
        event = {"BufWritePre", "BufWritePost"},
        opts = require "configs.conform"
    }, {
        "chipsenkbeil/distant.nvim",
        branch = "v0.3",
        config = function() require("distant"):setup() end
    }, {
        "folke/zen-mode.nvim",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    }, {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = {"nvim-lua/plenary.nvim"},
        config = function() require("harpoon"):setup() end
    }, {
        "mfussenegger/nvim-lint",
        prority = 1000,
        lazy = false,
        event = {"BufReadPre", "BufNewFile"},
        config = function() require "configs.lint" end
    }, {
        "https://github.com/folke/snacks.nvim",
        lazy = false,
        prority = 1000,
        opts = {
            bigfile = {enabled = true},
            notifier = {enabled = true},
            quickfile = {enabled = true},
            statuscolumn = {enabled = true},
            words = {enabled = true}
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
        dependencies = {"jbyuki/instant.nvim"},
        config = function()
            ---@diagnostic disable-next-line: 112
            vim.g.instant_username = "towjacix"
            require("live-share").setup {
                port_internal = 8765,
                max_attempts = 40, -- 10 seconds
                service = "serveo.net"
            }
        end
    }, {
        "barrett-ruth/live-server.nvim",
        build = "pnpm add -g live-server",
        cmd = {"LiveServerStart", "LiveServerStop"},
        config = true
    }, {"nvzone/typr"}, {"nvzone/timerly", cmd = "TimerlyToggle"}, {
        "nvzone/showkeys",
        lazy = false,
        cmd = "ShowkeysToggle",
        opts = {timeout = 2, maxkeys = 6}
    }, {
        "potamides/pantran.nvim",
        config = function()
            require("pantran").setup {
                default_engine = "google",

                command = {default_moode = "interactive"},

                engines = {
                    yandex = {
                        default_target = "vi",
                        -- api_key = vim.env.YANDEX_API_KEY,
                        iam_key = os.getenv "YANDEX_IAM_KEY"
                    }
                }
            }
        end
    }, {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup {
                patterns = {
                    ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile",
                    "package.json", ".env", ".venv"
                },
                silent_chdir = false
            }
        end
    }, {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter", {
                "ravitemer/mcphub.nvim",
                dependencies = {
                    "nvim-lua/plenary.nvim" -- Required for Job and HTTP requests
                },
                -- cmd = "MCPHub", -- lazily start the hub when `MCPHub` is called
                build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
                config = function()
                    require("mcphub").setup {
                        -- Required options
                        port = 37373, -- Port for MCP Hub server
                        auto_approve = true,
                        config = vim.fn.expand "~/mcpservers.json", -- Absolute path to config file

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
                ft = {"markdown", "codecompanion"}
            }, -- Optional: For prettier markdown rendering
            {"stevearc/dressing.nvim", opts = {}} -- Optional: Improves `vim.ui.select`
        },
        config = function() require "configs.code_companion" end
    }, {
        "glepnir/template.nvim",
        cmd = {"Template", "TemProject"},
        config = function()
            require("template").setup {
                -- config in there
            }
        end
    }, {
        "debugloop/telescope-undo.nvim",
        dependencies = { -- note how they're inverted to above example
            {
                "nvim-telescope/telescope.nvim",
                dependencies = {"nvim-lua/plenary.nvim"}
            }
        },
        keys = {
            { -- lazy style key map
                "<leader>u",
                "<cmd>Telescope undo<cr>",
                desc = "undo history"
            }
        },
        opts = {
            -- don't use `defaults = { }` here, do this in the main telescope spec
            extensions = {
                undo = {
                    -- telescope-undo.nvim config, see below
                }
                -- no other extensions here, they can have their own spec too
            }
        },
        config = function(_, opts)
            -- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
            -- configs for us. We won't use data, as everything is in it's own namespace (telescope
            -- defaults, as well as each extension).
            require("telescope").setup(opts)
            require("telescope").load_extension "undo"
        end
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
        dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"}
    }, {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            "neovim/nvim-lspconfig", "mfussenegger/nvim-dap",
            "mfussenegger/nvim-dap-python", -- optional
            {
                "nvim-telescope/telescope.nvim",
                branch = "0.1.x",
                dependencies = {"nvim-lua/plenary.nvim"}
            }
        },
        lazy = false,
        branch = "regexp", -- This is the regexp branch, use this for the new version
        config = function() require("venv-selector").setup() end,
        keys = {{",v", "<cmd>VenvSelect<cr>"}}
    }, {
        "doctorfree/cheatsheet.nvim",
        event = "VeryLazy",
        dependencies = {
            {"nvim-telescope/telescope.nvim"}, {"nvim-lua/popup.nvim"},
            {"nvim-lua/plenary.nvim"}
        },
        config = function()
            local ctactions = require "cheatsheet.telescope.actions"
            require("cheatsheet").setup {
                bundled_cheetsheets = {
                    enabled = {
                        "default", "lua", "markdown", "regex", "netrw",
                        "unicode"
                    },
                    disabled = {"nerd-fonts"}
                },
                bundled_plugin_cheatsheets = {
                    enabled = {
                        "auto-session", "goto-preview", "octo.nvim",
                        "telescope.nvim", "vim-easy-align", "vim-sandwich"
                    },
                    disabled = {"gitsigns"}
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
    }, {"nvim-telescope/telescope-media-files.nvim", lazy = false}, {
        "dhruvmanila/browser-bookmarks.nvim",
        version = "*",
        -- Only required to override the default options
        opts = {
            -- Override default configuration values
            selected_browser = "chrome"
        },
        dependencies = {
            --   -- Only if your selected browser is Firefox, Waterfox or buku
            --   'kkharji/sqlite.lua',
            --
            --   -- Only if you're using the Telescope extension
            -- 'nvim-telescope/telescope.nvim',
            -- }
        },

        {
            "iamcco/markdown-preview.nvim",
            cmd = {
                "MarkdownPreviewToggle", "MarkdownPreview",
                "MarkdownPreviewStop"
            },
            build = "cd app && yarn install",
            init = function() vim.g.mkdp_filetypes = {"markdown"} end,
            ft = {"markdown"}
        },

        {
            "lervag/vimtex",
            lazy = false,
            init = function() vim.g.vimtex_view_method = "zathura" end
        },

        {
            "nvim-treesitter/nvim-treesitter-textobjects",
            dependencies = "nvim-treesitter",
            run = ":TSUpdate"
        },

        {
            "ibhagwan/fzf-lua",
            -- optional for icon support
            dependencies = {"nvim-tree/nvim-web-devicons"},
            config = function()
                -- calling `setup` is optional for customization
                require("fzf-lua").setup {}
            end
        },

        {"rafamadriz/friendly-snippets"},

        {
            "saadparwaiz1/cmp_luasnip",
            config = function()
                require("cmp").setup {
                    snippset = {
                        expand = function(args)
                            require("luasnip").lsp_expand(args.body)
                        end
                    },

                    sources = {
                        {name = "luasnip"}
                        -- more sources
                    }
                }
            end
        },

        {
            "TobinPalmer/rayso.nvim",
            lazy = false,
            cmd = {"Rayso"},
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
        },

        {
            "ziontee113/icon-picker.nvim",
            lazy = false,
            config = function()
                require("icon-picker").setup {disable_legacy_comands = true}
            end
        },

        {
            "nvim-telescope/telescope-ui-select.nvim",
            lazy = false,
            dependecies = {"nvim-telescope/telescope.nvim"},
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
        },

        {
            "folke/trouble.nvim",
            dependencies = {"nvim-tree/nvim-web-devicons"},
            cmd = "Trouble",
            lazy = false,
            opts = {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        },

        {
            "preservim/tagbar",
            lazy = false,

            {
                "kylechui/nvim-surround",
                version = "*", -- Use for stability; omit to use `main` branch for the latest features
                event = "VeryLazy",
                config = function()
                    require("nvim-surround").setup {
                        -- Configuration here, or leave empty to use defaults
                    }
                end
            },

            {"junegunn/fzf", build = "./install --bin"},

            {"AckslD/nvim-neoclip.lua"},

            {"AckslD/muren.nvim", config = true, lazy = false},

            {"vijaymarupudi/nvim-fzf", event = "VeryLazy"},

            {
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
            },

            {"niuiic/core.nvim", lazy = false},

            -- lazy.nvim
            {
                "folke/noice.nvim",
                event = "VeryLazy",
                opts = require "configs.noice",
                dependencies = {
                    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
                    "MunifTanjim/nui.nvim", -- OPTIONAL:
                    --   `nvim-notify` is only needed, if you want to use the notification view.
                    --   If not available, we use `mini` as the fallback
                    "rcarriga/nvim-notify"
                }
            },

            {"stevearc/dressing.nvim", lazy = false, opts = {}},

            {"axkirillov/hbac.nvim", config = true, lazy = false},

            {
                "mfussenegger/nvim-dap",
                config = function()
                    local dap = require "dap"
                    dap.adapters.cppdbg = {
                        id = "cppdbg",
                        type = "executable",
                        command = "C:\\Users\\manhp\\Downloads\\cpptools\\extension\\debugAdapters\\bin\\OpenDebugAD7.exe",
                        options = {detached = false}
                    }
                    local dap = require "dap"
                    dap.configurations.cpp = {
                        {
                            name = "Launch file",
                            type = "cppdbg",
                            request = "launch",
                            program = function()
                                return vim.fn.input("Path to executable: ",
                                                    vim.fn.getcwd() .. "/",
                                                    "file")
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
                                                    vim.fn.getcwd() .. "/",
                                                    "file")
                            end
                        }
                    }
                end,
                lazy = false
            },

            {
                "rcarriga/nvim-dap-ui",
                dependencies = {"mfussenegger/nvim-dap"},
                lazy = false
            },

            { -- This plugin
                "Zeioth/compiler.nvim",
                lazy = false,
                cmd = {"CompilerOpen", "CompilerToggleResults", "CompilerRedo"},
                dependencies = {"stevearc/overseer.nvim"},
                opts = {}
            },

            { -- The task runner we use
                "stevearc/overseer.nvim",
                -- commit = "400e762648b70397d0d315e5acaf0ff3597f2d8b",
                cmd = {"CompilerOpen", "CompilerToggleResults", "CompilerRedo"},
                opts = {
                    task_list = {
                        direction = "bottom",
                        min_height = 25,
                        max_height = 25,
                        default_detail = 1
                    }
                }
            },

            {"nvim-lua/popup.nvim", lazy = false},

            {"ray-x/guihua.lua", run = "cd lua/fzy && make", event = "VeryLazy"},

            {"smoka7/hop.nvim", lazy = false, version = "*", opts = {}},

            {
                "folke/flash.nvim",
                event = "VeryLazy",
                -- @type Flash.Config
                opts = {},
                -- stylua: ignore
                keys = {
                    {
                        "s",
                        mode = {"n", "x", "o"},
                        function()
                            require("flash").jump()
                        end,
                        desc = "Flash"
                    }, {
                        "S",
                        mode = {"n", "x", "o"},
                        function()
                            require("flash").treesitter()
                        end,
                        desc = "Flash Treesitter"
                    }, {
                        "r",
                        mode = "o",
                        function()
                            require("flash").remote()
                        end,
                        desc = "Remote Flash"
                    }, {
                        "R",
                        mode = {"o", "x"},
                        function()
                            require("flash").treesitter_search()
                        end,
                        desc = "Treesitter Search"
                    }, {
                        "<c-s>",
                        mode = {"c"},
                        function()
                            require("flash").toggle()
                        end,
                        desc = "Toggle Flash Search"
                    }
                }
            },

            {"pocco81/auto-save.nvim", event = "VeryLazy"},

            {"niuiic/format.nvim", event = "VeryLazy"},

            {
                "gelguy/wilder.nvim",
                dependencies = {
                    "romgrk/fzy-lua-native", {
                        "nixprime/cpsm",
                        dependencies = {"ctrlpvim/ctrlp.vim", lazy = false},
                        lazy = false,
                        build = "bash ./install.sh"
                    }
                },
                lazy = false,
                config = function() require "configs.wilder" end
            },

            {
                "kawre/leetcode.nvim",
                build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
                dependencies = {
                    "nvim-telescope/telescope.nvim", -- "ibhagwan/fzf-lua",
                    "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim"
                },
                opts = {
                    -- configuration goes here
                    lang = "python"
                }
            },
            {
                "roobert/surround-ui.nvim",
                lazy = false,
                dependencies = {
                    "kylechui/nvim-surround", "folke/which-key.nvim"
                },
                config = function()
                    require("surround-ui").setup {root_key = "S"}
                end
            },

            {
                "piersolenski/wtf.nvim",
                lazy = false,
                dependencies = {"MunifTanjim/nui.nvim"},
                opts = {},
                keys = {
                    {
                        "gw",
                        mode = {"n", "x"},
                        function() require("wtf").ai() end,
                        desc = "Debug diagnostic with AI"
                    }, {
                        mode = {"n"},
                        "gW",
                        function()
                            require("wtf").search()
                        end,
                        desc = "Search diagnostic with Google"
                    }
                }
            },
            -- Install a plugin
            {
                "max397574/better-escape.nvim",
                event = "InsertEnter",
                config = function()
                    require("better_escape").setup()
                end
            }
        }
    }
}
