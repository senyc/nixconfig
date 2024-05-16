local map = require 'senyc.utils'.default_map
local utils = require 'senyc.utils'
local functions = require 'senyc.functions'

-- These are up to be on the chopping block
map('n', '<leader>bd', vim.cmd.bdelete)

-- Centralized navigation for search and <c-d/u>
map('n', '<C-d>', '<c-d>zz')
map('n', '<C-u>', '<c-u>zz')
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

-- Allow for easy empty line adjustments
map('n', 'go', 'o<Esc>')
map('n', 'gO', 'O<Esc>')

-- Y yanks to the end of the line
map('n', 'Y', 'y$')

-- Allow for visual mode to move lines
map('v', 'J', [[:m '>+1<cr>gv=gv]])
map('v', 'K', [[:m '<-2<CR>gv=gv]])

-- Adjustment of cursor location in J and inverse addition for <c-j>
map('n', '<C-j>', 'a<cr><Esc>')
map('n', 'J', 'mzJ`z')

-- System clipboard adjustments
map({ 'n', 'v' }, '<leader>Y', [["+y$]])
map({ 'n', 'v' }, '<leader>y', [["+y]])
map({ 'n', 'v' }, '<leader>P', [["+P]])
map({ 'n', 'v' }, '<leader>p', [["+p]])
map({ 'n', 'v' }, '<leader>d', [["+d]])

-- Deletion to the null buffer
map({ 'n', 'v' }, '<leader>x', [["_d]])

-- Rename word, performs local word replacement
-- map('n', '<leader>rw', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Similar to ZZ but saves all open buffers
map('n', 'ZA', vim.cmd.wqall)

-- QuickFix navigation
map('n', '<leader>,', ':cnext<cr>zz')
map('n', '<leader>;', ':cprev<cr>zz')

-- QuickFix close
map('n', '<leader>cc', vim.cmd.cclose)

-- QuickFix open
map('n', '<leader>co', vim.cmd.copen)

-- Netrw toggle (file explorer)
map('n', '<leader>fe', functions.toggle_netrw)

-- word replace
map({ 'n', 'v' }, '<leader>wr', functions.replace_word_in_project)

-- Renames the current file
map('n', '<leader>rn', functions.rename_current_file)

-- "Replaces" with delete (removes file)
map("n", "<leader>rd", functions.delete_current_file)

-- Copies buffer directory to system clipboard
map('n', '<leader>cy', function()
  local curr_dir = utils.get_formatted_path()
  vim.cmd('let @+ = "' .. curr_dir .. '"')
  vim.print("Copied " .. curr_dir .. " to clipboard")
end)
