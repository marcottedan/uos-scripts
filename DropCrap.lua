local G = require("Data/Profiles/Scripts/Lib/Global")
local printItemFn = require("Data/Profiles/Scripts/Lib/Print")
local mergeOreFn = require("Data/Profiles/Scripts/Lib/MergeOre")
local getOreFn = require("Data/Profiles/Scripts/Lib/Ore")
local itemTypes = require("Data/Profiles/Scripts/Lib/ItemCategory")

-- Barrel Tap: 4100
-- Barrel Hoops: 7607
-- Bowl : 5629

function dropCrap()

    craps = Items.FindByFilter({ onground = false, graphics = { 5629 } })
    for _, crap in ipairs(craps) do
        if crap.RootContainer == Player.Serial then
            --printItemFn(crap)
            Player.PickUp(crap.Serial)
            Player.DropOnGround(crap.Serial)
            Pause(100)
        end
    end

end

function main()

    while true do
        dropCrap()
    end

end

main()


