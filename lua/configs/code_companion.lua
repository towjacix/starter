require("codecompanion").setup({
  adapters = {
    anthropic = function()
      return require("codecompanion.adapters").extend("anthropic", {
        env = {
          api_key = os.getenv("ANTHROPIC_API_KEY")
        },
      })
    end,

    gemini = function ()
      return require("codecompanion.adapters").extend("gemini", {
        url = "https://generativelanguage.googleapis.com/v1beta/models/${model}:streamGenerateContent?alt=sse&key=${api_key}",
        env = {
          api_key =os.getenv("GEMINI_API_KEY"),
          model = "gemini-1.5-flash"
        }
      })
    end
  },

  strategies = {

    chat = {
      adapter = "gemini",
      roles = {
        llm = "CodeCompanion",
        user = "towjacix",
      }, 
    },

    inline = {
      adapter = "gemini",
    },
  },

  temperature = {
    order = 2,
    mapping = "parameters",
    type = "number",
    optional = true,
    default = 1,
    desc = "What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or top_p but not both.",
    validate = function(n)
      return n >= 0 and n <= 2, "Must be between 0 and 2"
    end,
  },

  display = {
    chat = {
      window = {
        layout = "float", -- float|vertical|horizontal|buffer
        border = "single",
        height = 0.8,
        width = 0.9,
        relative = "editor",
        opts = {
          breakindent = true,
          cursorcolumn = false,
          cursorline = false,
          foldcolumn = "0",
          linebreak = true,
          list = false,
          signcolumn = "no",
          spell = false,
          wrap = true,
        },
      },
     },

      intro_message = "Welcome to CodeCompanion ✨! Press ? for options",
      render_headers = false, -- Render headers in the chat buffer? Set this to false if you're using an exteral markdown formatting plugin
      separator = "─", -- The separator between the different messages in the chat buffer
      show_token_count = true, -- Show the token count for each response?
      start_in_insert_mode = false, -- Open the chat buffer in insert mode?
    

      ---@param tokens number
      ---@param adapter CodeCompanion.Adapter
      token_count = function(tokens, adapter) -- The function to display the token count
        return " (" .. tokens .. " tokens)"
      end,
    },
})
