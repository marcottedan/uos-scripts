function track()
    Skills.Use('Tracking')
    if Gumps.WaitForGump(880391009, 1000) then
        Pause(100)
        -- Sends a button click to the gump
        -- Animals: 1
        -- Monsters: 2
        -- NPCs: 3
        -- Players: 4
        Gumps.PressButton(880391009, 1)
    end
end

function main()
    track()
    Pause(10050)
end

while true do
    main()
end