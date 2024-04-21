return {
  'RRethy/vim-illuminate',
  lazy = false,
  config = function()
    require 'illuminate'.configure({
      -- providers: provider used to get references in the buffer, ordered by priority
      providers = {
        'lsp',
        'treesitter',
      },
      delay = 50,
      filetype_overrides = {},
      -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
      filetypes_denylist = {
        'netrw',
        'TelescopePrompt',
      },
      filetypes_allowlist = {},
      modes_denylist = {},
      modes_allowlist = {},
      providers_regex_syntax_denylist = {},
      providers_regex_syntax_allowlist = {},
      -- under_cursor: whether or not to illuminate under the cursor
      under_cursor = true,
      large_file_cutoff = nil,
      large_file_overrides = nil,
      min_count_to_highlight = 1,
    })
  end
}
