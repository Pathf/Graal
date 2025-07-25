local Menu = GRAAL.Menu

local ICONS = GRAAL.Data.ICONS
local CreateButton = GRAAL.Ui.CreateButton
local GetBgBox = GRAAL.BG.Utils.BgBox
local BgHardReset = GRAAL.BG.Utils.HardReset
local Reset = GRAAL.Utils.Reset
---

Menu.CreateMinimapButton = function()
    local onEnter = function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("Graal AV (v" .. VERSION .. ")")
        GameTooltip:AddLine("Clic gauche: Ouvrir/Fermer")
        GameTooltip:AddLine("Clic droit: Reset")
        GameTooltip:Show()
    end
    local onClick = function(_, button)
        local bgBox = GetBgBox()
        if button == "LeftButton" then
            if bgBox.IsShow() then bgBox.ClosedBox() else bgBox.ShowBox() end
        elseif button == "RightButton" then
            Reset()
            BgHardReset()
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
