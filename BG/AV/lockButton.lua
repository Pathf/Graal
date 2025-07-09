local AV = GRAAL.BG.AV

local Ternary = GRAAL.Utils.Ternary
local GetIcon = GRAAL.Utils.GetIcon
local ICONS = GRAAL.Data.ICONS
local CreateButton = GRAAL.Ui.CreateButton
---

local function SetLockedState(frame, locked)
    frame.lockButton:SetNormalTexture(Ternary(locked, GetIcon(ICONS.CHEST_LOCK), GetIcon(ICONS.KEY)))
end

local function SetMovableState(frame, movable, position)
    if movable then
        frame:EnableMouse(true)
        frame:RegisterForDrag("LeftButton")
        frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
        frame:SetScript("OnDragStop", function(self)
            self:StopMovingOrSizing()
            local _, _, _, x, y = self:GetPoint()
            position.x = x
            position.y = y
        end)
    else
        frame:EnableMouse(false)
        frame:SetScript("OnDragStart", nil)
        frame:SetScript("OnDragStop", nil)
    end
end

AV.CreateLockButton = function(frame, frameState)
    local onClick = function()
        frameState.locked = not frameState.locked
        SetMovableState(frame, not frameState.locked, frameState)
        SetLockedState(frame, frameState.locked)
    end
    local lockButton = CreateButton({
        template = "UIPanelButtonTemplate",
        name = "AvBossLockButton",
        frameParent = frame,
        size = { w = 18, h = 18 },
        point = { xf = "TOPLEFT", yf = "TOPLEFT", x = 8.5, y = -6 },
        script = { onClick = onClick }
    })
    SetMovableState(frame, not frameState.locked, frameState)
    lockButton:SetNormalTexture(Ternary(frameState.locked, GetIcon(ICONS.CHEST_LOCK), GetIcon(ICONS.KEY)))
    return lockButton
end
