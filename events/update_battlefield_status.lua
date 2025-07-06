local units = GRAAL.Data.UNITS
local ICONS = GRAAL.Data.ICONS
local Get = GRAAL.Utils.Get
local GetIcon = GRAAL.Utils.GetIcon
local SetHonorGame = GRAAL.BG.Utils.SetHonorGame
local SetBgGame = GRAAL.BG.Utils.SetBgGame
local REGISTERS = GRAAL.Event.registers
local GetBgBox = GRAAL.BG.AV.GetBgBox
---

local function ResetBGBox()
    for _, unitInfo in ipairs(units) do
        local frame = Get(unitInfo.name .. "HealthFrame")
        frame.healthBar:SetMinMaxValues(0, 100)
        frame.healthBar:SetValue(100)
        frame.text:SetText(GetIcon(ICONS.INTEROGATION, 'text') .. " -> " .. unitInfo.subname)
    end
    local box = GetBgBox()
    box.positionInformations.removeAll()
    box.title:SetText("AV - Boss")
end

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
