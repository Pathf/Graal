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
    CHEST_LOCK = "inv_misc_ornatebox"
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
    { name= "Lieutenant Spencer", color=data.COLORS.BLUE, subname= "Spencer", icon=data.ICONS.HUMAN.M },            
    { name= "Lieutenant Stouthandle", color=data.COLORS.BLUE, subname= "Stouthandle", icon=data.ICONS.DWARF.M },        
    { name= "Lieutenant Largent", color=data.COLORS.BLUE, subname= "Largent", icon=data.ICONS.HUMAN.M },            
    { name= "Lieutenant Mancuso", color=data.COLORS.BLUE, subname= "Mancuso", icon=data.ICONS.HUMAN.M },             
    { name= "Commandant Randolph", color=data.COLORS.BLUE, subname= "Randolph", icon=data.ICONS.NIGHTELF.M },          
    { name= "Lieutenant Greywand", color=data.COLORS.BLUE, subname= "Greywand", icon=data.ICONS.GNOME.M }
}


data.ResetData = function()
  data.saved = {}
  AVBossTrackerSaved = {}
end