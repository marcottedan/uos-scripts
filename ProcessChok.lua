local G = require("Data/Profiles/Scripts/Lib/Global")
local printItemFn = require("Data/Profiles/Scripts/Lib/Print")
local getOreFn = require("Data/Profiles/Scripts/Lib/Ore")
local moveItemLoopFn = require("Data/Profiles/Scripts/Lib/MoveItemLoop")

local waitTime = 500
local action = true

local function toString(b)
    return b and "true" or "false"
end

function mergeOres()

    local huesToSortedOres = getOreFn()

    for hue, sortedOres in pairs(huesToSortedOres) do
        -- Loop from the heaviest index down to the 2nd-lightest
        for i = #sortedOres, 2, -1 do

            local heavierOre = sortedOres[i]
            local lighterOre = sortedOres[i - 1]

            Player.UseObject(heavierOre.Serial)
            if Targeting.WaitForTarget(waitTime) then
                Messages.Overhead("Merging " .. heavierOre.Amount .. " choks into " .. lighterOre.Amount .. " pile.", Player.Serial)
                Targeting.Target(lighterOre.Serial)
                Pause(waitTime)
            end
            -- Reset array since merging 2 items creates a new SerialId
            huesToSortedOres = getOreFn()
        end
    end
    return getOreFn()
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
    local huesToSortedOres =  mergeOres()

    -- Find the only Iron Ore in the piles
    local ironOre = nil
    if huesToSortedOres[G.IronOreHue] and huesToSortedOres[G.IronOreHue][1] then
        ironOre = huesToSortedOres[G.IronOreHue][1]
        Messages.Overhead("Ore found: " .. ironOre.Name, Player.Serial)
    else
        Messages.Overhead('No chok to process', Player.Serial)
        return
    end

    -- Drop Iron Ore on ground + take it back
    printItemFn(ironOre)
    while action do
        moveItemLoopFn(ironOre)
    end

end

--while action do
main()
    --Pause(100)
--end
