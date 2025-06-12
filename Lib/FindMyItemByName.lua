local G = require("Data/Profiles/Scripts/Lib/Global")
local printItemFn = require("Data/Profiles/Scripts/Lib/Print")

local function findMyItemByName(itemName)

    local items = Items.FindByFilter({})

    for _, item in ipairs(items) do
        if item.RootContainer == Player.Serial then
            if item.Name == itemName then
                return item
            end
        end
    end

    return nil
end

return findMyItemByName