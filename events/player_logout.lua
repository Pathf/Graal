local REGISTERS = GRAAL.Event.registers
local dataSaved = GRAAL.Data.saved
---

local function SaveBeforeLogout() AVBossTrackerSaved = dataSaved end

local eventAction = function() SaveBeforeLogout() end
local eventName = "PLAYER_LOGOUT"

table.insert(REGISTERS, { name = eventName, action = eventAction })
