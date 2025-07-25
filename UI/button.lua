-- CONFIG BUTTON
--local functionExample = function() print("test") end
--local configButtonExample = {
--    frameParent = UIParent,                         -- *
--    point = { xf = "CENTER", yf = "TOP", x = 0, y = 0 }, -- *
--    name = "ExampleButton",
--    template = "UIPanelButtonTemplate",
--    size = { w = 80, h = 20 },
--    movable = true,
--    text = "ExampleText",
--    icon = { name = "achievement_pvp_a_01", minimap = true },
--    script = {
--        onDragStart = functionExample,
--        stop = functionExample,
--        onClick = functionExample,
--        onEnter = functionExample,
--        onLeave = functionExample
--    },
--    hide = false
--}

local function CreateFrameForButton(name, frameParent, template)
    if template then
        return CreateFrame("Button", name, frameParent, template)
    else
        return CreateFrame("Button", name, frameParent)
    end
end

local function ConfSize(button, size)
    size = size or { w = 80, h = 20 }
    button:SetSize(size.w, size.h)
end

local function ConfPoint(button, frameParent, point)
    point = point or { xf = "CENTER", yf = "CENTER", x = 0, y = 0 }
    button:SetPoint(point.xf, frameParent, point.yf, point.x, point.y)
end

local function ConfMovable(button, movable)
    if movable then
        button:SetMovable(true)
        button:SetClampedToScreen(true)
        button:EnableMouse(true)
        button:RegisterForDrag("LeftButton")
    end
end

local function ConfScript(button, script)
    if script then
        button:RegisterForClicks("AnyUp")
        if script.onDragStart then button:SetScript("OnDragStart", script.onDragStart) end
        if script.onDragStop then button:SetScript("OnDragStop", script.onDragStop) end
        if script.onClick then button:SetScript("OnClick", script.onClick) end
        if script.onEnter then button:SetScript("onEnter", script.onEnter) end
        if script.onLeave then button:SetScript("onLeave", script.onLeave) end
    end
end

local function ConfigIcon(button, icon)
    button.icon = button:CreateTexture(nil, "ARTWORK")
    button.icon:SetTexture("Interface\\Icons\\" .. icon.name)
    button.icon:SetAllPoints(button)
    if icon.minimap then
        button.icon.mask = button:CreateMaskTexture()
        button.icon.mask:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask")
        button.icon.mask:SetAllPoints(button)
        button.icon:AddMaskTexture(button.icon.mask)
        button.border = button:CreateTexture(nil, "OVERLAY")
        button.border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
        button.border:SetSize(54, 54)
        button.border:SetPoint("CENTER", button, "CENTER", 11, -12)
    end
end

GRAAL.Ui.CreateButton = function(config)
    local button = CreateFrameForButton(config.name, config.frameParent, config.template)
    ConfSize(button, config.size)
    ConfPoint(button, config.frameParent, config.point)
    ConfMovable(button, config.movable)
    if config.text then button:SetText(config.text) end
    if config.icon then ConfigIcon(button, config.icon) end
    ConfScript(button, config.script)
    if config.hide then button:Hide() end
    return button
end

-- GRAAL.Ui.CreateButton({
--     frameParent = UIParent,                                 -- *
--     point = { xf = "CENTER", yf = "CENTER", x = 0, y = 0 }, -- *
--     name = "buttontest",
--     text = "ExampleText",
--     template = "UIPanelButtonTemplate",
--     script = {
--         onDragStart = function() print("test") end,
--         stop = function() print("test") end,
--         onClick = function() print("test") end,
--         onEnter = function() print("test") end,
--         onLeave = function() print("test") end
--     },
-- })
