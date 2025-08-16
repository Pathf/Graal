local data = GRAAL.BG.Data

local COLORS = GRAAL.Data.COLORS
local POIICON = GRAAL.Data.POIICON
local i18n = GRAAL.I18N.transform
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
        id = "BATTLEFIELD_AV", name = i18n("Alterac Valley")
    },
    AB = {
        id = "BATTLEFIELD_AB", name = i18n("Arathi Basin")
    },
    WG = {
        id = "BATTLEFIELD_WG", name = i18n("Warsong Gulsh")
    }
}

data.CHIEFS = {
    { name = i18n("Chef d'escadrille Guse"),      color = COLORS.GREEN, subname = "Guse",      icon = POIICON.TOWER, x = -50 },
    { name = i18n("Chef d'escadrille Jeztor"),    color = COLORS.GREEN, subname = "Jeztor",    icon = POIICON.HOME,  x = 0 },
    { name = i18n("Chef d'escadrille Mulverick"), color = COLORS.GREEN, subname = "Mulverick", icon = POIICON.FLAG,  x = 50 }
}
