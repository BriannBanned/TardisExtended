include("shared.lua")
function ENT:Draw()
    self:DrawModel()
end
if CLIENT then
    net.Receive("tardis-ext-empparticle",function(len) 
        ob = net.ReadEntity()
        local vPoint = ob:GetPos() + (25 * ob:GetUp())
        local effectdata = EffectData()
        effectdata:SetScale(2)
        effectdata:SetMagnitude(2)
        effectdata:SetRadius(2)
        effectdata:SetOrigin( vPoint )
        util.Effect( "ElectricSpark", effectdata )
    
    end)
    end