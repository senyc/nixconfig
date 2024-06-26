local M = {}

--- Returns the base git directory from `CWD` else return error code
--- in string format
---
---@return string? err_msg
---@return string? git_dir
function M.get_git_dir()
  local handler = io.popen 'git rev-parse --show-toplevel 2>/dev/null'
  if not handler then
    return "Failed to execute 'git'", nil
  end

  local result = handler:read('*l')
  -- Because stderr redirected to null assumes any stdout response due to validity of call
  if result then
    return nil, result
  end
  return 'No valid return file', nil
end

function M.get_git_branch()
  local handler = io.popen 'git branch --show-current 2>/dev/null'
  if not handler then
    return "n/a"
  end
  local result = handler:read('*l')
  -- Because stderr redirected to null assumes any stdout response due to validity of call
  if result then
    return result
  end
  return "n/a"
end

--- If no `options` are given, then precedes with default (noreamp and silent) for the given keymaps/actions.
---
--- If given a table of `lhs` then the `rhs` will be applied to all possible inputs
---
---@param mode table|string
---@param lhs table|string
---@param rhs string|function
---@param options? table
function M.default_map(mode, lhs, rhs, options)
  local default_options = { noremap = true, silent = true }
  if options ~= nil then
    options = default_options
  end

  if type(lhs) == 'string' then
    vim.keymap.set(mode, lhs, rhs, options)
  elseif type(lhs) == 'table' then
    for _, possible_input in pairs(lhs) do
      vim.keymap.set(mode, possible_input, rhs, options)
    end
  end
end

--- Gets the buffer directory with properly substititued tilde for $HOME directory
--- This may fail in certain buffers (where nvim_buf_get_name fails)
---
---@return string
function M.get_formatted_path()
  local home_dir = os.getenv("HOME") or os.getenv("USERPROFILE") or ""
  local result = vim.api.nvim_buf_get_name(0)
  if home_dir ~= "" then
    result = result:gsub(home_dir, "~")
  end
  return result
end

return M
