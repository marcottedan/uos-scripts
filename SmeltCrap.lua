local G = require("Data/Profiles/Scripts/Lib/Global")
local printItemFn = require("Data/Profiles/Scripts/Lib/Print")
local mergeOreFn = require("Data/Profiles/Scripts/Lib/MergeOre")
local getOreFn = require("Data/Profiles/Scripts/Lib/Ore")
local itemTypes = require("Data/Profiles/Scripts/Lib/ItemCategory")
local findSmithHammerFn = require("Data/Profiles/Scripts/Lib/FindSmithHammer")

function smeltItem(item)
    -- Wait maximum 2 seconds for the gump to open
    if Gumps.WaitForGump(G.ToolGump, 2000) then
        Pause(100)
        -- Sends a button click to the gump
        Gumps.PressButton(G.ToolGump, 14) -- 14 == Smelt Item
        Pause(100)
        Targeting.Target(item.Serial)
        Pause(100)
    end

end

-- Cutlass : 5185
function smeltCrap()

    craps = Items.FindByFilter({ onground = false, graphics = { 5185 } })
    for _, crap in ipairs(craps) do
        if crap.RootContainer == Player.Serial then
            printItemFn(crap)
            smeltItem(crap)
            return
            --Player.PickUp(crap.Serial)
            --Player.DropOnGround(crap.Serial)
            --Pause(100)
        end
    end

end

function main()
    while findSmithHammerFn() do
        smeltCrap()
    end
end

main()


