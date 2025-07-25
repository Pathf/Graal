local BgBox = GRAAL.BG.Utils.BgBox
local AV_BOX = GRAAL.BG.Data.NAMEFRAME.AV.BOX
local CreatePositionInformations = GRAAL.BG.AV.CreatePositionInformations
local CreateTimer = GRAAL.Ui.CreateTimer
local CreateBossBar = GRAAL.BG.AV.CreateBossBar
local CreateAllChief = GRAAL.BG.AV.CreateAllChief
local UNITS = GRAAL.Data.UNITS
local BARTYPE = GRAAL.Data.BARTYPE
local GetIcon = GRAAL.Utils.GetIcon
local ELAPSED = GRAAL.Data.elapsed
---

local avFrame
local positionInformations

local function OnUpdate(_, delta)
    ELAPSED = ELAPSED + delta
    if ELAPSED >= 0.1 then
        BgBox().Update()
        ELAPSED = 0
    end
end

local function CreateBox()
    local bgBox = BgBox()
    avFrame = CreateFrame("Frame", AV_BOX, BgBox())
    avFrame:SetSize(180, 0)
    avFrame:SetPoint("TOPRIGHT", bgBox, "TOPRIGHT", 0, 0)
    avFrame:SetClampedToScreen(true)
    avFrame:SetFrameStrata("MEDIUM")
    avFrame:SetFrameLevel(5)
end

local function CreateAllBossBar()
    local allBossBar = {}
    for index, _ in ipairs(UNITS) do
        local bossBar = CreateBossBar(index, avFrame)
        avFrame.AddBar(bossBar)
        table.insert(allBossBar, bossBar)
    end
    return allBossBar
end


local function Resize(barNumber)
    local bgBox = BgBox()
    bgBox.AddHeightBox(18 * barNumber)
    avFrame:SetSize(180, bgBox:GetHeight() - 58)
end

local function AddBar(bar)
    positionInformations.Add(bar)
    Resize(1)
end

local function ResetAllBossBar()
    for _, bar in ipairs(avFrame.bossBars) do
        bar.Reset()
        AddBar(bar)
    end
end

local function ResetAllChiefIcons()
    for _, chief in ipairs(avFrame.chiefIcons) do
        chief:Hide()
    end
end

local function ShowBody()
    avFrame:Show()
    ResetAllBossBar()
    ResetAllChiefIcons()
    avFrame:SetScript("OnUpdate", OnUpdate)
end

local function HideBody()
    avFrame:SetScript("OnUpdate", nil)
    Resize(positionInformations.RemoveAll())
    avFrame:Hide()
end

local function Update()
    avFrame.UpdateAllBossHealth()
    avFrame.UpdateChief()
    BgBox().UpdateTime()
end

local function isBarExist(id)
    return positionInformations.IsExist(id)
end

local function RemoveBar(name)
    if isBarExist(name) then
        positionInformations.Remove(name, avFrame)
        Resize(-1)
    end
end

local function AddTimer(location, icon)
    local position = positionInformations.nextPosition()
    AddBar(
        CreateTimer({
            text = location.subname,
            point = { xf = "TOPRIGHT", yf = "TOPRIGHT", x = position.x, y = position.y },
            time = 300,
            icon = icon,
            isPoi = true,
            name = location.name,
            id = location.id,
            frameParent = avFrame,
            size = { w = 162, h = 18 }
        })
    )
end

local function CheckRaiderView(boss, bar)
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

local function UpdateAllBossHealth()
    local allBossBar = {}
    for _, bar in ipairs(positionInformations.current) do
        if bar.box.type == BARTYPE.BOSS then
            table.insert(allBossBar, bar.box)
        end
    end

    for _, bar in ipairs(allBossBar) do
        local hasRaiderView = false
        for i = 1, 40 do
            local boss = "raid" .. i .. "target"
            if UnitExists(boss) and UnitName(boss) == bar.name then
                hasRaiderView = CheckRaiderView(boss, bar)
            end
        end
        if not hasRaiderView then bar.iconEye:Hide() end
    end
end

local function UpdateChief()
    for _, chief in ipairs(avFrame.chiefIcons) do
        for indexTarget = 1, 40 do
            local boss = "raid" .. indexTarget .. "target"
            if UnitExists(boss) and UnitName(boss) == chief.name then
                chief:Show()
            end
        end
    end
end

GRAAL.BG.AV.CreateAVFrame = function()
    CreateBox()
    positionInformations = CreatePositionInformations()

    avFrame.Resize = Resize
    avFrame.AddBar = AddBar

    avFrame.bossBars = CreateAllBossBar()
    avFrame.chiefIcons = CreateAllChief(avFrame)

    avFrame.ShowBody = ShowBody
    avFrame.HideBody = HideBody
    avFrame.Update = Update
    avFrame.RemoveBar = RemoveBar
    avFrame.isBarExist = isBarExist
    avFrame.AddTimer = AddTimer
    avFrame.UpdateAllBossHealth = UpdateAllBossHealth
    avFrame.UpdateChief = UpdateChief

    avFrame.HideBody()

    return avFrame
end
