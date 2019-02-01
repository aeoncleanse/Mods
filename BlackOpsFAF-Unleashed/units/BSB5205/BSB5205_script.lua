-- Seraphim T3 Air Staging Platform script
-- By the Blackops team, small revisions by Mithy
local SAirStagingPlatformUnit = import('/lua/seraphimunits.lua').SAirStagingPlatformUnit
local SeraphimAirStagePlat02 = import('/lua/EffectTemplates.lua').SeraphimAirStagePlat02
local SeraphimAirStagePlat01 = import('/lua/EffectTemplates.lua').SeraphimAirStagePlat01

BSB5205 = Class(SAirStagingPlatformUnit) {
    Weapons = {
        TorpedoTurret01 = Class(import('/lua/seraphimweapons.lua').SANHeavyCavitationTorpedo) {},
        AjelluTorpedoDefense01 = Class(import('/lua/seraphimweapons.lua').SDFAjelluAntiTorpedoDefense) {},
        TorpedoTurret02 = Class(import('/lua/seraphimweapons.lua').SANHeavyCavitationTorpedo) {},
        AjelluTorpedoDefense02 = Class(import('/lua/seraphimweapons.lua').SDFAjelluAntiTorpedoDefense) {},
    },

    ShieldEffects = {
        '/effects/emitters/seraphim_shield_generator_t3_02_emit.bp',
        '/effects/emitters/seraphim_shield_generator_t3_03_emit.bp',
        '/effects/emitters/seraphim_shield_generator_t2_03_emit.bp',
    },

    OnStopBeingBuilt = function(self,builder,layer)
        self:ForkThread(self.InitialDroneSpawn)
        self:ForkThread(self.InitialRepairDroneSpawn)
        self:RequestRefreshUI()
        self.UnitComplete = true

        -- Drone Globals
        self.Side = 0
        self.DroneTable = {}
        self.RepairDroneTable = {}
        -- Globals uses for target assists and counter attacks
        self.CurrentTarget = nil
        self.OldTarget = nil
        self.MyAttacker = nil
        self.Retaliation = false
        self.EffectsBag = {}
        local layer = self:GetCurrentLayer()
        -- If created with F2 on land
        if layer == 'Land' then
            -- Disable Naval weapons
            self:SetWeaponEnabledByLabel('TorpedoTurret01', false)
            self:SetWeaponEnabledByLabel('TorpedoTurret02', false)
            self:SetWeaponEnabledByLabel('AjelluTorpedoDefense01', false)
            self:SetWeaponEnabledByLabel('AjelluTorpedoDefense02', false)
        elseif layer == 'Water' then
            -- Enable Naval Weapons
            self:SetWeaponEnabledByLabel('TorpedoTurret01', true)
            self:SetWeaponEnabledByLabel('TorpedoTurret02', true)
            self:SetWeaponEnabledByLabel('AjelluTorpedoDefense01', true)
            self:SetWeaponEnabledByLabel('AjelluTorpedoDefense02', true)
        end

        self.ShieldEffectsBag = {}
        self.Rotator1 = CreateRotator(self, 'Spinner01', 'y', nil, 10, 5, 10)
        self.Trash:Add(self.Rotator1)

        for k, v in SeraphimAirStagePlat02 do
            CreateAttachedEmitter(self, 'XSB5202', self:GetArmy(), v)
        end

        for k, v in SeraphimAirStagePlat01 do
            CreateAttachedEmitter(self, 'Pod01', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Pod02', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Pod03', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Pod04', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Pod05', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Pod06', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Pod07', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Pod08', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Pod09', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Pod10', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Pod11', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Pod12', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Pod13', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Pod14', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Pod15', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Pod16', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Pod17', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Pod18', self:GetArmy(), v)
        end
        SAirStagingPlatformUnit.OnStopBeingBuilt(self, builder, layer)
    end,

    OnShieldEnabled = function(self)
        SAirStagingPlatformUnit.OnShieldEnabled(self)
        if self.Rotator1 then
            self.Rotator1:SetTargetSpeed(10)
        end

        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
            self.ShieldEffectsBag = {}
        end

        for k, v in self.ShieldEffects do
            table.insert(self.ShieldEffectsBag, CreateAttachedEmitter(self, 0, self:GetArmy(), v) )
        end
    end,

    OnShieldDisabled = function(self)
        SAirStagingPlatformUnit.OnShieldDisabled(self)
        self.Rotator1:SetTargetSpeed(0)
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
            self.ShieldEffectsBag = {}
        end
    end,

    InitialDroneSpawn = function(self)
        local numcreate = 8

        -- Randomly determines which launch bay will be the first to spawn a drone
        self.Side = Random(1,4)

        -- Short delay after the carrier has been built
        WaitSeconds(2)

        -- Are we dead yet, if not spawn drones
        if not self.Dead then
            for i = 0, (numcreate -1) do
                if not self.Dead then
                    self:ForkThread(self.SpawnDrone)
                    -- Short delay between spawns to spread them out
                    WaitSeconds(2)
                end
            end
        end
    end,

    InitialRepairDroneSpawn = function(self)
        local numcreate = 4

        -- Randomly determines which launch bay will be the first to spawn a drone
        self.Side = Random(1,4)

        -- Short delay after the carrier has been built
        WaitSeconds(2)

        -- Are we dead yet, if not spawn drones
        if not self.Dead then
            for i = 0, (numcreate -1) do
                if not self.Dead then
                    self:ForkThread(self.SpawnRepairDrone)
                    -- Short delay between spawns to spread them out
                    WaitSeconds(2)
                end
            end
        end
    end,

    SpawnDrone = function(self)
        WaitSeconds(5)

        -- Only respawns the drones if the parent unit is not dead
        if not self.Dead then
            -- Sets up local Variables used and spawns a drone at the parents location
            local myOrientation = self:GetOrientation()

            if self.Side == 1 then
                -- Gets the current position of the carrier launch bay in the game world
                local location = self:GetPosition('Drone_Launch01')

                -- Creates our drone in the left launch bay and directs the unit to face the same direction as its parent unit
                local drone = CreateUnit('bsa0001', self:GetArmy(), location[1], location[2], location[3], myOrientation[1], myOrientation[2], myOrientation[3], myOrientation[4], 'Air')

                -- Adds the newly created drone to the parent carriers drone table
                table.insert (self.DroneTable, drone)

                -- Sets the Carrier unit as the drones parent
                drone:SetParent(self, 'bsb5205')
                drone:SetCreator(self)

                -- Issues the guard command
                IssueClearCommands({drone})
                IssueGuard({drone}, self)

                -- Flips to the next spawn point
                self.Side = 2

                -- Drone clean up scripts
                self.Trash:Add(drone)
            elseif self.Side == 2 then
                -- Gets the current position of the carrier launch bay in the game world
                local location = self:GetPosition('Drone_Launch02')

                -- Creates our drone in the right launch bay and directs the unit to face the same direction as its parent unit
                local drone = CreateUnit('bsa0001', self:GetArmy(), location[1], location[2], location[3], myOrientation[1], myOrientation[2], myOrientation[3], myOrientation[4], 'Air')

                -- Adds the newly created drone to the parent carriers drone table
                table.insert (self.DroneTable, drone)

                -- Sets the Carrier unit as the drones parent
                drone:SetParent(self, 'bsb5205')
                drone:SetCreator(self)

                -- Issues the guard command
                IssueClearCommands({drone})
                IssueGuard({drone}, self)

                -- Flips from the right to the left self.Side after a drone has been spawned
                self.Side = 3

                -- Drone clean up scripts
                self.Trash:Add(drone)
            elseif self.Side == 3 then
                -- Gets the current position of the carrier launch bay in the game world
                local location = self:GetPosition('Drone_Launch03')

                -- Creates our drone in the right launch bay and directs the unit to face the same direction as its parent unit
                local drone = CreateUnit('bsa0001', self:GetArmy(), location[1], location[2], location[3], myOrientation[1], myOrientation[2], myOrientation[3], myOrientation[4], 'Air')

                -- Adds the newly created drone to the parent carriers drone table
                table.insert (self.DroneTable, drone)

                -- Sets the Carrier unit as the drones parent
                drone:SetParent(self, 'bsb5205')
                drone:SetCreator(self)

                -- Issues the guard command
                IssueClearCommands({drone})
                IssueGuard({drone}, self)

                -- Flips to the next spawn point
                self.Side = 4

                --Drone clean up scripts
                self.Trash:Add(drone)
            elseif self.Side == 4 then
                -- Gets the current position of the carrier launch bay in the game world
                local location = self:GetPosition('Drone_Launch04')

                -- Creates our drone in the right launch bay and directs the unit to face the same direction as its parent unit
                local drone = CreateUnit('bsa0001', self:GetArmy(), location[1], location[2], location[3], myOrientation[1], myOrientation[2], myOrientation[3], myOrientation[4], 'Air')

                -- Adds the newly created drone to the parent carriers drone table
                table.insert (self.DroneTable, drone)

                -- Sets the Carrier unit as the drones parent
                drone:SetParent(self, 'bsb5205')
                drone:SetCreator(self)

                -- Issues the guard command
                IssueClearCommands({drone})
                IssueGuard({drone}, self)

                -- Flips back to the first spawn point
                self.Side = 1

                -- Drone clean up scripts
                self.Trash:Add(drone)
            end
        end
    end,

    SpawnRepairDrone = function(self)
        WaitSeconds(3)

        -- Only respawns the drones if the parent unit is not dead
        if not self.Dead then
            -- Sets up local Variables used and spawns a drone at the parents location
            local myOrientation = self:GetOrientation()

            if self.Side == 1 then
                -- Gets the current position of the carrier launch bay in the game world
                local location = self:GetPosition('Drone_Launch01')

                -- Creates our drone in the left launch bay and directs the unit to face the same direction as its parent unit
                local drone = CreateUnit('bsa0002', self:GetArmy(), location[1], location[2], location[3], myOrientation[1], myOrientation[2], myOrientation[3], myOrientation[4], 'Air')

                -- Adds the newly created drone to the parent carriers drone table
                table.insert (self.RepairDroneTable, drone)

                -- Sets the Carrier unit as the drones parent
                drone:SetParent(self, 'bsb5205')
                drone:SetCreator(self)

                -- Issues the guard command
                IssueClearCommands({drone})

                -- Flips to the next spawn point
                self.Side = 2

                -- Drone clean up scripts
                self.Trash:Add(drone)
            elseif self.Side == 2 then
                -- Gets the current position of the carrier launch bay in the game world
                local location = self:GetPosition('Drone_Launch02')

                -- Creates our drone in the right launch bay and directs the unit to face the same direction as its parent unit
                local drone = CreateUnit('bsa0002', self:GetArmy(), location[1], location[2], location[3], myOrientation[1], myOrientation[2], myOrientation[3], myOrientation[4], 'Air')

                -- Adds the newly created drone to the parent carriers drone table
                table.insert (self.RepairDroneTable, drone)

                -- Sets the Carrier unit as the drones parent
                drone:SetParent(self, 'bsb5205')
                drone:SetCreator(self)

                -- Issues the guard command
                IssueClearCommands({drone})

                -- Flips from the right to the left self.Side after a drone has been spawned
                self.Side = 3

                -- Drone clean up scripts
                self.Trash:Add(drone)
            elseif self.Side == 3 then
                -- Gets the current position of the carrier launch bay in the game world
                local location = self:GetPosition('Drone_Launch03')

                -- Creates our drone in the right launch bay and directs the unit to face the same direction as its parent unit
                local drone = CreateUnit('bsa0002', self:GetArmy(), location[1], location[2], location[3], myOrientation[1], myOrientation[2], myOrientation[3], myOrientation[4], 'Air')

                -- Adds the newly created drone to the parent carriers drone table
                table.insert (self.RepairDroneTable, drone)

                -- Sets the Carrier unit as the drones parent
                drone:SetParent(self, 'bsb5205')
                drone:SetCreator(self)

                -- Issues the guard command
                IssueClearCommands({drone})

                -- Flips to the next spawn point
                self.Side = 4

                -- Drone clean up scripts
                self.Trash:Add(drone)
            elseif self.Side == 4 then
                -- Gets the current position of the carrier launch bay in the game world
                local location = self:GetPosition('Drone_Launch04')

                -- Creates our drone in the right launch bay and directs the unit to face the same direction as its parent unit
                local drone = CreateUnit('bsa0002', self:GetArmy(), location[1], location[2], location[3], myOrientation[1], myOrientation[2], myOrientation[3], myOrientation[4], 'Air')

                -- Adds the newly created drone to the parent carriers drone table
                --Mithy: These drones should not be in the DroneTable, as this is used for issuing attack orders
                table.insert (self.RepairDroneTable, drone)

                -- Sets the Carrier unit as the drones parent
                drone:SetParent(self, 'bsb5205')
                drone:SetCreator(self)

                -- Issues the guard command
                IssueClearCommands({drone})
                --Mithy: These drones handle their own guard/patrol orders now
                --IssueGuard({drone}, self)

                -- Flips back to the first spawn point
                self.Side = 1

                -- Drone clean up scripts
                self.Trash:Add(drone)
            end
        end
    end,

    NotifyOfDroneDeath = function(self)
        -- Only respawns the drones if the parent unit is not dead
        if not self.Dead then
            local mass = self:GetAIBrain():GetEconomyStored('Mass')
            local energy = self:GetAIBrain():GetEconomyStored('Energy')

            -- Check to see if the player has enough mass / energy
            -- And that the production is enabled.
            if self:GetScriptBit('RULEUTC_ProductionToggle') == false and mass >= 50 and energy >= 100 then
                -- Remove the resources and spawn a single drone
                self:GetAIBrain():TakeResource('Mass',50)
                self:GetAIBrain():TakeResource('Energy',1000)
                self:ForkThread(self.SpawnDrone)
            else
                -- If the above conditions are not met the carrier will wait a short time and try again
                self:ForkThread(self.EconomyWait)
            end
        end
    end,

    NotifyOfRepairDroneDeath = function(self)
        -- Only respawns the drones if the parent unit is not dead
        if not self.Dead then
            local mass = self:GetAIBrain():GetEconomyStored('Mass')
            local energy = self:GetAIBrain():GetEconomyStored('Energy')

            -- Check to see if the player has enough mass / energy
            -- And that the production is enabled.
            if self:GetScriptBit('RULEUTC_ProductionToggle') == false and mass >= 50 and energy >= 100 then
                -- Remove the resources and spawn a single drone
                self:GetAIBrain():TakeResource('Mass',50)
                self:GetAIBrain():TakeResource('Energy',1000)
                self:ForkThread(self.SpawnRepairDrone)
            else
                -- If the above conditions are not met the carrier will wait a short time and try again
                self:ForkThread(self.EconomyWait2)
            end
        end
    end,

    EconomyWait = function(self)
        if not self.Dead then
        WaitSeconds(4)
            if not self.Dead then
                self:ForkThread(self.NotifyOfDroneDeath)
            end
        end
    end,

    EconomyWait2 = function(self)
        if not self.Dead then
        WaitSeconds(4)
            if not self.Dead then
                self:ForkThread(self.NotifyOfRepairDroneDeath)
            end
        end
    end,

    AssistHeartBeat = function(self)
        while not self.Dead do
            WaitSeconds(1)
            if not self.Dead and self.Retaliation == true and self.MyAttacker ~= nil then
                -- Clears flags if there is no longer a target to retaliate against thats in range
                if self.MyAttacker.Dead or self:GetDistanceToAttacker() >= 81 then
                    -- Clears flag to allow retaliation on another attacker
                    self.MyAttacker = nil
                    self.Retaliation = false
                end
            end
            if not self.Dead and self.Retaliation == false and table.getn({self.MyAttacker}) > 0 and self:GetDistanceToAttacker() <= 80 then
                if not self.MyAttacker.Dead then
                    -- Issues the retaliation command to each of the drones on the carriers table
                    if table.getn({self.DroneTable}) > 0 then
                        for k, v in self.DroneTable do
                            IssueClearCommands({self.DroneTable[k]})
                            IssueAttack({self.DroneTable[k]}, self.MyAttacker)
                        end
                        -- Performs retaliation flag
                        self.Retaliation = true
                    end
                end
            elseif not self.Dead and self.Retaliation == false and self:GetTargetEntity() then
                -- Updates variable with latest targeting info
                self.CurrentTarget = self:GetTargetEntity()
                -- Verifies that the carrier is not dead and that it has a target
                -- Ensures that either there hasnt been a target before or that its new
                -- To prevent the same retargeting command from being given out multible times
                if self.OldTarget == nil or self.OldTarget ~= self.CurrentTarget then
                    -- Updates the OldTarget to match CurrentTarget
                    self.OldTarget = self.CurrentTarget
                    -- Issues the attack command to each of the drones on the carriers table
                    if table.getn({self.DroneTable}) > 0 then
                        for k, v in self.DroneTable do
                            IssueClearCommands({self.DroneTable[k]})
                            IssueAttack({self.DroneTable[k]}, self.CurrentTarget)
                        end
                    end
                end
            end
        end
    end,

    GetDistanceToAttacker = function(self)
        local tpos = self.MyAttacker:GetPosition()
        local mpos = self:GetPosition()
        local dist = VDist2(mpos[1], mpos[3], tpos[1], tpos[3])
        return dist
    end,

    OnDamage = function(self, instigator, amount, vector, damagetype)
        -- Check to make sure that the carrier isnt already dead and what just damaged it is a unit we can attack
        if self.Dead == false and damagetype == 'Normal' and self.MyAttacker == nil then
            if IsUnit(instigator) then
                self.MyAttacker = instigator
            end
        end
        SAirStagingPlatformUnit.OnDamage(self, instigator, amount, vector, damagetype)
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        self:SetWeaponEnabledByLabel('TorpedoTurret01', false)
        self:SetWeaponEnabledByLabel('TorpedoTurret02', false)
        self:SetWeaponEnabledByLabel('AjelluTorpedoDefense01', false)
        self:SetWeaponEnabledByLabel('AjelluTorpedoDefense02', false)
        if self.ShieldEffctsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
        end

        if table.getn({self.DroneTable}) > 0 then
            for k, v in self.DroneTable do
                IssueClearCommands({self.DroneTable[k]})
                IssueKillSelf({self.DroneTable[k]})
            end
        end

        if table.getn({self.RepairDroneTable}) > 0 then
            for k, v in self.RepairDroneTable do
                IssueClearCommands({self.RepairDroneTable[k]})
                IssueKillSelf({self.RepairDroneTable[k]})
            end
        end
        SAirStagingPlatformUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

    OnProductionPaused = function(self)
    end,

    OnProductionUnpaused = function(self)
    end,
}

TypeClass = BSB5205
