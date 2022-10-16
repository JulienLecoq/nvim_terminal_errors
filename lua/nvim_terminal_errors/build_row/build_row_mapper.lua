-- local angular = require('nvim_terminal_errors.build_row.specific..angular')
local ionicAngular = require('nvim_terminal_errors.build_row.specific..angular')

local M = {}

local ionicAngularType = 0

M.defaultType = ionicAngularType

M.implementations = {
    [ionicAngularType] = ionicAngular
}

return M
