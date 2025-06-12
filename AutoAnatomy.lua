mobile = Mobiles.FindByName('an orcish mage')
if mobile ~= nil then
    Messages.Print('Mobile found with serial: ' .. mobile.Serial)
else
    Messages.Print('Mobile not found')
end

while not Player.IsDead do
    Skills.Use('Anatomy')
    Targeting.WaitForTarget(1000)
    Targeting.Target(mobile.Serial)
    --Pause(500)
end