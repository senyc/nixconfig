local map = require 'senyc.utils'.default_map
local no_formatting = {
  'pyright',
  'nil_ls',
}

local function is_in_table(value, table)
  for _, val in pairs(table) do
    if val == value then
      return true
    end
  end
  return false
end
return function(client, bufnr)
  local opts = { buffer = bufnr, remap = false, silent = true }
  -- Inspect cursor token
  map('n', 'K', vim.lsp.buf.hover, opts)
  -- Get definition
  map('n', 'gd', vim.lsp.buf.definition, opts)
  -- Get declaration
  map('n', 'gD', vim.lsp.buf.declaration, opts)
  -- Get symbol
  map('n', '<leader>gs', vim.lsp.buf.workspace_symbol, opts)
  -- Diagnostic QuickFix
  map('n', '<leader>dq', vim.diagnostic.setqflist, opts)
  -- Diagnostic open
  map('n', '<leader>do', vim.diagnostic.open_float, opts)
  -- Diagnostic previous
  map('n', '<leader>dp', vim.diagnostic.goto_prev, opts)
  -- Diagnostic next
  map('n', '<leader>dn', vim.diagnostic.goto_next, opts)
  -- Code action
  map('n', '<leader>.', vim.lsp.buf.code_action, opts)
  -- Rename symbol
  map('n', '<leader>rs', vim.lsp.buf.rename, opts)
  -- Get references
  map('n', 'gr', vim.lsp.buf.references, opts)
  -- Get implementation
  map('n', '<leader>gi', vim.lsp.buf.implementation, opts)

  -- Format
  if (not is_in_table(client.name, no_formatting)) then
    map('n', '<leader>=', vim.lsp.buf.format, opts)
  end
end
