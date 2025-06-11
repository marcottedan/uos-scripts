local function findMortar()
    -- Lockpick Tool : 3739
    tool = Items.FindByType(3739)

    -- If item is found use it
    if tool ~= nil then
        Player.UseObject(tool.Serial)
        return true
    end

    return false

end

return findMortar