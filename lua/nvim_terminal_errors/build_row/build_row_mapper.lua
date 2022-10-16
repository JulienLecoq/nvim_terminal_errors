local angular = require('nvim_terminal_errors.build_row.specific..angular')

local M = {}

local angularType = 0

M.defaultType = angularType

M.implementations = {
    [angularType] = angular
}

return M
