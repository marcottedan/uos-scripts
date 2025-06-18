local G = require("Data/Profiles/Scripts/Lib/Global")
local printItemFn = require("Data/Profiles/Scripts/Lib/Print")
local findMyItemOnGroundByNameFn = require("Data/Profiles/Scripts/Lib/FindMyItemOnGroundByName")
local findLockpickToolFn = require("Data/Profiles/Scripts/Lib/FindLockpickTool")


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
        Pause(10000)
    end

    chest = findMyItemOnGroundByNameFn('Wooden Box')
    if chest == nil then
        Messages.Overhead("No Wooden Box", Player.Serial)
    end

    -- Lockpick chest to explosion
    lockpickChest(chest)
end

while true do
    LockpickingChest = true
    main()
end


