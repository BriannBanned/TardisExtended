TARDIS:RemoveControl("repair")
TARDIS:AddControl({
    id = "repair",
    ext_func=function(self,ply)
            if self:GetAuxMode() then
                print("granpappy")
                self:LogoffAuxilliaryMode()
                self:SetData("power-state",false,true)
                self:SetData("auxlocked",false,true) 
                self:SetData("auxenginerelease",false,true) 
                self:SetData("auxhandbrake",false,true) 
                
                self:ToggleRepair()
                return
            elseif not self:GetPower() then
                if GetConVar("tardis_ex_completedeathrepair"):GetBool() then
                    TARDIS:ErrorMessage(ply, "Repair switch wont work, Will need to boot up auxilliary mode.")
                else
                    self:ToggleRepair()
                end
                return
            end
        if not self:ToggleRepair() then
            TARDIS:ErrorMessage(ply, "Controls.Repair.FailedToggle")
        end
    end,
    serveronly=true,
    power_independent = true,
    screen_button = {
        virt_console = true,
        mmenu = false,
        toggle = true,
        frame_type = {0, 1},
        text = "Controls.Repair",
        pressed_state_data = "repair-primed",
        order = 3,
    },
    tip_text = "Controls.Repair.Tip",
})