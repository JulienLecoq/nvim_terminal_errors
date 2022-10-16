local string_util = require('nvim_terminal_errors.string_util')

local M = {}

function M.has_error(row)
    return string_util.startsWith(row, "[ng] Error:")
end

function M.has_failed_build_statement(row)
    return string_util.startsWith(row, "[ng] ✖ Failed to compile")
end

function M.has_successful_build_statement(row)
    return string_util.startsWith(row, "[ng] ✔ Compiled successfully")
end

return M
