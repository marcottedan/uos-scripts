local printFn = require("Data/Profiles/Scripts/Lib/Print")
local moveItemLoopFn = require("Data/Profiles/Scripts/Lib/MoveItemLoop")

function main()

    -- Find Crate in hut
    -- Pouch: 3705
    local pouches = Items.FindByFilter({ name = "Pouch", rangemin = 0, rangemax = 2, container = true, graphics = { 3705 }} )
    if #pouches == 0 then
        Messages.Overhead("No pouch found")
        return
    end
    local pouch = pouches[1]
    printFn(pouch)

    -- Move Item to Pouch
    -- Mortar : 3739
    -- Lockpick: 5373
    -- Hatchet : 3907
    local items = Items.FindByFilter({ onground = false, graphics = 3907 })
    for _, item in ipairs(items) do
        if item.RootContainer == Player.Serial then
            Player.PickUp(item.Serial, item.Amount)
            Pause(400)
            Player.DropInContainer(pouch.Serial)
            Pause(100)
        end
    end

end

main()