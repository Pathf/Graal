local data = GRAAL.Data
---

data.elapsed = 0
data.honor = { duringGame = 0 }
data.saved = AVBossTrackerSaved or {}

data.COLORS = {
    RED = {r=1,g=0,b=0},
    GREEN = {r=0,g=1,b=0},
    BLUE = {r=0,g=0,b=1},
    BLACK = {r=0,g=0,b=0},
    WHITE = {r=1,g=1,b=1},
    PURPLE = {r=1,g=0,b=1},
    YELLOW = {r=1,g=1,b=0},
    YELLOW_TITLE = {r=1,g=0.82,b=0},
    CYAN = {r=0,g=1,b=1}
}

data.ICONS = {
    HUMAN= { M="achievement_character_human_male", F="inv_misc_head_human_02" },
    DWARF= { M="achievement_character_dwarf_male", O="inv_misc_head_dwarf_01" },
    GNOME= { M="achievement_character_gnome_male" },
    NIGHTELF= { M="achievement_character_nightelf_male" },
    INTEROGATION = "inv_misc_questionmark",
    KEY = "INV_Misc_Key_14",
    CHEST_LOCK = "inv_misc_ornatebox",
    BANNER_HORDE = "inv_bannerpvp_01"
}

data.POIIcon = {
    MINE={ l=0.000, r=0.121, t=0.000, b=0.122 },
    MINE_RED={ l=0.128, r=0.246, t=0.000, b=0.122 },
    MINE_BLUE={ l=0.253, r=0.371, t=0.000, b=0.122 },
    GRAVEYARD_BLUE_INFORCE={ l=0.378, r=0.496, t=0.00, b=0.122 },
    HOME={ l=0.503, r=0.621, t=0.00, b=0.122 },
    TOWER={ l=0.628, r=0.746, t=0.00, b=0.122 },
    FLAG={ l=0.753, r=0.871, t=0.00, b=0.122 },
    GRAVEYARD={ l=0.878, r=1.000, t=0.00, b=0.122 },
    
    TOWER_BLUE_INFORCE={ l=0.000, r=0.121, t=0.128, b=0.246 },
    TOWER_RED={ l=0.128, r=0.246, t=0.128, b=0.249 }, 
    TOWER_BLUE={ l=0.253, r=0.371, t=0.128, b=0.249 },
    TOWER_RED_INFORCE={ l=0.378, r=0.546, t=0.128, b=0.249 },
    GRAVEYARD_RED={ l=0.503, r=0.621, t=0.128, b=0.249 },
    GRAVEYARD_RED_INFORCE={ l=0.628, r=0.746, t=0.128, b=0.249 },
    GRAVEYARD_BLUE={ l=0.753, r=0.871, t=0.128, b=0.249 },
    --none={ l=0.878, r=1.000, t=0.128, b=0.249 },

    STONE={ l=0.000, r=0.121, t=0.253, b=0.374 },
    STONE_BLUE_INFOCE={ l=0.128, r=0.246, t=0.253, b=0.374 },
    STONE_BLUE={ l=0.253, r=0.371, t=0.253, b=0.374 },
    STONE_RED_INFOCE={ l=0.378, r=0.546, t=0.253, b=0.374 },
    STONE_RED={ l=0.503, r=0.621, t=0.253, b=0.374 },
    SAWMILLS={ l=0.628, r=0.746, t=0.253, b=0.374 },
    SAWMILLS_BLUE_INFOCE={ l=0.753, r=0.871, t=0.253, b=0.374 },
    SAWMILLS_BLUE={ l=0.878, r=1.000, t=0.253, b=0.374 },

    SAWMILLS_RED_INFOCE={ l=0.000, r=0.121, t=0.378, b=0.499 },
    SAWMILLS_RED={ l=0.128, r=0.246, t=0.378, b=0.499 },
    FORGE={ l=0.253, r=0.371, t=0.378, b=0.499 },
    FORGE_BLUE_INFOCE={ l=0.378, r=0.546, t=0.378, b=0.499 },
    FORGE_BLUE={ l=0.503, r=0.621, t=0.378, b=0.499 },
    FORGE_RED_INFOCE={ l=0.628, r=0.746, t=0.378, b=0.499 },
    FORGE_RED={ l=0.753, r=0.871, t=0.378, b=0.499 },
    FARM={ l=0.878, r=1.000, t=0.378, b=0.499 },

    FARM_BLUE_INFOCE={ l=0.000, r=0.121, t=0.503, b=0.624 },
    FARM_BLUE={ l=0.128, r=0.246, t=0.503, b=0.624 },
    FARM_RED_INFOCE={ l=0.253, r=0.371, t=0.503, b=0.624 },
    FARM_RED={ l=0.378, r=0.546, t=0.503, b=0.624 },
    STABLE={ l=0.503, r=0.621, t=0.503, b=0.624 },
    STABLE_BLUE_INFOCE={ l=0.628, r=0.746, t=0.503, b=0.624 },
    STABLE_BLUE={ l=0.753, r=0.871, t=0.503, b=0.624 },
    STABLE_RED_INFOCE={ l=0.878, r=1.000, t=0.503, b=0.624 },

    STABLE_RED={ l=0.000, r=0.121, t=0.628, b=0.749 },
    SKULL={ l=0.128, r=0.246, t=0.628, b=0.749 },
    BOSS={ l=0.253, r=0.371, t=0.628, b=0.749 },
    -- none={ l=0.378, r=0.546, t=0.628, b=0.749 },
    -- none={ l=0.503, r=0.621, t=0.628, b=0.749 },
    -- none={ l=0.628, r=0.746, t=0.628, b=0.749 },
    -- none={ l=0.753, r=0.871, t=0.628, b=0.749 },
    -- none={ l=0.878, r=1.000, t=0.628, b=0.749 },

    -- none={ l=0.000, r=0.125, t=0.75, b=0.824 },
    -- none={ l=0.125, r=0.250, t=0.75, b=0.824 },
    -- none={ l=0.250, r=0.375, t=0.75, b=0.824 },
    -- none={ l=0.375, r=0.500, t=0.75, b=0.824 },
    -- none={ l=0.500, r=0.625, t=0.75, b=0.824 },
    -- none={ l=0.625, r=0.750, t=0.75, b=0.824 },
    -- none={ l=0.750, r=0.875, t=0.75, b=0.824 },
    -- none={ l=0.875, r=1.000, t=0.75, b=0.824 },

    -- none={ l=0.000, r=0.125, t=0.825, b=1.00 }, 
    -- none={ l=0.125, r=0.250, t=0.825, b=1.00 }, 
    -- none={ l=0.250, r=0.375, t=0.825, b=1.00 }, 
    -- none={ l=0.375, r=0.500, t=0.825, b=1.00 }, 
    -- none={ l=0.500, r=0.625, t=0.825, b=1.00 }, 
    -- none={ l=0.625, r=0.750, t=0.825, b=1.00 }, 
    -- none={ l=0.750, r=0.875, t=0.825, b=1.00 }, 
    -- none={ l=0.875, r=1.000, t=0.825, b=1.00 }  
}

