local av = GRAAL.BG.AV

local CreateTimer = GRAAL.Ui.CreateTimer
---

av.AddTimer = function(avFrame, location, icon)
    local position = avFrame.positionInformations.nextPosition()
    avFrame.AddBar(
        CreateTimer({
            text = location.subname,
            point = { xf = "TOPRIGHT", yf = "TOPRIGHT", x = position.x, y = position.y },
            time = 300,
            icon = icon,
            isPoi = true,
            name = location.name,
            id = location.id,
            frameParent = avFrame,
            size = { w = 162, h = 18 }
        })
    )
end
