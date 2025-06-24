local G = require("Data/Profiles/Scripts/Lib/Global")
local printItemFn = require("Data/Profiles/Scripts/Lib/Print")
local findMyItemByNameFn = require("Data/Profiles/Scripts/Lib/FindMyItemByName")
local findTinkerToolFn = require("Data/Profiles/Scripts/Lib/FindTinkerTool")
local findLockpickToolFn = require("Data/Profiles/Scripts/Lib/FindLockpickTool")
local useBandageFn = require("Data/Profiles/Scripts/Lib/UseBandage")
local useSongOfHealingFn = require("Data/Profiles/Scripts/Lib/UseSongOfHealing")

local TrappingChest = true
local LockpickingChest = true

local trappingSuccess = {
    "There is no metal here to mine."
}

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

function lockChest(key, chest)
    Player.UseObject(key.Serial)
    Pause(100)
    Targeting.Target(chest.Serial)
end

function trapChest(chest)
    Journal.Clear()

    -- Create Explosion Trap Control Id: 16
    findTinkerToolFn()
    if Gumps.WaitForGump(2653346093, 2000) then
        Pause(100)
        -- Sends a button click to the gump
        Gumps.PressButton(2653346093, 16)
    end

    -- Wait for Tinker crafting the Trap
    Pause(1500)
    Targeting.Target(chest.Serial)
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

    chest = findMyItemByNameFn('Wooden Box')
    if chest == nil then
        Messages.Overhead("No Wooden Box", Player.Serial)
    end
    key = findMyItemByNameFn('Copper Key')
    if key == nil then
        Messages.Overhead("No Copper Key", Player.Serial)
    end

    -- Trap chest
    trapChest(chest)
    trapChest(chest)

    -- Enable trap
    lockChest(key, chest)

    -- Heal to max relying on ally
    while Player.DiffHits > 0 do
        Pause(1000)
    end

    -- Lockpick chest to explosion
    lockpickChest(chest)
end

while true do
    TrappingChest = true
    LockpickingChest = true
    main()
end


