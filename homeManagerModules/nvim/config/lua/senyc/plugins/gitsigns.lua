return {
  'lewis6991/gitsigns.nvim',
  lazy = false,
  config = function()
    local options = { remap = false, silent = true }
    require 'gitsigns'.setup {
      signs = {
        add = { text = '│' },
        change = { text = '│' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      watch_gitdir = {
        follow_files = true
      },
      attach_to_untracked = true,
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 10,
        virt_text_priority = 10001, -- This allows diagnostics to be in front of blame
        ignore_whitespace = false,
      },
      current_line_blame_formatter = '<author> • <author_time:%m/%d/%Y> • <summary>',
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,
      max_file_length = 40000,
      preview_config = {
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
      },
      yadm = {
        enable = false
      },
    }
    -- jumps down to the next change
    vim.keymap.set('n', '<leader>jn', require 'gitsigns'.next_hunk, options)
    -- jumps up to the previous change
    vim.keymap.set('n', '<leader>jp', require 'gitsigns'.prev_hunk, options)
  end
}
