AddCSLuaFile("cl_init.lua") -- stole a little forem time sdistort genreator im alittle tired its like 4 am
AddCSLuaFile("shared.lua")

include("shared.lua")

local chargeUpSound

if SERVER then
    chargeUpSound = {}
end

if SERVER then
    util.AddNetworkString("tardis-ext-tdparticle")
    util.AddNetworkString("tardis-ext-tdincrease")
    util.AddNetworkString("tardis-ext-tddecrease")
end

function ENT:SpawnFunction( ply, tr, ClassName )

    self.countedInSingle = false
    self.health = 200
    self.nextFart = 0
    if GetConVar("tardis_ex_tdsingle"):GetBool() then
        if _G.TardisTDExists then
            TARDIS:Message(ply,"A Temportal destabilzer already exists!")
            return
        else
            _G.TardisTDExists = true
            self.countedInSingle = true
        end
    end


    if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 10
	local SpawnAng = ply:EyeAngles()
	SpawnAng.p = 0
	SpawnAng.y = SpawnAng.y + 180
	
	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos )
	ent:SetAngles( SpawnAng )
	ent:Spawn()
	ent:Activate()
	return ent
	
end

function ENT:Initialize()
    self:SetModel("models/mechanics/roboticslarge/claw_hub_8l.mdl")
    self:SetModelScale(1.5)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetName("TemporalDisruptor")
    self:SetColor(Color(135, 241, 255, 255))
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()

    self.Radius = 1000
    if phys:IsValid() then
        phys:Wake()
    end
end


function ENT:OnRemove()
    if self.countedInSingle and GetConVar("tardis_ex_tdsingle"):GetBool() then
        _G.TardisTDExists = false
    end
    if self:GetIsCharged() then
        net.Start("tardis-ext-tddecrease")
        net.Broadcast()
        _G.TDsActive = _G.TDsActive - 1
    end
    if self:GetChargingUp() then
        if chargeUpSound ~= NULL then chargeUpSound:Stop() end
        timer.Remove("TDChargeTimer"..self:EntIndex())
    end
end

function ENT:Destruct()

    local explode = ents.Create("env_explosion")
    explode:SetPos( self:LocalToWorld(Vector(0,0,-50)) )
    explode:SetOwner( self )
    explode:Spawn()
    explode:Fire("Explode", 0, 0 )
    explode:SetKeyValue( "IMagnitude", 100 )

    if self:GetChargingUp() then
        timer.Remove("EMPChargeTimer" .. self:EntIndex())
        if chargeUpSound ~= NULL then chargeUpSound:Stop() end
    end
    self:Remove()
end

function ENT:Use(ply)
    if not GetConVar("tardis_ex_tdenabled"):GetBool() then
        TARDIS:Message(ply,"Temporal Destabilizers are disabled.")
        self:EmitSound("ambient/energy/spark1.wav")
        net.Start("tardis-ext-empparticle")
        net.WriteEntity(self)
        net.Broadcast()
        return
    end

    if self:GetChargingUp() then
        timer.Remove("TDChargeTimer"..self:EntIndex())
        chargeUpSound:Stop()
        self:SetChargingUp(false)
        if self:GetIsCharged() then
            TARDIS:Message(ply, "Disabled Unpowering")
        else
            TARDIS:Message(ply, "Disabled Charging")
        end
    else
        filter = RecipientFilter()
		filter:AddAllPlayers()
        chargeUpSound = CreateSound( self, "chargeupTemporalDestabilizer.wav", filter )
        chargeUpSound:ChangeVolume(1)
        chargeUpSound:Play()
        if self:GetIsCharged() then
            TARDIS:Message(ply, "Powering down!")
            timer.Create("TDChargeTimer" .. self:EntIndex(),15,1,function() disableTemporalDestabilizer(self,ply) end)
            self:SetChargingUp(true)
        else
            TARDIS:Message(ply, "Charging Up!")
            for i,v in ipairs(player.GetAll()) do
                if v ~= ply then TARDIS:Message(v, "A Temporal Destabilizer is charging up!") end
            end
            timer.Create("TDChargeTimer" .. self:EntIndex(),15,1,function() enableTemporalDestabilizer(self,ply) end)
            self:SetChargingUp(true)
        end
    end
end

function enableTemporalDestabilizer(self,ply) --Could have a bool for switch flop instead but i was coding this at 7am no sleep
    for i,v in ipairs(player.GetAll()) do
        TARDIS:Message(v, "A Temporal Destabilizer has been powered up!")
    end
    self:SetColor(Color(255, 94, 88))
    self:SetChargingUp(false)
    self:SetIsCharged(true)
    _G.TDsActive = _G.TDsActive + 1
    net.Start("tardis-ext-tdincrease")
    net.Broadcast()
    if chargeUpSound ~= NULL then chargeUpSound:Stop() end

end

function disableTemporalDestabilizer(self,ply)
    self:SetColor(Color(135, 241, 255, 255))
    self:SetChargingUp(false)
    self:SetIsCharged(false)
    _G.TDsActive = _G.TDsActive - 1
    net.Start("tardis-ext-tddecrease")
    net.Broadcast()
    if chargeUpSound ~= NULL then chargeUpSound:Stop() end
end

function ENT:OnTakeDamage( dmginfo )
    self:EmitSound("ambient/energy/spark2.wav")
    net.Start("tardis-ext-empparticle")
    net.WriteEntity(self)
    net.Broadcast()
	self.health = self.health - dmginfo:GetDamage()
    if self.health < 0 then
        self:Destruct()
    end
end