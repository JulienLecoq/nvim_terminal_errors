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

return M
