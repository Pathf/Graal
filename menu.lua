local Menu = GRAAL.Menu

local ICONS = GRAAL.Data.ICONS
local CreateButton = GRAAL.Ui.CreateButton
local GetBgBox = GRAAL.BG.AV.GetBgBox
---

Menu.CreateMinimapButton = function()
    local onEnter = function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("Graal AV (v" .. VERSION .. ")")
        GameTooltip:AddLine("Clic gauche: Ouvrir/Fermer")
        GameTooltip:AddLine("Clic droit: Reset")
        GameTooltip:Show()
    end
    local onClick = function(self, button)
        if button == "LeftButton" then
            local bgBox = GetBgBox()
            if bgBox and bgBox:IsShown() then bgBox:Hide() else bgBox:Show() end
        elseif button == "RightButton" then
            GRAAL.Utils.ResetData()
            GRAAL.BG.Utils.Reset()
            ReloadUI()
        end
    end
    CreateButton({
        name = "AvBossMinimapButton",
        frameParent = Minimap,
        size = { w = 25, h = 25 },
        movable = true,
        point = { xf = "TOPLEFT", yf = "TOPLEFT", x = 0, y = 0 },
        icon = { name = ICONS.BANNER_HORDE, minimap = true },
        script = {
            onDragStart = function(self) self:StartMoving() end,
            onDragStop = function(self) self:StopMovingOrSizing() end,
            onLeave = function() GameTooltip:Hide() end,
            onEnter = onEnter,
            onClick = onClick
        },
    })
end
