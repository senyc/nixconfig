local lspconfig = require 'lspconfig'
local cmp = require 'cmp_nvim_lsp'

local servers = {
  'bashls',
  'tailwindcss',
  'clangd',
  'lua_ls',
  'pyright',
  'tsserver',
  'yamlls',
  'gopls',
  'cssls',
  'nil_ls'
}

for _, server in ipairs(servers) do
  local config = {
    -- on_attach contains all lsp-specific key mappings
    on_attach = require 'senyc.lspsettings.on_attach',
    capabilities = cmp.default_capabilities(),
  }

  local ok, settings = pcall(require, 'senyc.lspsettings.' .. server)
  if ok then
    -- Config in file will override local initial config
    config = vim.tbl_deep_extend('keep', settings, config)
  end
  lspconfig[server].setup(config)
end

vim.diagnostic.config {
  virtual_text = {
    spacing = 2,
  },
  virtual_lines = true,
  signs = true,
  update_in_insert = true,
  underline = false,
  severity_sort = true,
  float = {
    focusable = true,
    style = 'minimal',
    border = 'rounded',
    header = '',
    prefix = '',
    suffix = '',
  },
}

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
require 'lspconfig.ui.windows'.default_options.border = 'rounded'

for type, icon in pairs({
  Error = '>>',
  Warn = '->',
  Hint = '>-',
  Info = '--'
}) do
  local name = 'DiagnosticSign' .. type
  local mapping = { text = icon, texthl = name, numhl = '' }
  vim.fn.sign_define(name, mapping)
end
