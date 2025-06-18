local dataSaved = GRAAL.Data.saved
local C = GRAAL.Data.COLORS
local ICONS = GRAAL.Data.ICONS
local unitInfoList = GRAAL.Data.UNITS
local elapsed = GRAAL.Data.elapsed
local honor = GRAAL.Data.honor

local Get = GRAAL.Utils.Get
local TableSize = GRAAL.Utils.TableSize
local Ternary = GRAAL.Utils.Ternary
local GetIconText = GRAAL.Utils.GetIconText

local GetTimeInBGString = GRAAL.BG.Utils.GetTimeInBGString


---------------------------------

local function ResetAddon()
    GRAAL.Data.ResetData()
    GRAAL.BG.AV.Component.Reset()
    ReloadUI()
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

local function SetLockedState(frame, locked)
    frame.lockButton:SetNormalTexture(Ternary(locked, GetIconText(ICONS.CHEST_LOCK), GetIconText(ICONS.KEY)))
end

local function CheckRaiderView(boss, unitInfo)
    local bossName, bossSubName, frame = unitInfo.name, unitInfo.subname, unitInfo.frame
    local hp, maxHp, percentage = UnitHealth(boss), UnitHealthMax(boss), 100
    if maxHp and maxHp > 0 then percentage = hp / maxHp * 100 end
    frame.healthBar:SetMinMaxValues(0, maxHp)
    frame.healthBar:SetValue(hp)
    frame.text:SetText(GetIconText(unitInfo.icon) .. " -> " .. string.format("%s - %d%%", bossSubName, percentage))
    frame.iconEye:Show()
    return true
end

local function UpdateBossHealth(unitInfo)
    local hasRaiderView, hasBossAgro = false, false
    for i = 1, 40 do
        local boss = "raid" .. i .. "target"
        if UnitExists(boss) and UnitName(boss) == unitInfo.name then
            hasRaiderView = CheckRaiderView(boss, unitInfo)
        end
    end
    if not hasRaiderView then unitInfo.frame.iconEye:Hide() end
end

---------------------------------------
---          COMPOSANTS             ---
---------------------------------------
local function CreateBossFrame(index, frameParent)
    frameParent = frameParent or UIParent
    local unitInfo = unitInfoList[index]
    local yFrame = -30 + ((index - 1) * -18)
    local name, subname, defaultX, defaultY, color = unitInfo.name, unitInfo.subname, unitInfo.defaultX, unitInfo.defaultY, unitInfo.color

    local frame = CreateFrame("Frame", name.."HealthFrame", frameParent)
    frame:SetSize(200, 15)
    frame:SetPoint("TOPLEFT", frameParent, "TOPLEFT", 10, yFrame)
    frame:SetClampedToScreen(true)
    frame:SetFrameStrata("MEDIUM")
    frame:SetFrameLevel(5)

    frame.healthBar = CreateFrame("StatusBar", nil, frame)
    frame.healthBar:SetAllPoints()
    frame.healthBar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
    frame.healthBar:SetStatusBarColor(color.r, color.g, color.b)
    frame.healthBar:SetMinMaxValues(0, 100)
    frame.healthBar:SetValue(100)
    frame.healthBar:SetFrameStrata("MEDIUM")
    frame.healthBar:SetFrameLevel(5)
    
    frame.textFrame = CreateFrame("Frame", nil, frame)
    frame.textFrame:SetAllPoints()
    frame.textFrame:SetFrameStrata("MEDIUM")
    frame.textFrame:SetFrameLevel(6)

    frame.iconEye = frame.textFrame:CreateTexture(nil, "ARTWORK")
    frame.iconEye:SetSize(15, 15)
    frame.iconEye:SetPoint("LEFT", frame, "LEFT", 0, 0)
    frame.iconEye:SetTexture("Interface\\Icons\\Ability_Ambush")
    frame.iconEye:Hide()
 
    frame.text = frame.textFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    frame.text:SetPoint("LEFT", frame, "LEFT", 25, 0)
    frame.text:SetTextColor(C.WHITE.r, C.WHITE.g, C.WHITE.b)
    frame.text:SetShadowColor(0, 0, 0, 1)
    frame.text:SetShadowOffset(1, -1)
    frame.text:SetText(GetIconText(ICONS.INTEROGATION).. " -> " .. subname)

    unitInfoList[index].frame = frame
end

local function CreateAllBossFrame(frameParent)
    local unitInfoListSize = TableSize(unitInfoList)
    for index, _ in ipairs(unitInfoList) do
        CreateBossFrame(index, frameParent)
    end
end

