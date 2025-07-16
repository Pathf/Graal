-- CONFIG ICON
--local configIconExample = {
--    icon= GRAAL.Data.ICONS.HUMAN.M, -- or GRAAL.Data.POIIcon.MINE -- *
--    isPoi= true,
--    point= { xf= "CENTER", yf= "TOP", x= 0, y= 0 },
--    name= "ExampleIcon",
--    frameParent= UIParent,
--    size= { w= 80, h= 20 },
--    hide=false
--}

GRAAL.Ui.CreateIcon = function(config)
    config.size = config.size or { w = 20, h = 20 }
    config.frameParent = config.frameParent or UIParent
    config.point = config.point or { xf = "CENTER", yf = "CENTER", x = 0, y = 0 }

    local icon = CreateFrame("Frame", config.name, config.frameParent)
    icon:SetSize(config.size.w, config.size.h)
    icon:SetPoint(config.point.xf, config.frameParent, config.point.yf, config.point.x, config.point.y)

    icon.name = config.name
    icon.texture = icon:CreateTexture(nil, "OVERLAY")
    icon.texture:SetAllPoints()
    if config.isPoi then
        icon.texture:SetTexture("Interface\\MINIMAP\\POIIcons")
        icon.texture:SetTexCoord(config.icon.l, config.icon.r, config.icon.t, config.icon.b)
    else
        icon.texture:SetTexture("Interface\\Icons\\" .. config.icon)
    end

    if config.hide then icon:Hide() else icon:Show() end
    return icon
end
