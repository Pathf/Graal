-- En cours de dev :
-- - Cimetiere lieux d'interet → cimetiere des neiges non detecté
-- - plus petit

-- TODO :
-- - customisation

local ResetData = GRAAL.Data.ResetData
local POIIcon = GRAAL.Data.POIIcon

local Get = GRAAL.Utils.Get
local Logger = GRAAL.Utils.Logger

local CreateBossBox = GRAAL.BG.AV.CreateBossBox
local Reset = GRAAL.BG.AV.Component.Reset

local ListenEvent = GRAAL.Event.ListenEvent

---------------------------------------

Logger("Elle est où la poulette ?")
CreateBossBox()
ListenEvent()
Logger("Graal trouvé !")

local function test()
end
--test()