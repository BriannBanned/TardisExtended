if SERVER then
    ENT:AddHook("Think", "tardis-ext-legacycrashthink", function(self)
        if CurTime() < self:GetData("next-tardis-dieflying-update", 0) then return end 
        self:SetData("next-tardis-dieflying-update", CurTime() + 1)
    end)

    ENT:AddHook("OnTakeDamage", "tardis-ext-preventdeathflying", function(self, dmginfo)
        print("try")
        if dmginfo:GetDamage() < self:GetHealth() then return end
        if self:GetData("flight") then
            print("HI")
            dmginfo:SetDamage(0)
            if self:GetData("next-tardis-dieflying-update") <= 0 then
                self:SetData("next-tardis-dieflying-update",5,true)
            end
        end
    end)
    --ph:AddVelocity(AngleRand():Forward()*(vell))
end