local function findLockpickTool()
    -- Lockpick Tool : 5373
    tool = Items.FindByType(5373)

    -- If item is found use it
    if tool ~= nil then
        Player.UseObject(tool.Serial)
        return true
    end

    return false

end

return findLockpickTool