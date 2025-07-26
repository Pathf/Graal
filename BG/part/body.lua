local BATTLEFIELD = GRAAL.BG.Data.BATTLEFIELD
local BgBox = GRAAL.BG.Utils.BgBox
---

local function ShowBody(idInstance, idBg)
    local bgBox = BgBox()
    if idBg == BATTLEFIELD.WG.id then
        bgBox.currentIdBg = BATTLEFIELD.WG.id
        bgBox.instanceID = idInstance
        bgBox.UpdateTitle("Warsong Gulsh " .. idInstance)
        if not bgBox.WG:IsVisible() then bgBox.WG.ShowBody(idInstance) end
    end
    if idBg == BATTLEFIELD.AB.id then
        bgBox.currentIdBg = BATTLEFIELD.AB.id
        bgBox.instanceID = idInstance
        bgBox.UpdateTitle("Arathi Basin " .. idInstance)
        if not bgBox.AB:IsVisible() then bgBox.AB.ShowBody(idInstance) end
    end
    if idBg == BATTLEFIELD.AV.id then
        bgBox.currentIdBg = BATTLEFIELD.AV.id
        bgBox.instanceID = idInstance
        bgBox.UpdateTitle("Alterac Valley " .. idInstance)
        if not bgBox.AV:IsVisible() then bgBox.AV.ShowBody(idInstance) end
    end
end

local function HideBody()
    local bgBox = BgBox()
    if bgBox.currentIdBg == BATTLEFIELD.WG.id then bgBox.WG.HideBody() end
    if bgBox.currentIdBg == BATTLEFIELD.AB.id then bgBox.AB.HideBody() end
    if bgBox.currentIdBg == BATTLEFIELD.AV.id then bgBox.AV.HideBody() end
    bgBox.currentIdBg = nil
    bgBox.instanceID = nil
end

local function Update()
    local bgBox = BgBox()
    if bgBox.currentIdBg == BATTLEFIELD.WG.id then bgBox.WG.Update() end
    if bgBox.currentIdBg == BATTLEFIELD.AB.id then bgBox.AB.Update() end
    if bgBox.currentIdBg == BATTLEFIELD.AV.id then bgBox.AV.Update() end
end

GRAAL.BG.Part.CreateBodyPart = function()
    local bgBox = BgBox()
    bgBox.currentIdBg = BATTLEFIELD.AV.id
    bgBox.AV = GRAAL.BG.AV.CreateAVFrame()
    --bgBox.AB = GRAAL.BG.AB.CreateABFrame()
    --bgBox.WG = GRAAL.BG.WG.CreateWGFrame()

    bgBox.ShowBody = ShowBody
    bgBox.HideBody = HideBody
    bgBox.Update = Update
end
