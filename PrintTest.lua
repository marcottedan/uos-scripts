local printFn = require("Data/Profiles/Scripts/Lib/Print")

function PrintMyBackpackItems()
    -- Find ALL Items in possession
    local items = Items.FindByFilter({})

    for _, item in ipairs(items) do
        if item.RootContainer == Player.Serial and string.find(item.Name, "Iron Ore") then
            printFn(item)
        end
    end
end

function Main()
    PrintMyBackpackItems()
end

Main()