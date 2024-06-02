return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  config = function()
    require 'nvim-treesitter.configs'.setup {
      sync_install = false,
      auto_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true
      }
    }
  end
}
