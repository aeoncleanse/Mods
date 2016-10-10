local BlackOpsEffectTemplate = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsEffectTemplates.lua')

local oldUnit = Unit
Unit = Class(oldUnit) {

    -----------------------------------------------------------
    -- First, all the functions which are hooking the originals
    -----------------------------------------------------------
    
    OnCreate = function(self)
        oldUnit.OnCreate(self)
        self.StunEffectsBag = {}
    end,
    
    OnStopBeingBuilt = function(self,builder,layer)
        oldUnit.OnStopBeingBuilt(self,builder,layer)
        self.EXPhaseShieldPercentage = 0
        self.EXPhaseEnabled = false
        self.EXTeleportCooldownCharge = false
        self.EXPhaseCharge = 0
        self:ForkThread(self.CloakEffectControlThread)
    end,

    -- Overrode this so that there will be no doubt if the cloak effect is active or not
    -- This is an engine function
    SetMesh = function(self, meshBp, keepActor)
        oldUnit.SetMesh(self, meshBp, keepActor)
        self.CloakEffectEnabled = false;
    end,

    -- While the CloakEffectControlThread will activate the cloak effect eventually,
    -- this method tries to provide a faster response time to intel changes
    OnIntelEnabled = function(self)
        oldUnit.OnIntelEnabled(self)
        if not self:IsDead() then
            self:UpdateCloakEffect()
        end
    end,

    -- While the CloakEffectControlThread will deactivate the cloak effect eventually,
    -- this method tries to provide a faster response time to intel changes
    OnIntelDisabled = function(self)
        oldUnit.OnIntelDisabled(self)
        if not self:IsDead() then
            self:UpdateCloakEffect()
        end
    end,

    CleanupTeleportChargeEffects = function(self)
        self.TeleportCostPaid = false
        oldUnit.CleanupTeleportChargeEffects(self)
    end,
    
    OnTeleportUnit = function(self, teleporter, location, orientation)
        local id = self:GetEntityId()
        
        -- Teleport Cooldown Charge
        -- Range Check to location
        local maxRange = self:GetBlueprint().Defense.MaxTeleRange
        local myposition = self:GetPosition()
        local destRange = VDist2(location[1], location[3], myposition[1], myposition[3])
        if maxRange and destRange > maxRange then
            FloatingEntityText(id,'Destination Out Of Range')
            return
        end
        
        -- Teleport Blocker Check
        for num, brain in ArmyBrains do
            local unitList = brain:GetListOfUnits(categories.ANTITELEPORT, false)
            for i, unit in unitList do
                -- If it's an ally, then we skip.
                if IsEnemy(self:GetArmy(), unit:GetArmy()) then
                    local blockerRange = unit:GetBlueprint().Defense.blockerRange
                    if blockerRange then
                        local blockerPosition = unit:GetPosition()
                        local targetDest = VDist2(location[1], location[3], blockerPosition[1], blockerPosition[3])
                        local sourceCheck = VDist2(myposition[1], myposition[3], blockerPosition[1], blockerPosition[3])
                        if blockerRange and blockerRange >= targetDest then
                            FloatingEntityText(id, 'Teleport Destination Scrambled')
                            return
                        elseif blockerRange and blockerRange >= sourceCheck then
                            FloatingEntityText(id, 'Teleport Source Location Scrambled')
                            return
                        end
                    end
                end
            end
        end
        
        -- Economy Check and Drain
        local bp = self:GetBlueprint()
        local telecost = bp.Economy.TeleportBurstEnergyCost or 0
        local mybrain = self:GetAIBrain()
        local storedenergy = mybrain:GetEconomyStored('ENERGY')
        if telecost > 0 and not self.TeleportCostPaid then
            if storedenergy >= telecost then
                mybrain:TakeResource('ENERGY', telecost)
                self.TeleportCostPaid = true
            else
                FloatingEntityText(id,'Insufficient Energy For Teleportation')
                return
            end
        end
        oldUnit.OnTeleportUnit(self, teleporter, location, orientation) 
    end,

    PlayTeleportChargeEffects = function(self, location)
        oldUnit.PlayTeleportChargeEffects(self, location) 
        if not self.Dead and self.EXPhaseEnabled == false then
            self.EXTeleportChargeEffects(self)
        end
    end,

    OnFailedTeleport = function(self)
        oldUnit.OnFailedTeleport(self) 
        if not self.Dead and self.EXPhaseEnabled == true then   
            self.EXPhaseEnabled = false
            self.EXPhaseCharge = 0
            self.EXPhaseShieldPercentage = 0
            
            local bpDisplay = self:GetBlueprint().Display
            self:SetMesh(bpDisplay.MeshBlueprint, true)
        end
    end,

    PlayTeleportInEffects = function(self)
        oldUnit.PlayTeleportInEffects(self) 
        if not self.Dead and self.EXPhaseEnabled == true then
            self.EXTeleportCooldownEffects(self)
        end
    end,
    
    OnCollisionCheck = function(self, other, firingWeapon)
        if self.DisallowCollisions then
            return false
        end
        -- Run a modified CollideFriendly check first that allows for allied phasing
        if EntityCategoryContains(categories.PROJECTILE, other) then
            if not self:GetShouldCollide(other:GetCollideFriendly(), self:GetArmy(), other:GetArmy()) then
                return false
            end
        end
        
        if other.lastimpact and other.lastimpact == self:GetEntityId() then
            return false
        end
        
        if not self.Dead and self.EXPhaseEnabled == true then
            if EntityCategoryContains(categories.PROJECTILE, other) then 
                local random = Random(1,100)
                -- Allows % of projectiles to pass
                if random <= self.EXPhaseShieldPercentage then   
                    -- Returning false allows the projectile to pass thru
                    return false       
                else
                    -- Projectile impacts normally
                    return true 
                end
            end
        end
        
        return oldUnit.OnCollisionCheck(self, other, firingWeapon) 
    end,  

    OnCollisionCheckWeapon = function(self, firingWeapon)
        if self.DisallowCollisions then
            return false
        end
        
        -- Run a modified CollideFriendly check first that allows for allied phasing
        if not self:GetShouldCollide(firingWeapon:GetBlueprint().CollideFriendly, self:GetArmy(), firingWeapon.unit:GetArmy()) then
            return false
        end
        
        return oldUnit.OnCollisionCheckWeapon(self, firingWeapon)
    end,
    
    -------------------------------------------------------
    -- The rest of the functions are added anew by BlackOps
    -------------------------------------------------------
    
    -- This thread runs constantly in the background for all units. It ensures that the cloak effect and cloak field are always in the correct state
    CloakEffectControlThread = function(self)
        if not self:IsDead() then
            local bp = self:GetBlueprint()
            if not bp.Intel.CustomCloak then
                local bpDisplay = bp.Display
                while not (self == nil or self:GetHealth() <= 0 or self:IsDead()) do
                    WaitSeconds(0.2)
                    self:UpdateCloakEffect()
                    local CloakFieldIsActive = self:IsIntelEnabled('CloakField')
                    if CloakFieldIsActive then
                        local position = self:GetPosition(0)
                        -- Range must be (radius - 2) because it seems GPG did that for the actual field for some reason.
                        -- Anything beyond (radius - 2) is not cloaked by the cloak field
                        local range = bp.Intel.CloakFieldRadius - 2
                        local brain = self:GetAIBrain()
                        local UnitsInRange = brain:GetUnitsAroundPoint(categories.ALLUNITS, position, range, 'Ally')
                        for num, unit in UnitsInRange do
                            unit:MarkUnitAsInCloakField()
                        end
                    end
                end
            end
        end
    end,

    -- Fork the thread that will deactivate the cloak effect, killing any previous threads that may be running
    MarkUnitAsInCloakField = function(self)
        self.InCloakField = true
        if self.InCloakFieldThread then
            KillThread(self.InCloakFieldThread)
            self.InCloakFieldThread = nil
        end
        self.InCloakFieldThread = self:ForkThread(self.InCloakFieldWatchThread)
    end,

    -- Will deactive the cloak effect if it is not renewed by the cloak field
    InCloakFieldWatchThread = function(self)
        WaitSeconds(0.2)
        self.InCloakField = false
    end,

    -- This is the core of the entire mod. The effect is actually applied here.
    UpdateCloakEffect = function(self)
        if not self:IsDead() then
            local bp = self:GetBlueprint()
            local bpDisplay = bp.Display
            if not bp.Intel.CustomCloak then
                local cloaked = self:IsIntelEnabled('Cloak') or self.InCloakField
                if (not cloaked and self.CloakEffectEnabled) or self:GetHealth() <= 0 then
                    self:SetMesh(bpDisplay.MeshBlueprint, true)
                elseif cloaked and not self.CloakEffectEnabled then
                    self:SetMesh(bpDisplay.CloakMeshBlueprint , true)
                    self.CloakEffectEnabled = true
                end
            end
        end
    end,
    
    EXTeleportChargeEffects = function(self)
        if not self:IsDead() then
            local bpe = self:GetBlueprint().Economy
            self.EXPhaseEnabled = true
            self.EXPhaseCharge = 1
            self.EXPhaseShieldPercentage = 0
            if bpe then
                local mass = bpe.BuildCostMass * (bpe.TeleportMassMod or 0.01)
                local energy = bpe.BuildCostEnergy * (bpe.TeleportEnergyMod or 0.01)
                energyCost = mass + energy
                EXTeleTime = energyCost * (bpe.TeleportTimeMod or 0.01)
                self.EXTeleTimeMod1 = (EXTeleTime * 10) * 0.2
                self.EXTeleTimeMod2 = self.EXTeleTimeMod1 * 2
                self.EXTeleTimeMod3 = (EXTeleTime * 10) - ((self.EXTeleTimeMod1 * 2) + self.EXTeleTimeMod2)
                self.EXTeleTimeMod4 = (self.EXTeleTimeMod3) - 7
                local bp = self:GetBlueprint()
                local bpDisplay = bp.Display
                if self.EXPhaseCharge == 1 then
                    WaitTicks(self.EXTeleTimeMod1)
                end
                if self.EXPhaseCharge == 1 then
                    self:SetMesh(bpDisplay.Phase1MeshBlueprint, true)
                    self.EXPhaseShieldPercentage = 33
                    WaitTicks(self.EXTeleTimeMod2)
                end
                if self.EXPhaseCharge == 1 then
                    self.EXPhaseShieldPercentage = 66
                    WaitTicks(self.EXTeleTimeMod1)
                end
                if self.EXPhaseCharge == 1 then
                    self.EXPhaseShieldPercentage = 100
                    if self.EXTeleTimeMod3 >= 7 then
                        WaitTicks(self.EXTeleTimeMod4)
                    end
                end
                if self.EXPhaseCharge == 1 then self:SetMesh(bpDisplay.Phase2MeshBlueprint, true) end
            end
        end
    end,

    EXTeleportCooldownEffects = function(self)
        if not self:IsDead() then
            local bp = self:GetBlueprint()
            local bpDisplay = bp.Display
            self.EXPhaseCharge = 0
            if self.EXPhaseCharge == 0 then
                self.EXPhaseShieldPercentage = 100
                WaitTicks(5)
            end
            if self.EXPhaseCharge == 0 then
                self.EXPhaseShieldPercentage = 100
                self:SetMesh(bpDisplay.Phase1MeshBlueprint, true)
                WaitTicks(8)
            end
            if self.EXPhaseCharge == 0 then
                self.EXPhaseShieldPercentage = 75
                self:SetMesh(bpDisplay.Phase1MeshBlueprint, true)
                WaitTicks(25)
            end
            if self.EXPhaseCharge == 0 then
                self.EXPhaseShieldPercentage = 50
                self:SetMesh(bpDisplay.MeshBlueprint, true)
                WaitTicks(10)
                self.EXPhaseShieldPercentage = 0
                self.EXPhaseEnabled = false
            end
        end
    end,

    GetShouldCollide = function(self, collidefriendly, army1, army2)
        if not collidefriendly then
            if army1 == army2 or IsAlly(army1, army2) then
                return false
            end
        end
        return true
    end, 
}