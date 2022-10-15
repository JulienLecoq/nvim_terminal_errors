local angular = require('nvim_terminal_errors.errors_from.angular')
local table_util = require('nvim_terminal_errors.table_util')
local string_util = require('nvim_terminal_errors.string_util')
local buffer = require('nvim_terminal_errors.buffer')
local file = require('nvim_terminal_errors.file')

local M = {}

function M.setup()
    M.register()
end

function M.register()
    api.nvim_create_user_command("GoToPreviousErrorFile", M.go_to_previous_error, {})
    api.nvim_create_user_command("GoToNextErrorFile", M.go_to_next_error, {})

    -- api.nvim_create_user_command("Telescope ToggleList", M.toggle_all, {})
end

function M.toggle_types()
end

local managers = {
    [angular.type] = angular
}

local defaultType = angular.type
local noErrorFoundMsg = "No error found"

local function row_has_error(row, projectType)
    projectType = projectType or defaultType
    return managers[projectType].row_has_error(row)
end

local function has_failed_statement(row, projectType)
    projectType = projectType or defaultType
    return managers[projectType].has_failed_statement(row)
end

local function has_successful_statement(row, projectType)
    projectType = projectType or defaultType
    return managers[projectType].has_successful_statement(row)
end

local function is_successful_build()
    local content = vim.api.nvim_buf_get_lines(buffer.current_buffer, buffer.first_line, buffer.last_line, false)

    for _, row in table_util.rpairs(content) do
        if has_failed_statement(row) then
            return false
        end

        if has_successful_statement(row) then
            return true
        end
    end

    return true
end

local function get_build_last_failed_statement_row()
    local content = vim.api.nvim_buf_get_lines(buffer.current_buffer, buffer.first_line, buffer.last_line, false)

    for index, row in table_util.rpairs(content) do
        if has_failed_statement(row) then
            return index
        end
    end

    return nil
end

local function get_file_path(row)
    return string_util.split(row)[3]
end

local function go_to_previous_error_from_current_cursor_position(build_last_failed_statement_row)
    build_last_failed_statement_row = build_last_failed_statement_row or get_build_last_failed_statement_row()
    local lastLine = buffer.get_cursor_row_position() - 1
    local content = vim.api.nvim_buf_get_lines(buffer.current_buffer, build_last_failed_statement_row, lastLine, false)

    for _, row in table_util.rpairs(content) do
        if row_has_error(row) then
            file.open(get_file_path(row))
            return true
        end
    end

    return false
end

local function go_to_previous_error_from_last_buffer_line(build_last_failed_statement_row)
    build_last_failed_statement_row = build_last_failed_statement_row or get_build_last_failed_statement_row()
    local content = vim.api.nvim_buf_get_lines(buffer.current_buffer, build_last_failed_statement_row, buffer.last_line,
        false)

    for _, row in table_util.rpairs(content) do
        if row_has_error(row) then
            file.open(get_file_path(row))
            return true
        end
    end

    return false
end

function M.go_to_previous_error()
    if is_successful_build() then
        print(noErrorFoundMsg)
        return
    end

    local build_last_failed_statement_row = get_build_last_failed_statement_row()

    local hasFoundError1 = go_to_previous_error_from_current_cursor_position(build_last_failed_statement_row)
    if hasFoundError1 then
        return
    end

    local hasFoundError2 = go_to_previous_error_from_last_buffer_line(build_last_failed_statement_row)
    if not hasFoundError2 then
        print(noErrorFoundMsg)
    end
end

local function go_to_first_error_from_last_failed_statement()
    local failedStatementRowIndex = get_build_last_failed_statement_row()
    if failedStatementRowIndex == nil then
        return false
    end

    local content = vim.api.nvim_buf_get_lines(buffer.current_buffer, failedStatementRowIndex, buffer.last_line,
        false)

    for _, row in ipairs(content) do
        if row_has_error(row) then
            file.open(get_file_path(row))
            return true
        end
    end

    return false
end

local function go_to_first_error_from_current_cursor_position()
    local content = vim.api.nvim_buf_get_lines(0, buffer.get_cursor_row_position(), buffer.last_line, false)

    for _, row in ipairs(content) do
        if row_has_error(row) then
            file.open(get_file_path(row))
            return true
        end
    end

    return false
end

function M.go_to_next_error()
    if is_successful_build() then
        print(noErrorFoundMsg)
        return
    end

    local hasFoundError1 = go_to_first_error_from_current_cursor_position()
    if hasFoundError1 then
        return
    end

    local hasFoundError2 = go_to_first_error_from_last_failed_statement()
    if not hasFoundError2 then
        print(noErrorFoundMsg)
    end
end

return M
