local AV = GRAAL.BG.AV

local AV_BOX = GRAAL.BG.Data.NAMEFRAME.AV.BOX
local CreateHonorDuringGame = GRAAL.BG.AV.CreateHonorDuringGame
local CreateLockButton = GRAAL.BG.AV.CreateLockButton
local CreatePositionInformations = GRAAL.BG.AV.CreatePositionInformations
local OnUpdate = GRAAL.BG.AV.OnUpdate
local CreateBossBar = GRAAL.BG.AV.CreateBossBar
local UNITS = GRAAL.Data.UNITS
local COLORS = GRAAL.Data.COLORS
local Get = GRAAL.Utils.Get
local Ternary = GRAAL.Utils.Ternary
local CreateText = GRAAL.Ui.CreateText
local CreateTimer = GRAAL.Ui.CreateTimer
local HONOR = GRAAL.Data.honor
local GetTimeInBGString = GRAAL.BG.Utils.GetTimeInBGString
local BARTYPE = GRAAL.Data.BARTYPE
local GetIcon = GRAAL.Utils.GetIcon
local Calendar = GRAAL.Calendar
local CHIEFS = GRAAL.BG.Data.CHIEFS
local CreateAllChief = GRAAL.BG.AV.CreateAllChief
---

local avBox
local heightFrame = 58

local positionInformations
local honorDuringGame

local function ClosedBox()
    avBox:Hide()
    GRAALSAVED["avBox_closed"] = true
end

local function ShowBox()
    avBox:Show()
    GRAALSAVED["avBox_closed"] = false
end

local function IsShow()
    return avBox and avBox:IsShown()
end

local function CreateCloseButton()
    local closeButton = Get(AV_BOX .. "Close")
    closeButton:SetPoint("TOPRIGHT", avBox, "TOPRIGHT", 2, 0)
    closeButton:SetScript("OnClick", function() ClosedBox() end)
end

local function CreatePastTimer()
    local pastTimer = CreateText({
        frameParent = avBox,
        font = "GameFontHighlight",
        point = { xf = "BOTTOMRIGHT", yf = "BOTTOMRIGHT", x = -15, y = 15 },
        color = COLORS.YELLOW_TITLE,
        hide = false
    })
    pastTimer:SetScript("OnEnter", function(self)
        local currentEvent = Calendar.CurrentEvent()
        local eventFinishIn = Calendar.ResetPvpIn()
        local nextEvent = Calendar.NextEvent()
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Calendar of Events", 1, 1, 1)
        GameTooltip:AddLine("Current Event: " .. Ternary(currentEvent, currentEvent, "None"), 0.8, 0.8, 0.8)
        GameTooltip:AddLine("Reset PVP in " .. eventFinishIn, 0.8, 0.8,
            0.8)
        GameTooltip:AddLine("Next Event: " .. Ternary(nextEvent, nextEvent, "None"), 0.8, 0.8, 0.8)
        GameTooltip:Show()
    end)
    pastTimer:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    return pastTimer
end

local function CreateTitle()
    return CreateText({
        frameParent = avBox,
        font = "GameFontNormal",
        point = { xf = "TOP", yf = "TOP", x = 0, y = -10 },
        text = "Alterac Valley"
    })
end

local function Resize(barNumber)
    if barNumber > 0 or barNumber < 0 then
        heightFrame = heightFrame + (18 * barNumber)
        avBox:SetSize(180, heightFrame)
    end
end

local function AddBar(bar)
    positionInformations.Add(bar)
    Resize(1)
end

local function ResetAllBossBar()
    for _, bar in ipairs(avBox.bossBars) do
        bar.Reset()
        AddBar(bar)
    end
end

local function ResetAllChiefIcons()
    for _, chief in ipairs(avBox.chiefIcons) do
        chief:Hide()
    end
end

local function Reset()
    avBox.title:SetText("Alterac Valley")
    Resize(positionInformations.RemoveAll())
    ResetAllBossBar()
    ResetAllChiefIcons()
end

local function HardReset()
    avBox:ClearAllPoints()
    avBox:SetPoint("CENTER", UIParent, "TOPRIGHT", -10, -10)
    avBox.title:SetText("Alterac Valley")
    Resize(positionInformations.RemoveAll())
    ResetAllBossBar()
    ResetAllChiefIcons()
