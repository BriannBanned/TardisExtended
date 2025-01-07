ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Tardis EMP"
ENT.Spawnable = true
ENT.Instructions= "Temporarily disables non-vortex Tardises around the EMP after a 8 second chargeup."
ENT.AdminOnly = false
ENT.Category = "#TARDIS.Spawnmenu.CategoryTools"
ENT.IconOverride = "materials/entities/tardis_emp_icon.png"


function ENT:SetupDataTables()
 
	self:NetworkVar( "Bool", false, "ChargingUp" )
	self:NetworkVar( "Bool", false, "IsBroken" )
 
 end