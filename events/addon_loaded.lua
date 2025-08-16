local ADDONNAME = 'Graal'
local REGISTERS = GRAAL.Event.registers
local Logger = GRAAL.Utils.Logger
local CreateBgBox = GRAAL.BG.CreateBgBox
local i18n = GRAAL.I18N.transform
---

local eventName = "ADDON_LOADED"
local eventAction = function(name)
    if name == ADDONNAME then
        --GRAALSAVED.counter = (GRAALSAVED.counter or 0) + 1
        --print("Tu as chargé", ADDONNAME, GRAALSAVED.counter, "fois.")
        Logger(i18n("Graal trouvé ! (version : {1})", VERSION))
        CreateBgBox()
    end
end

table.insert(REGISTERS, { name = eventName, action = eventAction })
