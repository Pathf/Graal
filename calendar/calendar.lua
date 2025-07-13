local calendar = GRAAL.Calendar
local data = GRAAL.Calendar.Data

---
local YEAR = date("*t").year

local yearWork = {
    [2025] = {
        IsWarsongGulch = function(weekNumber, dayNumber) -- multiple de trois +1 ou -1 %3 == 1
            return ((weekNumber % 3) == 1 and dayNumber > 4) or ((weekNumber % 3) == 2 and dayNumber < 3)
        end,
        IsArathiBasin = function(weekNumber, dayNumber) -- multiple de trois -1 ou +0
            return ((weekNumber % 3) == 2 and dayNumber > 4) or ((weekNumber % 3) == 0 and dayNumber < 3)
        end,
        IsAlteracValley = function(weekNumber, dayNumber) -- multiple de trois  +0 ou +1
            return ((weekNumber % 3) == 0 and dayNumber > 4) or ((weekNumber % 3) == 1 and dayNumber < 3)
        end,
        IsNextWarsongGulch = function(weekNumber, dayNumber)
            return ((weekNumber % 3) == 1 and dayNumber > 3 and dayNumber < 5)
        end,
        IsNextArathiBasin = function(weekNumber, dayNumber)
            return ((weekNumber % 3) == 2 and dayNumber > 3 and dayNumber < 5)
        end,
        IsNextAlteracValley = function(weekNumber, dayNumber)
            return ((weekNumber % 3) == 0 and dayNumber > 3 and dayNumber < 5)
        end,
    }
}

local function CurrentDayAndWeek()
    local currentDate = date("*t")
    local januaryWeek1 = date("*t", time { year = currentDate.year, month = 1, day = 1 })
    local januaryDayOfWeek1 = (januaryWeek1.wday + 5) % 7 + 1
    local dayNumber = (currentDate.wday + 5) % 7 + 1 -- dayNumber: 1=lundi
    local weekNumber = math.floor((currentDate.yday + januaryDayOfWeek1 - 2) / 7) + 1
    return dayNumber, weekNumber
end

calendar.NextEvent = function()
    local dayNumber, weekNumber = CurrentDayAndWeek()
    local run = yearWork[YEAR]
    if run.IsNextWarsongGulch(weekNumber, dayNumber) then return data.NAMEEVENT.GO end
    if run.IsNextArathiBasin(weekNumber, dayNumber) then return data.NAMEEVENT.AB end
    if run.IsNextAlteracValley(weekNumber, dayNumber) then return data.NAMEEVENT.AV end
    return nil
end

calendar.CurrentEvent = function()
    local dayNumber, weekNumber = CurrentDayAndWeek()
    local run = yearWork[YEAR]
    if run.IsWarsongGulch(weekNumber, dayNumber) then return data.NAMEEVENT.GO end
    if run.IsArathiBasin(weekNumber, dayNumber) then return data.NAMEEVENT.AB end
    if run.IsAlteracValley(weekNumber, dayNumber) then return data.NAMEEVENT.AV end
    return nil
end
