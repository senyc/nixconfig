return {
  'mhartington/formatter.nvim',
  cmd = 'Format',
  lazy = true,
  config = function()
    require 'formatter'.setup {
      logging = false,
      log_level = vim.log.levels.WARN,
      filetype = {
        python = {
          {
            exe = 'isort',
            args = {
              '-q',
              '-',
            },
            stdin = true,
          },
          {
            exe = 'black',
            args = {
              '-q',
              -- "--skip-string-normalization",
              '-',
              '--line-length 100',
            },
            stdin = true,
          },
          ['*'] = {
            require('formatter.filetypes.any').remove_trailing_whitespace
          }
        }
      }
    }
  end
}
