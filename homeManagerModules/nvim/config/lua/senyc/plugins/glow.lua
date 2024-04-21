return {
  'ellisonleao/glow.nvim',
  cmd = 'Glow',
  lazy = true,
  config = function()
    require 'glow'.setup {
      style = 'dark',
      pager = false, -- This is broken
      border = 'rounded',
      width_ratio = 0.8,
      height_ratio = 0.8,
      width = 210,
    }
  end
}