data.TARGETINGFRAME = {
    STATUSBAR = "UI-StatusBar"
}

data.UNITS = {
    { name= "Vanndar Stormpike", color=data.COLORS.RED, subname= "Vanndar", icon=data.ICONS.DWARF.O },            
    { name= "Commandant Mortimer", color=data.COLORS.RED, subname= "Mortimer", icon=data.ICONS.DWARF.M },
    { name= "Commandant Duffy", color=data.COLORS.RED, subname= "Duffy", icon=data.ICONS.DWARF.M },
    { name= "Commandant Karl Philips", color=data.COLORS.PURPLE, subname= "Karl Philips", icon=data.ICONS.HUMAN.M },      
    { name= "Capitaine Balinda Stonehearth", color=data.COLORS.BLUE, subname= "Balinda", icon=data.ICONS.HUMAN.F },
    { name= "Lieutenant Lonadin", color=data.COLORS.BLUE, subname= "Lonadin", icon=data.ICONS.NIGHTELF.M },           
    { name= "Commandant Randolph", color=data.COLORS.BLUE, subname= "Randolph", icon=data.ICONS.NIGHTELF.M },       
    { name= "Lieutenant Stouthandle", color=data.COLORS.BLUE, subname= "Stouthandle", icon=data.ICONS.DWARF.M },        
    { name= "Lieutenant Largent", color=data.COLORS.BLUE, subname= "Largent", icon=data.ICONS.HUMAN.M },            
    { name= "Lieutenant Mancuso", color=data.COLORS.BLUE, subname= "Mancuso", icon=data.ICONS.HUMAN.M },             
    { name= "Lieutenant Spencer", color=data.COLORS.BLUE, subname= "Spencer", icon=data.ICONS.HUMAN.M },            
    { name= "Lieutenant Greywand", color=data.COLORS.BLUE, subname= "Greywand", icon=data.ICONS.GNOME.M }
}

data.Location = {
    AV={
        {name="tour ...", color=data.COLORS.RED, subname="", poiicon=data.POIIcon.TOWER_RED_INFORCE},
        {name="tour ...", color=data.COLORS.BLUE, subname="", poiicon=data.POIIcon.TOWER_BLUE_INFORCE},
        {name="cimetiere ...", color=data.COLORS.RED, subname="", poiicon=data.POIIcon.GRAVEYARD_RED_INFORCE},
        {name="cimetiere ...", color=data.COLORS.BLUE, subname="", poiicon=data.POIIcon.GRAVEYARD_BLUE_INFORCE}
    }
}

data.ResetData = function()
  data.saved = {}
  AVBossTrackerSaved = {}
end