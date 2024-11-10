require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = "gemini",
    },
    inline = {
      adapter = "gemini",
    },
  },

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
          api_key = os.getenv("API_KEY"),
          model = "gemini-1.5-flash"
        }
      })
    end
  },

  opts = {
    ---@param adapter CodeCompanion.Adapter
    ---@return string
    system_prompt = function(opts)
      if opts.adapter.schema.model.default == "gemini-1.5-flash" then
        return "My custom system prompt"
      end
      return "My default system prompt"
    end
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
      render_headers = false,
    }
  }
})
