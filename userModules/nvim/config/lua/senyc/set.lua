vim.g.mapleader = ' '

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.spelllang = 'en_us'
vim.opt.spell = true

-- They allow for correct formatting of comments for some filetypes (doesn't treat them like
-- c preprocessor directives)
vim.cmd.autocmd 'FileType * set formatoptions-=cro'
vim.cmd.autocmd 'FileType * set cinkeys-=0#'
vim.cmd.autocmd 'FileType * set indentkeys-=0#'

-- This will replace the default eob (end of buffer) character to ' ' (from ~)
vim.opt.fillchars = { eob = ' ' }

-- Default tab sizing
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true -- tabs -> spaces

-- Auto change the current directory
vim.opt.autochdir = true

-- Smart(est) indentation
vim.opt.smartindent = false
vim.opt.cindent = true

vim.opt.termguicolors = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 50
vim.opt.autochdir = true
vim.opt.swapfile = false
vim.opt.backup = false

-- Use undo file for persistent state
vim.opt.history = 10000
vim.opt.undofile = true
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'

vim.opt.showmode = false -- No reason to show -- INSERT --
-- This allows for the gutter line number to be a different color
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'
vim.opt.wrap = false     -- Display lines as one long line
vim.opt.conceallevel = 0 -- So that `` is visible in markdown files
-- Setting grep command within vim to use ripgrep
-- allows for hidden files (like .dotfiles/**)
-- hides any .git/ files
vim.opt.grepprg = [[rg --hidden --iglob '!**/.git/**' --vimgrep]]
vim.opt.virtualedit = 'block' -- Allow cursor to move where there is no text in visual block mode
-- Netrw config
vim.g.netrw_banner = 0
-- Hide ../ and ./  and .git/ from entries
vim.g.netrw_list_hide = [[\.\./,\./,\.git/,__pycache__/]]
--[[
  noma: non-modifiable
  nomod: non-modified
  nu: line numbers
  bl: displays as a buffer (buflisted)
  nowrap: no word wrap
  ro: read only
--]]
vim.g.netrw_bufsettings = 'noma nomod nu bl nowrap ro'
-- 'p' opens in vertical window
vim.g.netrw_preview = 1
-- Human-readable file sizes
vim.g.netrw_sizestyle = "H"
-- Percent of new window size
vim.g.netrw_liststyle = '3'
