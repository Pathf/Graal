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

local function CreateBossBar(unit, frameParent)
    frameParent = frameParent or UIParent
    local yFrame = -25 + (unit.index * -18)
    local name, subname, color, icon = unit.name, unit.subname, unit.color, unit.icon

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

    return bossBar
end


local function CheckRaiderView(avFrame, boss, bar)
    local hp, maxHp, percentage = UnitHealth(boss), UnitHealthMax(boss), 100
    if maxHp and maxHp > 0 then percentage = hp / maxHp * 100 end
    bar.healthBar:SetMinMaxValues(0, maxHp)
    bar.healthBar:SetValue(hp)
    bar.text:SetText(GetIcon(bar.icon, 'text') .. " -> " .. string.format("%s - %d%%", bar.subname, percentage))
    bar.iconEye:Show()
    if percentage == 0 then
        avFrame.RemoveBar(bar.name)
    end
    return true
end

local function UpdateAllBossHealth(avFrame)
    local allBossBar = {}
    for _, bar in ipairs(avFrame.positionInformations.current) do
        if bar.box.type == BARTYPE.BOSS then
            table.insert(allBossBar, bar.box)
        end
    end

    for _, bar in ipairs(allBossBar) do
        local hasRaiderView = false
        for i = 1, 40 do
            local boss = "raid" .. i .. "target"
            if UnitExists(boss) and UnitName(boss) == bar.name then
                hasRaiderView = CheckRaiderView(avFrame, boss, bar)
            end
        end
        if not hasRaiderView then bar.iconEye:Hide() end
    end
end

local function ResetAllBossBar(avFrame)
    for _, bar in ipairs(avFrame.bossBars) do
        bar.Reset()
        avFrame.AddBar(bar)
    end
end

av.CreateAllBossBar = function(avFrame)
    local allBossBar = {}
    for _, unit in ipairs(UNITS) do
        local bossBar = CreateBossBar(unit, avFrame)
        avFrame.AddBar(bossBar)
        table.insert(allBossBar, bossBar)
    end

    avFrame.UpdateAllBossHealth = UpdateAllBossHealth
    avFrame.ResetAllBossBar = ResetAllBossBar
    return allBossBar
end
