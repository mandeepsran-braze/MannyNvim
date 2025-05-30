local icons = require 'icons'

local M = {}

local function is_ft(b, ft)
  return vim.bo[b].filetype == ft
end

local function custom_filter(buf, buf_nums)
  local logs = vim.tbl_filter(function(b)
    return is_ft(b, 'log')
  end, buf_nums or {})
  if vim.tbl_isempty(logs) then
    return true
  end
  local tab_num = vim.fn.tabpagenr()
  local last_tab = vim.fn.tabpagenr '$'
  local is_log = is_ft(buf, 'log')
  if last_tab == 1 then
    return true
  end
  -- only show log buffers in secondary tabs
  return (tab_num == last_tab and is_log) or (tab_num ~= last_tab and not is_log)
end

M.config = {
  on_config_done = nil,
  highlights = {
    buffer_selected = {
      bold = true,
      italic = true,
    },
  },
  options = {
    keymap = {
      normal_mode = {},
    },
    active = true,
    mode = 'buffers', -- set to "tabs" to only show tabpages instead
    numbers = 'none', -- can be "none" | "ordinal" | "buffer_id" | "both" | function
    close_command = function(bufnr) -- can be a string | function, see "Mouse actions"
      M.buf_kill('bd', bufnr, false)
    end,
    indicator = {
      icon = icons.ui.BoldLineLeft, -- this should be omitted if indicator style is not 'icon'
      style = 'icon', -- can also be 'underline'|'none',
    },
    buffer_close_icon = icons.ui.Close,
    modified_icon = icons.ui.Circle,
    close_icon = icons.ui.BoldClose,
    left_trunc_marker = icons.ui.ArrowCircleLeft,
    right_trunc_marker = icons.ui.ArrowCircleRight,
    --- name_formatter can be used to change the buffer's label in the bufferline.
    --- Please note some names can/will break the
    --- bufferline so use this at your discretion knowing that it has
    --- some limitations that will *NOT* be fixed.
    name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
      -- remove extension from markdown files for example
      if buf.name:match '%.md' then
        return vim.fn.fnamemodify(buf.name, ':t:r')
      end
    end,
    max_name_length = 18,
    max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
    truncate_names = true, -- whether or not tab names should be truncated
    tab_size = 18,
    diagnostics = 'nvim_lsp',
    diagnostics_update_in_insert = false,
    offsets = {
      {
        filetype = 'NvimTree',
        text = 'File Explorer',
        text_align = 'left',
        separator = true,
      },
      {
        filetype = 'lazy',
        text = 'Lazy',
        highlight = 'PanelHeading',
        padding = 1,
      },
    },
    persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
    -- NOTE: this will be called a lot so don't do any heavy processing here
    custom_filter = custom_filter,
    color_icons = true, -- whether or not to add the filetype icon highlights
    -- can also be a table containing 2 custom separators
    -- [focused and unfocused]. eg: { '|', '|' }
    separator_style = 'thin',
    enforce_regular_tabs = false,
    always_show_bufferline = false,
    hover = {
      enabled = true, -- requires nvim 0.8+
      delay = 200,
      reveal = { 'close' },
    },
    themable = true,
    sort_by = 'id',
  },
}

M.setup = function()
  require('bufferline').setup(M.config)

  -- Register keys
  vim.keymap.set('n', '<S-h>', '<cmd>BufferLineCyclePrev<CR>')
  vim.keymap.set('n', '<S-l>', '<cmd>BufferLineCycleNext<CR>')
end

-- Common kill function for bdelete and bwipeout
-- credits: based on bbye and nvim-bufdel
---@param kill_command? string defaults to "bd"
---@param bufnr? number defaults to the current buffer
---@param force? boolean defaults to false
function M.buf_kill(kill_command, bufnr, force)
  kill_command = kill_command or 'bd'

  local bo = vim.bo
  local api = vim.api
  local fmt = string.format
  local fnamemodify = vim.fn.fnamemodify

  if bufnr == 0 or bufnr == nil then
    bufnr = api.nvim_get_current_buf()
  end

  local bufname = api.nvim_buf_get_name(bufnr)

  if not force then
    local warning
    if bo[bufnr].modified then
      warning = fmt([[No write since last change for (%s)]], fnamemodify(bufname, ':t'))
    elseif api.nvim_buf_get_option(bufnr, 'buftype') == 'terminal' then
      warning = fmt([[Terminal %s will be killed]], bufname)
    end
    if warning then
      vim.ui.input({
        prompt = string.format([[%s. Close it anyway? [y]es or [n]o (default: no): ]], warning),
      }, function(choice)
        if choice ~= nil and choice:match 'ye?s?' then
          M.buf_kill(kill_command, bufnr, true)
        end
      end)
      return
    end
  end

  -- Get list of windows IDs with the buffer to close
  local windows = vim.tbl_filter(function(win)
    return api.nvim_win_get_buf(win) == bufnr
  end, api.nvim_list_wins())

  if force then
    kill_command = kill_command .. '!'
  end

  -- Get list of active buffers
  local buffers = vim.tbl_filter(function(buf)
    return api.nvim_buf_is_valid(buf) and bo[buf].buflisted
  end, api.nvim_list_bufs())

  -- If there is only one buffer (which has to be the current one), vim will
  -- create a new buffer on :bd.
  -- For more than one buffer, pick the previous buffer (wrapping around if necessary)
  if #buffers > 1 and #windows > 0 then
    for i, v in ipairs(buffers) do
      if v == bufnr then
        local prev_buf_idx = i == 1 and #buffers or (i - 1)
        local prev_buffer = buffers[prev_buf_idx]
        for _, win in ipairs(windows) do
          api.nvim_win_set_buf(win, prev_buffer)
        end
      end
    end
  end

  -- Check if buffer still exists, to ensure the target buffer wasn't killed
  -- due to options like bufhidden=wipe.
  if api.nvim_buf_is_valid(bufnr) and bo[bufnr].buflisted then
    vim.cmd(string.format('%s %d', kill_command, bufnr))
  end
end

return M

-- vim: ts=2 sts=2 sw=2 et
