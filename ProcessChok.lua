local printFn = require("Data/Profiles/Scripts/Lib/Print")
local waitTime = 500

-- Iron Ore 2 stones: 6583  # Small scattered
-- Iron Ore 7a stones: 6586 # Large scattered
-- Iron Ore 7b stones: 6584 # Small round
-- Iron Ore 12 stones: 6585 # Large round
local itemIdSmallOrePile = {6583, 6586, 6584, 6585} -- sorted heaviest [1] to lightest [4]

local itemTypeIndex = {} -- maps graphicId to 'weight/tier' index
for idx, graphic in ipairs(itemIdSmallOrePile) do
    itemTypeIndex[graphic] = idx
end

-- Gets all items that are Chok stacks, sort them by GraphicId ascending.
local function getAndSortChok()
    local foundOres = Items.FindByFilter({})
    local sortedChokStacks = {}

    for _, ore in ipairs(foundOres) do
        if ore.RootContainer == Player.Serial and itemTypeIndex[ore.Graphic] then
            table.insert(sortedChokStacks, ore)
        end
    end

    -- sort ascending: lightest (1) first, then heavier
    table.sort(sortedChokStacks, function(a, b)
        return itemTypeIndex[a.Graphic] < itemTypeIndex[b.Graphic]
    end)

    return sortedChokStacks
end

function mergeChoks()

    local sortedOres = getAndSortChok()

    -- Loop from the heaviest index down to the 2nd-lightest
    for i = #sortedOres, 2, -1 do

        local heavierOre = sortedOres[i]
        local lighterOre = sortedOres[i - 1]

        Player.UseObject(heavierOre.Serial)
        if Targeting.WaitForTarget(waitTime) then
            Messages.Overhead("Merging choks : ", heavierOre.Amount)
            Targeting.Target(lighterOre.Serial)
            Pause(waitTime)
        end
        sortedOres = getAndSortChok()
    end
    return sortedOres[1]
end

function main()
    Journal.Clear()
    local mergedChok = mergeChoks()
    printFn(mergedChok)
end

--while action do
main()
--end
