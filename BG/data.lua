local data = GRAAL.BG.Data

local COLORS = GRAAL.Data.COLORS
local POIICON = GRAAL.Data.POIICON
---

data.NAMEFRAME = {
    BG = {
        BOX = "BG_BOX",
    },
    AV = {
        BOX = "AV_BOX",
        CLOSEBUTTON = "AV_BOXClose"
    }
}

data.BATTLEFIELD = {
    AV = {
        id = "BATTLEFIELD_AV", name = "Alterac Valley", frName = "Vallée d'Alterac"
    },
    AB = {
        id = "BATTLEFIELD_AB", name = "Arathi Basin"
    },
    WG = {
        id = "BATTLEFIELD_WG", name = "Warsong Gulsh"
    }
}

data.CHIEFS = {
    { name = "Chef d'escadrille Guse",      color = COLORS.GREEN, subname = "Guse",      icon = POIICON.TOWER, x = -50 },
    { name = "Chef d'escadrille Jeztor",    color = COLORS.GREEN, subname = "Jeztor",    icon = POIICON.HOME,  x = 0 },
    { name = "Chef d'escadrille Mulverick", color = COLORS.GREEN, subname = "Mulverick", icon = POIICON.FLAG,  x = 50 }
}
