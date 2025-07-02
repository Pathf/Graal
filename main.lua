-- En cours de dev :
-- - Cimetiere lieux d'interet + décompte
-- - plus petit

-- TODO :
-- - customisation
-- - stat du honneur / temps

-- TODO mais compliqué :
-- - Taunted (UnitTarget pas pris en compte dans classic)

local ResetData = GRAAL.Data.ResetData
local POIIcon = GRAAL.Data.POIIcon

local Get = GRAAL.Utils.Get
local Logger = GRAAL.Utils.Logger

local CreateBossBox = GRAAL.BG.AV.CreateBossBox
local Reset = GRAAL.BG.AV.Component.Reset

local ListenEvent = GRAAL.Event.ListenEvent

---------------------------------------

Logger("Elle est où la poulette ?")
CreateBossBox()
ListenEvent()
Logger("Graal trouvé !")

local function CreatePOIIcon(name, parent, texturePath, x, y)
    local icon = CreateFrame("Frame", name, parent or UIParent)
    icon:SetSize(200, 200)
    icon:SetPoint("CENTER", UIParent, "CENTER", x or 0, y or 0)

    local texture = icon:CreateTexture(nil, "OVERLAY")
    texture:SetAllPoints()
    texture:SetTexture(texturePath or "Interface\\WorldMap\\Skull_64")
    
    
    icon.texture = texture
    
    icon:Show()
    return icon
end

local function test()
    local frostwolfGraveyardIcon = CreatePOIIcon(
        "FrostwolfGYIcon",
        UIParent,
        "Interface\\MINIMAP\\POIIcons", -- Atlas contenant plein d'icônes minimap
        100, 0 -- Position en X/Y
    )
    local tmp = POIIcon.a
    frostwolfGraveyardIcon.texture:SetTexCoord(tmp.l, tmp.r, tmp.t, tmp.b) -- left, right, top, bottom

    local tfrostwolfGraveyardIcon = CreatePOIIcon(
        "FrostwolfGYIcon",
        UIParent,
        "Interface\\MINIMAP\\POIIcons", -- Atlas contenant plein d'icônes minimap
        -150, 0 -- Position en X/Y
    )
end

--test()