local utils = GRAAL.BG.Utils
local Ternary = GRAAL.Utils.Ternary
---
utils.GetCurrentTimeInBG =  function()
    local milliseconds = GetBattlefieldInstanceRunTime()
    if milliseconds == 0 then return { minutes= 0, seconds= 0 } end
    local totalSeconds = math.floor(milliseconds / 1000)
    local minutes = math.floor(totalSeconds / 60)
    local seconds = totalSeconds % 60
    return { minutes= minutes, seconds= seconds }
end

utils.GetTimeInBGString = function(beforeText,afterText)
    beforeText = beforeText or ''
    afterText = afterText or ''
    local time = utils.GetCurrentTimeInBG()
    local text = Ternary(time.minutes < 1, string.format("%01dsec", time.seconds), string.format("%01dmin", time.minutes))
    return beforeText .. text .. afterText
end