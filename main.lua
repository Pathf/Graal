-- # TODO :
-- reprendre le systeme de command dans le chat de capping
-- afficher combien il manque pour le prochain palier
-- customisation : faire en sort que le fond soit transparent
-- communication entre client pour actualisation des données
-- faire en sorte que le chef de la horde pop quand il se fait attaquer et disparisse des le wipe

-- WTF : C:\Users\<user>\Documents\My Games\battle.net\World of Warcraft\_classic_era_\WTF

local Logger = GRAAL.Utils.Logger
local ListenEvent = GRAAL.Event.ListenEvent
local CreateMinimapButton = GRAAL.Menu.CreateMinimapButton

---------------------------------------

Logger("Elle est où la poulette ?")
ListenEvent()
CreateMinimapButton()
