local function FindSmithHammer()
    -- Blacksmith's Hammer : 5091
    tool = Items.FindByType(5091)

    -- If item is found use it
    if tool ~= nil then
        Player.UseObject(tool.Serial)
        return true
    end

    return false

end

return FindSmithHammer