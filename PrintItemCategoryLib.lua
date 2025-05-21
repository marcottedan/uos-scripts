local itemTypes = require("Data/Profiles/Scripts/Lib/ItemCategory")

for categoryName, items in pairs(itemTypes) do
    Messages.Print("Category:"..categoryName)

    for i, item in ipairs(items) do
        Messages.Print(string.format("  %d. %s (0x%04X)", i, item.Name, item.ItemType))
    end
end