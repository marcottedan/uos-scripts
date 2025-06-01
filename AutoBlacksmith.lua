local G = require("Data/Profiles/Scripts/Lib/Global")
local printItemFn = require("Data/Profiles/Scripts/Lib/Print")
local mergeOreFn = require("Data/Profiles/Scripts/Lib/MergeOre")
local getOreFn = require("Data/Profiles/Scripts/Lib/Ore")
local itemTypes = require("Data/Profiles/Scripts/Lib/ItemCategory")
local findSmithHammerFn = require("Data/Profiles/Scripts/Lib/FindSmithHammer")

function makeLast()
    -- Wait maximum 2 seconds for the gump to open
    if Gumps.WaitForGump(G.ToolGump, 2000) then
        Pause(1400)
        -- Sends a button click to the gump
        Gumps.PressButton(G.ToolGump, 21) -- 21 == Make Last
    end

end

function main()
    Journal.Clear()

    while findSmithHammerFn() do
        makeLast()
    end

end

main()


