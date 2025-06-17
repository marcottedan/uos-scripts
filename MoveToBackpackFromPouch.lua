local printFn = require("Data/Profiles/Scripts/Lib/Print")
local moveItemLoopFn = require("Data/Profiles/Scripts/Lib/MoveItemLoop")

function main()

    -- Move Item to Pouch
    -- Mortar : 3739
    -- Lockpick: 5373
    -- Tinker Tools: 7864
    local items = Items.FindByFilter({ onground = false, graphics = 7864 })
    for _, item in ipairs(items) do
        Player.PickUp(item.Serial, item.Amount)
        Pause(400)
        Player.DropInBackpack()
        Pause(100)
    end

end

main()