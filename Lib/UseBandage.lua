local function UseBandages()
    -- Clean Bandage : 3617
    bandages = Items.FindByType(3617)

    -- If item is found use it
    if bandages ~= nil then
        Player.UseObject(bandages.Serial)
        return true
    end

    return false

end

return UseBandages