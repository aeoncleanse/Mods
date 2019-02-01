
local ASeaUnit = import('/lua/aeonunits.lua').ASeaUnit
local BaseTransport = import('/lua/defaultunits.lua').BaseTransport
local AirDroneCarrier = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsunits.lua').AirDroneCarrier
local WeaponsFile = import('/lua/aeonweapons.lua')
local ADFCannonOblivionWeapon = WeaponsFile.ADFCannonOblivionWeapon02
local AANChronoTorpedoWeapon = WeaponsFile.AANChronoTorpedoWeapon
local AIFQuasarAntiTorpedoWeapon = WeaponsFile.AIFQuasarAntiTorpedoWeapon

UAS0401 = Class(BaseTransport, ASeaUnit, AirDroneCarrier) {
    Weapons = {
        MainGun = Class(ADFCannonOblivionWeapon) {},
        Torpedo01 = Class(AANChronoTorpedoWeapon) {},
        Torpedo02 = Class(AANChronoTorpedoWeapon) {},
        Torpedo03 = Class(AANChronoTorpedoWeapon) {},
        Torpedo04 = Class(AANChronoTorpedoWeapon) {},
        Torpedo05 = Class(AANChronoTorpedoWeapon) {},
        Torpedo06 = Class(AANChronoTorpedoWeapon) {},
        AntiTorpedo01 = Class(AIFQuasarAntiTorpedoWeapon) {},
        AntiTorpedo02 = Class(AIFQuasarAntiTorpedoWeapon) {},
    },


    BuildAttachBone = 'Attachpoint01',

    OnStopBeingBuilt = function(self,builder,layer)
        self:SetWeaponEnabledByLabel('MainGun', true)
        ASeaUnit.OnStopBeingBuilt(self,builder,layer)
        if layer == 'Water' then
            self:RestoreBuildRestrictions()
            self:RequestRefreshUI()
        else
            self:AddBuildRestriction(categories.ALLUNITS)
            self:RequestRefreshUI()
        end
        ChangeState(self, self.DroneMaintenanceState)
        AirDroneCarrier.InitDrones(self)
    end,

    OnStartBuild = function(self, unitBuilding, order)
        ASeaUnit.OnStartBuild(self, unitBuilding, order)
        self.UnitBeingBuilt = unitBuilding
        ChangeState(self, self.BuildingState)
    end,

    OnStopBuild = function(self, unitBeingBuilt)
        ASeaUnit.OnStopBuild(self, unitBeingBuilt)
        ChangeState(self, self.FinishedBuildingState)
    end,

    OnFailedToBuild = function(self)
        ASeaUnit.OnFailedToBuild(self)
        ChangeState(self, self.DroneMaintenanceState)
    end,


    OnMotionVertEventChange = function(self, new, old)
        ASeaUnit.OnMotionVertEventChange(self, new, old)
        if new == 'Top' then
            self:RestoreBuildRestrictions()
            self:RequestRefreshUI()
            self:SetWeaponEnabledByLabel('MainGun', true)
            self:PlayUnitSound('Open')
            self.DroneAssist = true
        elseif new == 'Down' then
            self:SetWeaponEnabledByLabel('MainGun', false)
            self:AddBuildRestriction(categories.ALLUNITS)
            self:RequestRefreshUI()
            self:PlayUnitSound('Close')
            self:RecallDrones()
            self.DroneAssist = false
        end
    end,

    BuildingState = State {
        Main = function(self)
            local unitBuilding = self.UnitBeingBuilt
            local bone = self.BuildAttachBone
            self:DetachAll(bone)
            if not self.UnitBeingBuilt.Dead then
                unitBuilding:AttachBoneTo(-2, self, bone)
                if EntityCategoryContains(categories.ENGINEER + categories.uas0102 + categories.uas0103, unitBuilding) then
                    unitBuilding:SetParentOffset({0,0,1})
                elseif EntityCategoryContains(categories.TECH2 - categories.ENGINEER, unitBuilding) then
                    unitBuilding:SetParentOffset({0,0,3})
                elseif EntityCategoryContains(categories.uas0203, unitBuilding) then
                    unitBuilding:SetParentOffset({0,0,1.5})
                else
                    unitBuilding:SetParentOffset({0,0,2.5})
                end
            end
            self.UnitDoneBeingBuilt = false
        end,

    },

    FinishedBuildingState = State {
        Main = function(self)
            local unitBuilding = self.UnitBeingBuilt
            unitBuilding:DetachFrom(true)
            self:DetachAll(self.BuildAttachBone)
            local worldPos = self:CalculateWorldPositionFromRelative({0, 0, -20})
            IssueMoveOffFactory({unitBuilding}, worldPos)
            ChangeState(self, self.DroneMaintenanceState)
        end,
    },

    --Places the Goliath's first drone-targetable attacker into a global
    OnDamage = function(self, instigator, amount, vector, damagetype)
        ASeaUnit.OnDamage(self, instigator, amount, vector, damagetype)
        AirDroneCarrier.SetAttacker(self, instigator)
    end,
    --Drone control buttons
    OnScriptBitSet = function(self, bit)
        --Drone assist toggle, on
        if bit == 1 then
            self.DroneAssist = false
        --Drone recall button
        elseif bit == 7 then
            self:RecallDrones()
            --Pop button back up, as it's not actually a toggle
            self:SetScriptBit('RULEUTC_SpecialToggle', false)
        else
            ASeaUnit.OnScriptBitSet(self, bit)
        end
    end,
    OnScriptBitClear = function(self, bit)
        --Drone assist toggle, off
        if bit == 1 then
            self.DroneAssist = true
        --Recall button reset, do nothing
        elseif bit == 7 then
            return
        else
            ASeaUnit.OnScriptBitClear(self, bit)
        end
    end,

    --Handles drone docking
    OnTransportAttach = function(self, attachBone, unit)
        self.DroneData[unit.Name].Docked = attachBone
        unit:SetDoNotTarget(true)
        BaseTransport.OnTransportAttach(self, attachBone, unit)
    end,

    --Handles drone undocking, also called when docked drones die
    OnTransportDetach = function(self, attachBone, unit)
        self.DroneData[unit.Name].Docked = false
        unit:SetDoNotTarget(false)
        if unit.Name == self.BuildingDrone then
            self:CleanupDroneMaintenance(self.BuildingDrone)
        end
        BaseTransport.OnTransportDetach(self, attachBone, unit)
    end,
    --Cleans up threads and drones on death
    OnKilled = function(self, instigator, type, overkillRatio)
        --Kill our heartbeat thread
        KillThread(self.HeartBeatThread)
        --Clean up any in-progress construction
        ChangeState(self, self.DeadState)
        --Immediately kill existing drones
        self:KillAllDrones()
        local nrofBones = self:GetBoneCount() -1
        local watchBone = self:GetBlueprint().WatchBone or 0

         self:ForkThread(function()
            local pos = self:GetPosition()
            local seafloor = GetTerrainHeight(pos[1], pos[3]) + GetTerrainTypeOffset(pos[1], pos[3])
            while self:GetPosition(watchBone)[2] > seafloor do
                WaitSeconds(0.1)
            end
            self:CreateWreckage(overkillRatio, instigator)
            self:Destroy()
        end)

        local layer = self:GetCurrentLayer()
        self:DestroyIdleEffects()
        if (layer == 'Water' or layer == 'Seabed' or layer == 'Sub') then
            self.SinkExplosionThread = self:ForkThread(self.ExplosionThread)
            self.SinkThread = self:ForkThread(self.SinkingThread)
        end
        ASeaUnit.OnKilled(self, instigator, type, overkillRatio)
    end,


    -- Set on unit death, ends production and consumption immediately
    DeadState = State {
        Main = function(self)
            if self.gettingBuilt == false then
                self:CleanupDroneMaintenance(nil, true)
            end
        end,
    },






}

TypeClass = UAS0401