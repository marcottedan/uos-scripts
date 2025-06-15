local G = require("Data/Profiles/Scripts/Lib/Global")
local printItemFn = require("Data/Profiles/Scripts/Lib/Print")
local getOreFn = require("Data/Profiles/Scripts/Lib/Ore")
local mergeOreFn = require("Data/Profiles/Scripts/Lib/MergeOre")
local moveItemLoopFn = require("Data/Profiles/Scripts/Lib/MoveItemLoop")

local action = true

local function toString(b)
    return b and "true" or "false"
end

function main()
    Journal.Clear()

    -- Collect all Ores in backpack + ground
    local oresByHue = getOreFn()
    for _, ores in pairs(oresByHue) do
        for _, ore in ipairs(ores) do
            printItemFn(ore)
        end
    end

    -- Merged them to 1 slot per Hue, prioritizing ground last
    local huesToSortedOres =  mergeOreFn()

    -- Find the only Iron Ore in the piles
    local ironOre = nil
    if huesToSortedOres[G.IronOreHue] and huesToSortedOres[G.IronOreHue][1] then
        ironOre = huesToSortedOres[G.IronOreHue][1]
    else
        Messages.Overhead('No chok to process', Player.Serial)
        return
    end

    -- Drop Iron Ore on ground + take it back
    --printItemFn(ironOre)
    while action do
        if not moveItemLoopFn(ironOre) then
            huesToSortedOres = mergeOreFn()
            if huesToSortedOres[G.IronOreHue] == nil then
                huesToSortedOres = mergeOreFn()
            end
            ironOre = huesToSortedOres[G.IronOreHue][1]
        end
    end

end

--while action do
main()
    --Pause(100)
--end
