local BG = GRAAL.BG

local BGNAME = GRAAL.BG.Data.NAMEFRAME.BG.BOX
---

local bgBox
local HEIGHTFIX = 58 + 28
local heightBox = HEIGHTFIX

local function LoadData()
    GRAALSAVED["bgBox_x"] = GRAALSAVED["bgBox_x"] or -10
    GRAALSAVED["bgBox_y"] = GRAALSAVED["bgBox_y"] or -10
    GRAALSAVED["bgBox_locked"] = GRAALSAVED["bgBox_locked"] or false
    GRAALSAVED["bgBox_closed"] = GRAALSAVED["bgBox_closed"] or false
end

local function CreateBox()
    bgBox = CreateFrame("Frame", BGNAME, UIParent, "UIPanelDialogTemplate")
    bgBox:SetSize(180, heightBox)
    bgBox:SetPoint("CENTER", UIParent, "TOPRIGHT", GRAALSAVED["bgBox_x"], GRAALSAVED["bgBox_y"])
    bgBox:SetMovable(true)
    bgBox:SetClampedToScreen(true)
    bgBox:SetFrameStrata("MEDIUM")
    bgBox:SetFrameLevel(5)
end

local function UpdateHeigthBox(newHeightBox)
    heightBox = newHeightBox
    bgBox:SetSize(180, heightBox)
end

local function Reset()
    bgBox.HideBody()
    bgBox.title:SetText(bgBox.titleText)
    UpdateHeigthBox(HEIGHTFIX)
    bgBox.UpdateTime()
end

local function HardReset()
    bgBox:ClearAllPoints()
    bgBox:SetPoint("CENTER", UIParent, "TOPRIGHT", -10, -10)
    bgBox.title:SetText(bgBox.titleText)
    UpdateHeigthBox(HEIGHTFIX)
    bgBox.UpdateTime()
end

local function AddHeightBox(modHeightBox)
    UpdateHeigthBox(heightBox + modHeightBox)
end

BG.CreateBgBox = function()
    LoadData()
    CreateBox()
    bgBox.AddHeightBox = AddHeightBox

    GRAAL.BG.Part.CreateTitlePart()
    GRAAL.BG.Part.CreateBodyPart()
    GRAAL.BG.Part.CreateFooterPart()

    bgBox.Reset = Reset
    bgBox.HardReset = HardReset
    bgBox.UpdateHeigthBox = UpdateHeigthBox


    if GRAALSAVED["bgBox_closed"] then bgBox.ClosedBox() else bgBox.ShowBox() end
end
