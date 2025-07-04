local utils = GRAAL.Utils
---

utils.Get = function(variable) return _G[variable] end

utils.TableSize = function(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

utils.Ternary = function(condition, trueResult, falseResult)
    if condition then return trueResult end
    return falseResult
end

utils.Logger = function(message) print("<Graal> "..message) end
--Logger = utils.Logger

utils.GetIcon = function(nameIcon, format, size)
    size = size or {w=16,h=16,x=0,y=0}
    format = format or 'texture'
    if format == 'text' then return "|TInterface\\ICONS\\".. nameIcon ..":".. size.w ..":".. size.h ..":".. size.x ..":".. size.y .."|t" end
    return "Interface\\ICONS\\".. nameIcon
end

utils.GetTargetingFrame = function(nameTargetingFrame)
    return "Interface\\TARGETINGFRAME\\".. nameTargetingFrame
end

utils.EscapePattern = function(s)
    return s:gsub("([%%%^%$%(%)%.%[%]%*%+%-%?])", "%%%1")
end

utils.GetTime =  function(milliseconds)
    if milliseconds == 0 then return { minutes= 0, seconds= 0 } end
    local totalSeconds = math.floor(milliseconds / 1000)
    local minutes = math.floor(totalSeconds / 60)
    local seconds = totalSeconds % 60
    return { minutes= minutes, seconds= seconds }
end