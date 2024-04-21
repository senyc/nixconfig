return {
  'williamboman/mason.nvim',
  lazy = false,
  config = function()
    require 'mason'.setup {
      ui = {
        border = 'rounded'
      }
    }
    -- This doesn't really need to be called all the time
    --   vim.cmd 'silent MasonUpdate'
  end,
}
