local COLORS, HONOR = GRAAL.Data.COLORS, GRAAL.Data.honor
local Get, Ternary = GRAAL.Utils.Get, GRAAL.Utils.Ternary
local Calendar = GRAAL.Calendar
local BuildTime, TimeSession = GRAAL.Utils.BuildTime, GRAAL.Utils.timeSession
local CreateText = GRAAL.Ui.CreateText
local BgBox, GetTimeInBGString = GRAAL.BG.Utils.BgBox, GRAAL.BG.Utils.GetTimeInBGString
local i18n = GRAAL.I18N.transform
---

local function GetHonorPerHour(timeSinceStartSession)
    local honorSession = HONOR.session * 60
    local minutesSinceStartSession = (timeSinceStartSession.hours * 60) + timeSinceStartSession.minutes
    return math.floor(honorSession / minutesSinceStartSession)
end

local function CreateHonorDuringGame()
    local honorDuring = CreateText({
        frameParent = BgBox(),
        font = "GameFontHighlight",
        point = { xf = "BOTTOMLEFT", yf = "BOTTOMLEFT", x = 15, y = 15 },
        color = COLORS.YELLOW_TITLE,
        text = i18n("Honor: {1}", HONOR.duringGame),
        hide = false
    })
    honorDuring:SetScript("OnEnter", function(self)
        local timeSinceStartSession = BuildTime(TimeSession())
        local honorPerHour = GetHonorPerHour(timeSinceStartSession)
        local honorWeek = Get("HonorFrameThisWeekContributionValue"):GetText()
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(i18n("Honor stats"), 1, 1, 1)
        GameTooltip:AddLine(i18n("Honor week: {1}", honorWeek), 0.8, 0.8, 0.8)
        GameTooltip:AddLine(i18n("Honor/h: {1}", honorPerHour), 0.8, 0.8, 0.8)
        GameTooltip:AddLine(i18n("Time since refresh: {1}", timeSinceStartSession.inText()), 0.8, 0.8, 0.8)
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
        text = i18n("Calendar")
    })
    pastTimer:SetScript("OnEnter", function(self)
        local currentEvent = Calendar.CurrentEvent()
        local eventFinishIn = Calendar.ResetPvpIn()
        local nextEvent = Calendar.NextEvent()
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(i18n("Calendar of Events"), 1, 1, 1)
        GameTooltip:AddLine(i18n("Current Event: {1}", Ternary(currentEvent, currentEvent, i18n("None"))), 0.8, 0.8, 0.8)
        GameTooltip:AddLine(i18n("Next Event: {1}", Ternary(nextEvent, nextEvent, i18n("None"))), 0.8, 0.8, 0.8)
        GameTooltip:AddLine(i18n("Reset PVP in {1}", eventFinishIn), 0.8, 0.8, 0.8)
        GameTooltip:Show()
    end)
    pastTimer:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    return pastTimer
end

local function UpdateHonorDuringGame(newHonor)
    HONOR.duringGame = newHonor
    BgBox().honorDuringGame:SetText(i18n("Honor: {1}", newHonor))
end

local function TimeInText(milliseconds)
    local totalSeconds = math.floor(milliseconds / 1000)
    local minutes = math.floor(totalSeconds / 60)
    local seconds = totalSeconds % 60
    return Ternary(
        minutes > 0,
        minutes .. ":" .. Ternary(seconds > 9, seconds, "0" .. seconds),
        seconds
    )
end

local queueTimer = nil
local elapsedQueueTimer = 0
local function GetQueueTimerFrame()
    if not queueTimer then
        queueTimer = CreateFrame("Frame", "QueueTimerFrame")
    end
    return queueTimer
end

local function UpdateTime(index)
    index = index or 0
    local bgBox = BgBox()
    if bgBox.currentIdBg and index == 0 then
        bgBox.timer:SetText(GetTimeInBGString())
    elseif index > 0 and GetQueueTimerFrame():GetScript("OnUpdate") == nil then
        GetQueueTimerFrame():SetScript("OnUpdate", function(self, elapsed)
            elapsedQueueTimer = elapsedQueueTimer + elapsed
            if elapsedQueueTimer >= 0.5 then
                if bgBox.instanceID == nil then
                    local waitedTime = TimeInText(GetBattlefieldTimeWaited(index))
                    local queueTime = TimeInText(GetBattlefieldEstimatedWaitTime(index))
                    bgBox.timer:SetText(waitedTime .. " (>=" .. queueTime .. ")")
                else
                    elapsedQueueTimer = 0
                    self:SetScript("OnUpdate", nil)
                end
            end
        end)
    elseif index == -1 then
        GetQueueTimerFrame():SetScript("OnUpdate", nil)
        bgBox.timer.UpdateText(i18n("Calendar"))
    end
end

GRAAL.BG.Part.CreateFooterPart = function()
    local bgBox = BgBox()
    bgBox.honorDuringGame = CreateHonorDuringGame()
    bgBox.timer = CreatePastTimer()
    bgBox.UpdateHonorDuringGame = UpdateHonorDuringGame
    bgBox.UpdateTime = UpdateTime
end
