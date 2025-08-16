local L = GRAAL.I18N.Language
local base = "chat_msg_monster_yell"

if GetLocale() ~= "frFR" then return end

L[base .. "Alliance"] = "Alliance"
L[base .. "Allliance"] = "Allliance"
L[base .. "Horde"] = "Horde"
L[base .. "attaqué"] = "attaqué"
L[base .. "sauvé"] = "sauvé"
L[base .. "capturé"] = "capturé"
L[base .. "détruit"] = "détruit"
L[base .. "L([ea]) (.+) est attaqu"] = "L[ea] (.+) est attaqu"
L[base .. "a pris le (.+) ! Si"] = "a pris le (.+) ! Si"
L[base .. "L([ea]) (.+) a été pri([se])"] = "L[ea] (.+) a été pri[se]"
L[base .. "L([ea]) (.+) a été détru([ite])"] = "L[ea] (.+) a été détru[ite]"
