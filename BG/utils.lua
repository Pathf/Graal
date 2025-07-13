local utils = GRAAL.BG.Utils
local avData = GRAAL.BG.Data
local Ternary = GRAAL.Utils.Ternary
local Get = GRAAL.Utils.Get
---
utils.GetAvBox = function() return Get(avData.NAMEFRAME.AV.BOX) end
local GetAvBox = utils.GetAvBox

utils.GetCurrentTimeInBG = function()
    local milliseconds = GetBattlefieldInstanceRunTime()
    if milliseconds == 0 then return { minutes = 0, seconds = 0 } end
    local totalSeconds = math.floor(milliseconds / 1000)
    local minutes = math.floor(totalSeconds / 60)
    local seconds = totalSeconds % 60
    return { minutes = minutes, seconds = seconds }
end

utils.GetTimeInBGString = function(beforeText, afterText)
    beforeText = beforeText or ''
    afterText = afterText or ''
    local time = utils.GetCurrentTimeInBG()
    local text = Ternary(time.minutes < 1, string.format("%01dsec", time.seconds), string.format("%01dmin", time.minutes))
    return beforeText .. text .. afterText
end

utils.Reset = function()
    GetAvBox().Reset()
end

utils.HardReset = function()
    GetAvBox().HardReset()
end

utils.SetHonorGame = function(newHonor)
    newHonor = newHonor or 0
    GetAvBox().UpdateHonorDuringGame(newHonor)
end

utils.SetBgGame = function(index)
    GetAvBox().title:SetText("Alterac Valley " .. index)
end
