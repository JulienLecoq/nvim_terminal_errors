local build_row_mapper = require('nvim_terminal_errors.build_row.build_row_mapper')
local string_util = require('nvim_terminal_errors.string_util')

local M = {}

function M.has_error(row, projectType)
    projectType = projectType or build_row_mapper.defaultType
    return build_row_mapper.implementations[projectType].has_error(row)
end

function M.has_failed_build_statement(row, projectType)
    projectType = projectType or build_row_mapper.defaultType
    return build_row_mapper.implementations[projectType].has_failed_build_statement(row)
end

function M.has_successful_build_statement(row, projectType)
    projectType = projectType or build_row_mapper.defaultType
    return build_row_mapper.implementations[projectType].has_successful_build_statement(row)
end

function M.get_file_path(row)
    return string_util.split(row)[3]
end

function M.error_detail(row)
    local row_parts = string_util.split(row)

    local error_parts = {
        unpack(row_parts, 7)
    }
    local error_message = table.concat(error_parts, " ")

    local path = row_parts[3]
    local path_parts = string_util.split(path, ":")
    local relative_path = path_parts[1]

    return {
        file = {
            relative_path = relative_path,
            absolute_path = vim.fn.getcwd() .. "/" .. relative_path,
        },
        position = {
            line_number = tonumber(path_parts[2]),
            col_number = tonumber(path_parts[3])
        },
        message = error_message
    }
end

return M
