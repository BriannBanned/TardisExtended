ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Temporal Destabilzer"
ENT.Spawnable = true
ENT.Instructions= "AHHHHHH!!!!!"
ENT.AdminOnly = false
ENT.Category = "#TARDIS.Spawnmenu.CategoryTools"
ENT.IconOverride = "materials/entities/tardis_temporal_destabilizer.png"


function ENT:SetupDataTables()
 
	self:NetworkVar( "Bool", false, "ChargingUp" )
	self:NetworkVar( "Bool", false, "IsCharged" )
 
 end


local function smoke_func(self)
    if self.health > 100 then return end
    if CurTime() < self.nextFart then return end
    self.nextFart = CurTime() + math.random(2,4)
    local smoke = ents.Create("env_smokestack")
    smoke:SetPos(self:LocalToWorld(Vector(0,0,80)))
    smoke:SetAngles(self:GetAngles()+Angle(-0,0,0))
    smoke:SetKeyValue("InitialState", "1")
    smoke:SetKeyValue("WindAngle", "0 0 0")
    smoke:SetKeyValue("WindSpeed", "2")
    smoke:SetKeyValue("rendercolor", "100 100 100")
    smoke:SetKeyValue("renderamt", "255")
    smoke:SetKeyValue("SmokeMaterial", "particle/smokesprites_0001.vmt")
    smoke:SetKeyValue("BaseSpread", "10")
    smoke:SetKeyValue("SpreadSpeed", "50")
    smoke:SetKeyValue("Speed", "15")
    smoke:SetKeyValue("StartSize", "30")
    smoke:SetKeyValue("EndSize", "50")
    smoke:SetKeyValue("roll", "35")
    smoke:SetKeyValue("Rate", "20")
    smoke:SetKeyValue("JetLength", "50")
    smoke:SetKeyValue("twist", "5")
    smoke:Spawn()
    smoke:SetParent(self)
    smoke:Activate()
    timer.Simple(2,function()
        if smoke ~= NULL then
            smoke:Fire("TurnOff")
        end
    end)
end

function ENT:Think()
    if SERVER then smoke_func(self) end
end