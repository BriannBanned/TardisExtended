--Temporoal desitoriotrr
if SERVER then
    ENT:AddHook("ShouldWarningBeEnabled","tardisext-destabilizewarning",function(self)
        if _G.TDsActive > 0 then
            if self:GetData("vortex") then
                return true
            end
        end
    end)
end

local function is_sonic_pressed()
    if not looked_at then
        return false
    end
    if ply:GetActiveWeapon() ~= ply:GetWeapon("swep_sonicsd") then
        return false
    end
    return ply:KeyDown(IN_ATTACK) or ply:KeyDown(IN_ATTACK2)
end

ENT:AddHook("Think", "tardis-ext-destabilizerthink", function(self)
    --print(self.interior.occupants)
        if _G.TDsActive > 0 then
            if self:GetData("vortex") then
                --Funky buisness
                if self.TDExplosionFlag == nil then 
                    self.TDExplosionFlag = false 
                end
                if SERVER then
                    self:UpdateWarning()
                    for ply, _ in pairs(self.occupants) do
                        net.Start("tardisext-shake")
                        net.WriteFloat(1)
                        net.WriteFloat(100)
                        net.WriteFloat(5)
                        net.WriteEntity(self.interior)
                        net.Send(ply)
                    end
                end
                if  self.TDExplosionFlag == false then
                    self.TDExplosionFlag = true
                    timer.Create("TDExplosionTimer" .. self:EntIndex(),math.random(2,5),1,function() ExplosionTimer(self) end)
                end
                
            elseif SERVER and self:GetWarning() then
                self:UpdateWarning() -- I dont like but whatever better than making another flag i guess
            end
        end
end)



function ExplosionTimer(self)
    if self == NULL then return end
    if self:GetData("vortex") then
        self.TDExplosionFlag = false
        if CLIENT then
            self:InteriorExplosion()
        end
        if SERVER then
            for ply, _ in pairs(self.occupants) do
                net.Start("tardisext-shake")
                net.WriteFloat(3)
                net.WriteFloat(100)
                net.WriteFloat(1)
                net.WriteEntity(self.interior)
                net.Send(ply)
            end
            self.interior:Explode(90)
            self:SetShieldsLevel(0)
        end
    end
end