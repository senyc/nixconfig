return {
  'mbbill/undotree',
  keys = '<leader>u',
  lazy = true,
  config = function()
    vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
    -- Allow for focus to change to undo tree on toggle
    vim.g.undotree_SetFocusWhenToggle = 1
  end
}
