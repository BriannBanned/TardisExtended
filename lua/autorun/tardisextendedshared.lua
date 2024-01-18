
print("Running Tardis Extended")


if CLIENT then
    
    hook.Add( "PopulateToolMenu", "TardisExtendedSettings", function()
        spawnmenu.AddToolMenuOption( "Options", "TARDIS", "TardisExtendedSetting", "#Tardis Extended", "", "", function( panel )
            panel:ClearControls()
            panel:Help("Tardis Mood")
            panel:NumSlider( "Mood Multiplier", "tardis_ex_moodmultiplier", 1, 100 , 0)
            panel:CheckBox( "Enable Mood", "tardis_ex_moodenabled")
            panel:Help("Tardis Weapons")
            panel:CheckBox( "Enable EMP's", "tardis_ex_empenabled")
            panel:Help("Tardis Misc")
            panel:CheckBox( "Enable repair extended?", "tardis_ex_repairext")
            -- Add stuff here
        end )
    end )

end


if not ConVarExists("tardis_ex_moodmultiplier") then
	
    CreateConVar("tardis_ex_moodmultiplier", "1", FCVAR_ARCHIVE)
        
end
    
if not ConVarExists("tardis_ex_moodenabled") then
    CreateConVar("tardis_ex_moodenabled", "true", FCVAR_ARCHIVE)
end

if not ConVarExists("tardis_ex_empenabled") then
    CreateConVar("tardis_ex_empenabled", "true", FCVAR_ARCHIVE)
end
if not ConVarExists("tardis_ex_repairext") then
    CreateConVar("tardis_ex_repairext", "true", FCVAR_ARCHIVE)
end