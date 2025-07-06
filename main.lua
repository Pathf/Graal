-- # TODO :
-- plus petit faire en sorte que quand arrivé à 0% les barres disparaise
-- faire une barre qui decremente pour les timers
-- customisation : faire en sort que le fond soit transparent
-- communication entre client pour actualisation des données
-- reprendre et réarange le Time avant début de la game

local Logger = GRAAL.Utils.Logger
local CreateBossBox = GRAAL.BG.AV.CreateBossBox
local ListenEvent = GRAAL.Event.ListenEvent
local CreateMinimapButton = GRAAL.Menu.CreateMinimapButton

---------------------------------------

Logger("Elle est où la poulette ?")
CreateBossBox()
ListenEvent()
CreateMinimapButton()
Logger("Graal trouvé ! (version: ", GetAddOnMetadata('Graal', 'version'), ")")
