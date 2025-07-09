local AV = GRAAL.BG.AV

local CreateHonorDuringGame = GRAAL.BG.AV.CreateHonorDuringGame
local CreateLockButton = GRAAL.BG.AV.CreateLockButton
local CreatePositionInformations = GRAAL.BG.AV.CreatePositionInformations
local OnUpdate = GRAAL.BG.AV.OnUpdate
local CreateAllBossBar = GRAAL.BG.AV.CreateAllBossBar
local UNITS = GRAAL.Data.UNITS
local COLORS = GRAAL.Data.COLORS
local dataSaved = GRAAL.Data.saved
local Get = GRAAL.Utils.Get
local TableSize = GRAAL.Utils.TableSize
local Ternary = GRAAL.Utils.Ternary
local CreateText = GRAAL.Ui.CreateText
---

local function CreateCloseButton(bossBoxFrame)
    local closeButton = Get("BossBoxFrameClose")
    closeButton:SetPoint("TOPRIGHT", bossBoxFrame, "TOPRIGHT", 2, 0)
    closeButton:SetScript("OnClick", function() bossBoxFrame:Hide() end)
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

AV.GetBgBox = function() return Get("BossBoxFrame") end
AV.CreateAvBox = function()
    local numberBoss = TableSize(UNITS)
    local heightFrame = (numberBoss * 20) + 32 + 120
    local bossBoxPosition = Ternary(dataSaved["bossBoxPosition"], dataSaved["bossBoxPosition"],
        { x = -10, y = -10, locked = false })
    dataSaved["bossBoxPosition"] = bossBoxPosition

    local avBox = CreateFrame("Frame", "BossBoxFrame", UIParent, "UIPanelDialogTemplate")
    avBox:SetSize(180, heightFrame)
    avBox:SetPoint("CENTER", UIParent, "TOPRIGHT", bossBoxPosition.x, bossBoxPosition.y)
    avBox:SetMovable(true)
    avBox:SetClampedToScreen(true)
    avBox:SetFrameStrata("MEDIUM")
    avBox:SetFrameLevel(5)

    avBox.title = CreateTitle(avBox)
    avBox.honorDuringGame = CreateHonorDuringGame(avBox)
    avBox.timer = CreatePastTimer(avBox)
    avBox.closeButton = CreateCloseButton(avBox)
    avBox.lockButton = CreateLockButton(avBox, bossBoxPosition)
    avBox.positionInformations = CreatePositionInformations()
    avBox.resetAllBossBar = function() CreateAllBossBar(avBox) end

    --avBox.bossBars = GRAAL.BG.AV.CreateAllBossBar(avBox)
    CreateAllBossBar(avBox)

    avBox:SetScript("OnUpdate", OnUpdate)
end
