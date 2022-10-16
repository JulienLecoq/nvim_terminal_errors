local api = vim.api
local builds = require('nvim_terminal_errors.builds')
local table_util = require('nvim_terminal_errors.table_util')
local buffer = require('nvim_terminal_errors.buffer')
local file = require('nvim_terminal_errors.file')
local build_row = require('nvim_terminal_errors.build_row.build_row')
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local sorters = require "telescope.sorters"
local conf = require("telescope.config").values

local M = {}

function M.print_no_error_found()
    print("No error found")
end

function M.terminal_buffer_id()
    if buffer.is_terminal_buffer(buffer.current_buffer) then
        return buffer.current_buffer
    end

    for _, buffer_id in ipairs(vim.api.nvim_list_bufs()) do
        if buffer.is_terminal_buffer(buffer_id) then
            return buffer_id
        end
    end

    return nil
end

function M.go_to_previous_error_file_from_current_cursor_position(buffer_id, last_failed_statement_row)
    if buffer_id ~= buffer.current_buffer then
        return M.go_to_previous_error_file_from_last_buffer_line(buffer_id)
    end

    last_failed_statement_row = last_failed_statement_row or builds.last_failed_build_statement_row()
    if last_failed_statement_row == nil then
        return false
    end

    local last_line = buffer.get_cursor_row_position() - 1
    if last_line < last_failed_statement_row then
        return false
    end

    local content = api.nvim_buf_get_lines(buffer_id, last_failed_statement_row, last_line, false)

    for _, row in table_util.rpairs(content) do
        if build_row.has_error(row) then
            file.open_from(row)
            return true
        end
    end

    return false
end

function M.go_to_previous_error_file_from_last_buffer_line(buffer_id, last_failed_statement_row)
    last_failed_statement_row = last_failed_statement_row or builds.last_failed_build_statement_row(buffer_id)
    if last_failed_statement_row == nil then
        return false
    end

    local content = api.nvim_buf_get_lines(buffer_id, last_failed_statement_row, buffer.last_line,
        false)

    for _, row in table_util.rpairs(content) do
        if build_row.has_error(row) then
            file.open_from(row)
            return true
        end
    end

    return false
end

function M.go_to_next_error_file_from_last_failed_statement(buffer_id)
    local last_failed_statement_row = builds.last_failed_build_statement_row(buffer_id)
    if last_failed_statement_row == nil then
        return false
    end

    local content = api.nvim_buf_get_lines(buffer_id, last_failed_statement_row, buffer.last_line,
        false)

    for _, row in ipairs(content) do
        if build_row.has_error(row) then
            file.open_from(row)
            return true
        end
    end

    return false
end

function M.go_to_next_error_file_from_current_cursor_position(buffer_id)
    if buffer_id ~= buffer.current_buffer then
        return M.go_to_next_error_file_from_last_failed_statement(buffer_id)
    end

    local current_pos = buffer.get_cursor_row_position()
    if current_pos < builds.last_failed_build_statement_row() then
        return false
    end

    local content = api.nvim_buf_get_lines(buffer_id, buffer.get_cursor_row_position(), buffer.last_line,
        false)

    for _, row in ipairs(content) do
        if build_row.has_error(row) then
            file.open_from(row)
            return true
        end
    end

    return false
end

function M.get_list_of_errors(buffer_id, opts)
    if builds.is_last_build_successful(buffer_id) then
        return M.print_no_error_found()
    end

    local last_failed_statement_row = builds.last_failed_build_statement_row(buffer_id)
    if last_failed_statement_row == nil then
        return M.print_no_error_found()
    end

    local content = vim.api.nvim_buf_get_lines(buffer_id, last_failed_statement_row, buffer.last_line, false)
    local finderRes = {}

    for _, row in ipairs(content) do
        if build_row.has_error(row) then
            table.insert(finderRes, {
                build_row.error_detail(row)
            })
        end
    end

    if #finderRes == 0 then
        return M.print_no_error_found()
    end

    pickers.new(opts, {
        prompt_title = "Errors reported from terminal",
        finder = finders.new_table {
            results = finderRes,
            entry_maker = function(entry)
                error = entry[1]

                return {
                    value = entry,
                    display = string.format("%d:%d %s",
                        error.position.line_number,
                        error.position.col_number,
                        error.message
                    ),
                    ordinal = error.file.absolute_path,
                    path = error.file.absolute_path,
                    lnum = error.position.line_number
                }
            end
        },
        previewer = conf.qflist_previewer(opts),
        sorter = sorters.get_fuzzy_file(),
    }):find()
end

return M
