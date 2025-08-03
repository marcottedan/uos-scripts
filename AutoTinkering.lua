function FindTinkerTool()
    -- Tinker's Tool : 7864
    tool = Items.FindByType(7864)

    -- If item is found use it
    if tool ~= nil then
        Player.UseObject(tool.Serial)
        return true
    end

    return false
end

function makeLast()
    -- Wait maximum 2 seconds for the gump to open
    if Gumps.WaitForGump(2653346093, 2000) then
        Pause(1400)
        -- Sends a button click to the gump
        Gumps.PressButton(2653346093, 21) -- 21 == Make Last
    end

end

function main()
    Journal.Clear()

    while FindTinkerTool() do
        makeLast()
    end
end

main()


