require("mini.comment").setup({
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
})

require("mini.move").setup({
  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
    left = '<M-h>',
    right = '<M-l>',
    down = '<M-j>',
    up = '<M-k>',

    -- Move current line in Normal mode
    line_left = '<S-M-h>',
    line_right = '<S-M-l>',
    line_down = '<S-M-j>',
    line_up = '<S-M-k>',
  },

  -- Options which control moving behavior
  options = {
    -- Automatically reindent selection during linewise vertical move
    reindent_linewise = true,
  },
})

require('mini.git').setup()
