if SERVER then
    ENT:AddHook("OnTakeDamage", "tardis-ext-nodamageinterior", function(self, dmginfo)
        print("Balls V")
        print(self.exterior:GetHealth())
        if dmginfo:GetDamage() < self.exterior:GetHealth() then return end
        print("hola")
        if self.exterior:GetData("flight") then
            print("HI")
            dmginfo:SetDamage(0)
        end
    end)
end