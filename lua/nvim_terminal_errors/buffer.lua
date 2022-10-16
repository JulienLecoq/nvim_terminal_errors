local M = {}

M.current_buffer = 0
M.first_line = 0
M.last_line = -1

function M.get_cursor_row_position()
    local linePos = vim.api.nvim_win_get_cursor(0)
    local row, _ = unpack(linePos)
    return row
end

return M
