local printFn = require("Data/Profiles/Scripts/Lib/Print")

-- Iron Ore 2 stones: 6583  # Small scattered
-- Iron Ore 7a stones: 6586 # Large scattered
-- Iron Ore 7b stones: 6584 # Small round
-- Iron Ore 12 stones: 6585 # Large round
local itemIdSmallOrePile = {6583, 6586, 6584, 6585} -- sorted heaviest [1] to lightest [4]

local itemTypeIndex = {} -- maps graphicId to 'weight/tier' index
for idx, graphic in ipairs(itemIdSmallOrePile) do
    itemTypeIndex[graphic] = idx
end

-- Gets all items that are Ore stacks, sort them by GraphicId ascending.
local function getSortedOreStacks()
    local foundOres = Items.FindByFilter({})
    local sortedOreStacks = {}

    for _, ore in ipairs(foundOres) do
        if ore.RootContainer == Player.Serial and itemTypeIndex[ore.Graphic] then
            table.insert(sortedOreStacks, ore)
        end
    end

    -- sort ascending: lightest (1) first, then heavier
    table.sort(sortedOreStacks, function(a, b)
        return itemTypeIndex[a.Graphic] < itemTypeIndex[b.Graphic]
    end)

    return sortedOreStacks
end

function oreProcessing()

    local sortedOres = getSortedOreStacks()

    -- Loop from the heaviest index down to the 2nd-lightest
    for i = #sortedOres, 2, -1 do

        local heavierOre = sortedOres[i]
        local lighterOre = sortedOres[i - 1]

        Player.UseObject(heavierOre.Serial)
        if Targeting.WaitForTarget(1000) then
            Messages.Overhead("Merging ore piles ", heavierOre.Amount)
            Targeting.Target(lighterOre.Serial)
            Pause(1000)

            hasMerged = true
            break -- after a merge, refresh the items to update the sorted list
        end
    end
    return sortedOres[1]
end

function main()
    Journal.Clear()
    local sortedOres = getSortedOreStacks()
    for _, ore in ipairs(sortedOres) do
        printFn(ore)
    end
    local mergedOre = oreProcessing()
    printFn(mergedOre)
end

--while action do
main()
--end
