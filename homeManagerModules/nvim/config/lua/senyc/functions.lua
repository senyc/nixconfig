local utils = require 'senyc.utils'

local M = {}
function M.toggle_netrw()
  if vim.api.nvim_buf_get_option(0, 'filetype') ~= 'netrw' then
    vim.cmd.Ex()
  else
    vim.cmd.bdelete()
  end
end

--- Gets word under cursor and executes replacement
--- action across the entire project (based on root git dir)
function M.replace_word_in_project()
  -- Get word under cursor
  local current_word = vim.fn.expand '<cword>'
  if current_word == nil then
    vim.print 'Please place cursor on word to replace'
    return
  end

  local err, gitdir = utils.get_git_dir()
  if err then
    vim.print 'Not a git repository'
    return
  end

  -- Save current buffer as grep moves to most recent updated buffer
  local current_buf = vim.api.nvim_get_current_buf()

  vim.cmd('silent grep ' .. current_word .. ' ' .. gitdir)

  vim.ui.input({ prompt = 'replace ' .. current_word .. ' with: ' }, function(input)
    -- Test for <C-c>
    if input ~= nil and not input:find '\3' and not input:find '\x03' then
      pcall(function() vim.cmd('silent cdo ' .. 's/' .. current_word .. '/' .. input .. '/') end)
    end
  end)
  -- Return to original buffer
  vim.api.nvim_set_current_buf(current_buf)
end

function M.rename_current_file()
  local filename = vim.api.nvim_buf_get_name(0)
  local basename = filename:match('^.+/(.+)$')

  vim.ui.input({ prompt = 'replace ' .. basename .. ' with: ', default = basename }, function(input)
    -- Test for <C-c>
    if input ~= nil and not input:find "\3" and not input:find "\x03" then
      local newname = basename:gsub(basename, input)
      vim.cmd('file ' .. newname)
      vim.cmd.w()
      vim.cmd('silent !rm ' .. filename)
    end
  end)
end

function M.delete_current_file()
  local filename = vim.api.nvim_buf_get_name(0)
  local basename = filename:match('^.+/(.+)$')

  vim.ui.input({ prompt = 'delete ' .. basename .. '? ' }, function(input)
    -- Test for <C-c>
    if input == nil or input:find "\3" or input:find "\x03" then
      return
    end
    if input:lower():sub(1, 1) == 'y' then
      vim.cmd.w()
      vim.cmd('silent !rm ' .. '"' .. filename .. '"')
      vim.cmd.bdelete()
    end
  end)
end

return M
