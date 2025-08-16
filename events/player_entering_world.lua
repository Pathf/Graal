local REGISTERS = GRAAL.Event.registers
---

local eventName = "PLAYER_ENTERING_WORLD"
local eventAction = function() GRAAL.Data.timeSinceCreatePlayer = GetTime() end

table.insert(REGISTERS, { name = eventName, action = eventAction })
