function detectHidden()
    Skills.Use('Detecting Hidden')
    if Targeting.WaitForTarget(1000) then
        Targeting.TargetSelf()
    end
end

function main()
    detectHidden()
    Pause(5050)
end

while true do
    main()
end