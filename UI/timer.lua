-- CONFIG TIMER
local configTimerExample = {
    icon= GRAAL.Data.ICONS.HUMAN.M, -- or GRAAL.Data.POIIcon.MINE -- *
    id= "b1", -- *
    text="text",
    isPoi= true,
    point= { xf= "CENTER", yf= "TOP", x= 0, y= 0 },
    name= "ExampleTimer",
    frameParent= UIParent,
    size= { w= 20, h= 20 }
}

local Ternary = GRAAL.Utils.Ternary
--
GRAAL.Ui.CreateTimer = function(config)
    config.frameParent = config.frameParent or UIParent
    config.time = config.time or 300
    config.point = config.point or { xf= "CENTER", yf= "CENTER", x= 0, y= 0 }
    config.size = config.size or { w= 15, h= 15 }
    config.isPoi = config.isPoi or false

    local frame = CreateFrame("Frame", config.id.."timer", config.frameParent)
    frame:SetSize(1, 1)
    frame:SetPoint(config.point.xf, config.frameParent, config.point.yf, config.point.x, config.point.y)
    frame.name = config.id
    frame.icon = GRAAL.Ui.CreateIcon({ frameParent=frame, isPoi=config.isPoi, point={ xf= "CENTER", yf= "CENTER", x=-30, y= 0 }, icon=config.icon, size= { w= config.size.w, h= config.size.h } })
    frame.cooldownText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.cooldownText:SetFont("Fonts\\FRIZQT__.TTF", 10)
    frame.cooldownText:SetPoint("LEFT", frame, "LEFT", -20, 0)
    
    frame.runTimer = function()
        frame:Show()
        frame.duration = config.time
        frame.startTime = GetTime()

        frame:SetScript("OnUpdate", function(self, elapsed)
            local remaining = frame.startTime + frame.duration - GetTime()
            if remaining > 0 then
                local time = GRAAL.Utils.BuildTime(remaining*1000)
                local text = Ternary(
                    time.minutes < 1, 
                    string.format("%01d", time.seconds), 
                    string.format(Ternary(time.seconds > 9, "%01d:%01d", "%01d:0%01d"), time.minutes, time.seconds)
                )
                frame.cooldownText:SetText(config.text .. " - " .. text)
            else
                frame.cooldownText:SetText("")
                config.frameParent.positionInformations.remove(config.id, config.frameParent)
                frame:Hide()
                self:SetScript("OnUpdate", nil)
            end
        end)
    end

    frame.runTimer()

    return frame
end