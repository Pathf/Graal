local utils = GRAAL.BG.Utils
local Ternary = GRAAL.Utils.Ternary
local honor = GRAAL.Data.honor
local Get = GRAAL.Utils.Get
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

utils.Reset = function()
    local frame = Get("BossBoxFrame")
    if frame then 
        frame:ClearAllPoints()
        frame:SetPoint("CENTER", UIParent, "TOPRIGHT", -10, -10) 
    end
    local reopenFrame = Get("ReopenAVB")
    if reopenFrame then 
        reopenFrame:ClearAllPoints()
        reopenFrame:SetPoint("CENTER", UIParent, "TOP", 0, -50) 
    end
end

utils.SetHonorGame = function(newHonor)
    newHonor = newHonor or 0
    honor.duringGame = newHonor
    Get("BossBoxFrame").honorDuringGame:SetText(honor.duringGame.." honor"..Ternary(honor.duringGame > 1, "s", ""))
end

utils.CalculateHonorPerHour = function(newHonor)
    honor.session = honor.session + newHonor
    local hourSinceStartSession = BuildTime(GetTime()*1000).hours
    local honorPerHour = honor.session / Ternary(hourSinceStartSession > 1, hourSinceStartSession, 1)
    Get("BossBoxFrame").honorPerHour:SetText("Honor/h: " .. honorPerHour)
end