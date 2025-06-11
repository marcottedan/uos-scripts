local G = require("Data/Profiles/Scripts/Lib/Global")
local printItemFn = require("Data/Profiles/Scripts/Lib/Print")

local function findMyItemByName(itemName)

    local item = nil
    item = Items.FindByName(itemName)

    if item ~= nil then
        --printItemFn(item)
        if item.RootContainer == Player.Serial then
            return item
        end
    end

    return item
end

return findMyItemByName