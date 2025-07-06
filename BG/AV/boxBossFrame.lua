local av = GRAAL.BG.AV

local honor = GRAAL.Data.honor
local elapsed = GRAAL.Data.elapsed
local UNITS = GRAAL.Data.UNITS
local COLORS = GRAAL.Data.COLORS
local ICONS = GRAAL.Data.ICONS
local dataSaved = GRAAL.Data.saved

local Get = GRAAL.Utils.Get
local GetIcon = GRAAL.Utils.GetIcon
local TableSize = GRAAL.Utils.TableSize
local Ternary = GRAAL.Utils.Ternary

local CreateButton = GRAAL.Ui.CreateButton
local CreateText = GRAAL.Ui.CreateText

local GetTimeInBGString = GRAAL.BG.Utils.GetTimeInBGString
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

local function CreateCloseButton(bossBoxFrame)
    local closeButton = Get("BossBoxFrameClose")
    closeButton:SetPoint("TOPRIGHT", bossBoxFrame, "TOPRIGHT", 2, 0)
    closeButton:SetScript("OnClick", function(self) bossBoxFrame:Hide() end)
end

local function CreateLockButton(frame, frameState)
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

local function CreateHonorDuringGame(frame)
    local honorDuring = CreateText({
        frameParent = frame,
        font = "GameFontHighlight",
        point = { xf = "BOTTOMLEFT", yf = "BOTTOMLEFT", x = 15, y = 15 },
        color = COLORS.YELLOW_TITLE,
        text = "Honor: " .. honor.duringGame,
        hide = false
    })
    honorDuring:SetScript("OnEnter", function(self)
        local timeSinceStartSession = GRAAL.Utils.BuildTime(GRAAL.Utils.timeSession())
        local honorPerHour = honor.session / Ternary(timeSinceStartSession.hours > 1, timeSinceStartSession.hours, 1)
        local honorWeek = Get("HonorFrameThisWeekContributionValue"):GetText()
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Honor stats", 1, 1, 1)
        GameTooltip:AddLine("Honor week: " .. honorWeek, 0.8, 0.8, 0.8)
        GameTooltip:AddLine("Honor/h: " .. honorPerHour, 0.8, 0.8, 0.8)
        GameTooltip:AddLine("Elapsed time: " .. timeSinceStartSession.inText(), 0.8, 0.8, 0.8)
        GameTooltip:Show()
    end)
    honorDuring:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
    return honorDuring
end

local function CreatePastTimer(frame)
    return CreateText({
        frameParent = frame,
        font = "GameFontHighlight",
        point = { xf = "BOTTOMRIGHT", yf = "BOTTOMRIGHT", x = -15, y = 15 },
        color = COLORS.YELLOW_TITLE,
        hide = false
    })
end

local function CreateTitle(frame)
    return CreateText({
        frameParent = frame,
        font = "GameFontNormal",
        point = { xf = "TOP", yf = "TOP", x = 0, y = -10 },
        text = "Alterac Valley"
    })
end

local function CheckRaiderView(boss, unitInfo)
    local bossSubName, frame = unitInfo.subname, unitInfo.frame
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

local function CreatePositionInformations()
    local positionInformations = { x = 45, yMinInBox = -250, current = {}, length = 0 }
    positionInformations.nextPosition = function()
        return {
            x = positionInformations.x,
            y = positionInformations.yMinInBox + (-14 * positionInformations.length)
        }
    end
    positionInformations.add = function(timerOrBoss)
        table.insert(positionInformations.current, { box = timerOrBoss, name = timerOrBoss.name })
        positionInformations.length = positionInformations.length + 1
    end
    positionInformations.remove = function(id, frameParent)
        local oldIndex
        for index, element in ipairs(positionInformations.current) do
            if element.name == id then
                oldIndex = index
                element.box:Hide()
                table.remove(positionInformations.current, index)
                break
            end
        end
        for index, element in ipairs(positionInformations.current) do
            if oldIndex == index then
                local y = positionInformations.yMinInBox + (-14 * (oldIndex - 1))
                oldIndex = oldIndex + 1
                local boxTmp = element.box
                boxTmp:ClearAllPoints()
                boxTmp:SetPoint("TOPLEFT", frameParent, "TOPLEFT", positionInformations.x, y)
            end
        end
        positionInformations.length = positionInformations.length - 1
    end
    positionInformations.exist = function(name)
        for index, element in ipairs(positionInformations.current) do
            if element.name == name then return true end
        end
        return false
    end
    positionInformations.removeAll = function()
        for index, element in ipairs(positionInformations.current) do
            element.box:Hide()
        end
        positionInformations.current = {}
        positionInformations.length = 0
    end
    return positionInformations
end

av.GetBgBox = function() return Get("BossBoxFrame") end

av.CreateBossBox = function()
    local numberBoss = TableSize(UNITS)
    local heightFrame = (numberBoss * 20) + 32 + 120
    local bossBoxPosition = Ternary(dataSaved["bossBoxPosition"], dataSaved["bossBoxPosition"],
        { x = -10, y = -10, locked = false })
    dataSaved["bossBoxPosition"] = bossBoxPosition

    local bossBoxFrame = CreateFrame("Frame", "BossBoxFrame", UIParent, "UIPanelDialogTemplate")
    bossBoxFrame:SetSize(180, heightFrame)
    bossBoxFrame:SetPoint("CENTER", UIParent, "TOPRIGHT", bossBoxPosition.x, bossBoxPosition.y)
    bossBoxFrame:SetMovable(true)
    bossBoxFrame:SetClampedToScreen(true)
    bossBoxFrame:SetFrameStrata("MEDIUM")
    bossBoxFrame:SetFrameLevel(5)

    bossBoxFrame.title = CreateTitle(bossBoxFrame)
    bossBoxFrame.honorDuringGame = CreateHonorDuringGame(bossBoxFrame)
    bossBoxFrame.timer = CreatePastTimer(bossBoxFrame)
    bossBoxFrame.closeButton = CreateCloseButton(bossBoxFrame)
    bossBoxFrame.lockButton = CreateLockButton(bossBoxFrame, bossBoxPosition)
    bossBoxFrame.positionInformations = CreatePositionInformations()

    GRAAL.BG.AV.CreateAllBossFrame(bossBoxFrame)

    bossBoxFrame:SetScript("OnUpdate", function(self, delta)
        elapsed = elapsed + delta
        if elapsed >= 0.5 then
            for _, unitInfo in ipairs(UNITS) do
                UpdateBossHealth(unitInfo)
            end
            bossBoxFrame.timer:SetText(GetTimeInBGString())

            elapsed = 0
        end
    end)
end
