TARDIS:RemoveControl("physlock")
TARDIS:AddControl({
    id = "physlock",
    ext_func=function(self,ply)
        print("hi")
        if not self:GetPower() then
            if self:GetData("auxlocked") then
                self:SetData("auxlocked",false,true) 
                TARDIS:Message(ply, "Locking down lower level TARDIS access.")
            else
                self:SetData("auxlocked",true,true) 
                TARDIS:Message(ply, "Unlocking lower level TARDIS access.")
            end
            if self:CanBootAuxilliary() then
                TARDIS:Message(ply, "All systems required for auxilliary mode are enabled.")
            end
            return
        end
        if self:TogglePhyslock() then
            TARDIS:StatusMessage(ply, "Controls.Physlock.Status", self:GetPhyslock(), "Common.Engaged.Lower", "Common.Disengaged.Lower")
        else
            TARDIS:ErrorMessage(ply, "Controls.Physlock.FailedToggle")
        end
    end,
    serveronly=true,
    power_independent = true,
    screen_button = {
        virt_console = true,
        mmenu = false,
        toggle = true,
        frame_type = {0, 2},
        text = "Controls.Physlock",
        pressed_state_data = "physlock",
        order = 12,
    },
    tip_text = "Controls.Physlock.Tip",
})