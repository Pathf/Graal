local COLORS, HONOR = GRAAL.Data.COLORS, GRAAL.Data.honor
local Get, Ternary = GRAAL.Utils.Get, GRAAL.Utils.Ternary
local Calendar = GRAAL.Calendar
local BuildTime, TimeSession = GRAAL.Utils.BuildTime, GRAAL.Utils.timeSession
local CreateText = GRAAL.Ui.CreateText
local BgBox, GetTimeInBGString = GRAAL.BG.Utils.BgBox, GRAAL.BG.Utils.GetTimeInBGString
---

local function CreateHonorDuringGame()
    local honorDuring = CreateText({
        frameParent = BgBox(),
        font = "GameFontHighlight",
        point = { xf = "BOTTOMLEFT", yf = "BOTTOMLEFT", x = 15, y = 15 },
        color = COLORS.YELLOW_TITLE,
        text = "Honor: " .. HONOR.duringGame,
        hide = false
    })
    honorDuring:SetScript("OnEnter", function(self)
        local timeSinceStartSession = BuildTime(TimeSession())
        local honorPerHour = HONOR.session / Ternary(timeSinceStartSession.hours > 1, timeSinceStartSession.hours, 1)
        local honorWeek = Get("HonorFrameThisWeekContributionValue"):GetText()
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Honor stats", 1, 1, 1)
        GameTooltip:AddLine("Honor week: " .. honorWeek, 0.8, 0.8, 0.8)
        GameTooltip:AddLine("Honor/h: " .. honorPerHour, 0.8, 0.8, 0.8)
        GameTooltip:AddLine("Time since refresh: " .. timeSinceStartSession.inText(), 0.8, 0.8, 0.8)
        GameTooltip:Show()
    end)
    honorDuring:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    return honorDuring
end

local function CreatePastTimer()
    local pastTimer = CreateText({
        frameParent = BgBox(),
        font = "GameFontHighlight",
        point = { xf = "BOTTOMRIGHT", yf = "BOTTOMRIGHT", x = -10, y = 15 },
        color = COLORS.YELLOW_TITLE,
        hide = false,
        text = "Calendar"
    })
    pastTimer:SetScript("OnEnter", function(self)
        local currentEvent = Calendar.CurrentEvent()
        local eventFinishIn = Calendar.ResetPvpIn()
        local nextEvent = Calendar.NextEvent()
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Calendar of Events", 1, 1, 1)
        GameTooltip:AddLine("Current Event: " .. Ternary(currentEvent, currentEvent, "None"), 0.8, 0.8, 0.8)
        GameTooltip:AddLine("Reset PVP in " .. eventFinishIn, 0.8, 0.8,
            0.8)
        GameTooltip:AddLine("Next Event: " .. Ternary(nextEvent, nextEvent, "None"), 0.8, 0.8, 0.8)
        GameTooltip:Show()
    end)
    pastTimer:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    return pastTimer
end

local function UpdateHonorDuringGame(newHonor)
    HONOR.duringGame = newHonor
    BgBox().honorDuringGame:SetText("Honor: " .. newHonor)
end

local function UpdateTime()
    local bgBox = BgBox()
    if bgBox.currentIdBg then
        bgBox.timer:SetText(GetTimeInBGString())
    else
        bgBox.timer.UpdateText("Calendar")
    end
end

GRAAL.BG.Part.CreateFooterPart = function()
    local bgBox = BgBox()
    bgBox.honorDuringGame = CreateHonorDuringGame()
    bgBox.timer = CreatePastTimer()
    bgBox.UpdateHonorDuringGame = UpdateHonorDuringGame
    bgBox.UpdateTime = UpdateTime
end
