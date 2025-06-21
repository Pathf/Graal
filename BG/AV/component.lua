local component = GRAAL.BG.AV.Component

local honor = GRAAL.Data.honor
local elapsed = GRAAL.Data.elapsed
local UNITS = GRAAL.Data.UNITS
local COLORS = GRAAL.Data.COLORS
local TARGETINGFRAME = GRAAL.Data.TARGETINGFRAME
local ICONS = GRAAL.Data.ICONS
local dataSaved = GRAAL.Data.saved

local Get = GRAAL.Utils.Get
local GetIcon = GRAAL.Utils.GetIcon
local GetTargetingFrame = GRAAL.Utils.GetTargetingFrame
local TableSize = GRAAL.Utils.TableSize
local Ternary = GRAAL.Utils.Ternary

local CreateButton = GRAAL.Ui.CreateButton

local GetTimeInBGString = GRAAL.BG.Utils.GetTimeInBGString
---

component.Reset = function()
    local frame = Get("BossBoxFrame")
    if frame then 
        frame:ClearAllPoints()
        frame:SetPoint("CENTER", UIParent, "TOPRIGHT", -10, -10) 
    end
    local reopenFrame = Get("ReopenAVB")
    if reopenFrame then 
        reopenFrame:ClearAllPoints()
        reopenFrame:SetPoint("CENTER", UIParent, "TOP", 0, -50) 
    end
end

component.SetHonorGame = function(honorBeforeGame)
    honorBeforeGame = honorBeforeGame or 0
    honor.duringGame = honorBeforeGame
    local frame = Get("BossBoxFrame")
    frame.honorDuringGame:SetText(honor.duringGame.." honors")
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
    frame.lockButton:SetNormalTexture(Ternary(locked, GetIcon(ICONS.CHEST_LOCK), GetIcon(ICONS.KEY)))
end

local function CheckRaiderView(boss, unitInfo)
    local bossName, bossSubName, frame = unitInfo.name, unitInfo.subname, unitInfo.frame
    local hp, maxHp, percentage = UnitHealth(boss), UnitHealthMax(boss), 100
    if maxHp and maxHp > 0 then percentage = hp / maxHp * 100 end
    frame.healthBar:SetMinMaxValues(0, maxHp)
    frame.healthBar:SetValue(hp)
    frame.text:SetText(GetIcon(unitInfo.icon, 'text') .. " -> " .. string.format("%s - %d%%", bossSubName, percentage))
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

local function CreateBossFrame(index, frameParent)
    frameParent = frameParent or UIParent
    local unitInfo = UNITS[index]
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
    frame.healthBar:SetStatusBarTexture(GetTargetingFrame(TARGETINGFRAME.STATUSBAR))
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
    frame.text:SetTextColor(COLORS.WHITE.r, COLORS.WHITE.g, COLORS.WHITE.b)
    frame.text:SetShadowColor(0, 0, 0, 1)
    frame.text:SetShadowOffset(1, -1)
    frame.text:SetText(GetIcon(ICONS.INTEROGATION, 'text').. " -> " .. subname)

    UNITS[index].frame = frame
end

local function CreateAllBossFrame(frameParent)
    local unitInfoListSize = TableSize(UNITS)
    for index, _ in ipairs(UNITS) do
        CreateBossFrame(index, frameParent)
    end
end

local function CreateAvBossMinimapButton(frame)
    local onEnter = function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("AV Boss Tracker")
        GameTooltip:AddLine("Clic gauche: Ouvrir/Fermer")
        GameTooltip:Show()
    end
    local onLeave = function() GameTooltip:Hide() end
    local onDragStart = function(self) self:StartMoving() end
    local onDragStop = function(self) self:StopMovingOrSizing() end
    local onClick = function(self, button) if button == "LeftButton" then if frame and frame:IsShown() then frame:Hide() else frame:Show() end end end
    local minimapButton = CreateButton({
      name= "AvBossMinimapButton",
      frameParent= Minimap,
      size= { w= 25, h= 25 },
      movable=true,
      point= { xf= "TOPLEFT", yf= "TOPLEFT", x= 0, y= 0 },
      icon= { name=ICONS.BANNER_HORDE, minimap=true },
      script= { onDragStart=onDragStart, onDragStop=onDragStop, onClick=onClick, onLeave=onLeave, onEnter=onEnter}, 
    })
end

component.CreateBossBox = function()
    local numberBoss = TableSize(UNITS)
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

    bossBoxFrame.title = bossBoxFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    bossBoxFrame.title:SetPoint("TOP", bossBoxFrame, "TOP", 0, -10)
    bossBoxFrame.title:SetText("AV - Boss")

    bossBoxFrame.honorDuringGame = bossBoxFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    bossBoxFrame.honorDuringGame:SetPoint("BOTTOMLEFT", bossBoxFrame, "BOTTOMLEFT", 15, 15)
    bossBoxFrame.honorDuringGame:SetTextColor(COLORS.YELLOW_TITLE.r, COLORS.YELLOW_TITLE.g, COLORS.YELLOW_TITLE.b)
    bossBoxFrame.honorDuringGame:SetShadowColor(0, 0, 0, 1)
    bossBoxFrame.honorDuringGame:SetShadowOffset(1, -1)
    bossBoxFrame.honorDuringGame:SetText(honor.duringGame.." honor")

    bossBoxFrame.timer = bossBoxFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    bossBoxFrame.timer:SetPoint("BOTTOMRIGHT", bossBoxFrame, "BOTTOMRIGHT", -15, 15)
    bossBoxFrame.timer:SetTextColor(COLORS.YELLOW_TITLE.r, COLORS.YELLOW_TITLE.g, COLORS.YELLOW_TITLE.b)
    bossBoxFrame.timer:SetShadowColor(0, 0, 0, 1)
    bossBoxFrame.timer:SetShadowOffset(1, -1)
    
    bossBoxFrame.closeButton = Get("BossBoxFrameClose")
    bossBoxFrame.closeButton:SetPoint("TOPRIGHT", bossBoxFrame, "TOPRIGHT", 2, 0)
    bossBoxFrame.closeButton:SetScript("OnClick", function(self) bossBoxFrame:Hide() end)

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
    
    CreateAllBossFrame(bossBoxFrame)
    CreateAvBossMinimapButton(bossBoxFrame)

    bossBoxFrame:SetScript("OnUpdate", function(self, delta)
        elapsed = elapsed + delta
        if elapsed >= 0.5 then
            for _,unitInfo in ipairs(UNITS) do 
                UpdateBossHealth(unitInfo)
            end
            elapsed = 0
            bossBoxFrame.timer:SetText(GetTimeInBGString())
        end
    end)
end