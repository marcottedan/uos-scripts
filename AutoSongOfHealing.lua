-- Error messages to watch for in the journal
local songWorkedMessage = {
    "Your song creates a healing aura around you."
}

-- Function to check if a stop message is present in the journal
function checkJournal(message)
    for _, msg in ipairs(message) do
        if Journal.Contains(msg) then
            return true, msg -- Returns true and the found message
        end
    end
    return false, nil
end

function castSongOfHealing()
    Spells.Cast('SongOfHealing')
    Pause(500)
end

function main()
    Journal.Clear()

    -- TODO Once instrument charges are out, auto select the new one

    -- Heal
    castSongOfHealing()

    -- Check if song worked
    if checkJournal(songWorkedMessage) then
        Messages.Overhead("Song of Healing worked!", Player.Serial)
        Pause(28000)
    else
        Messages.Overhead("Song of Healing failed", Player.Serial)
        Pause(1000)
    end
end

while true do
    main()
end