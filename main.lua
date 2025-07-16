-- # TODO :
-- Feature calendar affiché la date / heur de fin de l'event encour
-- faire une barre qui decremente pour les timers
-- customisation : faire en sort que le fond soit transparent
-- communication entre client pour actualisation des données
-- reprendre de capping et réarange le Time avant début de la game
-- reprendre le systeme de command dans le chat de capping
-- chef d'escadrille regarder pop (ambush eye icon)

local Logger = GRAAL.Utils.Logger
local ListenEvent = GRAAL.Event.ListenEvent
local CreateMinimapButton = GRAAL.Menu.CreateMinimapButton

---------------------------------------

Logger("Elle est où la poulette ?")
ListenEvent()
CreateMinimapButton()
