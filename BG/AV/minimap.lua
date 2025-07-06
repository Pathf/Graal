local av = GRAAL.BG.AV

local ICONS = GRAAL.Data.ICONS
local CreateButton = GRAAL.Ui.CreateButton
---

av.CreateAvBossMinimapButton = function(frame)
    local onEnter = function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("Graal")
        GameTooltip:AddLine("Clic gauche: Ouvrir/Fermer")
        GameTooltip:AddLine("Clic droit: Reset")
        GameTooltip:Show()
    end
    local onLeave = function() GameTooltip:Hide() end
    local onDragStart = function(self) self:StartMoving() end
    local onDragStop = function(self) self:StopMovingOrSizing() end
    local onClick = function(self, button) 
        if button == "LeftButton" then 
            if frame and frame:IsShown() then frame:Hide() else frame:Show() end 
        elseif button == "RightButton" then
            GRAAL.Utils.ResetData()
            GRAAL.BG.Utils.Reset()
            ReloadUI() 
        end 
    end
    CreateButton({
      name= "AvBossMinimapButton",
      frameParent= Minimap,
      size= { w= 25, h= 25 },
      movable=true,
      point= { xf= "TOPLEFT", yf= "TOPLEFT", x= 0, y= 0 },
      icon= { name=ICONS.BANNER_HORDE, minimap=true },
      script= { onDragStart=onDragStart, onDragStop=onDragStop, onClick=onClick, onLeave=onLeave, onEnter=onEnter}, 
    })
end