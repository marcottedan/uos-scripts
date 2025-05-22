local printFn = require("Data/Profiles/Scripts/Lib/Print")
local instrumentId = 3741 -- Tambourine graphic ID

function AutoMusicianship()
    local items = Items.FindByFilter({graphics = {instrumentId}})
    for _, item in ipairs(items) do

        if item.RootContainer ~= Player.Serial then
            goto continue
        end

        if item.Graphic ~= instrumentId then
            goto continue
        end


        --printFn(item)
        Player.UseObject(item.Serial)
        Pause(7500)

        ::continue::
    end
end

function Main()
	while true do
    	AutoMusicianship()
    end
end

Main()