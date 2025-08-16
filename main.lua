-- # TODO :
-- reprendre le systeme de command dans le chat de capping
-- afficher combien il manque pour le prochain palier
-- customisation : faire en sort que le fond soit transparent
-- communication entre client pour actualisation des données
-- faire en sorte que le chef de la horde pop quand il se fait attaquer et disparisse des le wipe
-- date de fin d'event

-- WS :
-- state de la personne qui porte le drapeau (buf pour detecter) /
-- Timing de repop du drapeau
-- recap des points dans la fenetre

-- Arathi :
--


-- WTF : C:\Users\<user>\Documents\My Games\battle.net\World of Warcraft\_classic_era_\WTF

local i18n = GRAAL.I18N.transform
local Logger = GRAAL.Utils.Logger
local ListenEvent = GRAAL.Event.ListenEvent
local CreateMinimapButton = GRAAL.Menu.CreateMinimapButton

---------------------------------------

Logger(i18n("Elle est où la poulette ?"))
ListenEvent()
CreateMinimapButton()
