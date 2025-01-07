TARDIS:RemoveControl("engine_release")
TARDIS:AddControl({
    id = "engine_release",
    ext_func=function(self, ply)
        if not self:GetPower() and not self:GetAuxMode() then
            if self:GetData("auxenginerelease") then
                self:SetData("auxenginerelease",false,true) 
                TARDIS:Message(ply, "Breaking EOH proxy console connection.")
            else
                self:SetData("auxenginerelease",true,true) 
                TARDIS:Message(ply, "Directing EOH proxy straight to console.")
            end
            if self:CanBootAuxilliary() then
                TARDIS:Message(ply, "All systems required for auxilliary mode are enabled.")
            end
            return
        end
        if self:GetAuxMode() then
            TARDIS:Message(ply, "Rebooting energy reserves..")
            self:LogoffAuxilliaryMode()
            timer.Simple(1,function()
                if IsValid(self) then
                    self:SetData("tardis-emped",false,true)
                    self:BootAuxilliaryMode() --make thing so it can tlike do crap and break stuff
                end
            end)
            return
        end
        self:EngineReleaseDemat(nil, nil, function(result)
            if result then
                TARDIS:Message(ply, "Controls.EngineRelease.ForceDemat")
            elseif result == false then
                TARDIS:ErrorMessage(ply, "Controls.EngineRelease.FailedDemat")
            end
        end)
        if self:EngineReleaseVortexArtron() then
            TARDIS:Message(ply, "Controls.EngineRelease.ArtronAdded")
        end
        self:EngineReleaseFreePower()
    end,
    serveronly=true,
    power_independent = true,
    power_off_bypass = true,
    auxilliary_bypass = true,
    bypass_isomorphic = true,
    screen_button = {
        virt_console = true,
        mmenu = false,
        toggle = false,
        frame_type = {0, 1},
        text = "Controls.EngineRelease",
        order = 8,
    },
    tip_text = "Controls.EngineRelease.Tip",
})