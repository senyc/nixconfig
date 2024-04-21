return {
  'laytan/tailwind-sorter.nvim',
  lazy = true,
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-lua/plenary.nvim' },
  build = 'cd formatter && npm i && npm run build',
  ft = { 'html', 'js', 'javascriptreact', 'typescriptreact', 'astro', 'ts' },
  config = function()
    require 'tailwind-sorter'.setup({

      on_save_enabled = true,
      -- The config.js pattern may lead to bugs
      on_save_pattern = { "!(*.config).js", '*.html', '*.jsx', '*.tsx', '*.astro', '*.html.erb'}, -- The file patterns to watch and sort.
      node_path = 'node',
    })
  end
}
