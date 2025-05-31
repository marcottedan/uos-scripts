local G = require("Data/Profiles/Scripts/Lib/Global")
local printItemFn = require("Data/Profiles/Scripts/Lib/Print")
local getOreFn = require("Data/Profiles/Scripts/Lib/Ore")
local mergeOreFn = require("Data/Profiles/Scripts/Lib/MergeOre")
local moveItemLoopFn = require("Data/Profiles/Scripts/Lib/MoveItemLoop")
local ensureToolFn = require("Data/Profiles/Scripts/Lib/EnsureTool")


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
        if not ensureToolFn(pickaxeGraphicId) then
            -- No more pickaxes in backpack
            action = false
            break
        end

        if debug then
            Messages.Overhead("Found Pickaxe", Player.Serial)
        end

        ensureToolFn(pickaxeGraphicId)
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
                Messages.Overhead("No ore", G.Gray, Player.Serial)
            end
            if debug then
                Messages.Overhead("Stopping Loop", G.Gray, Player.Serial)
            end
            action = false
        end

        -- Clear the journal after each check to avoid duplicates
        Journal.Clear()
    end

    -- Collect all Ores in backpack + ground
    local oresByHue = getOreFn()
    --for _, ores in pairs(oresByHue) do
    --    for _, ore in ipairs(ores) do
    --        printItemFn(ore)
    --    end
    --end

    -- Merged them to 1 slot per Hue, prioritizing ground last
    -- Do it twice since server desync can happen
    mergeOreFn()
    local huesToSortedOres = mergeOreFn()

    -- Find the only Iron Ore in the piles
    local ironOre = nil
    if huesToSortedOres[G.IronOreHue] and huesToSortedOres[G.IronOreHue][1] then
        ironOre = huesToSortedOres[G.IronOreHue][1]
        --Messages.Overhead("Ore found: " .. ironOre.Name, Player.Serial)
    else
        Messages.Overhead("No chok to process", Player.Serial)
    end

    -- Drop Iron Ore on ground + take it back if overweight
    local worldOres = Items.FindByFilter({rangmine = 0, rangemax = 2, graphics = G.OreGraphics})
    if Player.Weight > maxWeight or #worldOres > 0 then
        if debug then
            Messages.Overhead("Overweight!", G.Purple, Player.Serial)
        end
        while true do
            --Cancel with Ctrl + C shortcut on "Stop All Scripts"
            moveItemLoopFn(ironOre)
        end
    end
end

main()