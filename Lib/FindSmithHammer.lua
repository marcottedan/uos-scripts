local function FindSmithHammer(item)
    -- Blacksmith's Hammer : 5091
    -- Find an item to use
    tinkerTool = Items.FindByType(5091)

    -- If item is found use it
    if tinkerTool ~= nil then
        Player.UseObject(tinkerTool.Serial)
        return true
    end

    return false

end

return FindSmithHammer