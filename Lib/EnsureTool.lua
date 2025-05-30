local G = require("Data/Profiles/Scripts/Lib/Global")

-- Function to check and equip a tool if necessary
local function ensureTool(toolGraphic)
    local toolEquiped = Items.FindByLayer(1) -- Check if a tool is equipped in the hand (layer 1)

    -- If no tool is equipped, search for a tool in the bag
    if not toolEquiped then
        local toolInBag = Items.FindByType(toolGraphic)

        if toolInBag then
            -- If a tool is found in the bag, equip it
            Player.Equip(toolInBag.Serial)
            Messages.Overhead("New Tool equipped", G.Green, Player.Serial)
            Pause(1000)
            return true
        else
            -- No tool found, display a message and stop the script
            Messages.Overhead("No tool", G.Purple, Player.Serial)
            return false
        end
    end
    return true
end

return ensureTool