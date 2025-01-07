
print("Running Tardis Extended")

_G.TardisEMPisCooldown = false
_G.TardisTDExists = false
_G.TDsActive = 0

if CLIENT then
    
    hook.Add( "PopulateToolMenu", "TardisExtendedSettings", function()


        spawnmenu.AddToolMenuOption( "Options", "TARDIS Extended", "TraitsExtended","#Traits Extended", "", "", function( panel )
            panel:ClearControls()
            panel:Help("Tardis Mood/Traits")
            panel:NumSlider( "Mood Multiplier", "tardis_ex_moodmultiplier", 1, 100 , 0)
            panel:CheckBox( "Enable Mood", "tardis_ex_moodenabled")
            panel:CheckBox( "Show Traits In Chat", "tardis_ex_moodshowchat")
        end)
        spawnmenu.AddToolMenuOption( "Options", "TARDIS Extended", "TechnologyExtended","#Technology Extended", "", "", function( panel )
            panel:ClearControls()
            panel:Help("Tardis Weapons")
            panel:Help("Tardis EMP")
            panel:CheckBox( "Enable EMP's", "tardis_ex_empenabled")
            panel:CheckBox( "Enable EMP Global Cooldown", "tardis_ex_empglobalenabled")
            panel:NumSlider( "EMP Global Cooldown", "tardis_ex_empglobalcooldown",0,500,0)
            panel:NumSlider( "EMP Shutdown Time", "tardis_ex_empshutdowntime",0,500,0)
            panel:Help("")
            panel:Help("Temporal Destabilzer")
            panel:CheckBox( "Enable Temporal Destabilizer's", "tardis_ex_tdenabled")
            panel:CheckBox( "Only allow 1 temporal destabilizer", "tardis_ex_tdsingle")
        end )
        spawnmenu.AddToolMenuOption( "Options", "TARDIS Extended", "RepairExtended","#Repair Extended", "", "", function( panel )
            panel:ClearControls()
            panel:Help("Tardis Repair")
            panel:CheckBox( "Repair Smoke/Sounds", "tardis_ex_repaireffects")
            panel:CheckBox( "Enable auxillary mode death repair", "tardis_ex_completedeathrepair")

        end )
        spawnmenu.AddToolMenuOption( "Options", "TARDIS Extended", "TardisHADS","#HADS Extended", "", "", function( panel )
            panel:ClearControls()
            panel:Help("H.A.D.S. Extended")
            panel:CheckBox( "Enable HADS Extended", "tardis_ex_hadsextended")
            panel:NumSlider( "HADS Cooldown", "tardis_ex_hadscooldown",1,300,0)
            panel:CheckBox( "Damage Trigger HADS", "tardis_ex_haddamagetrigger")
            panel:CheckBox( "Safe return around tardis creator", "tardis_ex_hadsafecreator")
            panel:CheckBox( "Artron doesnt effect HADS", "tardis_ex_artrondonteffecthads")
            panel:CheckBox( "Trigger on enemy in range", "tardis_ex_hadttriggerrange")
            panel:NumSlider( "Enemy trigger range", "tardis_ex_hadrange",1,3000,0)
            panel:CheckBox( "Wont leave if next to creator", "tardis_ex_hadswithincreatorrange")
            panel:NumSlider( "Creator no leave range", "tardis_ex_hadscreatorrange",1,3000,0)
            panel:Help("")
            panel:NumSlider( "Safe return range", "tardis_ex_hadsaferange",1,3000,0)
            panel:NumSlider( "Minimum vortex time", "tardis_ex_hadsminvortextime",1,1000,0)
        end )
        spawnmenu.AddToolMenuOption( "Options", "TARDIS Extended", "TardisMisc","#Extra Extended", "", "", function( panel )
            panel:ClearControls()
            panel:Help("Tardis Misc")
            --panel:CheckBox( "Enable auxilliary isomorphic bypass", "tardis_ex_auxisobypass") didnt work out as isomorphi security is bugged currently
            panel:Help("Uh there was stuff here but it didnt all workout because tardis code is a little hard to work around")
        end )
    end )

end

--Mood
if not ConVarExists("tardis_ex_moodmultiplier") then
    CreateConVar("tardis_ex_moodmultiplier", "1", FCVAR_ARCHIVE)
