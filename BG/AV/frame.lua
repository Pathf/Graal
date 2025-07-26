local BgBox = GRAAL.BG.Utils.BgBox
local AV_BOX = GRAAL.BG.Data.NAMEFRAME.AV.BOX
local CreatePositionInformations = GRAAL.BG.AV.CreatePositionInformations
local CreateAllBossBar = GRAAL.BG.AV.CreateAllBossBar
local CreateAllChief = GRAAL.BG.AV.CreateAllChief
local ELAPSED = GRAAL.Data.elapsed
local AddTimer = GRAAL.BG.AV.AddTimer
---

local avFrame

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

local function Resize(barNumber)
    local bgBox = BgBox()
    bgBox.AddHeightBox(18 * barNumber)
    avFrame:SetSize(180, bgBox:GetHeight() - 58)
end

local function AddBar(bar)
    avFrame.positionInformations.Add(bar)
    Resize(1)
end

local function ShowBody()
    avFrame:Show()
    avFrame.ResetAllBossBar(avFrame)
    avFrame.ResetAllChiefIcons(avFrame.chiefIcons)
    avFrame:SetScript("OnUpdate", OnUpdate)
end

local function HideBody()
    avFrame:SetScript("OnUpdate", nil)
    Resize(avFrame.positionInformations.RemoveAll())
    avFrame:Hide()
end

local function Update()
    avFrame.UpdateAllBossHealth(avFrame)
    avFrame.UpdateChief(avFrame.chiefIcons)
    BgBox().UpdateTime()
end

local function isBarExist(id)
    return avFrame.positionInformations.IsExist(id)
end

local function RemoveBar(name)
    if isBarExist(name) then
        avFrame.positionInformations.Remove(name, avFrame)
        Resize(-1)
    end
end

GRAAL.BG.AV.CreateAVFrame = function()
    CreateBox()
    avFrame.positionInformations = CreatePositionInformations()

    avFrame.Resize = Resize
    avFrame.AddBar = AddBar

    avFrame.bossBars = CreateAllBossBar(avFrame)
    avFrame.chiefIcons = CreateAllChief(avFrame)

    avFrame.ShowBody = ShowBody
    avFrame.HideBody = HideBody
    avFrame.Update = Update
    avFrame.RemoveBar = RemoveBar
    avFrame.isBarExist = isBarExist
    avFrame.AddTimer = AddTimer

    avFrame.HideBody()
    return avFrame
end
