local function FindTinkerTool(item)
    -- Tinker's Tool : 7864
    tool = Items.FindByType(7864)

    -- If item is found use it
    if tool ~= nil then
        Player.UseObject(tool.Serial)
        return true
    end

    return false

end

return FindTinkerTool