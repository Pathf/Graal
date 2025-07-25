local REGISTERS = GRAAL.Event.registers

local SetHonorGame = GRAAL.BG.Utils.SetHonorGame
local SetBgGame = GRAAL.BG.Utils.SetBgGame
local BgBox = GRAAL.BG.Utils.BgBox
---

local eventName = "UPDATE_BATTLEFIELD_STATUS"
local function eventAction()
    for i = 1, GetMaxBattlefieldID() do
        local status, mapName, instanceID = GetBattlefieldStatus(i) -- status, mapName, instanceID, queueID
        if status == "none" then                                    -- Battleground fini / plus de file d'attente
            BgBox().Reset()
        elseif status == "active" then                              -- Battleground en cours
            SetBgGame(instanceID, mapName)
        elseif status == "confirm" then                             -- Invité à rejoindre la bataille
            SetHonorGame()
            if ENV then Logger(mapName) end
        end
    end
end

table.insert(REGISTERS, { name = eventName, action = eventAction })
