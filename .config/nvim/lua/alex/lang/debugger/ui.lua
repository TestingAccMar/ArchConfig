require 'dapui' .setup {

  icons = {
      expanded = "",
      collapsed = "",
      current_frame = ""
  },
  mappings = {
    expand = {
        "<Tab>",
        "<2-LeftMouse>"
    },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- Use this to override mappings for specific elements
  element_mappings = {
    -- Example:
    -- stacks = {
    --   open = "<CR>",
    --   expand = "o",
    -- }
  },
  -- Expand lines larger than the window
  -- Requires >= 0.7
  expand_lines = vim.fn.has("nvim-0.7") == 1,
  -- Layouts define sections of the screen to place windows.
  -- The position can be "left", "right", "top" or "bottom".
  -- The size specifies the height/width depending on position. It can be an Int
  -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
  -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
  -- Elements are the elements shown in the layout (in order).
  -- Layouts are opened in order so that earlier layouts take priority in window sizing.
  layouts = {
    -- Vertical bar.
    {
        elements = {
            {
                id = "repl",
                size = 0.20,
            },
            {
                id = "watches",
                size = 0.65
            },
            {
                id = "console",
                size = 0.15
            }
        },
        size = 0.25,
        position = "right",
    },
    -- Horizontal bar.
    {
        elements = {
            "stacks"
        },
        size = 0.2,
        position = "bottom"
    },
  },
  controls = {
    enabled = true,
    element = "console",
    icons = {
      pause = "",
      play = "",
      step_into = "",
      step_over = "",
      step_out = "",
      step_back = "",
      run_last = "",
      terminate = "",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "rounded",
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = {
      indent = 1
  },
  render = {
    max_type_length = nil, -- Can be integer or nil.
    max_value_lines = 100, -- Can be integer or nil.
  }
}
