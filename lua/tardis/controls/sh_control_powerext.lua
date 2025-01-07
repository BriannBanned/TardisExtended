TARDIS:RemoveControl("power")
TARDIS:AddControl({
    id = "power",
    ext_func=function(self,ply)
        if self:GetAuxMode() then
            TARDIS:Message(ply, "Logging off auxilliary mode.")
            self:LogoffAuxilliaryMode()
            return
        elseif not self:GetPower() then
            if self:CanBootAuxilliary() then
                TARDIS:Message(ply, "Booting up auxilliary mode.")
                self:BootAuxilliaryMode()
                return
            end
        end
        if self:TogglePower() then
            TARDIS:StatusMessage(ply, "Controls.Power.Status", self:GetData("power-state"))
        else
            TARDIS:ErrorMessage(ply, "Controls.Power.FailedToggle")
        end
    end,
    serveronly=true,
    power_independent = true,
    screen_button = {
        virt_console = true,
        mmenu = false,
        toggle = true,
        frame_type = {2, 1},
        text = "Controls.Power",
        pressed_state_data = "power-state",
        order = 2,
    },
    tip_text = "Controls.Power.Tip",
})