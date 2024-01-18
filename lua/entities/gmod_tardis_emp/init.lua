AddCSLuaFile("cl_init.lua") -- stole a little forem time sdistort genreator im alittle tired its like 4 am
AddCSLuaFile("shared.lua")

include("shared.lua")

if SERVER then
    util.AddNetworkString("tardis-ext-explosion")
end

net.Receive("tardis-ext-explosion",function(len , ply)
    print("Hio")
    ob = net.ReadEntity()
    local effectData = EffectData()
    effectData:SetOrigin(ob:GetPos())
    effectData:SetScale(1)
    effectData:SetMagnitude(1)
    util.Effect("Explosion",effectData)
end)

function ENT:Initialize()
    self:SetModel("models/items/battery.mdl")
    self:ManipulateBoneScale( 0, Vector( 5, 5, 5 ) )
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
end

function ENT:Use(ply)
    if not GetConVar("tardis_ex_empenabled"):GetBool() then
        TARDIS:ErrorMessage(ply,"EMP's are not enabled!")
        return
    end
    TARDIS:Message(ply,"BOOM!")
    print(ply:GetPos())


    for i,v in ipairs(ents.FindByClass("gmod_tardis")) do -- i dont wanna put the mood stuff on a object but i can tthink of any other way than maybe on the hud but that might be annoying
        print(v:GetPos():Distance(self:GetPos()))
        if v:GetPos():Distance(self:GetPos()) < 2500 and not v:GetData("tardis-emped") then
            v:SetPower(false)
            v:SetData("tardis-emped",true,true)
            v:Explode(10)
            timer.Simple(15,function()
                if IsValid(v) then
                    v:SetData("tardis-emped",false,true)
                    v:TogglePower(true)
                end
            end)
        end

    end
    net.Start( "tardis-ext-explosion" )
	net.WriteEntity(self)
    net.Broadcast()

    local effectData = EffectData()
    effectData:SetOrigin(self:GetPos())
    effectData:SetScale(1)
    effectData:SetMagnitude(1)
    util.Effect("Explosion",effectData)
    self:Remove()

end