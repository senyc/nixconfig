return {
  'numToStr/Comment.nvim',
  keys = { 'gc', { 'gc', mode = 'v' } },
  lazy = true,
  config = function()
    require 'Comment'.setup()
  end
}
