-- # TODO :
-- plus petit faire en sorte que quand on ajoute ou supprime edit la taille de la box général
-- faire une barre qui decremente pour les timers
-- customisation : faire en sort que le fond soit transparent
-- communication entre client pour actualisation des données
-- reprendre de capping et réarange le Time avant début de la game
-- reprendre le systeme de command dans le chat de capping
-- chef d'escadrille regarder pop

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
