local ICONS = GRAAL.Data.ICONS
local Get = GRAAL.Utils.Get
local GetIcon = GRAAL.Utils.GetIcon
local Ternary = GRAAL.Utils.Ternary
local CreateButton = GRAAL.Ui.CreateButton
local CreateText = GRAAL.Ui.CreateText
local BOXNAME = GRAAL.BG.Data.NAMEFRAME.BG.BOX
local BgBox = GRAAL.BG.Utils.BgBox
---

local titleText = "Graal PVP"

local function SetLockedState(locked)
    BgBox().lockButton:SetNormalTexture(Ternary(locked, GetIcon(ICONS.CHEST_LOCK), GetIcon(ICONS.KEY)))
end

local function SetMovableState(movable, position)
    local bgBox = BgBox()
    if movable then
        bgBox:EnableMouse(true)
        bgBox:RegisterForDrag("LeftButton")
        bgBox:SetScript("OnDragStart", function(self) self:StartMoving() end)
        bgBox:SetScript("OnDragStop", function(self)
            self:StopMovingOrSizing()
            local _, _, _, x, y = self:GetPoint()
            position.x = x
            position.y = y
        end)
    else
        bgBox:EnableMouse(false)
        bgBox:SetScript("OnDragStart", nil)
        bgBox:SetScript("OnDragStop", nil)
    end
end

local function CreateLockButton()
    local locked = GRAALSAVED["bgBox_locked"]
    local position = { x = GRAALSAVED["bgBox_x"], y = GRAALSAVED["bgBox_y"] }

    local onClick = function()
        locked = not locked
        SetMovableState(not locked, position)
        SetLockedState(locked)
    end
    local lockButton = CreateButton({
        template = "UIPanelButtonTemplate",
        name = "BgBoxLockButton",
        frameParent = BgBox(),
        size = { w = 18, h = 18 },
        point = { xf = "TOPLEFT", yf = "TOPLEFT", x = 8.5, y = -6 },
        script = { onClick = onClick }
    })
    SetMovableState(not locked, position)
    lockButton:SetNormalTexture(Ternary(locked, GetIcon(ICONS.CHEST_LOCK), GetIcon(ICONS.KEY)))
    return lockButton
end

local function CreateTitle()
    local bgBox = BgBox()
    return CreateText({
        frameParent = bgBox,
        font = "GameFontNormal",
        point = { xf = "TOP", yf = "TOP", x = 0, y = -10 },
        text = titleText
    })
end

local function IsShow()
    local box = BgBox()
    return box and box:IsShown()
end

local function ShowBox()
    BgBox():Show()
    GRAALSAVED["bgBox_closed"] = false
end

local function ClosedBox()
    BgBox():Hide()
    GRAALSAVED["bgBox_closed"] = true
end

local function CreateCloseButton()
    local closeButton = Get(BOXNAME .. "Close")
    closeButton:SetPoint("TOPRIGHT", BgBox(), "TOPRIGHT", 2, 0)
    closeButton:SetScript("OnClick", function() ClosedBox() end)
    return closeButton
end

local function UpdateTitle(newTitleText)
    BgBox().title:SetText(newTitleText)
end

local function ResetTitle()
    BgBox().title:SetText(titleText)
end

GRAAL.BG.Part.CreateTitlePart = function()
    local bgBox = BgBox()
    bgBox.lockButton = CreateLockButton()
    bgBox.title = CreateTitle()
    bgBox.titleText = titleText
    bgBox.closeButton = CreateCloseButton()

    bgBox.ShowBox = ShowBox
    bgBox.ClosedBox = ClosedBox
    bgBox.ResetTitle = ResetTitle
    bgBox.UpdateTitle = UpdateTitle
    bgBox.IsShow = IsShow
end
