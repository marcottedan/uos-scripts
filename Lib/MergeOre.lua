local G = require("Data/Profiles/Scripts/Lib/Global")
local printItemFn = require("Data/Profiles/Scripts/Lib/Print")
local getOreFn = require("Data/Profiles/Scripts/Lib/Ore")

local waitTime = 500
local function mergeOres()

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

return mergeOres