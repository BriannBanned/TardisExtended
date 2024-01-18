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