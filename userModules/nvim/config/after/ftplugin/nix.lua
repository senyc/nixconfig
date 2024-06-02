local map = require 'senyc.utils'.default_map
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

map('n', '<leader>=', ":w<cr>:silent !alejandra %<cr>")
-- vim.bo.commentstring = '# %s'
-- vim.bo.smartindent = false
-- vim.bo.cindent = false
