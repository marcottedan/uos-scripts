local function PrintItem(item)
    -- Get item properties safely:
    local name = item.Name or "NoName"
    local graphic = item.Graphic or "Unknown"
    local container = item.RootContainer
    local hue = item.Hue or "0"
    local amount = item.Amount or 1
    local layer = item.Layer or "None"
    local serial = item.Serial or 0
    local durability = item.Durability or "N/A"

    -- Now print clearly formatted information:
    Messages.Print("===============================")
    Messages.Print("Name:       " .. name)
    Messages.Print("Graphic ID: " .. graphic)
    Messages.Print("Container: " .. container)
    Messages.Print("Hue:        " .. hue)
    Messages.Print("Amount:     " .. amount)
    -- Will work eventually
    -- Messages.Print("Durability: " .. durability)
    Messages.Print("Layer:      " .. layer)
    Messages.Print("Serial:     " .. serial)
end

return PrintItem