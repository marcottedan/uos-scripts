local G = require("Data/Profiles/Scripts/Lib/Global")
local printItemFn = require("Data/Profiles/Scripts/Lib/Print")

local function moveItemLoop(item)

    Pause(100)
    result = Player.PickUp(item.Serial, item.Amount)
    result = Player.DropOnGround(item.Serial)
end

return moveItemLoop