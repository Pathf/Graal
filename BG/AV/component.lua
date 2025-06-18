local component = GRAAL.BG.AV.Component

local honor = GRAAL.Data.honor

local Get = GRAAL.Utils.Get
---

component.Reset = function()
    local frame = Get("BossBoxFrame")
    if frame then 
        frame:ClearAllPoints()
        frame:SetPoint("CENTER", UIParent, "TOPRIGHT", -10, -10) 
    end
    local reopenFrame = Get("ReopenAVB")
    if reopenFrame then 
        reopenFrame:ClearAllPoints()
        reopenFrame:SetPoint("CENTER", UIParent, "TOP", 0, -50) 
    end
end

component.SetHonorGame = function(honorBeforeGame)
    honorBeforeGame = honorBeforeGame or 0
    honor.duringGame = honorBeforeGame
    local frame = Get("BossBoxFrame")
    frame.honorDuringGame:SetText(honor.duringGame.." honors")
end