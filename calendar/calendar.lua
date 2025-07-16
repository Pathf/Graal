local calendar = GRAAL.Calendar
local data = GRAAL.Calendar.Data
local Ternary = GRAAL.Utils.Ternary
local BuildTime = GRAAL.Utils.BuildTime

---
local YEAR = date("*t").year

local yearWork = {
    [2025] = {
        IsWarsongGulch = function(weekNumber, dayNumber) -- multiple de trois +1 ou -1
            return ((weekNumber % 3) == 1 and dayNumber >= 5) or ((weekNumber % 3) == 2 and dayNumber <= 2)
        end,
        IsArathiBasin = function(weekNumber, dayNumber) -- multiple de trois -1 ou +0
            return ((weekNumber % 3) == 2 and dayNumber >= 5) or ((weekNumber % 3) == 0 and dayNumber <= 2)
        end,
        IsAlteracValley = function(weekNumber, dayNumber) -- multiple de trois +0 ou +1
            return ((weekNumber % 3) == 0 and dayNumber >= 5) or ((weekNumber % 3) == 1 and dayNumber <= 2)
        end,
        IsNextWarsongGulch = function(weekNumber, dayNumber)
            return ((weekNumber % 3) == 0 and dayNumber >= 5) or ((weekNumber % 3) == 1 and dayNumber < 5)
        end,
        IsNextArathiBasin = function(weekNumber, dayNumber)
            return ((weekNumber % 3) == 1 and dayNumber >= 5) or ((weekNumber % 3) == 2 and dayNumber < 5)
        end,
        IsNextAlteracValley = function(weekNumber, dayNumber)
            return ((weekNumber % 3) == 2 and dayNumber >= 5) or ((weekNumber % 3) == 0 and dayNumber < 5)
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

local function CurrentTime()
    local t = date("*t")
    return t.hour, t.min, t.sec
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

calendar.ResetPvpIn = function()
    --Mercredi à 6h fin des events PVP
    local dayNumber = CurrentDayAndWeek()
    local currentHours, currentMinutes = CurrentTime()

    local days

    if (dayNumber == 3 and (currentHours > 6 or (currentHours == 6 and currentMinutes > 0))) or dayNumber > 3 then
        days = 7 - (dayNumber - 2)
    elseif dayNumber == 3 then
        days = 0
    else -- dayNumber < 3
        days = 7 - (dayNumber + 4)
    end
    local totalTimeInSeconds = (((days * 24 * 60) - ((currentHours * 60 + currentMinutes) - 6 * 60)) % (24 * 60)) * 60
    local time = BuildTime(totalTimeInSeconds * 1000)
    local hours = time.hours
    local minutes = time.minutes

    local remainingDays = days .. Ternary(days > 1, " days", " day")
    local remainingHours = Ternary(hours > 9, hours, "0" .. hours)
    local remainingMinutes = Ternary(minutes > 9, minutes, "0" .. minutes)
    return remainingDays .. ", " .. remainingHours .. "h" .. remainingMinutes
end
