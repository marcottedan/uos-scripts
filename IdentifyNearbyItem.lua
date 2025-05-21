local printFn = require("Data/Profiles/Scripts/Lib/Print")

function IdentifyNearbyItem()
    while true do
        local items = Items.FindByFilter({
            name = "Unidentified",
--            hues = {0},
            rangemin = 0,
            rangemax = 2
        })

        for i, item in ipairs(items) do
            	printFn(item)
                local itemName = item.Name or "NoName"
                Player.SayWhisper("Identifying " .. itemName)
                Skills.Use('Item Identification')
                Targeting.WaitForTarget(500)
                Targeting.Target(item.Serial)
                Pause(600)
        end
    end
end

function Main()
    IdentifyNearbyItem()
end

Main()