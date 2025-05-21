local printFn = require("Data/Profiles/Scripts/Lib/Print")

function PrintMyEquippedItems()
    local equippedLayers = {
        1,  -- No idea
        2,  -- OneHanded (Left Hand usually)
        3,  -- TwoHanded Weapon
        4,  -- Shoes
        5,  -- Pants
        6,  -- Shirt
        7,  -- Helmet/Headgear
        8,  -- Gloves
        9,  -- Ring
        10, -- Talisman
        11, -- Necklace
        12, -- Hair
        13, -- Waist (e.g. belt)
        14, -- Torso
        15, -- Bracelet
        16, -- Face (e.g. masks)
        17, -- Beard
        18, -- Tunic (e.g. surcoat)
        19, -- Earrings
        20, -- Arms (arm armor)
        21, -- Cloak
        22, -- Backpack
        23, -- Robe
        24, -- Skirt
        25, -- Leg Armor
        26  -- Mount
    }

    for _, layerID in ipairs(equippedLayers) do
        local item = Items.FindByLayer(layerID)
        if item ~= nil then
            printFn(item)
        end
    end
end

function Main()
    PrintMyEquippedItems()
end

Main()