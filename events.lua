local EVENT = GRAAL.Event
local REGISTERS = EVENT.registers
---

EVENT.ListenEvent = function()
    local eventFrame = CreateFrame("Frame")
    for _, registerEvent in ipairs(REGISTERS) do
        eventFrame:RegisterEvent(registerEvent.name)
    end

    eventFrame:SetScript("OnEvent", function(self, event, message)
        for _, registerEvent in ipairs(REGISTERS) do
            if event == registerEvent.name then registerEvent.action(message) end
        end
    end)
end
