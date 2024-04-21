return {
  'akinsho/bufferline.nvim',
  lazy = false,
  config = function()
    require 'bufferline'.setup {
      options = {
        mode = 'buffers',                    -- set to "tabs" to only show tabpages instead
        themable = false,                    -- allows highlight groups to be overriden i.e. sets highlights as default
        numbers = 'none',
        close_command = 'bdelete! %d',       -- can be a string | function, | false see "Mouse actions"
        right_mouse_command = 'bdelete! %d', -- can be a string | function | false, see "Mouse actions"
        left_mouse_command = 'buffer %d',    -- can be a string | function, | false see "Mouse actions"
        middle_mouse_command = nil,          -- can be a string | function, | false see "Mouse actions"
        buffer_close_icon = '',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        max_name_length = 18,
        max_prefix_length = 15,   -- prefix used when a buffer is de-duplicated
        truncate_names = true,    -- whether or not tab names should be truncated
        tab_size = 18,
        diagnostics = 'nvim_lsp', --| "nvim_lsp" | "coc",
        diagnostics_update_in_insert = false,
        -- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          return '(' .. count .. ')'
        end,
        custom_filter = function(buf_number, buf_numbers)
          -- filter out filetypes you don't want to see
          if vim.bo[buf_number].filetype ~= '<i-dont-want-to-see-this>' then
            return true
          end
          -- filter out by buffer name
          if vim.fn.bufname(buf_number) ~= '<buffer-name-I-dont-want>' then
            return true
          end
          -- filter out based on arbitrary rules
          -- e.g. filter out vim wiki buffer from tabline in your work repo
          if vim.fn.getcwd() == '<work-repo>' and vim.bo[buf_number].filetype ~= 'wiki' then
            return true
          end
          -- filter out by it's index number in list (don't show first buffer)
          if buf_numbers[1] ~= buf_number then
            return true
          end
        end,
        offsets = {
          {
            text_align = 'left',    --| "center" | "right"
            separator = false
          }
        },
        color_icons = true, -- whether or not to add the filetype icon highlights
        show_buffer_icons = false,
        show_buffer_close_icons = false,
        show_close_icon = false,
        show_tab_indicators = true,
        show_duplicate_prefix = false,
        persist_buffer_sort = false,    -- whether or not custom sorted buffers should persist
        separator_style = 'none',       --| "slope" | "thick" | "thin" | { 'any', 'any' },
        enforce_regular_tabs = false,   --| true,
        always_show_bufferline = false, --| false,
        hover = {
          enabled = true,
          delay = 200,
          reveal = { 'close' }
        },
        sort_by = 'id', --|'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
      }
    }
  end
}
