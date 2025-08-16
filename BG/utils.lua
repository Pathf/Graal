local utils = GRAAL.BG.Utils
local bgData = GRAAL.BG.Data
local Ternary = GRAAL.Utils.Ternary
local Get = GRAAL.Utils.Get
local BATTLEFIELD = GRAAL.BG.Data.BATTLEFIELD
local i18n = GRAAL.I18N.transform
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

utils.GetTimeInBGString = function()
    local time = utils.GetCurrentTimeInBG()
    local beforeText = ""
    if time.minutes < 2 or (time.minutes == 2 and time.seconds < 4) then
        local secondesBeforeStart = 123 - (time.minutes * 60 + time.seconds)
        time.minutes = math.floor(secondesBeforeStart / 60)
        time.seconds = secondesBeforeStart % 60
        beforeText = i18n("Start in ")
    end
    return beforeText .. Ternary(
        time.minutes > 0,
        time.minutes .. ":" .. Ternary(time.seconds > 9, time.seconds, "0" .. time.seconds),
        time.seconds
    )
end

utils.HardReset = function()
    GetBgBox().HardReset()
end

utils.SetHonorGame = function(newHonor)
    newHonor = newHonor or 0
    GetBgBox().UpdateHonorDuringGame(newHonor)
end

local function GetBattleGround(mapName)
    if mapName == BATTLEFIELD.WG.name then return BATTLEFIELD.WG.id end
    if mapName == BATTLEFIELD.AB.name then return BATTLEFIELD.AB.id end
    if mapName == BATTLEFIELD.AV.name then return BATTLEFIELD.AV.id end
end

utils.SetBgGame = function(index, mapName)
    GetBgBox().ShowBody(index, GetBattleGround(mapName))
end
