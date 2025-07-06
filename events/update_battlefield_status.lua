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
    for index, unitInfo in ipairs(units) do
        local frame = Get(unitInfo.name.."HealthFrame")
        frame.healthBar:SetMinMaxValues(0, 100)
        frame.healthBar:SetValue(100)
        frame.text:SetText(GetIcon(ICONS.INTEROGATION, 'text').." -> " .. unitInfo.subname)
    end
    local box = GetBgBox()
    box.positionInformations.removeAll()
    box.title:SetText("AV - Boss")
end

local eventName = "UPDATE_BATTLEFIELD_STATUS"
local function eventAction()
    for i = 1, GetMaxBattlefieldID() do
        local status, mapName, instanceID = GetBattlefieldStatus(i)
        if status == "none" then ResetBGBox()  -- Battleground fini / plus de file d'attente
        elseif status == "active" then SetBgGame(instanceID) -- Battleground en cours
        elseif status == "confirm" then SetHonorGame() -- Invité à rejoindre la bataille
        end
    end
end

table.insert(REGISTERS, { name=eventName, action=eventAction })