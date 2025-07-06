local LOCATIONS = GRAAL.Data.LOCATIONS
local REGISTERS = GRAAL.Event.registers
---

local eventName = "CHAT_MSG_BG_SYSTEM_HORDE"
local eventAction = function(message) 
    if string.match(message, LOCATIONS.AV[8].name) then 
        GetElementInTalbe(name, "CHAT_MSG_MONSTER_YELL", REGISTERS).action(message) 
    end 
end
table.insert(REGISTERS, { name=eventName, action=eventAction })