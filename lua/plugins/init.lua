return {
  {
    "chipsenkbeil/distant.nvim",
    branch = "v0.3",
    config = function()
      require("distant"):setup()
    end,
  },

  {
    "folke/zen-mode.nvim",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon"):setup()
    end,
  },

  {
    "mfussenegger/nvim-lint",
    prority = 1000,
    lazy = false,
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    config = function()
      require "configs.lint"
    end,
  },

  {
    "https://github.com/folke/snacks.nvim",
    lazy = false,
    prority = 1000,
    opts = {
      bigfile = {
        enabled = true,
      },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
  },

  {
    "williamboman/mason.nvim",
    "mfussenegger/nvim-dap",
    "jay-babu/mason-nvim-dap.nvim",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "azratul/live-share.nvim",
    dependencies = {
      "jbyuki/instant.nvim",
    },
    config = function()
      vim.g.instant_username = "towjacix"
      require("live-share").setup {
        port_internal = 8765,
        max_attempts = 40, -- 10 seconds
        service = "serveo.net",
      }
    end,
  },

  {
    "barrett-ruth/live-server.nvim",
    build = "pnpm add -g live-server",
    cmd = { "LiveServerStart", "LiveServerStop" },
    config = true,
  },

  { "nvzone/typr" },

  { "nvzone/timerly", cmd = "TimerlyToggle" },

  {
    "nvzone/showkeys",
    lazy = false,
    cmd = "ShowkeysToggle",
    opts = {
      timeout = 2,
      maxkeys = 6,
    },
  },

  {
    "potamides/pantran.nvim",
    config = function()
      require("pantran").setup {
        default_engine = "google",

        command = {
          default_moode = "interactive",
        },

        engines = {
          yandex = {
            default_target = "vi",
            -- api_key = vim.env.YANDEX_API_KEY,
            iam_key = os.getenv "YANDEX_IAM_KEY",
          },
        },
      }
    end,
  },

  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", ".env", ".venv" },
        silent_chdir = false,
      }
    end,
  },

  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "ravitemer/mcphub.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
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
                make_vars = true,
              },
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
              prefix = "MCPHub",
            },
          }
        end,
      },
      { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } }, -- Optional: For prettier markdown rendering
      { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
    },
    config = function()
      require "configs.code_companion"
    end,
  },

  {
    "glepnir/template.nvim",
    cmd = { "Template", "TemProject" },
    config = function()
      require("template").setup {
        -- config in there
      }
    end,
  },

  {
    "debugloop/telescope-undo.nvim",
    dependencies = { -- note how they're inverted to above example
      {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    keys = {
      { -- lazy style key map
        "<leader>u",
        "<cmd>Telescope undo<cr>",
        desc = "undo history",
      },
    },
    opts = {
      -- don't use `defaults = { }` here, do this in the main telescope spec
      extensions = {
        undo = {
          -- telescope-undo.nvim config, see below
        },
        -- no other extensions here, they can have their own spec too
      },
    },
    config = function(_, opts)
      -- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
      -- configs for us. We won't use data, as everything is in it's own namespace (telescope
      -- defaults, as well as each extension).
      require("telescope").setup(opts)
      require("telescope").load_extension "undo"
    end,
  },

  { "nvim-telescope/telescope.nvim", dependencies = "tsakirist/telescope-lazy.nvim" },
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      "mfussenegger/nvim-dap-python", --optional
      { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    lazy = false,
    branch = "regexp", -- This is the regexp branch, use this for the new version
    config = function()
      require("venv-selector").setup()
    end,
    keys = {
      { ",v", "<cmd>VenvSelect<cr>" },
    },
  },

  {
    "doctorfree/cheatsheet.nvim",
    event = "VeryLazy",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
      { "nvim-lua/popup.nvim" },
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      local ctactions = require "cheatsheet.telescope.actions"
      require("cheatsheet").setup {
        bundled_cheetsheets = {
          enabled = { "default", "lua", "markdown", "regex", "netrw", "unicode" },
          disabled = { "nerd-fonts" },
        },
        bundled_plugin_cheatsheets = {
          enabled = {
            "auto-session",
            "goto-preview",
            "octo.nvim",
            "telescope.nvim",
            "vim-easy-align",
            "vim-sandwich",
          },
          disabled = { "gitsigns" },
        },
        include_only_installed_plugins = true,
        telescope_mappings = {
          ["<CR>"] = ctactions.select_or_fill_commandline,
          ["<A-CR>"] = ctactions.select_or_execute,
          ["<C-Y>"] = ctactions.copy_cheat_value,
          ["<C-E>"] = ctactions.edit_user_cheatsheet,
        },
      }
    end,
  },
  {
    "nvim-telescope/telescope-media-files.nvim",
    lazy = false,
  },

  {
    "dhruvmanila/browser-bookmarks.nvim",
    version = "*",
    -- Only required to override the default options
    opts = {
      -- Override default configuration values
      selected_browser = "chrome",
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
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      build = "cd app && yarn install",
      init = function()
        vim.g.mkdp_filetypes = { "markdown" }
      end,
      ft = { "markdown" },
    },

    {
      "lervag/vimtex",
      lazy = false,
      init = function()
        vim.g.vimtex_view_method = "zathura"
      end,
    },

    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      dependencies = "nvim-treesitter",
      run = ":TSUpdate",
    },

    {
      "ibhagwan/fzf-lua",
      -- optional for icon support
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        -- calling `setup` is optional for customization
        require("fzf-lua").setup {}
      end,
    },

    { "rafamadriz/friendly-snippets" },

    {
      "saadparwaiz1/cmp_luasnip",
      config = function()
        require("cmp").setup {
          snippset = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
            end,
          },

          sources = {
            { name = "luasnip" },
            --more sources
          },
        }
      end,
    },

    {
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
            title = "Untitled",
          },
        }
      end,
    },

    {
      "ziontee113/icon-picker.nvim",
      lazy = false,
      config = function()
        require("icon-picker").setup {
          disable_legacy_comands = true,
        }
      end,
    },

    {
      "nvim-telescope/telescope-ui-select.nvim",
      lazy = false,
      dependecies = { "nvim-telescope/telescope.nvim" },
      require("telescope").setup {
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {
              -- even more opts
            },

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
          },
        },
      },
    },

    {
      "folke/trouble.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      enable = true,
      lazy = false,
      opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
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
        end,
      },

      { "junegunn/fzf", build = "./install --bin" },

      {
        "AckslD/nvim-neoclip.lua",
      },

      {
        "AckslD/muren.nvim",
        config = true,
        lazy = false,
      },

      {
        "vijaymarupudi/nvim-fzf",
        event = "VeryLazy",
      },

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
              pad_comment_parts = true,
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
              textobject = "gc",
            },

            -- Hook functions to be executed at certain stage of commenting
            hooks = {
              -- Before successful commenting. Does nothing by default.
              pre = function() end,
              -- After successful commenting. Does nothing by default.
              post = function() end,
            },
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
              line_up = "<M-k>",
            },

            -- Options which control moving behavior
            options = {
              -- Automatically reindent selection during linewise vertical move
              reindent_linewise = true,
            },
          }

          require("mini.splitjoin").setup()
        end,
      },

      {
        "niuiic/core.nvim",
        lazy = false,
      },

      -- lazy.nvim
      {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {},
        dependencies = {
          -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
          "MunifTanjim/nui.nvim",
          -- OPTIONAL:
          --   `nvim-notify` is only needed, if you want to use the notification view.
          --   If not available, we use `mini` as the fallback
          "rcarriga/nvim-notify",
        },
      },

      {
        "stevearc/dressing.nvim",
        lazy = false,
        opts = {},
      },

      {
        "axkirillov/hbac.nvim",
        config = true,
        lazy = false,
      },

      {
        "mfussenegger/nvim-dap",
        config = function()
          local dap = require "dap"
          dap.adapters.cppdbg = {
            id = "cppdbg",
            type = "executable",
            command = "C:\\Users\\manhp\\Downloads\\cpptools\\extension\\debugAdapters\\bin\\OpenDebugAD7.exe",
            options = {
              detached = false,
            },
          }
          local dap = require "dap"
          dap.configurations.cpp = {
            {
              name = "Launch file",
              type = "cppdbg",
              request = "launch",
              program = function()
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
              end,
              cwd = "${workspaceFolder}",
              stopAtEntry = true,
            },
            {
              name = "Attach to gdbserver :1234",
              type = "cppdbg",
              request = "launch",
              MIMode = "gdb",
              miDebuggerServerAddress = "localhost:1234",
              miDebuggerPath = "/usr/bin/gdb",
              cwd = "${workspaceFolder}",
              program = function()
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
              end,
            },
          }
        end,
        lazy = false,
      },

      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap" },
        lazy = false,
      },

      { -- This plugin
        "Zeioth/compiler.nvim",
        lazy = false,
        cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
        dependencies = { "stevearc/overseer.nvim" },
        opts = {},
      },

      { -- The task runner we use
        "stevearc/overseer.nvim",
        -- commit = "400e762648b70397d0d315e5acaf0ff3597f2d8b",
        cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
        opts = {
          task_list = {
            direction = "bottom",
            min_height = 25,
            max_height = 25,
            default_detail = 1,
          },
        },
      },

      {
        "nvim-lua/popup.nvim",
        lazy = false,
      },

      {
        "ray-x/guihua.lua",
        run = "cd lua/fzy && make",
        event = "VeryLazy",
      },

      {
        "smoka7/hop.nvim",
        lazy = false,
        version = "*",
        opts = {},
      },

      {
        "folke/flash.nvim",
        event = "VeryLazy",
        --@type Flash.Config
        opts = {},
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
      },

      {
        "pocco81/auto-save.nvim",
        event = "VeryLazy",
      },

      {
        "niuiic/format.nvim",
        event = "VeryLazy",
      },

      {
        "gelguy/wilder.nvim",
        lazy = false,
        config = function()
          require("wilder").setup {
            modes = { ":", "/", "?" },
          }
        end,
      },

      {
        "kawre/leetcode.nvim",
        build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
        dependencies = {
          "nvim-telescope/telescope.nvim",
          -- "ibhagwan/fzf-lua",
          "nvim-lua/plenary.nvim",
          "MunifTanjim/nui.nvim",
        },
        opts = {
          -- configuration goes here
          lang = python,
        },
      },
      {
        "roobert/surround-ui.nvim",
        lazy = false,
        dependencies = {
          "kylechui/nvim-surround",
          "folke/which-key.nvim",
        },
        config = function()
          require("surround-ui").setup {
            root_key = "S",
          }
        end,
      },

      {
        "piersolenski/wtf.nvim",
        lazy = false,
        dependencies = {
          "MunifTanjim/nui.nvim",
        },
        opts = {},
        keys = {
          {
            "gw",
            mode = { "n", "x" },
            function()
              require("wtf").ai()
            end,
            desc = "Debug diagnostic with AI",
          },
          {
            mode = { "n" },
            "gW",
            function()
              require("wtf").search()
            end,
            desc = "Search diagnostic with Google",
          },
        },
      },
      -- Install a plugin
      {
        "max397574/better-escape.nvim",
        event = "InsertEnter",
        config = function()
          require("better_escape").setup()
        end,
      },
    },
  },
}
