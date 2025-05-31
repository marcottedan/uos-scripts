local G = require("Data/Profiles/Scripts/Lib/Global")
local printItemFn = require("Data/Profiles/Scripts/Lib/Print")
local mergeOreFn = require("Data/Profiles/Scripts/Lib/MergeOre")
local getOreFn = require("Data/Profiles/Scripts/Lib/Ore")
local itemTypes = require("Data/Profiles/Scripts/Lib/ItemCategory")

local FORGE_GRAPHIC_ID = 4017

-- Finds a forge near player
function findForge()
    local forgeFilter = {
        graphics = { FORGE_GRAPHIC_ID },
        onground = true,
        rangemin = 0,
        rangemax = 2
    }
    local forgeList = Items.FindByFilter(forgeFilter)
    if #forgeList == 0 then
        return nil
    end

    -- returns first forge found
    local forge = forgeList[1]
    printItemFn(forge)
    return forge
end

function main()
    Journal.Clear()

    -- Look for Forge
    local forge = findForge()

    -- Smelt Ores
    local huesToSortedOres = mergeOreFn()
    for _, sortedOres in pairs(huesToSortedOres) do
        local ore = sortedOres[1]
        Player.UseObject(ore.Serial)
        if Targeting.WaitForTarget(2000) then
            Targeting.Target(forge.Serial)
            Pause(100)
        end
    end
    Pause(500)

    -- Find Crate in hut
    local crates = Items.FindByFilter({ name = "Crate", onground = true, container = true, rangemin = 0, rangemax = 2 , graphics = {3710}})
    if #crates == 0 then
        Messages.Overhead("No crate found")
        return
    end
    local crate = crates[1]
    printItemFn(crate)

    -- Move smelted ores to crate
    local backpackIngots = Items.FindByFilter({ onground = false, graphics = G.IngotGraphics })
    for _, ingot in ipairs(backpackIngots) do
        if ingot.RootContainer == Player.Serial then
            Player.PickUp(ingot.Serial, ingot.Amount)
            Pause(500)
            Player.DropInContainer(crate.RootContainer)
            Pause(100)
        end
    end

    -- Find Crate in hut
    local bags = Items.FindByFilter({ name = "Bag", onground = true, container = true, rangemin = 0, rangemax = 2 , graphics = {3702}})
    if #bags == 0 then
        Messages.Overhead("No bag found")
        return
    end
    local bag = bags[1]
    printItemFn(bag)


    -- Move Gems to Bag
    local gemGraphicIds = (function() local t={} for _,v in ipairs(itemTypes.Gems) do table.insert(t,v.ItemType) end return t end)()
    local gems = Items.FindByFilter({ onground = false, graphics = gemGraphicIds })
    for _, gem in ipairs(gems) do
        if gem.RootContainer == Player.Serial then
            Player.PickUp(gem.Serial, gem.Amount)
            Pause(500)
            Player.DropInContainer(bag.RootContainer)
            Pause(100)
        end
    end
end

main()