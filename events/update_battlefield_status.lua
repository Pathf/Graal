local SetHonorGame = GRAAL.BG.Utils.SetHonorGame
local SetBgGame = GRAAL.BG.Utils.SetBgGame
local REGISTERS = GRAAL.Event.registers
local ResetBGBox = GRAAL.BG.Utils.Reset
---

local eventName = "UPDATE_BATTLEFIELD_STATUS"
local function eventAction()
    for i = 1, GetMaxBattlefieldID() do
        local status, _, instanceID = GetBattlefieldStatus(i)
        if status == "none" then        -- Battleground fini / plus de file d'attente
            ResetBGBox()
        elseif status == "active" then  -- Battleground en cours
            SetBgGame(instanceID)
        elseif status == "confirm" then -- Invité à rejoindre la bataille
            SetHonorGame()
        end
    end
end

table.insert(REGISTERS, { name = eventName, action = eventAction })
