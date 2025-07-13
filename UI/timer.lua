--local configTimerExample = {
--    icon= GRAAL.Data.ICONS.HUMAN.M, -- or GRAAL.Data.POIIcon.MINE -- *
--    id= "b1", -- *
--    text="text",
--    isPoi= true,
--    point= { xf= "CENTER", yf= "TOP", x= 0, y= 0 },
--    name= "ExampleTimer",
--    frameParent= UIParent,
--    size= { w= 20, h= 20 }
--}

local Ternary = GRAAL.Utils.Ternary
local BARTYPE = GRAAL.Data.BARTYPE
--

GRAAL.Ui.CreateTimer = function(config)
    config.frameParent = config.frameParent or UIParent
    config.time = config.time or 300
    config.point = config.point or { xf = "TOPRIGHT", yf = "TOPRIGHT", x = 0, y = 0 }
    config.size = config.size or { w = 162, h = 18 }
    config.isPoi = config.isPoi or false

    local frame = CreateFrame("Frame", config.id .. "timer", config.frameParent)
    frame:SetSize(config.size.w, config.size.h)
    frame:SetPoint(config.point.xf, config.frameParent, config.point.yf, config.point.x, config.point.y)
    frame.name = config.id
    frame.type = BARTYPE.TIMER
    frame.icon = GRAAL.Ui.CreateIcon({
        frameParent = frame,
        isPoi = config.isPoi,
        point = { xf = "LEFT", yf = "LEFT", x = 0, y = 0 },
        icon =
            config.icon,
        size = { w = 15, h = 15 }
    })
    frame.cooldownText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.cooldownText:SetFont("Fonts\\FRIZQT__.TTF", 10)
    frame.cooldownText:SetPoint("LEFT", frame, "LEFT", 15, 0)

    frame.runTimer = function()
        frame:Show()
        frame.duration = config.time
        frame.startTime = GetTime()

        frame:SetScript("OnUpdate", function(self)
            local remaining = frame.startTime + frame.duration - GetTime()
            if remaining > 0 then
                local time = GRAAL.Utils.BuildTime(remaining * 1000)
                local text = Ternary(
                    time.minutes < 1,
                    string.format("%01d", time.seconds),
                    string.format(Ternary(time.seconds > 9, "%01d:%01d", "%01d:0%01d"), time.minutes, time.seconds)
                )
                frame.cooldownText:SetText(config.text .. " - " .. text)
            else
                frame:Hide()
                config.frameParent.RemoveBar(config.id)
                self:SetScript("OnUpdate", nil)
            end
        end)
    end

    frame.runTimer()

    return frame
end
