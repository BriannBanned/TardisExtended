--EMP
ENT:AddHook("CanTogglePower", "tardis-ext-empedpower", function(self, on)
    if self:GetData("tardis-emped") then
        return false
    end
end)

ENT:AddHook("CanRepair", "tardis-ext-empedrepair", function(self, ignore_health)
    if self:GetData("tardis-emped") then
        return false
    end
end)

ENT:AddHook("EMPShouldPass", "emppass", function(self,emp) --Expandability i guess
    if not self:GetPower() then return true end
end)
ENT:AddHook("EMPShouldIgnore", "empignore", function(self,emp)
    if self:GetVortex() then return true end
end)