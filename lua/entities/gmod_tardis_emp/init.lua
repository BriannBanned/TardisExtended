AddCSLuaFile("cl_init.lua") -- stole a little forem time sdistort genreator im alittle tired its like 4 am
AddCSLuaFile("shared.lua")

include("shared.lua")

local chargeUpSound
if SERVER then
    chargeUpSound = {}
end

if SERVER then
    util.AddNetworkString("tardis-ext-empparticle")
end

function ENT:Initialize()
    self:SetModel("models/Items/combine_rifle_ammo01.mdl")
    self:SetModelScale(5)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetName("TardisEmp")
    self:SetColor(Color(255, 255, 255, 255))
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()

    self.Radius = 1000
    if phys:IsValid() then
        phys:Wake()
    end
    self.boomed = false
end

function endTimer()
    _G.TardisEMPisCooldown = false
end

function EMPBoom(self,ply)
    if _G.TardisEMPisCooldown and BoolConvar("tardis_ex_empglobalenabled") then 
        self:SetChargingUp(false)
        self:EmitSound("ambient/energy/spark1.wav")
        net.Start("tardis-ext-empparticle")
        net.WriteEntity(self)
        net.Broadcast()
        return 
    end
    timer.Create("tardisglobalemptimer",GetConVar("tardis_ex_empglobalcooldown"):GetFloat(),1,function() endTimer() end)
    _G.TardisEMPisCooldown = true
    self:SetIsBroken(true)
    self:SetColor(Color(151, 151, 151))
    self:SetChargingUp(false)
    self:EmitSound("TardisEMPBoom.wav")
    if not GetConVar("tardis_ex_empenabled"):GetBool() then
        TARDIS:ErrorMessage(ply,"EMP's are not enabled!")
        return
    end
    TARDIS:Message(ply,"TARDIS EMP pulsing!")

    for i,v in ipairs(ents.FindByClass("gmod_tardis")) do
        if v:CallHook("EMPShouldIgnore",v,self) then 
            continue 
        end
            if v:GetPos():Distance(self:GetPos()) < 8000 and not v:GetData("tardis-emped") then
                if not v:CallHook("EMPShouldPass",v,self) then
                    v:CallCommonHook("PowerToggled", false)
                    v:SetHandbrake(true) --Doinnteruptflight?
                    v:SetHandbrake(false)
                    v:SetPower(false)
                    v:SetData("tardis-emped",true,true)
                    v:SetArtron(v:GetArtron() * 0.25)
                    --v:Explode(10) WHY DOES IT MAKE IT NOT POWER TOGGLE OFF?????
                    num = GetConVar("tardis_ex_empshutdowntime"):GetFloat()
                    for ply, _ in pairs(v.occupants) do
                        TARDIS:Message(ply,"The TARDIS has been hit by a EMP wave!")
                        net.Start("tardisext-shake")
                        net.WriteFloat(3)
                        net.WriteFloat(100)
                        net.WriteFloat(3)
                        net.WriteEntity(v.interior)
                        net.Send(ply)
                    end
                    timer.Simple(num,function()
                        if IsValid(v) then
                            v:SetData("tardis-emped",false,true)
                            v:SetPower(true)
                        end
                    end)
                else
                    for ply, _ in pairs(v.occupants) do
                        TARDIS:Message(ply,"An EMP wave went past the tardis!")
                        net.Start("tardisext-shake")
                        net.WriteFloat(1)
                        net.WriteFloat(100)
                        net.WriteFloat(1)
                        net.WriteEntity(v.interior)
                        net.Send(ply)
                    end
                end
        end

    end

    local effectData = EffectData()
    effectData:SetOrigin(self:GetPos())
    effectData:SetScale(0) --Kinda looks cool when at 0 hm
    effectData:SetMagnitude(1)
    util.Effect("Explosion",effectData)
end
function ENT:OnRemove()
    if self:GetChargingUp() then
        timer.Remove("EMPChargeTimer"..self:EntIndex())
        if chargeUpSound ~= nil then chargeUpSound:Stop() end
    end
end

function ENT:Use(ply)
    if not GetConVar("tardis_ex_empenabled"):GetBool() then
        TARDIS:Message(ply,"Tardis EMP's are disabled.")
        self:EmitSound("ambient/energy/spark1.wav")
        net.Start("tardis-ext-empparticle")
        net.WriteEntity(self)
        net.Broadcast()
        return
    end
    if self:GetIsBroken() then
        self:EmitSound("ambient/energy/spark1.wav")
        net.Start("tardis-ext-empparticle")
        net.WriteEntity(self)
        net.Broadcast()
    elseif _G.TardisEMPisCooldown then
        TARDIS:Message(ply, "Tardis EMP energy still lingering from last EMP.")
        self:EmitSound("ambient/energy/spark3.wav")
        net.Start("tardis-ext-empparticle")
        net.WriteEntity(self)
        net.Broadcast()
        return
    elseif self:GetChargingUp() then
        timer.Remove("EMPChargeTimer"..self:EntIndex())
        TARDIS:Message(ply, "Disabled Charging")
        chargeUpSound:Stop()
        self:SetChargingUp(false)
    else
        filter = RecipientFilter()
		filter:AddAllPlayers()
        chargeUpSound = CreateSound( self, "tardisEMPChargeup.wav", filter )
        chargeUpSound:Play()
        TARDIS:Message(ply, "Charging Up!")
        for i,v in ipairs(player.GetAll()) do
            if v ~= ply then TARDIS:Message(v, "A Tardis EMP is charging up!") end
        end
        timer.Create("EMPChargeTimer" .. self:EntIndex(),10,1,function() EMPBoom(self,ply) end)
        self:SetChargingUp(true)
    end
end

function ENT:OnTakeDamage( dmginfo )
	if self == NULL or self.boomed then return end
    if dmginfo:GetDamage() > 1 then
        self.boomed = true
        local explode = ents.Create("env_explosion")
        explode:SetPos( self:LocalToWorld(Vector(0,0,0)) )
        explode:SetOwner( self )
        explode:Spawn()
        explode:Fire("Explode", 0, 0 )
        explode:SetKeyValue( "IMagnitude", 25 )
        if self:GetChargingUp() then
            timer.Remove("EMPChargeTimer" .. self:EntIndex())
            if chargeUpSound ~= nil then chargeUpSound:Stop() end
        end
        self:Remove()
    end
end