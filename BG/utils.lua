local utils = GRAAL.BG.Utils
local bgData = GRAAL.BG.Data
local Ternary = GRAAL.Utils.Ternary
local Get = GRAAL.Utils.Get
local BATTLEFIELD = GRAAL.BG.Data.BATTLEFIELD
---

local bgBoxIntern
utils.BgBox = function()
    if not bgBoxIntern then bgBoxIntern = Get(bgData.NAMEFRAME.BG.BOX) end
    return bgBoxIntern
end
local GetBgBox = utils.BgBox

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

utils.HardReset = function()
    GetBgBox().HardReset()
end

utils.SetHonorGame = function(newHonor)
    newHonor = newHonor or 0
    GetBgBox().UpdateHonorDuringGame(newHonor)
end

local function GetBattleGround(mapName)
    if mapName == BATTLEFIELD.WG.frName then return BATTLEFIELD.WG.id end
    if mapName == BATTLEFIELD.AB.frName then return BATTLEFIELD.AB.id end
    if mapName == BATTLEFIELD.AV.frName then return BATTLEFIELD.AV.id end
end

utils.SetBgGame = function(index, mapName)
    GetBgBox().ShowBody(index, GetBattleGround(mapName))
end
