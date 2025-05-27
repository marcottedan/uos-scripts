local G = require("Data/Profiles/Scripts/Lib/Global")
local printItemFn = require("Data/Profiles/Scripts/Lib/Print")
local getOreFn = require("Data/Profiles/Scripts/Lib/Ore")

local waitTime = 500
local action = true

function mergeOres()

    local huesToSortedOres = getOreFn()

    for hue, sortedOres in pairs(huesToSortedOres) do
        -- Loop from the heaviest index down to the 2nd-lightest
        for i = #sortedOres, 2, -1 do

            local heavierOre = sortedOres[i]
            local lighterOre = sortedOres[i - 1]

            Player.UseObject(heavierOre.Serial)
            if Targeting.WaitForTarget(waitTime) then
                Messages.Overhead("Merging choks : " .. heavierOre.Amount, Player.Serial)
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

    local oresByHue = getOreFn()
    for _, ores in pairs(oresByHue) do
        for _, ore in ipairs(ores) do
            printItemFn(ore)
        end
    end

    local mergedChok = mergeOres()
    if mergedChok == nil then
        Messages.Overhead('No chok to process', Player.Serial)
        return
    end
end

while action do
    main()
    Pause(100)
end
