return {
  'senyc/tailwind-sorter.nvim',
  lazy = true,
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-lua/plenary.nvim' },
  -- this is broken, could be a nix thing
  build = 'cd formatter && npm i && npm run build',
  ft = { 'html', 'js', 'javascriptreact', 'typescriptreact', 'astro', 'ts' },
  config = function()
    local map = require "senyc.utils".default_map
    require 'tailwind-sorter'.setup({
      on_save_enabled = false,
      node_path = 'node',
    })
    -- tailwind sort
    map("n", "<leader>ts", vim.cmd.TailwindSort)
  end
}
