local api = vim.api
local builds = require('nvim_terminal_errors.builds')
local table_util = require('nvim_terminal_errors.table_util')
local buffer = require('nvim_terminal_errors.buffer')
local file = require('nvim_terminal_errors.file')
local build_row = require('nvim_terminal_errors.build_row.build_row')

local M = {}

function M.print_no_error_found()
    print("No error found")
end

function M.go_to_previous_error_file_from_current_cursor_position(last_failed_statement_row)
    last_failed_statement_row = last_failed_statement_row or builds.last_failed_build_statement_row()
    if last_failed_statement_row == nil then
        return false
    end

    local last_line = buffer.get_cursor_row_position() - 1
    if last_line < last_failed_statement_row then
        return false
    end

    local content = api.nvim_buf_get_lines(buffer.current_buffer, last_failed_statement_row, last_line, false)

    for _, row in table_util.rpairs(content) do
        if build_row.has_error(row) then
            file.open_from(row)
            return true
        end
    end

    return false
end

function M.go_to_previous_error_file_from_last_buffer_line(last_failed_statement_row)
    last_failed_statement_row = last_failed_statement_row or builds.last_failed_build_statement_row()
    if last_failed_statement_row == nil then
        return false
    end

    local content = api.nvim_buf_get_lines(buffer.current_buffer, last_failed_statement_row, buffer.last_line,
        false)

    for _, row in table_util.rpairs(content) do
        if build_row.has_error(row) then
            file.open_from(row)
            return true
        end
    end

    return false
end

function M.go_to_next_error_file_from_last_failed_statement()
    local last_failed_statement_row = builds.last_failed_build_statement_row()
    if last_failed_statement_row == nil then
        return false
    end

    local content = api.nvim_buf_get_lines(buffer.current_buffer, last_failed_statement_row, buffer.last_line,
        false)

    for _, row in ipairs(content) do
        if build_row.has_error(row) then
            file.open_from(row)
            return true
        end
    end

    return false
end

function M.go_to_next_error_file_from_current_cursor_position()
    local current_pos = buffer.get_cursor_row_position()
    if current_pos < builds.last_failed_build_statement_row() then
        return false
    end

    local content = api.nvim_buf_get_lines(buffer.current_buffer, buffer.get_cursor_row_position(), buffer.last_line,
        false)

    for _, row in ipairs(content) do
        if build_row.has_error(row) then
            file.open_from(row)
            return true
        end
    end

    return false
end

return M
