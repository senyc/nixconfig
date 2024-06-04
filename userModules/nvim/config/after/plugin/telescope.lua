local builtin = require 'telescope.builtin'
local utils = require 'telescope.utils'
local actions = require 'telescope.actions'

local get_git_dir = require 'senyc.utils'.get_git_dir
local map = require 'senyc.utils'.default_map

require 'telescope'.setup {
  defaults = {
    file_ignore_patterns = {
      '^.git/',
      'node_modules/'
    },
    vimgrep_arguments = {
      'rg',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
    },
    mappings = {
      i = {
        ['ZZ'] = actions.close,
        -- This only works because the default function of esc is to exit insert mode
        ["<C-c>"] = { "<esc>", type = "command" },
        ['<esc>'] = actions.close,
      },
      n = {
        ['ZZ'] = actions.close,
      },
    },
  }
}

-- Searches for files available in the repository including ones that are not being tracked
local function defaut_search()
  local err, gitdir = get_git_dir()
  if err then
    builtin.fd { cwd = utils.buffer_dir(), hidden = true }
  else
    builtin.fd { cwd = gitdir, hidden = true }
  end
end

local function live_git_grep()
  local err, gitdir = get_git_dir()
  if err then
    builtin.live_grep { cwd = utils.buffer_dir(), hidden = true }
  else
    builtin.live_grep { cwd = gitdir, hidden = true }
  end
end

local function grep_string()
  local err, gitdir = get_git_dir()
  if err then
    builtin.grep_string { cwd = utils.buffer_dir(), hidden = true }
  else
    builtin.grep_string { cwd = gitdir, hidden = true }
  end
end

local function quickfix_find()
  vim.cmd.cclose()
  builtin.quickfix()
end

-- Search
map('n', '<leader>s', defaut_search)
-- Find live git grep
map('n', '<leader>g', live_git_grep)
-- telescope resume
map('n', '<leader>tr', builtin.resume)
-- quickfix find
map('n', '<leader>cf', quickfix_find)
-- Find word
map('n', '<leader>fg', grep_string)
-- Old files
map('n', '<leader>of', builtin.oldfiles)

-- Adding default search lua command, user commands must start with capital letter
vim.api.nvim_create_user_command('Search', function()
  pcall(defaut_search)
end, {})
