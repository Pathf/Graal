-- # TODO :
-- plus petit faire en sorte que quand arrivé à 0% les barres disparaise
-- faire une barre qui decremente pour les timers
-- customisation : faire en sort que le fond soit transparent

local Logger = GRAAL.Utils.Logger
local CreateBossBox = GRAAL.BG.AV.CreateBossBox
local ListenEvent = GRAAL.Event.ListenEvent

---------------------------------------

Logger("Elle est où la poulette ?")
CreateBossBox()
ListenEvent()
Logger("Graal trouvé !")