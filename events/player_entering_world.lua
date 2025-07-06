local TIME_SINCE_CREATE_PLAYER = GRAAL.Data.timeSinceCreatePlayer
local REGISTERS = GRAAL.Event.registers
---

local eventName = "PLAYER_ENTERING_WORLD"
local eventAction = function() TIME_SINCE_CREATE_PLAYER = GetTime() end

table.insert(REGISTERS, { name = eventName, action = eventAction })
