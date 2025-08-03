--local G = require("Data/Profiles/Scripts/Lib/Global")
--local printItemFn = require("Data/Profiles/Scripts/Lib/Print")
--local getOreFn = require("Data/Profiles/Scripts/Lib/Ore")
--local mergeOreFn = require("Data/Profiles/Scripts/Lib/MergeOre")
--local moveItemLoopFn = require("Data/Profiles/Scripts/Lib/MoveItemLoop")
--local ensureToolFn = require("Data/Profiles/Scripts/Lib/EnsureTool")

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
        --printItemFn(ore)
        table.insert(oresByHue[ore.Hue], ore)
    end

    local playerOres = Items.FindByFilter({ graphics = OreGraphics })
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

-- Function to check if a stop message is present in the journal
function checkJournal()
    for _, msg in ipairs(errorMessages) do
        if Journal.Contains(msg) then
            return true, msg -- Returns true and the found message
        end
    end
    return false, nil
end

local function toString(b)
    return b and "true" or "false"
end

-- Main function
function main()
    Journal.Clear()

    -- Continuous check, as long as no error is found
    while action do
        if debug then
            Messages.Overhead("Looking for Pickaxe", Player.Serial)
        end
        -- Check if a tool is available and equipped
        if not ensureTool(pickaxeGraphicId) then
            -- No more pickaxes in backpack
            action = false
            break
        end

        if debug then
            Messages.Overhead("Found Pickaxe", Player.Serial)
        end

        ensureTool(pickaxeGraphicId)
        local pickaxe = Items.FindByLayer(1) -- Check if the tool is still equipped in the hand
        Player.UseObject(pickaxe.Serial)
        Pause(100) -- Wait a second between actions
        if not hasTarget then
            if debug then
                Messages.Overhead("Waiting for first target", Player.Serial)
            end
            Pause(1000)
            hasTarget = true
        end
        Targeting.TargetLast()

        if debug then
            Messages.Overhead("Looking for Journal", Player.Serial)
        end

        -- Check the journal for specific messages
        local hasError, foundMessage = checkJournal()
        if hasError then
            -- If the error message is "There is no metal here to mine", display a specific message
            if foundMessage == "There is no metal here to mine." then
                Messages.Overhead("No ore", Gray, Player.Serial)
            end
            if debug then
                Messages.Overhead("Stopping Loop", Gray, Player.Serial)
            end
            action = false
        end

        -- Clear the journal after each check to avoid duplicates
        Journal.Clear()
    end

    -- Collect all Ores in backpack + ground
    local oresByHue = getOresByHue()
    --for _, ores in pairs(oresByHue) do
    --    for _, ore in ipairs(ores) do
    --        printItemFn(ore)
    --    end
    --end

    -- Merged them to 1 slot per Hue, prioritizing ground last
    -- Do it twice since server desync can happen
    mergeOres()
    local huesToSortedOres = mergeOres()

    -- Find the only Iron Ore in the piles
    local ironOre = nil
    if huesToSortedOres[IronOreHue] and huesToSortedOres[IronOreHue][1] then
        ironOre = huesToSortedOres[IronOreHue][1]
        --Messages.Overhead("Ore found: " .. ironOre.Name, Player.Serial)
    else
        Messages.Overhead("No chok to process", Player.Serial)
    end

    -- Drop Iron Ore on ground + take it back if overweight
    local worldOres = Items.FindByFilter({rangmine = 0, rangemax = 2, graphics = OreGraphics})
    if Player.Weight > maxWeight or #worldOres > 0 then
        if debug then
            Messages.Overhead("Overweight!", G.Purple, Player.Serial)
        end
        while true do
            --Cancel with Ctrl + C shortcut on "Stop All Scripts"
            if not moveItemLoop(ironOre) then
                huesToSortedOres = mergeOres()
                if huesToSortedOres[G.IronOreHue] == nil then
                    huesToSortedOres = mergeOres()
                end
                ironOre = huesToSortedOres[G.IronOreHue][1]
            end
        end
    end
end

main()