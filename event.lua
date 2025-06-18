local event = GRAAL.Event

local dataSaved = GRAAL.Data.saved
local honor = GRAAL.Data.honor
local units = GRAAL.Data.UNITS
local ICONS = GRAAL.Data.ICONS

local Get = GRAAL.Utils.Get

local SetHonorGame = GRAAL.BG.AV.Component.SetHonorGame
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
        frame.text:SetText(GetIconText(ICONS.INTEROGATION).." -> " .. unitInfo.subname)
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

event.ListenEvent = function()
    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent(logoutEvent)
    eventFrame:RegisterEvent(bgStatusEvent)
    eventFrame:RegisterEvent(chatHonorEvent)

    eventFrame:SetScript("OnEvent", function(self, event, message)
        if event == logoutEvent then LogoutAction()
        elseif event == bgStatusEvent then BgStatusAction()
        elseif event == chatHonorEvent then ChatHonorAction(message)
        end
    end)
end