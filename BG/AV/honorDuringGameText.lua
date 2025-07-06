local AV = GRAAL.BG.AV

local HONOR = GRAAL.Data.honor
local CreateText = GRAAL.Ui.CreateText
local COLORS = GRAAL.Data.COLORS
local Ternary = GRAAL.Utils.Ternary
local Get = GRAAL.Utils.Get
local TimeSession = GRAAL.Utils.timeSession
local BuildTime = GRAAL.Utils.BuildTime
---

AV.CreateHonorDuringGame = function(frame)
    local honorDuring = CreateText({
        frameParent = frame,
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
