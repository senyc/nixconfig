require 'catppuccin'.setup {
  flavour = 'macchiato',      -- latte, frappe, macchiato, mocha
  transparent_background = false,
  show_end_of_buffer = false, -- Don't show the '~' characters after the end of buffers
  term_colors = true,
  dim_inactive = {
    enabled = false,
    shade = 'dark',
    percentage = 0.15,
  },
  no_italic = true,    -- Force no italic
  no_bold = false,     -- Force no bold
  no_underline = true, -- Force no underline
  styles = {
    comments = {},
    conditionals = {},
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
  color_overrides = {},
  custom_highlights = {},
  integrations = {
    cmp = true,
    telescope = true,
    gitsigns = true,
    illuminate = true,
    treesitter = true,
    nvimtree = false,
    notify = false,
    mini = false,
    mason = false,
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = {},
        hints = {},
        warnings = {},
        information = {},
      },
      underlines = {
        errors = {},
        hints = {},
        warnings = {},
        information = {},
      },
      inlay_hints = {
        background = false,
      },
    },
  },
}
vim.cmd.colorscheme 'catppuccin'
-- These make the numbers much easier to see they use the colors here:
-- https://github.com/catppuccin/nvim/blob/main/lua/catppuccin/palettes/macchiato.lua
-- vim.cmd 'hi CursorLineNr guifg=#a6da95'
-- make line numbers a little easier to read
vim.cmd 'hi LineNr guifg=#a5adcb'
-- -- Change the virtual text color for git blame to make it a little easier to read
vim.cmd 'hi GitSignsCurrentLineBlame guifg=#6c7086'
