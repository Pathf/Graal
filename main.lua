-- # TODO :
-- plus petit faire en sorte que quand arrivé à 0% les barres disparaise
-- faire une barre qui decremente pour les timers
-- customisation : faire en sort que le fond soit transparent
-- communication entre client pour actualisation des données
-- reprendre de capping et réarange le Time avant début de la game
-- reprendre le systeme de command dans le chat de capping

local Logger = GRAAL.Utils.Logger
local CreateAvBox = GRAAL.BG.AV.CreateAvBox
local ListenEvent = GRAAL.Event.ListenEvent
local CreateMinimapButton = GRAAL.Menu.CreateMinimapButton

---------------------------------------

Logger("Elle est où la poulette ?")
CreateAvBox()
ListenEvent()
CreateMinimapButton()
Logger("Graal trouvé ! (version: ", VERSION, ")")
