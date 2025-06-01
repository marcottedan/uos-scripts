local function FindSmithHammer(item)
    -- Tinker's Tool : 7864
    -- Find an item to use
    tinkerTool = Items.FindByType(7864)

    -- If item is found use it
    if tinkerTool ~= nil then
        Player.UseObject(tinkerTool.Serial)
        return true
    end

    return false

end

return FindSmithHammer