local AV = GRAAL.BG.AV

local TableSize = GRAAL.Utils.TableSize
local BARTYPE = GRAAL.Data.BARTYPE
---

local positionInformations

local function nextPosition()
    return {
        x = positionInformations.x,
        y = positionInformations.yMinInBox + (-18 * positionInformations.length)
    }
end

local function Add(bar)
    table.insert(positionInformations.current, { box = bar, name = bar.name })
    positionInformations.length = positionInformations.length + 1
end

local function Remove(id, frameParent)
    local oldIndex
    for index, element in ipairs(positionInformations.current) do
        if element.name == id then
            oldIndex = index
            element.box:Hide()
            table.remove(positionInformations.current, index)
            positionInformations.length = positionInformations.length - 1
            break
        end
    end
    for index, element in ipairs(positionInformations.current) do
        if oldIndex == index then
            local y = positionInformations.yMinInBox + (-18 * oldIndex)
            oldIndex = oldIndex + 1
            local boxTmp = element.box
            boxTmp:ClearAllPoints()
            boxTmp:SetPoint("TOPRIGHT", frameParent, "TOPRIGHT", positionInformations.x, y)
        end
    end
end

local function IsExist(name)
    for _, element in ipairs(positionInformations.current) do
        if element.name == name then return true end
    end
    return false
end

local function RemoveAll()
    local numberRemove = TableSize(positionInformations.current)
    for index = 0, numberRemove do
        if index == numberRemove then break end
        local element = positionInformations.current[numberRemove - index]
        element.box:Hide()
        if element.box.type == BARTYPE.TIMER then element.box:SetScript("OnUpdate", nil) end
        table.remove(positionInformations.current, numberRemove - index)
        positionInformations.length = positionInformations.length - 1
    end
    return numberRemove * -1
end

local function isEmpty()
    return positionInformations.length <= 1
end

AV.CreatePositionInformations = function()
    positionInformations = { x = -8, yMinInBox = -7, current = {}, length = 1 }
    positionInformations.nextPosition = nextPosition
    positionInformations.Add = Add
    positionInformations.Remove = Remove
    positionInformations.IsExist = IsExist
    positionInformations.RemoveAll = RemoveAll
    positionInformations.isEmpty = isEmpty
    return positionInformations
end
