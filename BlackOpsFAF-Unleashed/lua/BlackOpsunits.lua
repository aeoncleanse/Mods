
local AirUnit = import('/lua/defaultunits.lua').AirUnit

AirDroneCarrier = Class() {

    InitDrones = function(self)
        -- Transportslots
        self.slots = {}
        self.transData = {}
        -- Button status toggles
        self.DroneMaintenance = true
        self.DroneAssist = true
        -- Assist management globals
        self.MyAttacker = nil
        self.MyTarget = nil
        -- Drone construction/repair buildrate
        self.BuildRate = self:GetBlueprint().Economy.BuildRate or 30
        -- Drone setup (load globals/tables & create drones)
        self:DroneSetup()
    end,

    -- Creates specified drone from its entry in DroneData and creates handles
    CreateDrone = function(self, droneName)
        if not self.Dead and not self.DroneTable[droneName] and not self.DroneData[droneName].Active then
            if not self:IsValidBone(self.DroneData[droneName].Attachpoint) then
                error("*ERROR: Attachpoint '" .. self.DroneData[droneName].Attachpoint .. "' not a valid bone!", 2)
                return
            end
            local location = self:GetPosition(self.DroneData[droneName].Attachpoint)
            local newdrone = CreateUnitHPR(self.DroneData[droneName].UnitID, self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
            newdrone:SetParent(self, self.DroneData[droneName].Name)
            newdrone:SetCreator(self)
            self.DroneTable[droneName] = newdrone
            self.DroneData[droneName].Active = newdrone
            self.DroneData[droneName].Docked = false
            self.DroneData[droneName].Damaged = false
            self.DroneData[droneName].BuildProgress = 1
            self.Trash:Add(newdrone)
            self:RequestRefreshUI()
        end
    end,

    SetAttacker = function(self, instigator)
        if not self.Dead
        and self.MyAttacker == nil
        and self:IsValidDroneTarget(instigator) then
            self.MyAttacker = instigator
        end
    end,

    -- Runs a potential target through filters to insure that drones can attack it; checks are as simple and efficient as possible
    IsValidDroneTarget = function(self, target)
        local ivdt
        if target ~= nil
        and target.Dead ~= nil
        and not target.Dead
        and IsEnemy(self:GetArmy(), target:GetArmy())
        and not EntityCategoryContains(categories.UNTARGETABLE, target)
        and target:GetCurrentLayer() ~= 'Sub'
        and target:GetBlip(self:GetArmy()) ~= nil then
            ivdt = true
        end
        return ivdt
    end,

    KillAllDrones = function(self, instigator)
        if next(self.DroneTable or {}) then
            for name, drone in self.DroneTable do
                IssueClearCommands({drone})
                IssueKillSelf({drone})
            end
        end
    end,

    --Initial drone setup - loads globals, DroneData table, and creates drones
    DroneSetup = function(self)
        --Drone handle table, used to issue orders to all drones at once
        self.DroneTable = {}

        --Drone construction globals
        self.BuildingDrone = false    --Holds the name (string) of the drone currently being repaired or rebuilt

        --Drone control parameters (inherited by drones in SetParent)
        self.ControlRange = self:GetBlueprint().AI.DroneControlRange or 70   --Range at which drones will be recalled
        self.ReturnRange = self:GetBlueprint().AI.DroneReturnRange or (ControlRange / 2)    --Range at which returning drones will be released
        self.AssistRange = self.ControlRange + 10    --Max target distance for retaliation - drones can engage targets just beyond recall range
        self.AirMonitorRange = self:GetBlueprint().AI.AirMonitorRange or (self.AssistRange / 2)    --Air target search distance
        self.HeartBeatInterval = self:GetBlueprint().AI.AssistHeartbeatInterval or 1 -- Heartbeat wait time, in seconds

        --Load DroneData table from BP (name, attachpoint, unitid)
        --Only drones with entries in this table (including unique key names and the other two required values) will be spawned!
        self.DroneData = table.deepcopy(self:GetBlueprint().DroneData)

        --Load other data from drone BP and spawn drones
        for droneName, droneData in self.DroneData do
            --Set drone name variable
            if not droneData.Name then
                droneData.Name = droneName
            end
            droneData.Blueprint = table.deepcopy(GetUnitBlueprintByName(droneData.UnitID))
            droneData.Economy = droneData.Blueprint.Economy
            droneData.BuildProgress = 1    --Holds the progress of drone rebuilds

            --Create this drone
            self:ForkThread(self.CreateDrone, droneName)
        end

        --Assist/monitor heartbeat thread
        self.HeartBeatThread = self:ForkThread(self.AssistHeartBeat)

        --Begin drone maintenance monitoring
        ChangeState(self, self.DroneMaintenanceState)
    end,

    --Clears all handles and active DroneData variables for the calling drone.
    NotifyOfDroneDeath = function(self,droneName)
        self.DroneTable[droneName] = nil
        self.DroneData[droneName].Active = false
        self.DroneData[droneName].Docked = false
        self.DroneData[droneName].Damaged = false
        self.DroneData[droneName].BuildProgress = 0
    end,

    DroneMaintenanceState = State {
        Main = function(self)
            self.DroneMaintenance = true
            -- Resume any interrupted drone rebuilds
            if self.BuildingDrone then
                ChangeState(self, self.DroneRebuildingState)
            end
            -- Check for dead or damaged drones
            while self and not self.Dead and not self.BuildingDrone do
                for droneName, droneData in self.DroneData do
                    if not droneData.Active or (droneData.Active and droneData.Damaged and droneData.Docked) then
                        self.BuildingDrone = droneName
                        ChangeState(self, self.DroneRebuildingState)
                    end
                end
                WaitTicks(2)
            end
        end,

        OnPaused = function(self)
            ChangeState(self, self.PausedState)
        end,
    },

    -- Active construction/repair state - consumes resources and advances progress
    DroneRebuildingState = State {
        Main = function(self)
            -- Flag as repair if drone is alive and damaged
            local isRepair = self.DroneData[self.BuildingDrone].Active and self.DroneData[self.BuildingDrone].Damaged
            -- Calculate build time from buildrate
            local buildTimeSeconds = self.DroneData[self.BuildingDrone].Economy.BuildTime / self.BuildRate
            -- Enable econ consumption
            self:EnableResourceConsumption(self.DroneData[self.BuildingDrone].Economy)

            -- Begin or resume construction if not repair
            if not isRepair then
                -- Set progress bar/variable to 0 for fresh drone construction
                if not self.DroneData[self.BuildingDrone].BuildProgress then
                    self:SetWorkProgress(0.01)
                end
                -- Construction runs until buildprogress >= 1
                while self and not self.Dead
                and self.DroneData[self.BuildingDrone].BuildProgress < 1 do
                    WaitTicks(1)
                    local tickprogress = (self:GetResourceConsumed() * 0.1) / buildTimeSeconds
                    self.DroneData[self.BuildingDrone].BuildProgress = self.DroneData[self.BuildingDrone].BuildProgress + tickprogress
                    self:SetWorkProgress(self.DroneData[self.BuildingDrone].BuildProgress)
                end
                self:CreateDrone(self.BuildingDrone)
            -- Otherwise begin repair
            elseif isRepair then
                local repairingDrone = self.DroneData[self.BuildingDrone].Active
                local maxhealth = repairingDrone:GetMaxHealth()
                -- Repair runs while drone is alive, damaged, and docked
                while self and not self.Dead
                and self.DroneData[self.BuildingDrone].Damaged
                and self.DroneData[self.BuildingDrone].Docked
                and repairingDrone and not repairingDrone.Dead do
                    WaitTicks(1)
                    local restorehealth = ((self:GetResourceConsumed() * 0.1) / buildTimeSeconds) * maxhealth
                    repairingDrone:AdjustHealth(self, restorehealth)
                    -- Repair progress = drone health percent, and the progressbar reflects this
                    local totalprogress = repairingDrone:GetHealth() / maxhealth
                    self:SetWorkProgress(totalprogress)
                    if self.DroneData[self.BuildingDrone] and totalprogress >= 1 then
                        self.DroneData[self.BuildingDrone].Damaged = false
                    end
                end
            end
            -- Return to Maintenance State to check/wait for other jobs
            self:CleanupDroneMaintenance(self.BuildingDrone)
            ChangeState(self, self.DroneMaintenanceState)
        end,

        OnPaused = function(self)
            ChangeState(self, self.PausedState)
        end,
    },

    -- Paused state, econ and construction progress halted
    PausedState = State {
        Main = function(self)
            self:DisableResourceConsumption()
            self.DroneMaintenance = false
        end,

        OnUnpaused = function(self)
            ChangeState(self, self.DroneMaintenanceState)
        end,
    },

    -- Enables economy drain
    EnableResourceConsumption = function(self, econdata)
        local energy_rate = econdata.BuildCostEnergy / (econdata.BuildTime / self.BuildRate)
        local mass_rate = econdata.BuildCostMass / (econdata.BuildTime / self.BuildRate)
        self:SetConsumptionPerSecondEnergy(energy_rate)
        self:SetConsumptionPerSecondMass(mass_rate)
        self:SetConsumptionActive(true)
    end,

    -- Disables economy drain
    DisableResourceConsumption = function(self)
        self:SetConsumptionPerSecondEnergy(0)
        self:SetConsumptionPerSecondMass(0)
        self:SetConsumptionActive(false)
    end,
    -- Resets resume/progress data, clears effects
    -- Used to clean up finished construction and repair, and to interrupt repairs when undocking
    CleanupDroneMaintenance = function(self, droneName, deadState)
        if deadState or (droneName and droneName == self.BuildingDrone) then
            self:SetWorkProgress(0)
            self.BuildingDrone = false
            self:DisableResourceConsumption()
        end
    end,
    -- Manages drone assistance and firestate propagation
    AssistHeartBeat = function(self)
        local SuspendAssist = 0
        local LastFireState
        local LastDroneTarget
        -- The DroneCarrier's current weapon target is now used for better, earlier drone deployment
        -- Best results achieved so far have been with the missile launcher, due to range
        local TargetWeapon = self:GetWeapon(1)

        while not self.Dead do
            -- Refresh current firestate and check for holdfire
            local MyFireState = self:GetFireState()
            local HoldFire = MyFireState == 1
            -- De-blip our weapon target, nil MyTarget if none
            local TargetBlip = TargetWeapon:GetCurrentTarget()
            if TargetBlip ~= nil then
                self.MyTarget = self:GetRealTarget(TargetBlip)
            else
                self.MyTarget = nil
            end

            -- Propagate the DroneCarrier's fire state to the drones, to keep them from retaliating when the DroneCarrier is on hold-fire
            -- This also allows you to set both drones to target-ground, although I'm not sure how that'd be useful
            if LastFireState ~= MyFireState then
                LastFireState = MyFireState
                self:SetDroneFirestate(MyFireState)
            end

            -- Drone Assist management
            -- New target priority:
            -- 1. Nearby gunships - these can attack both drones and DroneCarrier, otherwise often killing drones while they're elsewise occupied
            -- 2. DroneCarrier's current target - whatever the missile launcher is shooting at; this also responds to force-attack calls
            -- 3. DroneCarrier's last drone-targetable attacker - this is only used when something is hitting the DroneCarrier out of launcher range
            --
            -- Drones are not re-assigned to a new target unless their old target is dead, or a higher-priority class of target is found.
            -- The exception is newly-constructed drones, which are dispatched to the current drone target on the next heartbeat.
            -- Acquisition of a gunship target suspends further assist management for 7 heartbeats - with the new logic this is somewhat
            -- vestigial, but it does insure that the drones aren't jerked around between gunship targets if one of them strays slightly
            -- outside the air monitor range.
            --
            -- Existing target validity and distance is checked every heartbeat, so we don't get stuck trying to send drones after a
            -- submerged, recently taken-off highaltair, or out-of-range target.  Likewise, when the DroneCarrier submerges, the drones will
            -- continue engaging only until the last assigned target is destroyed, at which point they will dock with the underwater DroneCarrier.
            if self.DroneAssist and not HoldFire and SuspendAssist <= 0 then
                local NewDroneTarget

                local GunshipTarget = self:SearchForGunshipTarget(self.AirMonitorRange)
                if GunshipTarget and not GunshipTarget.Dead then
                    if GunshipTarget ~= LastDroneTarget then
                        NewDroneTarget = GunshipTarget
                    end
                elseif self.MyTarget ~= nil and not self.MyTarget.Dead then
                    if self.MyTarget ~= LastDroneTarget then
                        NewDroneTarget = self.MyTarget
                    end
                elseif self.MyAttacker ~= nil and not self.MyAttacker.Dead and self:IsTargetInRange(self.MyAttacker) then
                    if self.MyAttacker ~= LastDroneTarget then
                        NewDroneTarget = self.MyAttacker
                    end
                -- If our previous attacker is no longer valid, clear MyAttacker to re-enable the OnDamage check
                elseif self.MyAttacker ~= nil then
                    self.MyAttacker = nil
                end

                -- Assign chosen target, if valid
                if NewDroneTarget and self:IsValidDroneTarget(NewDroneTarget) then
                    if NewDroneTarget == GunshipTarget then
                        -- Suspend the assist targeting for 7 heartbeats if we have a gunship target, to keep them at top priority
                        SuspendAssist = 7
                    end
                    LastDroneTarget = NewDroneTarget
                    self:AssignDroneTarget(NewDroneTarget)
                -- Otherwise re-check our existing target:
                else
                    if LastDroneTarget and self:IsValidDroneTarget(LastDroneTarget)
                    and self:IsTargetInRange(LastDroneTarget) then
                        -- Dispatch any docked (usually newly-built) drones, if it's still valid
                        if self:GetDronesDocked() then
                            self:AssignDroneTarget(LastDroneTarget)
                        end
                    else
                        -- Clear last target if no longer valid, forcing re-acquisition on the next beat
                        LastDroneTarget = nil
                    end
                end

            -- Otherwise, tick down the assistance suspension timer (if set)
            elseif SuspendAssist > 0 then
                SuspendAssist = SuspendAssist - 1
            end

            WaitSeconds(self.HeartBeatInterval)
        end
    end,
    -- Recalls all drones to the carrier at 2x speed under temp command lockdown
    RecallDrones = function(self)
        if next(self.DroneTable or {}) then
            for id, drone in self.DroneTable do
                drone:DroneRecall()
            end
        end
    end,
    -- Issues an attack order for all drones
    AssignDroneTarget = function(self, dronetarget)
        if next(self.DroneTable or {}) then
            for id, drone in self.DroneTable do
                --if not self.DroneData[self.BuildingDrone].Docked then
                if drone.AwayFromCarrier == false then
                    local targetblip = dronetarget:GetBlip(self:GetArmy())
                    if targetblip ~= nil then
                        IssueClearCommands({drone})
                        IssueAttack({drone}, targetblip)
                    end
                end
            end
        end
    end,

    -- Sets a firestate for all drones
    SetDroneFirestate = function(self, firestate)
        if next(self.DroneTable or {}) then
            for id, drone in self.DroneTable do
                if drone and not drone.Dead then
                    drone:SetFireState(firestate)
                end
            end
        end
    end,
    -- Checks whether any drones are docked.  Used by AssistHeartBeat.
    -- Returns a table of dronenames that are currently docked, or false if none
    GetDronesDocked = function(self)
        local docked = {}
        if next(self.DroneTable or {}) then
            for id, drone in self.DroneTable do
                if drone and not drone.Dead and self.DroneData[id].Docked then
                    table.insert(docked, id)
                end
            end
        end
        if next(docked) then
            return docked
        else
            return false
        end
    end,
    -- Returns a hostile gunship/transport in range for drone targeting, or nil if none
    SearchForGunshipTarget = function(self, radius)
        local targetindex, target
        local units = self:GetAIBrain():GetUnitsAroundPoint(categories.AIR - (categories.HIGHALTAIR + categories.UNTARGETABLE), self:GetPosition(), radius, 'Enemy')
        if next(units) then
            targetindex, target = next(units)
        end
        return target
    end,

    -- De-blip a weapon target - stolen from the GC tractorclaw script
    GetRealTarget = function(self, target)
        if target and not IsUnit(target) then
            local unitTarget = target:GetSource()
            local unitPos = unitTarget:GetPosition()
            local reconPos = target:GetPosition()
            local dist = VDist2(unitPos[1], unitPos[3], reconPos[1], reconPos[3])
            if dist < 5 then
                return unitTarget
            end
        end
        return target
    end,


    -- Insures that potential retaliation targets are within drone control range
    IsTargetInRange = function(self, target)
        local tpos = target:GetPosition()
        local mpos = self:GetPosition()
        local dist = VDist2(mpos[1], mpos[3], tpos[1], tpos[3])
        local itir
        if dist <= self.AssistRange then
            itir = true
        end
        return itir
    end,

}

AirDroneUnit = Class(AirUnit) {

    OnStopBeingBuilt = function(self, builder, layer)
        AirUnit.OnStopBeingBuilt(self, builder, layer)
        --Table of all command caps the drone may have available, for recall lockdown
        self.CapTable = {
            'RULEUCC_Attack',
            'RULEUCC_Guard',
            'RULEUCC_Move',
            'RULEUCC_Patrol',
            'RULEUCC_RetaliateToggle',
            'RULEUCC_Stop',
        }
        -- Flags drone as being recalled
        self.AwayFromCarrier = false
        self.Carrier = nil
    end,

    OnDamage = function(self, instigator, amount, vector, damagetype)
        AirUnit.OnDamage(self, instigator, amount, vector, damagetype)
        if self.Carrier.DroneData[self.Name] and not self.Carrier.DroneData[self.Name].Damaged and amount > 0 and amount < self:GetHealth() then
            self.Carrier.DroneData[self.Name].Damaged = true
        end
    end,

    OnKilled = function(self, instigator, damagetype, overkillRatio)
        -- Notify the carrier of our death
        self.Carrier:NotifyOfDroneDeath(self.Name)
        self.Carrier = nil
        -- Kill our heartbeat thread
        KillThread(self.HeartBeatThread)
        AirUnit.OnKilled(self, instigator, damagetype, overkillRatio)
    end,

    OnDetachedFromTransport = function(self, transport, bone)
        AirUnit.OnDetachedFromTransport(self, transport, bone)
        self:SetImmobile(false)
    end,

    -- Called on us by the carrier after creation, sets our name, parent ref and control variables
    SetParent = function(self, parent, droneName)
        self.Name = droneName
        self.Carrier = parent

        -- Heartbeat globals
        self.MaxRange = self.Carrier.ControlRange -- Distance from the carrier at which the drone is recalled
        self.ReturnRange = self.Carrier.ReturnRange -- Distance from the carrier at which the returning drone is released
        self.HeartBeatInterval = self.Carrier.HeartBeatInterval -- Time in seconds between monitor heartbeats

        -- Start our monitor heartbeat thread
        self.HeartBeatThread = self:ForkThread(self.DroneLinkHeartbeat)
    end,

    -- Monitors drone distance from the carrier, issuing recalls and releases as necessary
    DroneLinkHeartbeat = function(self)
        while self and not self.Dead and self.Carrier and not self.Carrier.Dead do
            local distance = self:GetDistanceFromAttachpoint()
            if distance > self.MaxRange and self.AwayFromCarrier == false then
                self:DroneRecall()
            elseif distance <= self.ReturnRange and self.AwayFromCarrier == true then
                self:DroneRelease()
            end
            WaitSeconds(self.HeartBeatInterval)
        end
    end,

    -- Returns the drone's horizontal distance from its original attach point, used for all distance checks
    GetDistanceFromAttachpoint = function(self)
        local myPosition = self:GetPosition()
        local parentPosition = self.Carrier:GetPosition(self.Carrier.DroneData[self.Name].Attachpoint)
        local dist = VDist2(myPosition[1], myPosition[3], parentPosition[1], parentPosition[3])
        return dist
    end,

    -- Locks drone down and returns it to the carrier - also called in the carrier script by the recall button
    DroneRecall = function(self, disableweapons)
        self.AwayFromCarrier = true
        -- Accelerate the drone for return
        self:SetSpeedMult(2.0)
        self:SetAccMult(2.0)
        self:SetTurnMult(2.0)
        -- Temporarily disable weapons, if requested
        if disableweapons and not self.WeaponsDisabled then
            for i = 1, self:GetWeaponCount() do
                local wep = self:GetWeapon(i)
                wep:SetWeaponEnabled(false)
                wep:AimManipulatorSetEnabled(false)
            end
            self.WeaponsDisabled = true
        end
        -- Halt the drone and clear its orders - the drone will immediately attempt to return
        IssueStop({self})
        IssueClearCommands({self})
        -- Lock the drone's command input until it's back in the specified control range
        for k, cap in self.CapTable do
            self:RemoveCommandCap(cap)
        end
    end,

    -- Cancels drone lockdown and returns it to normal speed
    DroneRelease = function(self)
        self.AwayFromCarrier = false
        -- Restore standard mobility
        self:SetSpeedMult(1.0)
        self:SetAccMult(1.0)
        self:SetTurnMult(1.0)
        -- Re-enable weapons, if disabled
        if self.WeaponsDisabled then
            for i = 1, self:GetWeaponCount() do
                local wep = self:GetWeapon(i)
                wep:SetWeaponEnabled(true)
                wep:AimManipulatorSetEnabled(true)
            end
            self.WeaponsDisabled = false
        end
        -- Cancel drone lockdown, re-enable command caps
        self:RestoreCommandCaps()
    end,

}
