

--[[traitList = {"adrenaline", 
"lazy", 
"vortexSick", 
"agrophobic", 
"claustrophobic",
"outdoorsy", --incompatible with agrophobic and introverted
"introverted"} --incompatible with claustrophobic and outdoorsy. ok i just commeted all of this to move it down so it just sets it i have no idea what is going on--]] 
debugmode = false

local rageCoolDownMax = 200
if CLIENT then return end
    function ENT:GiveTraits()
        local tab = {}
        local possibleTraits = {"adrenaline", --was setting possible traits to ttrait list nbut whatever i mean it doesnt matter or wahtevrer ig euss
        "lazy", 
        "vortexSick", 
        "agrophobic", 
        "claustrophobic",
        "outdoorsy", --incompatible with agrophobic and introverted
        "introverted"} --ok for some reason its deleting tghe things in traitlist and not piossible traits what is going on?!?!?!?!@?@ anm i ajust du bM!!?!??!
        for i=1,2 do 
            tra = possibleTraits[math.random(#possibleTraits)]
            self:SetData("tardis-traits", {}, true)
            table.insert(tab,tra)
            self:SetData("tardis-traits", tab, true)
            self:SetData("tardis-mood", 100, true)
            self:SetData("tardis-rage-cooldown",20,true )
            for k,v in pairs(possibleTraits) do
                if v == tra then
                    table.remove(possibleTraits, k) -- ill probably do incompatabilities another time
                end
            end
        end
        if GetConVar("tardis_ex_moodshowchat"):GetBool() then
            PrintMessage(HUD_PRINTTALK, "--" )
            for k,v in pairs(self:GetData("tardis-traits")) do
                PrintMessage(HUD_PRINTTALK, v )
            end
        end
    end

    function ENT:SetTardisMood(num, add)
        numChanged = num * GetConVar("tardis_ex_moodmultiplier"):GetInt()
        if add then
            self:SetData("tardis-mood",self:GetData("tardis-mood") + numChanged,true)
        else
            self:SetData("tardis-mood",numChanged,true)
        end
        if self:GetData("tardis-mood") > 250 then
            self:SetData("tardis-mood",250,true)
        end
        if self:GetData("tardis-mood") < -150 then
            self:SetData("tardis-mood",-150,true)
        end
    end

    function ENT:HasTrait(traitName)
        for k,trait   in pairs(self:GetData("tardis-traits")) do
            if trait == traitName then
                return true
            end
        end
        return false
    end

    ENT:AddHook("Initialize", "tardis-trait", function(self)
        self:GiveTraits()
    end)

    ENT:AddHook("OnTakeDamage", "tardis-mood-damage", function(self, dmginfo)
        if not GetConVar("tardis_ex_moodenabled"):GetBool()  then return end
        if dmginfo:GetAttacker() == self:GetCreator() then
            self:SetTardisMood(-2, true)
        end
    end)

    ENT:AddHook("Think", "tardis-trait-think", function(self)
        if not GetConVar("tardis_ex_moodenabled"):GetBool()  then return end
        if not self:GetCreator():IsValid() then return end
        --[[for op in pairs(self.occupants) do
            self:SetCreator(op)
            self.interior:SetCreator(op) -- thank you divided from 12/23/2021
            break
        end--]]
        if CurTime() < self:GetData("next-tardis-mood-update", 0) then return end -- i didnt steal this from the artron stuff nope... ok maybe but that code is like 25% mine so i partially own this ( life saver i was using frametime like delta time in unity)
        self:SetData("next-tardis-mood-update", CurTime() + 1)
        if self:GetData("tardis-rage-cooldown") > 0 then
            self:SetData("tardis-rage-cooldown",self:GetData("tardis-rage-cooldown") -1 ,true)
        end
        if self:GetData("tardis-mood") > 25 and not self:HasTrait("lazy") and table.IsEmpty(self.occupants) then -- maybe add code for changeed this tick so dont do this.. i dont remember what i was trying to say here
            self:SetTardisMood(-0.02, true)
        end
        if not table.IsEmpty(self.occupants) then
            if debugmode then
                self:SetTardisMood(-25, true)
            else
                self:SetTardisMood(0.04, true)
            end
        end

        if self:GetData("flight") then
            self:SetTardisMood(0.1, true)
        end

        if self:GetData("vortex") or self:GetData("teleport") then
            if not self:HasTrait("vortexSick") then
                self:SetTardisMood(0.1, true)
            end
        end



        --Adrenaline
        if self:HasTrait("adrenaline") then -- i could put all of these into seperate functions but i also could shove a pineapple up my butt
            if self:GetData("flight") and not self:GetData("vortex") and not self:GetData("teleport")then
                self:SetTardisMood(1.5, true)
            end
            if self:GetData("vortex") or self:GetData("teleport") and not self:HasTrait("vortexSick") then
                self:SetTardisMood(1, true)
            end
        end
        --vortex sick
        if self:HasTrait("vortexSick") then
            if self:GetData("vortex") or self:GetData("teleport") then
                self:SetTardisMood(-1.5, true)
            end
        end
        --agrophobic claustrophobic introverted outdoorsy
        if self:HasTrait("agrophobic") or self:HasTrait("claustrophobic") or self:HasTrait("introverted") or self:HasTrait("outdoorsy") then -- i dont wanna run 4 diffewrent raycasts per agrophobic and claustrophobic. just change the penatly/reward depending on the type
            local tr = util.TraceLine( {
                start = self:GetPos(),
                endpos = self:GetPos() + Vector(0,0,1) * 1000,
                filter = function( ent ) return ( ent:GetClass() == "prop_physics" ) end
            } )
            debugoverlay.Line(self:GetPos(),self:GetPos() + Vector(0,0,1) * 1000, 1,Color( 255, 255, 255 ),false)
            if tr.Hit then
                if self:HasTrait("claustrophobic") then
                    self:SetTardisMood(-0.2, true)
                end
                if self:HasTrait("introverted") then
                    self:SetTardisMood(0.02, true)
                end
            else
                if self:HasTrait("agrophobic") then
                    self:SetTardisMood(-0.2, true) --outdoorsy
                end
                if self:HasTrait("outdoorsy") then
                    self:SetTardisMood(0.02, true)
                end
            end
        end
        --BUFFS FROM MOOD!!!
        if self:GetData("tardis-mood") > 150 then
            for op in pairs(self.occupants) do
                if op:Health() < op:GetMaxHealth() then
                    op:SetHealth(op:Health() + 1)
                end
                if op:Health() < op:GetMaxHealth() and self:GetData("tardis-mood") > 200 then
                    op:SetHealth(op:Health() + 1)
                end
            end
        end
        --debuffs from mood ): your mean
        if self:GetData("tardis-mood") < -125 and math.random(1,100) == 5 and self:GetData("tardis-rage-cooldown") <= 0  and not self:GetRepairing() then
            if math.random(1,1000) == 69 then
                self:secret() --dont look into it you will regret it
            else
                if not self:GetData("vortex") and not self:GetData("teleport") then
                    ownerHere = false
                    for op in pairs(self.occupants) do -- gonna leave the owner behind but other people can stay
                        if op == self:GetCreator() then
                            ownerHere = true
                        end
                    end
                    if not ownerHere then
                        TARDIS:ErrorMessage(self:GetCreator(), "Your tardis just dematerialized!") -- can add different rage types
                        self:SetData("tardis-mood",self:GetData("tardis-mood")+25,true)
                        self:SetData("cloisters",true,true)
                        self:SetData("tardis-rage-cooldown", rageCoolDownMax,true)
                        self:SetHandbrake(false)
                        if self:GetData("doorstatereal") then
                            self:ToggleDoor()
                        end
                        self:SetData("power-state",on,true)
                        self:CallCommonHook("PowerToggled", on)
                        self:SetPower(true)
                        self:SetRandomDestination(not self:GetData("float"))
                        self:Demat()
                        timer.Simple(25, function()
                            if IsValid(self) and self:GetData("vortex") then
                                self:Mat()
                                self:SetData("cloisters",false,true)
                            end
                        end)
                    end
                end
            end
        end
        
    end)
--save player from death if high enough mood

hook.Add( "EntityTakeDamage", "tardis-ext-preventdeath", function( victim, dmginfo,t )
    if victim:IsPlayer() and not victim:Alive() then --why does the player still take damage when dead?
        return
    end
    if victim:IsPlayer() and dmginfo:GetDamage() >= victim:Health() then --- only fatal
        for i,v in ipairs(ents.FindByClass("gmod_tardis_interior")) do
            if victim == v.exterior:GetCreator() and v:GetData("tardis-mood") > 200 and v:GetPower() and math.random(1,10) == 2 then
                print("Savior")
                dmginfo:SetDamage(0)
                victim:SetHealth(victim:GetMaxHealth())
                local fallback=v.metadata.Interior.Fallback
                TARDIS:Message(victim,"The TARDIS saved you from fatal damage!")
                victim:SetPos(v:LocalToWorld(fallback.pos))
                victim:SetEyeAngles(v:LocalToWorldAngles(fallback.ang))
                victim:EmitSound(v.metadata.Exterior.Sounds.CloakOff)
            end
            
        end
    end
end )







--[[



dont look down here its a secret























































































































































your gonna regret looking down there

































































⣿⣿⣿⠟⢹⣶⣶⣝⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⡟⢰⡌⠿⢿⣿⡾⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⢸⣿⣤⣒⣶⣾⣳⡻⣿⣿⣿⣿⡿⢛⣯⣭⣭⣭⣽⣻⣿⣿⣿
⣿⣿⣿⢸⣿⣿⣿⣿⢿⡇⣶⡽⣿⠟⣡⣶⣾⣯⣭⣽⣟⡻⣿⣷⡽⣿
⣿⣿⣿⠸⣿⣿⣿⣿⢇⠃⣟⣷⠃⢸⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣽
⣿⣿⣿⣇⢻⣿⣿⣯⣕⠧⢿⢿⣇⢯⣝⣒⣛⣯⣭⣛⣛⣣⣿⣿⣿⡇
⣿⣿⣿⣿⣌⢿⣿⣿⣿⣿⡘⣞⣿⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇
⣿⣿⣿⣿⣿⣦⠻⠿⣿⣿⣷⠈⢞⡇⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇
⣿⣿⣿⣿⣿⣿⣗⠄⢿⣿⣿⡆⡈⣽⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢻
⣿⣿⣿⣿⡿⣻⣽⣿⣆⠹⣿⡇⠁⣿⡼⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⣾
⣿⠿⣛⣽⣾⣿⣿⠿⠋⠄⢻⣷⣾⣿⣧⠟⣡⣾⣿⣿⣿⣿⣿⣿⡇⣿
⢼⡟⢿⣿⡿⠋⠁⣀⡀⠄⠘⠊⣨⣽⠁⠰⣿⣿⣿⣿⣿⣿⣿⡍⠗⣿
⡼⣿⠄⠄⠄⠄⣼⣿⡗⢠⣶⣿⣿⡇⠄⠄⣿⣿⣿⣿⣿⣿⣿⣇⢠⣿
⣷⣝⠄⠄⢀⠄⢻⡟⠄⣿⣿⣿⣿⠃⠄⠄⢹⣿⣿⣿⣿⣿⣿⣿⢹⣿
⣿⣿⣿⣿⣿⣧⣄⣁⡀⠙⢿⡿⠋⠄⣸⡆⠄⠻⣿⡿⠟⢛⣩⣝⣚⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣤⣤⣤⣾⣿⣿⣄⠄⠄⠄⣴⣿⣿⣿⣇⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣄⡀⠛⠿⣿⣫⣾⣿


told you so



]]--
function ENT:secret()
    if self:GetData("tardis-done") then return end
    ownerHere = false
    for op in pairs(self.occupants) do -- gonna leave the owner behind but other people can stay
        if op == self:GetCreator() then
            ownerHere = true
        end
    end
    if not ownerHere then return end -- want them inside for shock value
    self:SetData("tardis-done",true,true)
    self:SetData("power-state",off,true)
    self:CallCommonHook("PowerToggled", off)
    self:SetPower(false)
    self:SetArtron(0)
    self:ChangeHealth(0)
    timer.Simple(4,function()
        if not IsValid(self) then return end
        self:Extinguish()
        self.interior:Extinguish()
        TARDIS:ErrorMessage(self:GetCreator(),"Your Tardis gave up.")
    end)
    timer.Simple(8,function()
        if not IsValid(self) then return end
        self:Extinguish()
        self.interior:Extinguish() -- SOO MUCH FIRE WHYHUJ!!?!?!?!?
        TARDIS:ErrorMessage(self:GetCreator(),"Theres a small chance it may come back.")
    end)
    timer.Simple(12,function()
        if not IsValid(self) then return end
        TARDIS:ErrorMessage(self:GetCreator(),"But i doubt that.") --despsite saying this its like a 50 50 chance xd
    end)
    if math.random(1,2) == 1 then
        if not IsValid(self) then return end
        timer.Simple(80,function()
            if not IsValid(self) then return end
            self:SetData("tardis-done",false,true)
            self:SetData("power-state",on,true)
            self:CallCommonHook("PowerToggled", on)
            self:SetPower(true)
            self:SetArtron(100) -- if it isnt max whaterver this is kinda of a easter egg
            self:ChangeHealth(100)
            self:SetTardisMood(0)
            TARDIS:ErrorMessage(self:GetCreator(),"Your tardis came back. Consider yourself lucky.") -- is this like too dark? am i gonna get banned from gmod? scare 12 year olds away or smth
        end)
    end
end
ENT:AddHook("CanTogglePower", "tardis-ext-gaveup", function(self, on)
    if self:GetData("tardis-done") then
        return false
    end
end)
ENT:AddHook("CanRepair", "tardis-ext-gaverepairup", function(self, ignore_health)
    if self:GetData("tardis-done") then
        return false
    end
end)