return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  config = function()
    -- We should do more with this we really don't do that much here
    -- tj has a great video of this
    require 'nvim-treesitter.configs'.setup {
      ensure_installed = {
        'bash',
        'c',
        'lua',
        'vim',
        'vimdoc',
        'ruby',
        'javascript',
        'python'
      },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true
      }
    }
    vim.cmd 'silent TSUpdate'
  end
}
