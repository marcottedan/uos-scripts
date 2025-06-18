function armsLore(itemSerial)
    Skills.Use('Arms Lore')
    --Skills.Use('Item Identification')
    Targeting.WaitForTarget(1050)
    Targeting.Target(itemSerial)
end

function main()
    itemSerial = 1149919325
    armsLore(itemSerial)
    --Pause(10050)
end

while true do
    main()
end