local builds = require('nvim_terminal_errors.builds')
local errors = require('nvim_terminal_errors.errors')
local api = vim.api

local M = {}

function M.setup()
    api.nvim_create_user_command("GoToPreviousErrorFile", M.go_to_previous_error_file, {})
    api.nvim_create_user_command("GoToNextErrorFile", M.go_to_next_error_file, {})

    -- api.nvim_create_user_command("Telescope ToggleList", M.toggle_all, {})
end

function M.go_to_next_error_file()
    if builds.is_last_build_successful() then
        return errors.print_no_error_found()
    end

    local hasFoundError1 = errors.go_to_next_error_file_from_current_cursor_position()
    if hasFoundError1 then
        return
    end

    local hasFoundError2 = errors.go_to_next_error_file_from_last_failed_statement()
    if not hasFoundError2 then
        errors.print_no_error_found()
    end
end

function M.go_to_previous_error_file()
    if builds.is_last_build_successful() then
        return errors.print_no_error_found()
    end

    local last_failed_statement_row = builds.last_failed_build_statement_row()

    local hasFoundError1 = errors.go_to_previous_error_file_from_current_cursor_position(last_failed_statement_row)
    if hasFoundError1 then
        return
    end

    local hasFoundError2 = errors.go_to_previous_error_file_from_last_buffer_line(last_failed_statement_row)
    if not hasFoundError2 then
        errors.print_no_error_found()
    end
end

return M
