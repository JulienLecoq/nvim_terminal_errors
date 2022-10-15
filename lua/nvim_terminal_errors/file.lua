local M = {}

function M.open(filePath)
    vim.cmd(":e " .. filePath)
end

return M
