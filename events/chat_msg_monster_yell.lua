local LOCATIONS = GRAAL.Data.LOCATIONS
local EscapePattern = GRAAL.Utils.EscapePattern
local POIICON = GRAAL.Data.POIICON
local CreateTimer = GRAAL.Ui.CreateTimer
local REGISTERS = GRAAL.Event.registers
local GetBgBox = GRAAL.BG.AV.GetBgBox
local Get = GRAAL.Utils.Get
---

local ALLY = "Alliance"
local HORDE = "Horde"
local ATTACKING = "attaqué"
local SAVED = "sauvé"
local CAPTURED = "capturé"
local DESTOYED = "détruit"

local function IsAlly(message) return string.match(message, ALLY) or string.match(message, "Allliance") end
local function IsHorde(message) return string.match(message, HORDE) end

local function Who(message)
    if IsAlly(message) then return ALLY end
    if IsHorde(message) then return HORDE end
    return nil
end

local function IsAttackingLocation(message)
    return string.match(message, "Le (.+) est attaqu") or string.match(message, "La (.+) est attaqu") or
        string.match(message, "a pris le (.+) ! Si") -- dernier = cas du cimitiere des neiges
end
local function IsSavedLocation(message) return string.match(message, "Le (.+) est sauvé") end
local function IsCapturedLocation(message)
    return string.match(message, "Le (.+) a été pris") or
        string.match(message, "La (.+) a été prise")
end
local function IsDestroyedLocation(message)
    return string.match(message, "La (.+) a été détruite") or
        string.match(message, "Le (.+) a été détrui")
end

local function ParseHeraldMessage(message)
    local location
    local who = Who(message)

    location = IsAttackingLocation(message)
    if location then return location, ATTACKING, who end

    location = IsSavedLocation(message)
    if location then return location, SAVED, who end

    location = IsCapturedLocation(message)
    if location then return location, CAPTURED, who end

    location = IsDestroyedLocation(message)
    if location then return location, DESTOYED, who end

    return nil, nil, who
end

local function isExist(id) return GetBgBox().positionInformations.exist(id) end
local function isAttacked(action, avLocation)
    return action == ATTACKING and
        (not isExist(avLocation.id) or avLocation.id == "w1")
end
local function isSaved(action, avLocation) return action == SAVED and isExist(avLocation.id) end
local function isCaptured(action, avLocation) return action == CAPTURED and isExist(avLocation.id) end
local function isDestroyed(action, avLocation) return action == DESTOYED and isExist(avLocation.id) end

local function ChatHeraldAction(message)
    local location, action, who = ParseHeraldMessage(message)
    if location and action and who then
        local bgBox = GetBgBox()
        for _, avLocation in ipairs(LOCATIONS.AV) do
            local match = string.match(location, EscapePattern(avLocation.name))
            if match then
                if isAttacked(action, avLocation) then
                    local position = bgBox.positionInformations.nextPosition()
                    local icon = avLocation.poiicon
                    if avLocation.id == "w1" then
                        if who == HORDE then
                            icon = POIICON.GRAVEYARD_RED_INFORCE
                        else
                            icon = POIICON.GRAVEYARD_BLUE_INFORCE
                        end
                    end

                    if avLocation.id == "w1" and isExist(avLocation.id) then
                        Get(avLocation.id .. "timer").icon.texture:SetTexCoord(icon.l, icon.r, icon.t, icon.b)
                    else
                        bgBox.positionInformations.add(
                            CreateTimer({
                                text = avLocation.subname,
                                point = { xf = "TOPRIGHT", yf = "TOPRIGHT", x = position.x, y = position.y },
                                icon = icon,
                                isPoi = true,
                                name = avLocation.name,
                                id = avLocation.id,
                                frameParent = bgBox,
                                size = { w = 162, h = 18 }
                            })
                        )
                    end
                elseif isSaved(action, avLocation) or isCaptured(action, avLocation) or isDestroyed(action, avLocation) then
                    bgBox.positionInformations.remove(avLocation.id, bgBox)
                end
            end
        end
    end
end

local eventName = "CHAT_MSG_MONSTER_YELL"
local eventAction = function(message) ChatHeraldAction(message) end

table.insert(REGISTERS, { name = eventName, action = eventAction })
