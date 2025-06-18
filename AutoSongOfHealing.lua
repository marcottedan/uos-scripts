function castSongOfHealing()
    Spells.Cast('SongOfHealing')
end

function main()
    castSongOfHealing()
    Pause(500)
    castSongOfHealing()
    Pause(28000)
end

while true do
    main()
end