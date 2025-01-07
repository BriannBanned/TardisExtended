function ENT:GetVortex() --Probably better stuff or ways to do already but whatever honestly
    return self:GetData("vortex")
end
function ENT:GetTeleport() --Probably better stuff or ways to do already but whatever honestly
    return self:GetData("teleport")
end
function GetDestabilizer()
    if _G.TDsActive > 0 then
        return true
    end
    return false
end

if SERVER then
    util.AddNetworkString("tardisext-shake")

end

if CLIENT then
    net.Receive("tardisext-shake",function(len) 
        amp = net.ReadFloat()
        frq = net.ReadFloat()
        dur = net.ReadFloat()
        self = net.ReadEntity()
        util.ScreenShake(self:GetPos(), amp, frq, dur, 300)
    end)
end


--Convar junk
function BoolConvar(name)
    return GetConVar(name):GetBool()
end
function FloatConvar(name)
    return GetConVar(name):GetFloat()
end