local G = require("Data/Profiles/Scripts/Lib/Global")
local printItemFn = require("Data/Profiles/Scripts/Lib/Print")

local itemTypeIndex = {}
for idx, graphic in ipairs(G.OreGraphics) do
    itemTypeIndex[graphic] = idx
end

--[[
    Gets all Ore items from player's inventory and groups them by Hue.

    Returns:
    - table: A map with hue as keys and each value is a sorted array of ores
             (each ore item contains fields Name, Graphic, Hue, Serial).

    Example Return:
    {
        [0] = { -- Regular iron ores (hue 0)
            { Name = "Iron Ore (light)", Graphic = 6585, Hue = 0, Serial = 123456 },
            { Name = "Iron Ore (Heavy)", Graphic = 6584, Hue = 0, Serial = 133457 }
        },
        [2406] = { -- Shadow Iron ores (hue 2406)
            { Name = "Shadow Iron Ore (light)", Graphic = 6585, Hue = 2406, Serial = 223344 },
            { Name = "Shadow Iron Ore (heavy)", Graphic = 6584, Hue = 2406, Serial = 223345 }
        }
    }
]]
local function getOresByHue()

    local oresByHue = {}

    local worldOres = Items.FindByFilter({rangmine = 0, rangemax = 2, graphics = G.OreGraphics})
    for _, ore in ipairs(worldOres) do
        oresByHue[ore.Hue] = oresByHue[ore.Hue] or {}
        --printItemFn(ore)
        table.insert(oresByHue[ore.Hue], ore)
    end

    local playerOres = Items.FindByFilter({ graphics = G.OreGraphics })
    for _, ore in ipairs(playerOres) do
        if ore.RootContainer == Player.Serial then
            oresByHue[ore.Hue] = oresByHue[ore.Hue] or {}
            --printItemFn(ore)
            table.insert(oresByHue[ore.Hue], ore)
        end
    end

    -- Sort each hue group ascending: lightest (1) first, then heavier
    for hue, ores in pairs(oresByHue) do
        table.sort(ores, function(a, b)
            return itemTypeIndex[a.Graphic] < itemTypeIndex[b.Graphic]
        end)
    end

    return oresByHue
end

return getOresByHue