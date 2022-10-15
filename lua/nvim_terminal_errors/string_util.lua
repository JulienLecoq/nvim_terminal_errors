local M = {}

function M.startsWith(text, prefix)
    return text:find(prefix, 1, true) == 1
end

function M.split(text, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(text, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

return M
