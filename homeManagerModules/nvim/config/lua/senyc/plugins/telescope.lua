return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.4',
  dependencies = { 'nvim-lua/plenary.nvim' },
  lazy = false,
  config = function()
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
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            -- For now I would like to keep the default binding for this
            -- however, this does lead to it being impossible to scroll the preview
            -- up or down
            -- ["<C-n>"] = actions.preview_scrolling_up,
            -- ["<C-p>"] = actions.preview_scrolling_down,
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

    local function git_commits()
      if not pcall(builtin.git_commits) then
        vim.print 'Not in a git repository'
      end
    end

    local function git_buffer_commit_diff()
      if not pcall(builtin.git_bcommits) then
        vim.print 'Not in a git repository'
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

    -- Find file
    map('n', { '<leader>ff', '<c-g>' }, defaut_search)
    -- Find vim help
    map('n', '<leader>fh', builtin.help_tags)
    -- Find live git grep
    map('n', '<leader>fg', live_git_grep)
    -- Find commits in repo
    map('n', '<leader>fc', git_commits)
    -- Find man page entries
    map('n', '<leader>fm', builtin.man_pages)
    -- Find git buffer commit diff
    map('n', '<leader>fd', git_buffer_commit_diff)
    -- Find references
    map('n', '<leader>fr', builtin.lsp_references)
    -- Find buffer
    map('n', '<leader>fb', builtin.buffers)
    -- telescope resume
    map('n', '<leader>tr', builtin.resume)
    -- Find word
    map('n', '<leader>fw', grep_string)
    -- Find keymaps
    map('n', '<leader>fk', builtin.keymaps)
    -- Old files
    map('n', { '<leader>fo', '<leader>of' }, builtin.oldfiles)

    -- Adding default search lua command, user commands must start with capital letter
    vim.api.nvim_create_user_command('Search', function()
      pcall(defaut_search)
    end, {})
  end
}
