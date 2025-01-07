
if SERVER then
    ENT:AddHook("CanTriggerHads","tardisext-hads",function(self)
        if BoolConvar("tardis_ex_hadsextended") then
            return false
        end
    end)
    ENT:AddHook("Initialize", "tardisext-hads", function(self)
        self:SetData("hads-waitingmin",false)
        self:SetData("hads-preartron",0)
        self:SetData("hads-cooldown", false)
        self:SetData("hads-prePos",Vector(0,0,0),true)
    end)
    ENT:AddHook("SlowThink", "tardisext-hads", function(self)
        if not BoolConvar("tardis_ex_hadsextended") then return end
        if not self:GetHADS() then return end
        if not self:GetVortex() and not self:GetTeleport() then
            local entsRound = ents.FindInSphere( self:GetPos(), FloatConvar("tardis_ex_hadrange"))
            for key, value in ipairs(entsRound) do
                if value:IsNPC() and value:GetEnemy() then
                    self:UniqueNameTriggerHADS(enemy)
                    break
                end
            end
        elseif not self:GetData("mat") and not self:GetTeleport() and not self:GetData("hads-waitingmin") then--Not in vortex
            self:HADSCheckIfSafe()
        end
    end)

    ENT:AddHook("OnTakeDamage", "tardisext-hads", function(self)
        if not self:IsDead() and self:GetPower() and BoolConvar("tardis_ex_haddamagetrigger") and BoolConvar("tardis_ex_hadsextended") then
            self:UniqueNameTriggerHADS()
        end
    end)

    ENT:AddHook("CanTriggerEXTHADS","tardisext-destabilize",function(self,enemy)
        if GetDestabilizer() then
            TARDIS:ErrorMessage(self:GetCreator(), "HADS.DematError")
            TARDIS:ErrorMessage(self:GetCreator(), "HADS.UnderAttack")
            return false
        end
    end)
    ENT:AddHook("CanTriggerEXTHADS","tardisext-creatordontabandon",function(self,enemy)
        if BoolConvar("tardis_ex_hadswithincreatorrange") then
           if math.abs(self:GetPos():Distance(self:GetCreator():GetPos())) < FloatConvar("tardis_ex_hadscreatorrange") then
                return false
           end
        end
    end)
    ENT:AddHook("CanTriggerEXTHADS","tardisext-hadscooldown",function(self,enemy)
        if self:GetData("hads-cooldown") then
            return false
        end
    end)

    function ENT:UniqueNameTriggerHADS(enemy, curPos) --Force remat on low artron
        if not self:GetHADS() then return end --Just in case i forget.
        if not BoolConvar("tardis_ex_hadsextended") then
            self:TriggerHADS()
            return
        end
        if self:CallHook("CanTriggerEXTHADS",enemy) == false then
            return
        end
        if self:GetData("doorstatereal") then
            self:ToggleDoor()
        end
        self:SetData("hads-preartron",self:GetArtron())
        self:SetData("hads-waitingmin",true)
        self:SetData("hads-cooldown", true)
        self:SetData("hads-prePos",self:GetPos())
        timer.Simple(FloatConvar("tardis_ex_hadsminvortextime"),function()
            if IsValid(self) and self ~= NULL then
                self:SetData("hads-waitingmin",false)
                self:Timer("hads-cooldown",FloatConvar("tardis_ex_hadscooldown"),function()
                    if not IsValid(self) then return end
                    self:SetData("hads-cooldown", false)
                end)
            end
        end)
        self:SetData("hads-triggered", true, true)
        self:SetData("hads-demat", true, true)
        self:SetFastRemat(false)
        self:SetRandomDestination(true)
        self:AutoDemat()
        self:CallHook("HADSTrigger")

        TARDIS:Message(self:GetCreator(),"HADS.Triggered")
    end

    function ENT:HADSCheckIfSafe() --IMPlement uh no player just nor remat around where left oder random 
        
        --Check Artron Here!/Temporal Destabilizer tardis_ex_artrondonteffecthads
        if not BoolConvar("tardis_ex_artrondonteffecthads") then
            if self:GetArtron() < 100 then
                self:HADSRemat()
                return
            end
        else
            self:SetArtron(self:GetData("hads-preartron"))
        end
        if GetDestabilizer() then
            self:HADSRemat()
            return
        end

        if BoolConvar("tardis_ex_hadsafecreator") then --If creator inside tardis fix later probably wont but whatever
            local entsRound = ents.FindInSphere( self:GetCreator():GetPos(), FloatConvar("tardis_ex_hadsaferange"))
            for key, value in ipairs(entsRound) do
                if value:IsNPC() and value:GetEnemy() then
                    return
                end
            end
        else
            local entsRound = ents.FindInSphere(self:GetData("hads-prePos"), FloatConvar("tardis_ex_hadsaferange"))
            for key, value in ipairs(entsRound) do
                if value:IsNPC() and value:GetEnemy() then
                    return
                end
            end
        end
        TARDIS:Message(self:GetCreator(),"H.A.D.S has rematerialized the TARDIS!")
        self:HADSRemat()

    end

    function ENT:HADSRemat()
        if BoolConvar("tardis_ex_hadsafecreator") then
            local nowayflag = false
            for ply, _ in pairs(self.occupants) do
                if ply == self:GetCreator() then
                    nowayflag = true
                    break
                end
            end
            if nowayflag then
                self:SetDestination(self:GetGroundedPos(self:GetData("hads-prePos"))) --Will materialize even if unsafe fix later probably
            else
                self:SetDestination(self:GetPositionAroundCreator(self:GetCreator():GetRight()*-300), Angle(0,0,0))
            end
        else
            self:SetDestination(self:GetGroundedPos(self:GetData("hads-prePos")))
        end
        self:Mat()
    end

    function ENT:GetPositionAroundCreator(offset)
        creatorPos = self:GetCreator():GetPos() + offset
        groundPos = self:GetGroundedPos(creatorPos)
        return groundPos
    end
end