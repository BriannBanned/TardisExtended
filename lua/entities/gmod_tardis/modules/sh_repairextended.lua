if SERVER then
    
    ENT:AddHook("Think", "tardis-repairextend-think", function(self)
        if not GetConVar("tardis_ex_repairext"):GetBool() then return end
        if not self:GetRepairing() then return end
        if CurTime() < self:GetData("next-tardis-repair-update", 0) then return end -- i didnt steal this from the artron stuff nope... ok maybe but that code is like 25% mine so i partially own this ( life saver i was using frametime like delta time in unity)
        self:SetData("next-tardis-repair-update", CurTime() + math.random(4,8)) --48
        self:Extinguish()
        self.interior:Extinguish()
        self:EmitSound("steamsound.wav")
        local smoke = ents.Create("env_smokestack")
        smoke:SetPos(self:LocalToWorld(Vector(0,0,80)))
        smoke:SetAngles(self:GetAngles()+Angle(-0,0,0))
        smoke:SetKeyValue("InitialState", "1")
        smoke:SetKeyValue("WindAngle", "0 0 0")
        smoke:SetKeyValue("WindSpeed", "0")
        smoke:SetKeyValue("rendercolor", "200 200 200")
        smoke:SetKeyValue("renderamt", "255")
        smoke:SetKeyValue("SmokeMaterial", "particle/smokesprites_0001.vmt")
        smoke:SetKeyValue("BaseSpread", "30")
        smoke:SetKeyValue("SpreadSpeed", "10")
        smoke:SetKeyValue("Speed", "15")
        smoke:SetKeyValue("StartSize", "15")
        smoke:SetKeyValue("EndSize", "35")
        smoke:SetKeyValue("roll", "35")
        smoke:SetKeyValue("Rate", "10")
        smoke:SetKeyValue("JetLength", "18")
        smoke:SetKeyValue("twist", "5")
        smoke:Spawn()
        smoke:SetParent(self)
        smoke:Activate()
        timer.Simple(1,function()
            smoke:Fire("TurnOff")
        end)
    end)

    ENT:AddHook("ShouldStartSmoke", "tardis-ext-repairext", function(self) -- ewww other smoek ugly fugly
        if not GetConVar("tardis_ex_repairext"):GetBool() then return end
        if self:GetRepairing() then
            return false
        end
    end)
end