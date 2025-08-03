--local G = require("Data/Profiles/Scripts/Lib/Global")
--local printItemFn = require("Data/Profiles/Scripts/Lib/Print")
--local getOreFn = require("Data/Profiles/Scripts/Lib/Ore")
--local mergeOreFn = require("Data/Profiles/Scripts/Lib/MergeOre")
--local moveItemLoopFn = require("Data/Profiles/Scripts/Lib/MoveItemLoop")

Green = 38
Purple = 14
Gray = 73
OreGraphics = { 6583, 6586, 6584, 6585}
IronOreHue = 0
ShadowIronOreHue = 2406
AllOreHue = {
    [1] = 0,
    [2] = 2406
}

local pickaxeGraphicId = 0x0E86 -- Tool identifier
local waitTime = 500
local action = true
local maxWeight = 394
local hasTarget = false
local debug = false

-- Error messages to watch for in the journal
local errorMessages = {
    "There is no metal here to mine.",
    "That is too far away.",
    "You can't mine that.",
    "You can't mine there",
    "Target cannot be seen."
}

function PrintItem(item)
    -- Get item properties safely:
    local name = item.Name or "NoName"
    local graphic = item.Graphic or "Unknown"
    local container = item.RootContainer
    local hue = item.Hue or "0"
    local amount = item.Amount or 1
    local layer = item.Layer or "None"
    local serial = item.Serial or 0
    local durability = item.Durability or "N/A"

    -- Now print clearly formatted information:
    Messages.Print("===============================")
    Messages.Print("Name:       " .. name)
    Messages.Print("Graphic ID: " .. graphic)
    Messages.Print("Container: " .. container)
    Messages.Print("Hue:        " .. hue)
    Messages.Print("Amount:     " .. amount)
    -- Will work eventually
    -- Messages.Print("Durability: " .. durability)
    Messages.Print("Layer:      " .. layer)
    Messages.Print("Serial:     " .. serial)
end

function ensureTool(toolGraphic)
    local toolEquiped = Items.FindByLayer(1) -- Check if a tool is equipped in the hand (layer 1)

    -- If no tool is equipped, search for a tool in the bag
    if not toolEquiped then
        local toolInBag = Items.FindByType(toolGraphic)

        if toolInBag then
            -- If a tool is found in the bag, equip it
            Player.Equip(toolInBag.Serial)
            Messages.Overhead("New Tool equipped", Green, Player.Serial)
            Pause(1000)
            return true
        else
            -- No tool found, display a message and stop the script
            Messages.Overhead("No tool", Purple, Player.Serial)
            return false
        end
    end
    return true
end

function moveItemLoop(item)

    if item == nil or item.Amount == nil or item.Serial == nil then
        return false
    end

    Pause(100)

    if item == nil or item.Amount == nil or item.Serial == nil then
        return false
    end

    result = Player.PickUp(item.Serial, item.Amount)
    result = Player.DropOnGround(item.Serial)
    return true
end

local itemTypeIndex = {}
for idx, graphic in ipairs(OreGraphics) do
    itemTypeIndex[graphic] = idx
end

function getOresByHue()

    local oresByHue = {}

    local worldOres = Items.FindByFilter({rangmine = 0, rangemax = 2, graphics = OreGraphics})
    for _, ore in ipairs(worldOres) do
        oresByHue[ore.Hue] = oresByHue[ore.Hue] or {}
        --PrintItem(ore)
        table.insert(oresByHue[ore.Hue], ore)
    end

    local playerOres = Items.FindByFilter({ graphics = OreGraphics })
    for _, ore in ipairs(playerOres) do
        if ore.RootContainer == Player.Serial then
            oresByHue[ore.Hue] = oresByHue[ore.Hue] or {}
            --PrintItem(ore)
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

local waitTime = 500
function mergeOres()

    local huesToSortedOres = getOresByHue()

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
            huesToSortedOres = getOresByHue()
        end
    end
    return getOresByHue()
end

local action = true

local function toString(b)
    return b and "true" or "false"
end

function main()
    Journal.Clear()

    -- Collect all Ores in backpack + ground
    local oresByHue = getOresByHue()
    for _, ores in pairs(oresByHue) do
        for _, ore in ipairs(ores) do
            PrintItem(ore)
        end
    end

    -- Merged them to 1 slot per Hue, prioritizing ground last
    local huesToSortedOres =  mergeOres()

    -- Find the only Iron Ore in the piles
    local ironOre = nil
    if huesToSortedOres[IronOreHue] and huesToSortedOres[IronOreHue][1] then
        ironOre = huesToSortedOres[IronOreHue][1]
    else
        Messages.Overhead('No chok to process', Player.Serial)
        return
    end

    -- Drop Iron Ore on ground + take it back
    --PrintItem(ironOre)
    while action do
        if not moveItemLoop(ironOre) then
            huesToSortedOres = mergeOres()
            if huesToSortedOres[IronOreHue] == nil then
                huesToSortedOres = mergeOres()
            end
            ironOre = huesToSortedOres[G.IronOreHue][1]
        end
    end

end

--while action do
main()
    --Pause(100)
--end
