local builds = require('nvim_terminal_errors.builds')
local errors = require('nvim_terminal_errors.errors')
local api = vim.api

local M = {}

function M.setup()
    api.nvim_create_user_command("GoToPreviousErrorFileFromTerminal", M.go_to_previous_error_file, {})
    api.nvim_create_user_command("GoToNextErrorFileFromTerminal", M.go_to_next_error_file, {})
    api.nvim_create_user_command("ListErrorsFromTerminal", M.list_errors, {})
end

function M.go_to_next_error_file()
    local buffer_id = errors.terminal_buffer_id()

    if buffer_id == nil then
        return errors.print_no_error_found()
    end

    if builds.is_last_build_successful(buffer_id) then
        return errors.print_no_error_found()
    end

    local hasFoundError1 = errors.go_to_next_error_file_from_current_cursor_position(buffer_id)
    if hasFoundError1 then
        return
    end

    local hasFoundError2 = errors.go_to_next_error_file_from_last_failed_statement(buffer_id)
    if not hasFoundError2 then
        errors.print_no_error_found()
    end
end

function M.go_to_previous_error_file()
    local buffer_id = errors.terminal_buffer_id()

    if buffer_id == nil then
        return errors.print_no_error_found()
    end

    if builds.is_last_build_successful(buffer_id) then
        return errors.print_no_error_found()
    end

    local last_failed_statement_row = builds.last_failed_build_statement_row(buffer_id)

    local hasFoundError1 = errors.go_to_previous_error_file_from_current_cursor_position(buffer_id,
        last_failed_statement_row)
    if hasFoundError1 then
        return
    end

    local hasFoundError2 = errors.go_to_previous_error_file_from_last_buffer_line(buffer_id, last_failed_statement_row)
    if not hasFoundError2 then
        errors.print_no_error_found()
    end
end

function M.list_errors(opts)
    local buffer_id = errors.terminal_buffer_id()

    if buffer_id == nil then
        return errors.print_no_error_found()
    end

    errors.get_list_of_errors(buffer_id, opts or {})
end

return M
