local event = GRAAL.Event

local dataSaved = GRAAL.Data.saved
local honor = GRAAL.Data.honor
local units = GRAAL.Data.UNITS
local ICONS = GRAAL.Data.ICONS

local Get = GRAAL.Utils.Get
local GetIcon = GRAAL.Utils.GetIcon

local SetHonorGame = GRAAL.BG.Utils.SetHonorGame
---

local logoutEvent = "PLAYER_LOGOUT"
local function SaveBeforeLogout() AVBossTrackerSaved = dataSaved end
local function LogoutAction() SaveBeforeLogout() end

local bgStatusEvent = "UPDATE_BATTLEFIELD_STATUS"
local function resetHpBar()
    for index, unitInfo in ipairs(units) do
        local frame = Get(unitInfo.name.."HealthFrame")
        frame.healthBar:SetMinMaxValues(0, 100)
        frame.healthBar:SetValue(100)
        frame.text:SetText(GetIcon(ICONS.INTEROGATION, 'text').." -> " .. unitInfo.subname)
    end
end
local function BgStatusAction()
    for i = 1, GetMaxBattlefieldID() do
        local status = GetBattlefieldStatus(i)
        if status == "none" then resetHpBar()  -- Battleground fini / plus de file d'attente
        elseif status == "active" then -- Battleground en cours
        elseif status == "confirm" then SetHonorGame() -- Invité à rejoindre la bataille
        end
    end
end

local chatHonorEvent = "CHAT_MSG_COMBAT_HONOR_GAIN"
local function RefreshHonorDuringGame(honorMessage)
    local newHonor = string.match(honorMessage, "(%d+) points? d'honneur.") or string.match(honorMessage, "Points? d'honneur estimés : (%d+)") 
    if newHonor then SetHonorGame(honor.duringGame + tonumber(newHonor)) end
end
local function ChatHonorAction(message) RefreshHonorDuringGame(message) end

local chatHerald = "CHAT_MSG_MONSTER_YELL"

local function Who(message)
    if string.match(message, "Alliance") or string.match(message, "Allliance") then return "Alliance" end
    if string.match(message, "Horde") then return "Horde" end
    return nil
end

local function ParseHeraldMessage(message)
    local location, action
    local who = Who(message)

    location = string.match(message, "Le (.+) est attaqu") or string.match(message, "La (.+) est attaqu")
    if location then return location, "attaqué", who end

    location = string.match(message, "Le (.+) est sauvé")
    if location then return location, "sauvé", who end

    location = string.match(message, "Le (.+) a été pris") or string.match(message, "La (.+) a été prise")
    if location then return location, "capturé", who end

    location = string.match(message, "La (.+) a été détruite") or string.match(message, "Le (.+) a été détrui")
    if location then return location, "détruit", who end

    return nil, nil, who
end

local function ChatHeraldAction(message)
    local location, action, who = ParseHeraldMessage(message)
    if location and action and who then 
        --GRAAL.Utils.Logger(location .. " - " .. action .. " - " .. who)
        -- declencheur de la création de la bar
    end
end

event.ListenEvent = function()
    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent(logoutEvent)
    eventFrame:RegisterEvent(bgStatusEvent)
    eventFrame:RegisterEvent(chatHonorEvent)
    eventFrame:RegisterEvent(chatHerald)

    eventFrame:SetScript("OnEvent", function(self, event, message)
        if event == logoutEvent then LogoutAction()
        elseif event == bgStatusEvent then BgStatusAction()
        elseif event == chatHonorEvent then ChatHonorAction(message)
        elseif event == chatHerald then ChatHeraldAction(message, event)
        end
    end)
end