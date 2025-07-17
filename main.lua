-- # TODO :
-- reprendre de capping et réarange le Time avant début de la game
-- faire une barre qui decremente pour les timers
-- reprendre le systeme de command dans le chat de capping
-- afficher combien il manque pour le prochain palier
-- customisation : faire en sort que le fond soit transparent
-- communication entre client pour actualisation des données

local Logger = GRAAL.Utils.Logger
local ListenEvent = GRAAL.Event.ListenEvent
local CreateMinimapButton = GRAAL.Menu.CreateMinimapButton

---------------------------------------

Logger("Elle est où la poulette ?")
ListenEvent()
CreateMinimapButton()
