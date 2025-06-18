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
local C = data.COLORS

data.ICONS = {
    HUMAN= { M="achievement_character_human_male", F="inv_misc_head_human_02" },
    DWARF= { M="achievement_character_dwarf_male", O="inv_misc_head_dwarf_01" },
    GNOME= { M="achievement_character_gnome_male" },
    NIGHTELF= { M="achievement_character_nightelf_male" },
    INTEROGATION = "inv_misc_questionmark",
    KEY = "INV_Misc_Key_14",
    CHEST_LOCK = "inv_misc_ornatebox"
}
local ICONS = data.ICONS

data.UNITS = {
    { name= "Vanndar Stormpike", color=C.RED, subname= "Vanndar", icon=ICONS.DWARF.O },            
    { name= "Commandant Mortimer", color=C.RED, subname= "Mortimer", icon=ICONS.DWARF.M },
    { name= "Commandant Duffy", color=C.RED, subname= "Duffy", icon=ICONS.DWARF.M },
    { name= "Commandant Karl Philips", color=C.PURPLE, subname= "Karl Philips", icon=ICONS.HUMAN.M },      
    { name= "Capitaine Balinda Stonehearth", color=C.BLUE, subname= "Balinda", icon=ICONS.HUMAN.F },
    { name= "Lieutenant Lonadin", color=C.BLUE, subname= "Lonadin", icon=ICONS.NIGHTELF.M },           
    { name= "Lieutenant Spencer", color=C.BLUE, subname= "Spencer", icon=ICONS.HUMAN.M },            
    { name= "Lieutenant Stouthandle", color=C.BLUE, subname= "Stouthandle", icon=ICONS.DWARF.M },        
    { name= "Lieutenant Largent", color=C.BLUE, subname= "Largent", icon=ICONS.HUMAN.M },            
    { name= "Lieutenant Mancuso", color=C.BLUE, subname= "Mancuso", icon=ICONS.HUMAN.M },             
    { name= "Commandant Randolph", color=C.BLUE, subname= "Randolph", icon=ICONS.NIGHTELF.M },          
    { name= "Lieutenant Greywand", color=C.BLUE, subname= "Greywand", icon=ICONS.GNOME.M }
}


data.ResetData = function()
  data.saved = {}
  AVBossTrackerSaved = {}
end