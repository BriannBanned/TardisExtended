
TARDIS:AddControl({
    id = "link_tardis",
    int_func=function(self,ply)
        print(self)
        if ply == self:GetCreator() then
            TARDIS:ErrorMessage(ply, "You are already linked to tardis!")
        elseif not self:GetCreator():IsValid() then
            self:SetCreator(ply)
            self.exterior:SetCreator(ply) -- thank you divided from 12/23/2021
            TARDIS:Message(ply, "You are now linked to tardis!")
            return true
        else
            TARDIS:ErrorMessage(ply, "Already linked to someone!")
            print(self:GetCreator())
            print(self:GetCreator():IsValid())
            return false
        end
        
    end,
    serveronly=true,
    bypass_isomorphic=true,
    power_independent = true,
    screen_button = {
        virt_console = true,
        mmenu = false,
        popup_only = false,
        toggle = false,
        frame_type = {2, 1},
        text = "Link Tardis",
        order = 17,
    },
    tip_text = "Links you to a tardis. (Only one can be linked)",
})



TARDIS:AddControl({
    id = "unlink_tardis",
    int_func=function(self,ply)
        if self:GetCreator() == ply then
            self:SetCreator(nil)
            self.exterior:SetCreator(nil)
            TARDIS:Message(ply, "You are now not linked to this tardis!")
        else
            TARDIS:ErrorMessage(ply, "You are not linked to this tardis!")
        end
        
    end,
    serveronly=true,
    power_independent = true,
    bypass_isomorphic=true,
    screen_button = {
        virt_console = true,
        mmenu = false,
        popup_only = false,
        toggle = false,
        frame_type = {2, 1},
        text = "Unlink Tardis",
        order = 17,
    },
    tip_text = "Unlinks you from a tardis.",
})
