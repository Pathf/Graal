-- En cours de dev :
-- - plus petit

-- TODO :
-- - Cimetiere lieux d'interet + décompte
-- - customisation
-- - stat du honneur / temps

-- TODO mais compliqué :
-- - Taunted (UnitTarget pas pris en compte dans classic)

local ResetData = GRAAL.Data.ResetData

local Get = GRAAL.Utils.Get
local Logger = GRAAL.Utils.Logger

local CreateBossBox = GRAAL.BG.AV.Component.CreateBossBox
local Reset = GRAAL.BG.AV.Component.Reset

local ListenEvent = GRAAL.Event.ListenEvent
---------------------------------

local function AddResetAddonButton()
    local bossBoxFrame = Get("BossBoxFrame")
    bossBoxFrame.resetButton = CreateFrame("Button", nil, bossBoxFrame, "UIPanelButtonTemplate")
    bossBoxFrame.resetButton:SetSize(42, 18)
    bossBoxFrame.resetButton:SetPoint("TOPRIGHT", bossBoxFrame, "TOPRIGHT", -170, -6)
    bossBoxFrame.resetButton:SetText("Reset")
    bossBoxFrame.resetButton:SetScript("OnClick", function()
        ResetData()
        Reset()
        ReloadUI()
    end)
end

---------------------------------------

Logger("Elle est où la poulette ?")
CreateBossBox()
AddResetAddonButton()
ListenEvent()
Logger("Graal trouvé !")