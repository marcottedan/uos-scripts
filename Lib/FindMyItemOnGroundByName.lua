local G = require("Data/Profiles/Scripts/Lib/Global")
local printItemFn = require("Data/Profiles/Scripts/Lib/Print")

local function findMyItemOnGroundByName(itemName)

    local items = Items.FindByFilter({onground = true})

    for _, item in ipairs(items) do
        if item.Name == itemName then
            return item
        end
    end

    return nil
end

return findMyItemOnGroundByName