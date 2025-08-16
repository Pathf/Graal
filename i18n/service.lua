-- Fonction utilitaire : remplace {1}, {2}, ... par les arguments
local function formatBraces(str, ...)
    local args = { ... }
    return (str:gsub("{(%d+)}", function(i)
        i = tonumber(i)
        return args[i] ~= nil and tostring(args[i]) or "{" .. i .. "}"
    end))
end

GRAAL.I18N.transform = function(key, ...)
    local text = GRAAL.I18N.Language[key] or key
    if select("#", ...) > 0 then
        return formatBraces(text, ...)
    end
    return text
end
