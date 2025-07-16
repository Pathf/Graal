local av = GRAAL.BG.AV
local CreateIcon = GRAAL.Ui.CreateIcon
local CHIEFS = GRAAL.BG.Data.CHIEFS

--

local function CreateChief(chief, frameParent)
    local chiefIcon = CreateIcon({
        icon = chief.icon,
        isPoi = true,
        point = { xf = "BOTTOM", yf = "BOTTOM", x = chief.x, y = -18 },
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

av.CreateAllChief = function(frameParent)
    local chiefIcons = {}
    for _, chief in ipairs(CHIEFS) do
        Logger(chief.name)
        table.insert(chiefIcons, CreateChief(chief, frameParent))
    end
    return chiefIcons
end
