local av = GRAAL.BG.AV

local UNITS = GRAAL.Data.UNITS
local COLORS = GRAAL.Data.COLORS
local TARGETINGFRAME = GRAAL.Data.TARGETINGFRAME
local ICONS = GRAAL.Data.ICONS

local GetIcon = GRAAL.Utils.GetIcon
local GetTargetingFrame = GRAAL.Utils.GetTargetingFrame
local TableSize = GRAAL.Utils.TableSize

local CreateText = GRAAL.Ui.CreateText
---
local function CreateHealthBar(frame, color)
    local healthBar = CreateFrame("StatusBar", nil, frame)
    healthBar:SetAllPoints()
    healthBar:SetStatusBarTexture(GetTargetingFrame(TARGETINGFRAME.STATUSBAR))
    healthBar:SetStatusBarColor(color.r, color.g, color.b)
    healthBar:SetMinMaxValues(0, 100)
    healthBar:SetValue(100)
    healthBar:SetFrameStrata("MEDIUM")
    healthBar:SetFrameLevel(5)
    return healthBar
end

local function CreateLabel(frame, subname)
    return CreateText({
        frameParent= frame,
        font= "GameFontHighlightSmall",
        point= { xf= "LEFT", yf= "LEFT", x= 15, y= 0 },
        color=COLORS.WHITE,
        text=GetIcon(ICONS.INTEROGATION, 'text').. " -> " .. subname
    })
end

local function CreateBossFrame(index, frameParent)
    frameParent = frameParent or UIParent
    local unitInfo = UNITS[index]
    local yFrame = -25 + ((index - 1) * -18)
    local name, subname, defaultX, defaultY, color = unitInfo.name, unitInfo.subname, unitInfo.defaultX, unitInfo.defaultY, unitInfo.color

    local frame = CreateFrame("Frame", name.."HealthFrame", frameParent)
    frame:SetSize(162, 18)
    frame:SetPoint("TOPRIGHT", frameParent, "TOPRIGHT", -8, yFrame)
    frame:SetClampedToScreen(true)
    frame:SetFrameStrata("MEDIUM")
    frame:SetFrameLevel(5)

    frame.healthBar = CreateHealthBar(frame, color)
    
    frame.textFrame = CreateFrame("Frame", nil, frame)
    frame.textFrame:SetAllPoints()
    frame.textFrame:SetFrameStrata("MEDIUM")
    frame.textFrame:SetFrameLevel(6)

    frame.iconEye = frame.textFrame:CreateTexture(nil, "ARTWORK")
    frame.iconEye:SetSize(15, 15)
    frame.iconEye:SetPoint("LEFT", frame, "LEFT", 0, 0)
    frame.iconEye:SetTexture("Interface\\Icons\\Ability_Ambush")
    frame.iconEye:Hide()
 
    frame.text = CreateLabel(frame.textFrame, subname)

    UNITS[index].frame = frame
end

av.CreateAllBossFrame = function(frameParent)
    local unitInfoListSize = TableSize(UNITS)
    for index, _ in ipairs(UNITS) do
        CreateBossFrame(index, frameParent)
    end
end