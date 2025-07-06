-- CONFIG BUTTON
--local functionExample = function() print("test") end
--local configTextExample = {
--    frameParent= UIParent,
--    font= "GameFontHighlight",
--    point= { xf= "CENTER", yf= "CENTER", x= 0, y= 0 },
--    color=COLORS.WHITE,
--    hide=false
--}

GRAAL.Ui.CreateText = function(config)
    local text = config.frameParent:CreateFontString(nil, "OVERLAY", config.font)
    text:SetPoint(config.point.xf, config.frameParent, config.point.yf, config.point.x, config.point.y)
    if config.color then
        text:SetTextColor(config.color.r, config.color.g, config.color.b)
        text:SetShadowColor(0, 0, 0, 1)
        text:SetShadowOffset(1, -1)
    end
    if config.text then text:SetText(config.text) end
    if config.hide then text:Hide() end
    return text
end
