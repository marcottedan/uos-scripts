local G = require("Data/Profiles/Scripts/Lib/Global")
local printItemFn = require("Data/Profiles/Scripts/Lib/Print")
local findMyItemOnGroundByNameFn = require("Data/Profiles/Scripts/Lib/FindMyItemOnGroundByName")
local findLockpickToolFn = require("Data/Profiles/Scripts/Lib/FindLockpickTool")

local itemName = 'Wooden Box'
local LockpickingChest = true

local lockpickSuccess = {
    "You set off a trap!",
    "This does not appear to be locked."
}

function checkJournal(messages)
    for _, msg in ipairs(messages) do
        if Journal.Contains(msg) then
            return true, msg -- Returns true and the found message
        end
    end
    return false, nil
end

function lookForWoodenBox()
    local items = Items.FindByFilter({rangemax = 2})

    for _, item in ipairs(items) do
        if item.Name == itemName then
            --Messages.Overhead("Found a Wooden Box", Player.Serial)
            --printItemFn(item)
            return item
        end
    end
end

function lockpickChest(chest)

    while LockpickingChest do
        if not findLockpickToolFn() then
            return
        end
        Targeting.WaitForTarget(1000)
        Targeting.Target(chest.Serial)
        Pause(4050)
        LockpickingChest = not checkJournal(lockpickSuccess)
    end
end

function main()
    Journal.Clear()

    -- Wait for healthy
    while Player.DiffHits > 0 do
        -- Wait for Song of Healing Tick
        Messages.Overhead("Waiting for Healing", Player.Serial)
        Pause(10000)
    end

    chest = findMyItemOnGroundByNameFn('Wooden Box')
    if chest == nil then
        Messages.Overhead("No Wooden Box, waiting", Player.Serial)
    end

    -- Lockpick chest to explosion
    if chest ~= nil then
        lockpickChest(chest)
    end
end

while true do
    LockpickingChest = true
    main()
    Pause(1000)
end


