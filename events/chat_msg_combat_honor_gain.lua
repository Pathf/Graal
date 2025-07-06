local HONOR = GRAAL.Data.honor
local SetHonorGame = GRAAL.BG.Utils.SetHonorGame
local REGISTERS = GRAAL.Event.registers
---

local function RefreshHonorDuringGame(honorMessage)
    local newHonor = string.match(honorMessage, "(%d+) points? d'honneur.") or
        string.match(honorMessage, "Points? d'honneur estimés : (%d+)")
    if newHonor then
        SetHonorGame(HONOR.duringGame + tonumber(newHonor))
        HONOR.session = HONOR.session + tonumber(newHonor)
    end
end

local eventName = "CHAT_MSG_COMBAT_HONOR_GAIN"
local eventAction = function(message) RefreshHonorDuringGame(message) end

table.insert(REGISTERS, { name = eventName, action = eventAction })
