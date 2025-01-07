include("shared.lua")
function ENT:Draw()
    self:DrawModel()
end
if CLIENT then
    net.Receive("tardis-ext-tdparticle",function(len) 
        ob = net.ReadEntity()
        local vPoint = ob:GetPos() + (25 * ob:GetUp())
        local effectdata = EffectData()
        effectdata:SetScale(2)
        effectdata:SetMagnitude(2)
        effectdata:SetRadius(2)
        effectdata:SetOrigin( vPoint )
        util.Effect( "ElectricSpark", effectdata )
    
    end)
        net.Receive("tardis-ext-tdincrease",function(len) 
            _G.TDsActive = _G.TDsActive + 1
        end)
        net.Receive("tardis-ext-tddecrease",function(len) 
            _G.TDsActive = _G.TDsActive - 1
        end)
end