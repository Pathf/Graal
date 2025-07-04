local event = GRAAL.Event

local dataSaved = GRAAL.Data.saved
local honor = GRAAL.Data.honor
local units = GRAAL.Data.UNITS
local ICONS = GRAAL.Data.ICONS
local LOCATIONS = GRAAL.Data.LOCATIONS

local Get = GRAAL.Utils.Get
local GetIcon = GRAAL.Utils.GetIcon
local EscapePattern = GRAAL.Utils.EscapePattern

local SetHonorGame = GRAAL.BG.Utils.SetHonorGame
---

local logoutEvent = "PLAYER_LOGOUT"
local function SaveBeforeLogout() AVBossTrackerSaved = dataSaved end
local function LogoutAction() SaveBeforeLogout() end

local bgStatusEvent = "UPDATE_BATTLEFIELD_STATUS"
local function resetBarAndTimer()
    for index, unitInfo in ipairs(units) do
        local frame = Get(unitInfo.name.."HealthFrame")
        frame.healthBar:SetMinMaxValues(0, 100)
        frame.healthBar:SetValue(100)
        frame.text:SetText(GetIcon(ICONS.INTEROGATION, 'text').." -> " .. unitInfo.subname)
    end
    Get("BossBoxFrame").positionInformations.removeAll()
end
local function BgStatusAction()
    for i = 1, GetMaxBattlefieldID() do
        local status = GetBattlefieldStatus(i)
        if status == "none" then resetBarAndTimer()  -- Battleground fini / plus de file d'attente
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

local function isExist(id) return Get("BossBoxFrame").positionInformations.exist(id) end
local function isAttacked(action, avLocation) return action == "attaqué" and not isExist(avLocation.id) end
local function isSaved(action, avLocation) return action == "sauvé" and isExist(avLocation.id) end
local function isCaptured(action, avLocation) return action == "capturé" and isExist(avLocation.id) end
local function isDestroyed(action, avLocation) return action == "détruit" and isExist(avLocation.id) end

local function ChatHeraldAction(message)
    local location, action, who = ParseHeraldMessage(message)
    if location and action and who then
        local bossBoxFrame = Get("BossBoxFrame")
        for index, avLocation in ipairs(LOCATIONS.AV) do 
            local match = string.match(location, EscapePattern(avLocation.name))
            if match then
                if isAttacked(action, avLocation) then
                    local position = bossBoxFrame.positionInformations.nextPosition()
                    bossBoxFrame.positionInformations.add(
                        GRAAL.Ui.CreateTimer({ 
                            text=avLocation.subname, 
                            point={ xf="TOPLEFT", yf="TOPLEFT", x=position.x, y=position.y }, 
                            icon=avLocation.poiicon, 
                            isPoi=true, 
                            name=avLocation.name,
                            id=avLocation.id,
                            frameParent=bossBoxFrame
                        })
                    )
                elseif isSaved(action, avLocation) or isCaptured(action, avLocation) or isDestroyed(action, avLocation) then 
                    bossBoxFrame.positionInformations.remove(avLocation.id, bossBoxFrame)
                end
            end
        end
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