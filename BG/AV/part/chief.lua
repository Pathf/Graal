local av = GRAAL.BG.AV
local CreateIcon = GRAAL.Ui.CreateIcon
local CHIEFS = GRAAL.BG.Data.CHIEFS

--

local function CreateChief(chief, frameParent)
    local chiefIcon = CreateIcon({
        icon = chief.icon,
        isPoi = true,
        point = { xf = "BOTTOM", yf = "BOTTOM", x = chief.x, y = -22 },
        name = chief.name,
        frameParent = frameParent,
        size = { w = 20, h = 20 },
        hide = false
    })
    chiefIcon:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Chief " .. chief.subname .. " has been view", 1, 1, 1)
        GameTooltip:Show()
    end)
    chiefIcon:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    chiefIcon:Hide()
    return chiefIcon
end

local function UpdateChief(chiefs)
    for _, chief in ipairs(chiefs) do
        for indexTarget = 1, 40 do
            local boss = "raid" .. indexTarget .. "target"
            if UnitExists(boss) and UnitName(boss) == chief.name then
                chief:Show()
            end
        end
    end
end

local function ResetAllChiefIcons(chiefs)
    for _, chief in ipairs(chiefs) do
        chief:Hide()
    end
end

av.CreateAllChief = function(avFrame)
    local chiefIcons = {}
    for _, chief in ipairs(CHIEFS) do
        table.insert(chiefIcons, CreateChief(chief, avFrame))
    end

    avFrame.UpdateChief = UpdateChief
    avFrame.ResetAllChiefIcons = ResetAllChiefIcons
    return chiefIcons
end
