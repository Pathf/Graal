local AV = GRAAL.BG.AV

local GetIcon = GRAAL.Utils.GetIcon
local UNITS = GRAAL.Data.UNITS
local ELAPSED = GRAAL.Data.elapsed
local GetTimeInBGString = GRAAL.BG.Utils.GetTimeInBGString
local Get = GRAAL.Utils.Get
---

local function CheckRaiderView(boss, unitInfo)
    local bossSubName, frame = unitInfo.subname, unitInfo.frame
    local hp, maxHp, percentage = UnitHealth(boss), UnitHealthMax(boss), 100
    if maxHp and maxHp > 0 then percentage = hp / maxHp * 100 end
    frame.healthBar:SetMinMaxValues(0, maxHp)
    frame.healthBar:SetValue(hp)
    frame.text:SetText(GetIcon(unitInfo.icon, 'text') .. " -> " .. string.format("%s - %d%%", bossSubName, percentage))
    frame.iconEye:Show()
    if percentage == 0 then
        local bgBox = Get("BossBoxFrame")
        bgBox.positionInformations.remove(frame.name, bgBox)
    end
    return true
end

local function UpdateBossHealth(unitInfo)
    local hasRaiderView = false
    for i = 1, 40 do
        local boss = "raid" .. i .. "target"
        if UnitExists(boss) and UnitName(boss) == unitInfo.name then
            hasRaiderView = CheckRaiderView(boss, unitInfo)
        end
    end
    if not hasRaiderView then unitInfo.frame.iconEye:Hide() end
end

AV.OnUpdate = function(_, delta)
    ELAPSED = ELAPSED + delta
    if ELAPSED >= 0.5 then
        for _, unitInfo in ipairs(UNITS) do
            UpdateBossHealth(unitInfo)
        end
        AV.GetBgBox().timer:SetText(GetTimeInBGString())

        ELAPSED = 0
    end
end
