local G = require("Data/Profiles/Scripts/Lib/Global")
local printItemFn = require("Data/Profiles/Scripts/Lib/Print")
local mergeOreFn = require("Data/Profiles/Scripts/Lib/MergeOre")
local getOreFn = require("Data/Profiles/Scripts/Lib/Ore")

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

    -- Move smelted ores to locked piles
    local crates = Items.FindByFilter({ name = "Crate", onground = true, rangemin = 0, rangemax = 2 })
    if #crates == 0 then
        return
    end

    Pause(500)
    local backpackIngots = Items.FindByFilter({ onground = false, graphics = G.IngotGraphics })
    for _, ingot in ipairs(backpackIngots) do
        if ingot.RootContainer == Player.Serial then
            Player.PickUp(ingot.Serial, ingot.Amount)
            Pause(500)
            Player.DropInContainer(crates[1].Serial)
        end
    end

end

main()