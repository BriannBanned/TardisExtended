AddCSLuaFile("cl_init.lua") -- stole a little forem time sdistort genreator im alittle tired its like 4 am
AddCSLuaFile("shared.lua")

include("shared.lua")


function ENT:Initialize()
    self:SetModel("models/props_lab/reciever01b.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetName("TardisMoodifier")
    self:SetColor(Color(255, 255, 255, 255))
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()

    self.Radius = 1000

    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:Use(ply)
    if not GetConVar("tardis_ex_moodenabled"):GetBool() then
        TARDIS:ErrorMessage(ply,"Mood is not enabled!")
        return
    end
    for i,v in ipairs(ents.FindByClass("gmod_tardis_interior")) do -- i dont wanna put the mood stuff on a object but i can tthink of any other way than maybe on the hud but that might be annoying
        if v:GetPos():Distance(self:GetPos()) <= v.metadata.Interior.ExitDistance then -- i dont evebn unerstad this
            if v:GetData("tardis-done") then
                TARDIS:ErrorMessage(ply,"Moodifier cant pick up any signal.")
                return
            end
            print(v:GetData("tardis-mood"))
            if v:GetData("tardis-mood") > 225 then
                TARDIS:Message(ply,"The TARDIS is feeling wonderful!")
            elseif v:GetData("tardis-mood") > 200 then
                TARDIS:Message(ply,"The TARDIS is feeling great!")
            elseif v:GetData("tardis-mood") > 150 then
                TARDIS:Message(ply,"The TARDIS is feeling nice!")
            elseif v:GetData("tardis-mood") > 100 then
                TARDIS:Message(ply,"The TARDIS is feeling ok.")
            elseif v:GetData("tardis-mood") > 0 then
                TARDIS:Message(ply,"The TARDIS is feeling bored.")
            elseif v:GetData("tardis-mood") > -50 then
                TARDIS:Message(ply,"The TARDIS is feeling sad.")
            elseif v:GetData("tardis-mood") > -100 then
                TARDIS:Message(ply,"The TARDIS is feeling mad!")
            else
                TARDIS:Message(ply,"The TARDIS is feeling furous!")
            end
        end
    end
end