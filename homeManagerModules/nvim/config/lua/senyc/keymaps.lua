local map = require 'senyc.utils'.default_map
local utils = require 'senyc.utils'
local functions = require 'senyc.functions'

-- Exit insert mode
-- This allows <C-c> in visual block mode to work as expected
map("i", "<C-c>", "<Esc>")
-- Buffer deletion and traversal
map('n', '<leader>l', vim.cmd.bnext)
map('n', '<leader>h', vim.cmd.bprevious)
map('n', '<leader>bd', vim.cmd.bdelete)
map('n', '<leader>$', vim.cmd.blast)
map('n', '<leader>0', vim.cmd.bfirst)
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
map({ 'n', 'v' }, '<leader>Y', [["+Y]])
map({ 'n', 'v' }, '<leader>y', [["+y]])
map({ 'n', 'v' }, '<leader>P', [["+P]])
map({ 'n', 'v' }, '<leader>p', [["+p]])
-- Deletion to system clipboard
map({ 'n', 'v' }, '<leader>d', [["+d]])
-- Deletion to the null buffer
map({ 'n', 'v' }, '<leader>x', [["_d]])
-- Rename word, performs local word replacement
map('n', '<leader>rw', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- White space remove
map('n', '<leader>wr', [[m`:%s/\s\+$//e<cr>``]])
-- Similar to ZZ but saves all open buffers
map('n', 'ZA', vim.cmd.wqall)
-- Resize windows w/ arrows
map('n', '<Up>', ':resize -2<CR>')
map('n', '<Down>', ':resize +2<CR>')
map('n', '<Left>', ':vertical resize -2<CR>')
map('n', '<Right>', ':vertical resize +2<CR>')
-- Add space after cursor
map('n', 'gl', 'a <Esc>h')
-- QuickFix navigation
map('n', '<leader>,', ':cnext<cr>zz')
map('n', '<leader>;', ':cprev<cr>zz')
-- QuickFix close
map('n', '<leader>cc', vim.cmd.cclose)
-- QuickFix open
map('n', '<leader>co', vim.cmd.copen)
-- Netrw toggle (file explorer)
map('n', '<leader>fe', functions.toggle_netrw)
-- Netrw side window (view explorer)
map('n', '<leader>ve', functions.toggle_windowed_netrw)
-- global replace
map({ 'n', 'v' }, '<leader>gr', functions.replace_word_in_project)
-- Number toggle (toggles relative line numbers
map('n', '<leader>nt', function() vim.cmd "set invrelativenumber" end)
-- Renames the current file
map('n', '<leader>rn', functions.rename_current_file)
-- Tmux-sessionizer
map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- Show current directory in popup
map("n", "<leader>cd", functions.pwd_popup)
-- "Replaces" with delete (removes file)
map("n", "<leader>rd", functions.delete_current_file)
-- Pastes current word in " buffer to word, moves pasted over word to " buffer
map("n", "<leader>s", "viwP")
-- Pastes current word in " buffer to word, which then overwrites the " buffer
map("n", "<leader>S", "viwp")
-- Copies buffer directory to system clipboard
map('n', '<leader>cy', function()
  local curr_dir = utils.get_formatted_path()
  vim.cmd('let @+ = "' .. curr_dir .. '"')
  vim.print("Copied " .. curr_dir .. " to clipboard")
end)