end

local function isBarExist(id)
    return positionInformations.IsExist(id)
end

local function RemoveBar(name)
    if isBarExist(name) then
        positionInformations.Remove(name, avBox)
        Resize(-1)
    end
end

local function CheckRaiderView(boss, bar)
    local hp, maxHp, percentage = UnitHealth(boss), UnitHealthMax(boss), 100
    if maxHp and maxHp > 0 then percentage = hp / maxHp * 100 end
    bar.healthBar:SetMinMaxValues(0, maxHp)
    bar.healthBar:SetValue(hp)
    bar.text:SetText(GetIcon(bar.icon, 'text') .. " -> " .. string.format("%s - %d%%", bar.subname, percentage))
    bar.iconEye:Show()
    if percentage == 0 then
        avBox.RemoveBar(bar.name)
    end
    return true
end

local function CheckChief()
    for _, chief in ipairs(avBox.chiefIcons) do
        for indexTarget = 1, 40 do
            local boss = "raid" .. indexTarget .. "target"
            if UnitExists(boss) and UnitName(boss) == chief.name then
                chief:Show()
            end
        end
    end
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
            frameParent = avBox,
            size = { w = 162, h = 18 }
        })
    )
end

local function UpdateHonorDuringGame(newHonor)
    HONOR.duringGame = newHonor
    honorDuringGame:SetText("Honor: " .. newHonor)
end

local function UpdateTime()
    avBox.timer:SetText(GetTimeInBGString())
end

local function CreateAllBossBar()
    local allBossBar = {}
    for index, _ in ipairs(UNITS) do
        local bossBar = CreateBossBar(index, avBox)
        avBox.AddBar(bossBar)
        table.insert(allBossBar, bossBar)
    end
    return allBossBar
end

AV.CreateAvBox = function()
    GRAALSAVED["avBox_x"] = GRAALSAVED["avBox_x"] or -10
    GRAALSAVED["avBox_y"] = GRAALSAVED["avBox_y"] or -10
    GRAALSAVED["avBox_locked"] = GRAALSAVED["avBox_locked"] or false
    GRAALSAVED["avBox_closed"] = GRAALSAVED["avBox_closed"] or false

    avBox = CreateFrame("Frame", AV_BOX, UIParent, "UIPanelDialogTemplate")
    avBox:SetSize(180, heightFrame)
    avBox:SetPoint("CENTER", UIParent, "TOPRIGHT", GRAALSAVED["avBox_x"], GRAALSAVED["avBox_y"])
    avBox:SetMovable(true)
    avBox:SetClampedToScreen(true)
    avBox:SetFrameStrata("MEDIUM")
    avBox:SetFrameLevel(5)
    avBox.title = CreateTitle()

    honorDuringGame = CreateHonorDuringGame(avBox)
    positionInformations = CreatePositionInformations()

    avBox.timer = CreatePastTimer()
    avBox.closeButton = CreateCloseButton()
    avBox.lockButton = CreateLockButton(
        avBox,
        GRAALSAVED["avBox_locked"],
        { x = GRAALSAVED["avBox_x"], y = GRAALSAVED["avBox_y"] }
    )

    avBox.Resize = Resize
    avBox.Reset = Reset
    avBox.HardReset = HardReset
    avBox.AddBar = AddBar
    avBox.RemoveBar = RemoveBar
    avBox.isBarExist = isBarExist
    avBox.AddTimer = AddTimer
    avBox.UpdateHonorDuringGame = UpdateHonorDuringGame
    avBox.UpdateTime = UpdateTime
    avBox.UpdateAllBossHealth = UpdateAllBossHealth
    avBox.ClosedBox = ClosedBox
    avBox.ShowBox = ShowBox
    avBox.IsShow = IsShow
    avBox.CheckChief = CheckChief

    avBox.bossBars = CreateAllBossBar()
    avBox.chiefIcons = CreateAllChief(avBox)

    avBox:SetScript("OnUpdate", OnUpdate)

    if GRAALSAVED["avBox_closed"] then ClosedBox() else ShowBox() end
end
