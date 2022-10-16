local build_row = require('nvim_terminal_errors.build_row.build_row')

local M = {}

function M.open(filePath)
    vim.cmd(":e " .. filePath)
end

function M.open_from(row)
    M.open(build_row.get_file_path(row))
end

return M