end
if not ConVarExists("tardis_ex_moodenabled") then
    CreateConVar("tardis_ex_moodenabled", "false", FCVAR_ARCHIVE)
end
if not ConVarExists("tardis_ex_moodshowchat") then
    CreateConVar("tardis_ex_moodshowchat", "false", FCVAR_ARCHIVE)
end

--Repair
if not ConVarExists("tardis_ex_repaireffects") then --Repair Effects
    CreateConVar("tardis_ex_repaireffects", "true", FCVAR_ARCHIVE)
end
if not ConVarExists("tardis_ex_completedeathrepair") then --Compelte Death repair sequence thing
    CreateConVar("tardis_ex_completedeathrepair", "true", FCVAR_ARCHIVE)
end
if not ConVarExists("tardis_ex_repairext") then
    CreateConVar("tardis_ex_repairext", "true", FCVAR_ARCHIVE)
end

--EMP
if not ConVarExists("tardis_ex_empenabled") then
    CreateConVar("tardis_ex_empenabled", "true", FCVAR_ARCHIVE)
end
if not ConVarExists("tardis_ex_empglobalenabled") then
    CreateConVar("tardis_ex_empglobalenabled", "true", FCVAR_ARCHIVE)
end
if not ConVarExists("tardis_ex_empglobalcooldown") then -- EMP Global Cooldown
    CreateConVar("tardis_ex_empglobalcooldown", "50", FCVAR_ARCHIVE)
end
if not ConVarExists("tardis_ex_empshutdowntime") then -- EMP Global Cooldown
    CreateConVar("tardis_ex_empshutdowntime", "30", FCVAR_ARCHIVE)
end
--Temporal Disruptor
if not ConVarExists("tardis_ex_tdenabled") then
    CreateConVar("tardis_ex_tdenabled", "true", FCVAR_ARCHIVE)
end
if not ConVarExists("tardis_ex_tdsingle") then
    CreateConVar("tardis_ex_tdsingle", "true", FCVAR_ARCHIVE)
end

--Hads
if not ConVarExists("tardis_ex_hadsextended") then
    CreateConVar("tardis_ex_hadsextended", "true", FCVAR_ARCHIVE)
end
if not ConVarExists("tardis_ex_haddamagetrigger") then
    CreateConVar("tardis_ex_haddamagetrigger", "true", FCVAR_ARCHIVE)
end
if not ConVarExists("tardis_ex_artrondonteffecthads") then
    CreateConVar("tardis_ex_artrondonteffecthads", "true", FCVAR_ARCHIVE)
end
if not ConVarExists("tardis_ex_hadttriggerrange") then
    CreateConVar("tardis_ex_hadttriggerrange", "true", FCVAR_ARCHIVE)
end
if not ConVarExists("tardis_ex_hadsafecreator") then
    CreateConVar("tardis_ex_hadsafecreator", "true", FCVAR_ARCHIVE)
end
if not ConVarExists("tardis_ex_hadswithincreatorrange") then
    CreateConVar("tardis_ex_hadswithincreatorrange", "true", FCVAR_ARCHIVE)
end
if not ConVarExists("tardis_ex_hadscreatorrange") then
    CreateConVar("tardis_ex_hadscreatorrange", "500", FCVAR_ARCHIVE)
end
if not ConVarExists("tardis_ex_hadrange") then
    CreateConVar("tardis_ex_hadrange", "800", FCVAR_ARCHIVE)
end
if not ConVarExists("tardis_ex_hadsaferange") then
    CreateConVar("tardis_ex_hadsaferange", "2000", FCVAR_ARCHIVE)
end
if not ConVarExists("tardis_ex_hadsminvortextime") then
    CreateConVar("tardis_ex_hadsminvortextime", "20", FCVAR_ARCHIVE)
end
if not ConVarExists("tardis_ex_hadscooldown") then
    CreateConVar("tardis_ex_hadscooldown", "30", FCVAR_ARCHIVE)
end

--Misc Junk
if not ConVarExists("tardis_ex_auxisobypass") then
    CreateConVar("tardis_ex_auxisobypass", "true", FCVAR_ARCHIVE)
end