local function CreateBossBox()
    local numberBoss = TableSize(unitInfoList)
    local heightFrame = (numberBoss * 20) + 40
    local bossBoxPosition = Ternary(dataSaved["bossBoxPosition"], dataSaved["bossBoxPosition"], { x = -10, y = -10, locked = false })
    dataSaved["bossBoxPosition"] = bossBoxPosition

    local bossBoxFrame = CreateFrame("Frame", "BossBoxFrame", UIParent, "UIPanelDialogTemplate")
    bossBoxFrame:SetSize(220, heightFrame)
    bossBoxFrame:SetPoint("CENTER", UIParent, "TOPRIGHT", bossBoxPosition.x, bossBoxPosition.y)
    bossBoxFrame:SetMovable(true)
    bossBoxFrame:SetClampedToScreen(true)
    bossBoxFrame:SetFrameStrata("MEDIUM")
    bossBoxFrame:SetFrameLevel(5)

    local reopen = CreateFrame("Button", "ReopenAVB", UIParent, "UIPanelButtonTemplate")
    reopen:SetSize(80, 20)
    reopen:SetPoint("CENTER", UIParent, "TOP", 0, 0)
    reopen:SetMovable(true)
    reopen:SetClampedToScreen(true)
    reopen:EnableMouse(true)
    reopen:RegisterForDrag("LeftButton")
    reopen:SetText("Reopen AVB")
    reopen:SetScript("OnDragStart", function(self) self:StartMoving() end)
    reopen:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    reopen:SetScript("OnClick", function() 
        bossBoxFrame:Show()
        reopen:Hide()
    end)
    reopen:Hide()

    bossBoxFrame.title = bossBoxFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    bossBoxFrame.title:SetPoint("TOP", bossBoxFrame, "TOP", 0, -10)
    bossBoxFrame.title:SetText("AV - Boss")

    bossBoxFrame.honorDuringGame = bossBoxFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    bossBoxFrame.honorDuringGame:SetPoint("BOTTOMLEFT", bossBoxFrame, "BOTTOMLEFT", 15, 15)
    bossBoxFrame.honorDuringGame:SetTextColor(C.YELLOW_TITLE.r, C.YELLOW_TITLE.g, C.YELLOW_TITLE.b)
    bossBoxFrame.honorDuringGame:SetShadowColor(0, 0, 0, 1)
    bossBoxFrame.honorDuringGame:SetShadowOffset(1, -1)
    bossBoxFrame.honorDuringGame:SetText(honor.duringGame.." honor")

    bossBoxFrame.timer = bossBoxFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    bossBoxFrame.timer:SetPoint("BOTTOMRIGHT", bossBoxFrame, "BOTTOMRIGHT", -15, 15)
    bossBoxFrame.timer:SetTextColor(C.YELLOW_TITLE.r, C.YELLOW_TITLE.g, C.YELLOW_TITLE.b)
    bossBoxFrame.timer:SetShadowColor(0, 0, 0, 1)
    bossBoxFrame.timer:SetShadowOffset(1, -1)
    
    bossBoxFrame.closeButton = Get("BossBoxFrameClose")
    bossBoxFrame.closeButton:SetPoint("TOPRIGHT", bossBoxFrame, "TOPRIGHT", 2, 0)
    bossBoxFrame.closeButton:SetScript("OnClick", function(self) 
        bossBoxFrame:Hide()
        reopen:Show()
    end)

    bossBoxFrame.lockButton = CreateFrame("Button", nil, bossBoxFrame, "UIPanelButtonTemplate")
    bossBoxFrame.lockButton:SetSize(18, 18)
    bossBoxFrame.lockButton:SetPoint("TOPRIGHT", bossBoxFrame, "TOPRIGHT", -27, -6)
    bossBoxFrame.lockButton:SetScript("OnClick", function()
        bossBoxPosition.locked = not bossBoxPosition.locked
        SetMovableState(bossBoxFrame, not bossBoxPosition.locked, bossBoxPosition)
        SetLockedState(bossBoxFrame, bossBoxPosition.locked)
    end)
    SetMovableState(bossBoxFrame, not bossBoxPosition.locked, bossBoxPosition)
    SetLockedState(bossBoxFrame, bossBoxPosition.locked)

    bossBoxFrame.resetButton = CreateFrame("Button", nil, bossBoxFrame, "UIPanelButtonTemplate")
    bossBoxFrame.resetButton:SetSize(42, 18)
    bossBoxFrame.resetButton:SetPoint("TOPRIGHT", bossBoxFrame, "TOPRIGHT", -170, -6)
    bossBoxFrame.resetButton:SetText("Reset")
    bossBoxFrame.resetButton:SetScript("OnClick", ResetAddon)
    
    CreateAllBossFrame(bossBoxFrame)

    bossBoxFrame:SetScript("OnUpdate", function(self, delta)
        elapsed = elapsed + delta
        if elapsed >= 0.5 then
            for _,unitInfo in ipairs(unitInfoList) do 
                UpdateBossHealth(unitInfo)
            end
            elapsed = 0
            bossBoxFrame.timer:SetText(GetTimeInBGString())
        end
    end)

    
end

---------------------------------------
GRAAL.Utils.Logger("Elle est où la poulette ?")
CreateBossBox()
GRAAL.Event.ListenEvent()
GRAAL.Utils.Logger("Graal trouvé !")