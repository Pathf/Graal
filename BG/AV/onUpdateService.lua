local AV = GRAAL.BG.AV

local ELAPSED = GRAAL.Data.elapsed
local GetAvBox = GRAAL.BG.Utils.GetAvBox
---

AV.OnUpdate = function(_, delta)
    ELAPSED = ELAPSED + delta
    if ELAPSED >= 0.5 then
        local avBox = GetAvBox()
        avBox.UpdateAllBossHealth()
        avBox.UpdateTime()
        ELAPSED = 0
    end
end
