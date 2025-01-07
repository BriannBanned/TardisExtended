SWEP:AddFunction(function(self,data)
    if data.class=="gmod_tardis_emp" then
        if data.keydown1 and data.hooks.canuse then
            data.ent:Use( self.Owner, self, USE_ON, 0 )
        end
        if data.keydown2 then
            self:EmitSound("ambient/energy/spark1.wav")
            net.Start("tardis-ext-empparticle")
            net.WriteEntity(data.ent)
            net.Broadcast()
            data.ent:TakeDamage(400)
        end
    end
end)