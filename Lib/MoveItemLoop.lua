local G = require("Data/Profiles/Scripts/Lib/Global")

local function moveItemLoop(item)

    if item == nil or item.Amount == nil or item.Serial == nil then
        return false
    end

    Pause(100)

    if item == nil or item.Amount == nil or item.Serial == nil then
        return false
    end

    result = Player.PickUp(item.Serial, item.Amount)
    result = Player.DropOnGround(item.Serial)
    return true
end

return moveItemLoop