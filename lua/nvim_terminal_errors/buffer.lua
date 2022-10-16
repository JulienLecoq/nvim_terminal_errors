local string_util = require('nvim_terminal_errors.string_util')

local M = {}

M.current_buffer = 0
M.first_line = 0
M.last_line = -1

function M.get_cursor_row_position(buffer_id)
    local linePos = vim.api.nvim_win_get_cursor(buffer_id or M.current_buffer)
    local row, _ = unpack(linePos)
    return row
end

function M.is_terminal_buffer(buffer_id)
    local buffer_name = vim.api.nvim_buf_get_name(buffer_id or M.current_buffer)
    return string_util.startsWith(buffer_name, "term:")
end

return M
