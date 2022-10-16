local buffer = require('nvim_terminal_errors.buffer')
local build_row = require('nvim_terminal_errors.build_row.build_row')
local table_util = require('nvim_terminal_errors.table_util')
local api = vim.api

local M = {}

function M.is_last_build_successful(buffer_id)
    local content = api.nvim_buf_get_lines(buffer_id, buffer.first_line, buffer.last_line, false)

    for _, row in table_util.rpairs(content) do
        if build_row.has_failed_build_statement(row) then
            return false
        end

        if build_row.has_successful_build_statement(row) then
            return true
        end
    end

    return true
end

function M.last_failed_build_statement_row(buffer_id)
    local content = api.nvim_buf_get_lines(buffer_id or buffer.current_buffer, buffer.first_line, buffer.last_line, false)

    for index, row in table_util.rpairs(content) do
        if build_row.has_failed_build_statement(row) then
            return index
        end
    end

    return nil
end

return M
