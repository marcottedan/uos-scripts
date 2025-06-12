local G = require("Data/Profiles/Scripts/Lib/Global")

local function moveItemLoop(item)

    if item == nil or item.Amount == nil or item.Serial == nil then
        return
    end

    Pause(100)
    result = Player.PickUp(item.Serial, item.Amount)
    result = Player.DropOnGround(item.Serial)
end

return moveItemLoop