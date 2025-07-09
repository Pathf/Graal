local AV = GRAAL.BG.AV
---

local positionInformations

local function nextPosition()
    return {
        x = positionInformations.x,
        y = positionInformations.yMinInBox + (-18 * positionInformations.length)
    }
end

local function add(bar)
    table.insert(positionInformations.current, { box = bar, name = bar.name })
    positionInformations.length = positionInformations.length + 1
end

local function remove(id, frameParent)
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

local function exist(name)
    for _, element in ipairs(positionInformations.current) do
        if element.name == name then return true end
    end
    return false
end

local function removeAll()
    for _, element in ipairs(positionInformations.current) do
        element.box:Hide()
    end
    positionInformations.current = {}
    positionInformations.length = 1
end

local function isEmpty()
    return positionInformations.length <= 1
end

AV.CreatePositionInformations = function()
    positionInformations = { x = -8, yMinInBox = -7, current = {}, length = 1 }
    positionInformations.nextPosition = nextPosition
    positionInformations.add = add
    positionInformations.remove = remove
    positionInformations.exist = exist
    positionInformations.removeAll = removeAll
    positionInformations.isEmpty = isEmpty
    return positionInformations
end
