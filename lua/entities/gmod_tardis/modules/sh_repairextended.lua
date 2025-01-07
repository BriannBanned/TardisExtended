function ENT:GetAuxMode() --TODO make auxilliary mode own lua file...   Auxilliary also give alot of extra energy but also double damage taken and allow isomorphic bypass?
    return self:GetData("auxilliarymode")
end

if CLIENT then
    
    ENT:AddHook("ShouldTurnOnCloisters","cloisters",function(self)
        if self:GetAuxMode() then
            return false
        end
    end)
    net.Receive("tardis-ext-auxmode",function(len) 
        mode = net.ReadBool()
        self = net.ReadEntity()
        self:SetData("auxilliarymode",mode,true)
    end)
end



if SERVER then
    util.AddNetworkString("tardis-ext-auxmode")
    ENT:AddHook("Think", "tardis-repairextend-think", function(self)
        RepairEffects(self)
    end)


    function RepairEffects(self) --I dont wanna touch this as it is currently fine..
        if not GetConVar("tardis_ex_repaireffects"):GetBool() then return end
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
        smoke:SetKeyValue("BaseSpread", "40")
        smoke:SetKeyValue("SpreadSpeed", "10")
        smoke:SetKeyValue("Speed", "15")
        smoke:SetKeyValue("StartSize", "15")
        smoke:SetKeyValue("EndSize", "35")
        smoke:SetKeyValue("roll", "35")
        smoke:SetKeyValue("Rate", "10")
        smoke:SetKeyValue("JetLength", "20")
        smoke:SetKeyValue("twist", "5")
        smoke:Spawn()
        smoke:SetParent(self)
        smoke:Activate()
        timer.Simple(1,function()
            smoke:Fire("TurnOff")
        end)
    end
    ENT:AddHook("ShouldStopSmoke", "tardis-ext-repaireffects", function(self) -- ewww other smoek ugly fugly
        if not GetConVar("tardis_ex_repaireffects"):GetBool() then return end
        if self:GetRepairing() then
            return true
        end
    end)

    
    ENT:AddHook("Initialize", "tardisext-repairinit", function(self)
        self:SetData("auxilliarymode",false,true) 
        self:SetData("auxlocked",false,true) 
        self:SetData("auxenginerelease",false,true) 
        self:SetData("auxhandbrake",false,true) 
    end)

    function ENT:CanBootAuxilliary()
        if self:GetData("auxlocked") and self:GetData("auxhandbrake") and self:GetData("auxenginerelease") then
            return true
        end
        return false
    end

    function ENT:BootAuxilliaryMode()
        self:SetData("auxilliarymode",true,true) 
        self:SetData("power-state",true,true)
        self:SetWarning(true)
        self:SetData("cloisters",false,true)
        self.interior:EmitSound("auxilliaryModeEnable.wav")
        net.Start("tardis-ext-auxmode")
        net.WriteBool(true)
        net.WriteEntity(self)
        net.Broadcast()

    end
    function ENT:LogoffAuxilliaryMode()
        self:SetData("auxilliarymode",false,true) 
        self:SetData("power-state",false,true)
        self:SetData("auxlocked",false,true) 
        self:SetData("auxenginerelease",false,true) 
        self:SetData("auxhandbrake",false,true) 
        self:SetWarning(false)
        self:SetData("cloisters",false,true)
        net.Start("tardis-ext-auxmode")
        net.WriteBool(false)
        net.WriteEntity(self)
        net.Broadcast()
    end

    --The hookening
    ENT:AddHook("PowerToggled", "tardisext-aux", function(self,on)
        if self:GetAuxMode() then
            net.Start("tardis-ext-auxmode")
            net.WriteBool(false)
            net.WriteEntity(self)
            net.Broadcast()
            self:SetData("auxilliarymode",false,true) 
        end
    end)

    ENT:AddHook("CanDemat", "tardisext-aux", function(self, force)
        if self:GetAuxMode() then
            return false
        end
    end)
    ENT:AddHook("CanTurnOnFloat", "tardisext-aux", function(self, force)
        if self:GetAuxMode() then
            return false
        end
    end)
    ENT:AddHook("CanTurnOnFlight", "tardisext-aux", function(self, force)
        if self:GetAuxMode() then
            return false
        end
    end)
    ENT:AddHook("CanTriggerHads", "tardisext-aux", function(self, force)
        if self:GetAuxMode() then
            return false
        end
    end)
    ENT:AddHook("CanToggleShields", "tardisext-aux", function(self, force)
        if self:GetAuxMode() then
            return false
        end
    end)
    ENT:AddHook("CanChangeExterior", "tardisext-aux", function(self, force)
        if self:GetAuxMode() then
            return false
        end
    end)
    ENT:AddHook("CanLock", "tardisext-aux", function(self, force)
        if self:GetAuxMode() then
            return false
        end
    end)

end