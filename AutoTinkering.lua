local G = require("Data/Profiles/Scripts/Lib/Global")
local printItemFn = require("Data/Profiles/Scripts/Lib/Print")
local mergeOreFn = require("Data/Profiles/Scripts/Lib/MergeOre")
local getOreFn = require("Data/Profiles/Scripts/Lib/Ore")
local itemTypes = require("Data/Profiles/Scripts/Lib/ItemCategory")

-- Tinker's Tool : 7864

function findTool()
    -- Find an item to use
    tinkerTool = Items.FindByType(7864)

    -- If item is found use it
    if tinkerTool ~= nil then
        Player.UseObject(tinkerTool.Serial)
        return true
    end

    return false
end

function makeLast()
    -- Wait maximum 2 seconds for the gump to open
    if Gumps.WaitForGump(G.MakeLast, 2000) then
        Pause(1400)
        -- Sends a button click to the gump
        Gumps.PressButton(G.MakeLast, 21)
    end

end

function main()
    Journal.Clear()

    while true do
        findTool()
        makeLast()
    end

end

main()


