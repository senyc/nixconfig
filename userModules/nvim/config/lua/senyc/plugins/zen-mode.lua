return {
  'folke/zen-mode.nvim',
  keys = '<leader>zm',
  lazy = true,
  config = function()
    vim.keymap.set('n', '<leader>zm', function()
      -- Toggles virtual text
      vim.diagnostic.config({
        virtual_text = not vim.diagnostic.config().virtual_text
      })
      -- Toggles line blame
      require 'gitsigns'.toggle_current_line_blame()
      -- Toggles gitsigns
      require 'gitsigns'.toggle_signs()
      -- Clears bottom messages
      vim.cmd 'echo ""'

      require 'zen-mode'.setup {
        window = {
          width = 90,
          backdrop = 0.6
        },
      }

      require 'zen-mode'.toggle()
      vim.wo.wrap = false
      vim.wo.number = true
      -- Relative line number
      vim.wo.rnu = true
    end)
  end
}
