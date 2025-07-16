local av = GRAAL.BG.AV

local UNITS = GRAAL.Data.UNITS
local BARTYPE = GRAAL.Data.BARTYPE
local COLORS = GRAAL.Data.COLORS
local TARGETINGFRAME = GRAAL.Data.TARGETINGFRAME
local ICONS = GRAAL.Data.ICONS

local GetIcon = GRAAL.Utils.GetIcon
local GetTargetingFrame = GRAAL.Utils.GetTargetingFrame

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
        frameParent = frame,
        font = "GameFontHighlightSmall",
        point = { xf = "LEFT", yf = "LEFT", x = 15, y = 0 },
        color = COLORS.WHITE,
        text = GetIcon(ICONS.INTEROGATION, 'text') .. " -> " .. subname
    })
end

--local configBossBarExample = {
--  name= "ExampleBossBar",
--  frameParent=UIParent,
--  point= { xf= "TOPRIGHT", yf= "TOPRIGHT", x= 0, y= 0 },
--  size= { w= 162, h= 18 }
--  unitInfo= {
--      name=,
--      subname=,
--      color=
--  }
--}

local function CreateBossBar(index, frameParent)
    frameParent = frameParent or UIParent
    local unitInfo = UNITS[index]
    local yFrame = -25 + ((index - 1) * -18)
    local name, subname, color, icon = unitInfo.name, unitInfo.subname, unitInfo.color, unitInfo.icon

    local bossBar = CreateFrame("Frame", name .. "HealthFrame", frameParent)
    bossBar.name = name
    bossBar.subname = subname
    bossBar.icon = icon
    bossBar.type = BARTYPE.BOSS
    bossBar:SetSize(162, 18)
    bossBar:SetPoint("TOPRIGHT", frameParent, "TOPRIGHT", -8, yFrame)
    bossBar:SetClampedToScreen(true)
    bossBar:SetFrameStrata("MEDIUM")
    bossBar:SetFrameLevel(5)

    bossBar.healthBar = CreateHealthBar(bossBar, color)

    bossBar.textFrame = CreateFrame("Frame", nil, bossBar)
    bossBar.textFrame:SetAllPoints()
    bossBar.textFrame:SetFrameStrata("MEDIUM")
    bossBar.textFrame:SetFrameLevel(6)

    bossBar.iconEye = bossBar.textFrame:CreateTexture(nil, "ARTWORK")
    bossBar.iconEye:SetSize(15, 15)
    bossBar.iconEye:SetPoint("LEFT", bossBar, "LEFT", 0, 0)
    bossBar.iconEye:SetTexture("Interface\\Icons\\Ability_Ambush")
    bossBar.iconEye:Hide()

    bossBar.text = CreateLabel(bossBar.textFrame, subname)

    bossBar.Reset = function()
        bossBar:ClearAllPoints()
        bossBar:SetPoint("TOPRIGHT", frameParent, "TOPRIGHT", -8, yFrame)
        bossBar.healthBar:SetMinMaxValues(0, 100)
        bossBar.healthBar:SetValue(100)
        bossBar.text.UpdateText(GetIcon(ICONS.INTEROGATION, 'text') .. " -> " .. subname)
        bossBar:Show()
    end

    UNITS[index].frame = bossBar
    return bossBar
end

av.CreateAllBossBar = function(frameParent)
    local allBossBar = {}
    for index, _ in ipairs(UNITS) do
        local bossBar = CreateBossBar(index, frameParent)
        frameParent.AddBar(bossBar)
        table.insert(allBossBar, bossBar)
    end
    return allBossBar
end
