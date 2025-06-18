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

utils.GetIconText = function(nameIcon, size)
    size = size or {w=16,h=16,x=0,y=0}
    return "|TInterface\\ICONS\\".. nameIcon ..":".. size.w ..":".. size.h ..":".. size.x ..":".. size.y .."|t"
end