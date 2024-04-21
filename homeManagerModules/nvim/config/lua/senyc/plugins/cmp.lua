return {
  'hrsh7th/nvim-cmp',
  dependencies = { 'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-path',
    'rafamadriz/friendly-snippets',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
  },
  lazy = false,
  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    require 'luasnip.loaders.from_vscode'.lazy_load()

    -- `/` cmdline setup.
    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-space>'] = cmp.mapping.confirm {
          -- behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ['<CR>'] = cmp.mapping.confirm {
          select = false, -- On new line doesn't prefill first item
        },
        ['<S-CR>'] = cmp.mapping.confirm {
          select = true,
        },
        ['<tab>'] = cmp.mapping.confirm {
          select = true,
        },
        ['<C-j>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<C-k>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'buffer' } -- Only for current buffer
      },
    }
  end
}
