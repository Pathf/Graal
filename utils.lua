local utils = GRAAL.Utils
local SAVED = GRAAL.Data.saved
---

utils.Get = function(variable) return _G[variable] end

utils.GetElementInTalbe = function(property, value, table)
    for _, elements in ipairs(table) do
        if elements[property] == value then return element end
    end
    return nil
end

utils.TableSize = function(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

utils.Ternary = function(condition, trueResult, falseResult)
    if condition then return trueResult end
    return falseResult
end
local Ternary = utils.Ternary

utils.Logger = function(...)
    local message = "<Graal> "
    for _, element in ipairs{...} do
        message = message .. element
    end
    print(message) 
end
if ENV and ENV == "local" then Logger = utils.Logger end

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

utils.BuildTime =  function(milliseconds)
    if milliseconds == 0 then return { minutes= 0, seconds= 0 } end
    local totalSeconds = math.floor(milliseconds / 1000)
    local hours = math.floor(totalSeconds / 3600)
    local minutes = math.floor((totalSeconds % 3600) / 60)
    local seconds = totalSeconds % 60
    return {
        hours=hours, 
        minutes=minutes, 
        seconds=seconds, 
        inText=function() return Ternary(hours > 9,hours, "0"..hours) ..":".. Ternary(minutes > 9,minutes, "0"..minutes) ..":".. Ternary(seconds > 9,seconds, "0"..seconds) end
    }
end

utils.timeSession = function() return math.floor((GetTime() - GRAAL.Data.timeSinceCreatePlayer)*1000) end -- since refresh or connection

utils.ResetData = function()
  SAVED = {}
  AVBossTrackerSaved = {}
end