--Cybran Scorpion T2 Ambushing Bot script by the Blackops team, refined by Mithy
--rev. 2
local CWalkingLandUnit = import('/lua/cybranunits.lua').CWalkingLandUnit
local CybranWeaponsFile = import('/lua/cybranweapons.lua')
local CybranWeaponsFile2 = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsWeapons.lua')
local CDFLaserHeavyWeapon = CybranWeaponsFile.CDFLaserHeavyWeapon
local ScorpDisintegratorWeapon = CybranWeaponsFile2.ScorpDisintegratorWeapon
local EffectUtil = import('/lua/EffectUtilities.lua')

XRL0205 = Class(CWalkingLandUnit) {

    -- While cloaked, weapons fire immediately decloaks; while waiting to recloak, it resets the timer.
    Weapons = {
        Disintigrator01 = Class(ScorpDisintegratorWeapon) {
            -- Hook RackSalvoFiringState Main for instant decloak, as OnWeaponFired happens post-salvo and the unit fires while still cloaked
            RackSalvoFiringState = State(ScorpDisintegratorWeapon.RackSalvoFiringState) {
                Main = function(self)
                    self.unit:RequestDecloak(self.AddCloakDelay)
                    ScorpDisintegratorWeapon.RackSalvoFiringState.Main(self)
                end,
            },

            -- Set up weaponfire-added cloak delay from weapon bp
            OnCreate = function(self)
                ScorpDisintegratorWeapon.OnCreate(self)
                self.AddCloakDelay = self:GetBlueprint().AddCloakDelay or 0
            end,
        },

        LaserArms = Class(CDFLaserHeavyWeapon) {
            RackSalvoFiringState = State(CDFLaserHeavyWeapon.RackSalvoFiringState) {
                Main = function(self)
                    self.unit:RequestDecloak(self.AddCloakDelay)
                    CDFLaserHeavyWeapon.RackSalvoFiringState.Main(self)
                end,
            },

            OnCreate = function(self)
                CDFLaserHeavyWeapon.OnCreate(self)
                self.AddCloakDelay = self:GetBlueprint().AddCloakDelay or 0
            end,
        },
    },

    OnStopBeingBuilt = function(self, builder, layer)
        CWalkingLandUnit.OnStopBeingBuilt(self, builder, layer)
        -- Intel effects start on, added/removed by cloak toggle button
        self:DoIntelEffects(false)

        local bp = self:GetBlueprint()
        self.Moving = false
        self.Building = false
        -- Stationary re-cloak wait time
        self.CloakWait = bp.Intel.CloakWaitTime or 1
        -- This variable holds the actual countdown timer
        self.CloakTimer = self.CloakWait
        -- By default, maintenance is halved while stealth is enabled, full while cloaked.
        -- Cloak toggle button disables both stealth and cloak, and turns off maintenance.
        self.StealthMaintenance = bp.Economy.MaintenanceConsumptionPerSecondEnergyStealth or bp.Economy.MaintenanceConsumptionPerSecondEnergy / 2
        self.CloakMaintenance = bp.Economy.MaintenanceConsumptionPerSecondEnergyCloak or bp.Economy.MaintenanceConsumptionPerSecondEnergy
        -- Begin cloaking attempts
        ChangeState(self, self.DecloakedState)
    end,

    OnCreate = function(self)
        CWalkingLandUnit.OnCreate(self)
        if self:GetBlueprint().General.BuildBones then
            local bp = self:GetBlueprint()
            self.BuildArmManipulator = CreateBuilderArmController(self, bp.General.BuildBones.YawBone or 0 , bp.General.BuildBones.PitchBone or 0, bp.General.BuildBones.AimBone or 0)
            self.Trash:Add(self.BuildArmManipulator)
            self:SetupBuildBones()
            -- Override default 360 degree build arm arc with laserarm weapon settings
            -- This is currently useless as I can't get the unit to call OnPrepareArmForBuild
            local wepbp = self:GetWeaponByLabel('LaserArms'):GetBlueprint()
            local yawmin, yawmax, yawspeed = wepbp.TurretYawRange*-1, wepbp.TurretYawRange, wepbp.TurretYawSpeed
            local pitchmin, pitchmax, pitchspeed = wepbp.TurretPitchRange*-1, wepbp.TurretPitchRange, wepbp.TurretPitchSpeed
        end
    end,

    -- Decloak/reset timer when we move
    OnMotionHorzEventChange = function(self, new, old)
        if new ~= 'Stopped' then
            self.Moving = true
            self:RequestDecloak(0)
        elseif new == 'Stopped' then
            self.Moving = false
        end
        CWalkingLandUnit.OnMotionHorzEventChange(self, new, old)
    end,

    CreateBuildEffects = function(self, unitBeingBuilt, order)
       EffectUtil.SpawnBuildBots(self, unitBeingBuilt, 1, self.BuildEffectsBag)
       EffectUtil.CreateCybranBuildBeams(self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag)
    end,

    OnPrepareArmToBuild = function(self)
        CWalkingLandUnit.OnPrepareArmToBuild(self)
        self:BuildPrep(true)
    end,

    OnStopCapture = function(self, target)
        CWalkingLandUnit.OnStopCapture(self, target)
        self:BuildPrep(true)
    end,

    OnFailedCapture = function(self, target)
        CWalkingLandUnit.OnFailedCapture(self, target)
        self:BuildPrep(true)
    end,

    OnStopReclaim = function(self, target)
        CWalkingLandUnit.OnStopReclaim(self, target)
        self:BuildPrep(true)
    end,

    OnFailedToBuild = function(self)
        CWalkingLandUnit.OnFailedToBuild(self)
        self:BuildPrep(true)
    end,

    OnStartBuild = function(self, unitBeingBuilt, order)
        CWalkingLandUnit.OnStartBuild(self, unitBeingBuilt, order)
        self:BuildPrep()
        self.UnitBeingBuilt = unitBeingBuilt
        self.UnitBuildOrder = order
        self.BuildingUnit = true
    end,

    OnStopBuild = function(self, unitBeingBuilt)
        CWalkingLandUnit.OnStopBuild(self, unitBeingBuilt)
        self:BuildPrep(true)
    end,

    -- Switches between build arm and laser weapon and flips self.Building flag
    -- NOTE: Can't get the build arm manipulator working, but this is still needed for the build flag and laser disable.
    -- FWIW, OnPrepareArmForBuild is never called on any unit other than ACUs/SCUs/engineers.  I suspect it's a category thing.
    BuildPrep = function(self, done)
        if self and not self.Dead and not self:BeenDestroyed() then
            if done then
                -- Mark unit as no longer building
                self.Building = false
                -- Clean up manipulator, re-enable weapon, sync turret
                self:BuildManipulatorSetEnabled(false)
                self.BuildArmManipulator:SetPrecedence(0)
                self:SetWeaponEnabledByLabel('LaserArms', true)
                self:GetWeaponManipulatorByLabel('LaserArms'):SetHeadingPitch(self.BuildArmManipulator:GetHeadingPitch())
            else
                -- Mark unit as building and issue decloak
                self.Building = true
                self:RequestDecloak(0)
                -- Enable manipulator, disable weapon, sync turret
                self:BuildManipulatorSetEnabled(true)
                self.BuildArmManipulator:SetPrecedence(20)
                self:SetWeaponEnabledByLabel('LaserArms', false)
                self.BuildArmManipulator:SetHeadingPitch(self:GetWeaponManipulatorByLabel('LaserArms'):GetHeadingPitch())
            end
        end
    end,

    IntelEffects = {
        Stealth = {
            {
                Bones = {
                    'Turret01',
                    'Tail2',
                },
                Scale = 1.0,
                Type = 'Cloak01',
            },
        },
    },

    -- Make sure we immediately decloak/stop energy drain on death
    -- Nothing is more embarrassing than recloaking while dying!
    OnKilled = function(self, instigator, type, overkillRatio)
        ChangeState(self, self.CloakDisabledState)
        CWalkingLandUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

    -- Cloak toggle off: stealth and cloak both disabled
    OnScriptBitSet = function(self, bit)
        if bit == 8 then
            self:DoIntelEffects(true)
            ChangeState(self, self.CloakDisabledState)
        end
    end,

    -- Cloak toggle on: stealth enabled, cloak on-stop
    OnScriptBitClear = function(self, bit)
        if bit == 8 then
            self:DoIntelEffects(false)
            ChangeState(self, self.DecloakedState)
        end
    end,

    -- Enables/disables intel effects on stealth/cloak toggle
    DoIntelEffects = function(self, cleanup)
        if cleanup then
            if self.IntelEffectsBag then
                EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
                self.IntelEffectsBag = nil
            end
        else
            if not self.IntelEffectsBag then
                self.IntelEffectsBag = {}
                for fx, fxtable in self.IntelEffects do
                    self.CreateTerrainTypeEffects(self, fxtable, 'FXIdle',  self:GetCurrentLayer(), nil, self.IntelEffectsBag)
                end
            end
        end
    end,

    RequestDecloak = function(self, addtime)
        -- Does nothing outside of states
    end,

    -- CloakedState - Fully cloaked and stealthed, full energy maintenance
    -- Any movement or weapon firing immediately decloaks
    CloakedState = State() {
        Main = function(self)
            -- Full consumption while cloaked (def. 50)
            self:SetEnergyMaintenanceConsumptionOverride(self.CloakMaintenance)
            self:SetMaintenanceConsumptionActive()
            if not self:IsIntelEnabled('Cloak') then
                self:EnableUnitIntel('Cloak')
            end
        end,

        RequestDecloak = function(self, addtime)
            if self.CloakTimer < (self.CloakWait + addtime) then
                self.CloakTimer = self.CloakWait + addtime
            end
            ChangeState(self, self.DecloakedState)
        end,
    },

    -- DecloakedState - Stealth enabled, trying to recloak, half energy maintenance
    -- Movement, repairing, and weapons fire all reset and suspend the timer
    DecloakedState = State() {
        Main = function(self)
            -- Make sure timer is reset
            if self.CloakTimer < self.CloakWait then
                self.CloakTimer = self.CloakWait
            end
            -- Half consumption while decloaked but stealthed (def. 25)
            self:SetEnergyMaintenanceConsumptionOverride(self.StealthMaintenance)
            self:SetMaintenanceConsumptionActive()
            -- Make sure stealth is enabled if we're coming from an intel toggle
            if not self:IsIntelEnabled('RadarStealth') then
                self:EnableUnitIntel('RadarStealth')
            end
            if self:IsIntelEnabled('Cloak') then
                self:DisableUnitIntel('Cloak')
            end
            -- While uncloaked and idle, constantly tick down timer - firing, repairing, and moving all reset the timer
            -- Comment/remove both self.Building checks to allow the bot to recloak while still repairing/assisting
            while self and not self.Dead and self.CloakTimer > -0.1 do
                WaitTicks(3) -- Actually waits 2, while 2 waits 1
                if not self.Building and not self.Moving then
                    self.CloakTimer = self.CloakTimer - 0.2
                end
            end
            -- Make sure we're still not moving/building before actually cloaking - weapons taken care of via timer
            if not self.Building and not self.Moving then
                ChangeState(self, self.CloakedState)
            else
                ChangeState(self, self.DecloakedState)
            end
        end,

        -- Reset our recloaking countdown on movement, weapon fire, etc
        RequestDecloak = function(self, addtime)
            if self.CloakTimer < (self.CloakWait + addtime) then
                self.CloakTimer = self.CloakWait + addtime
            end
        end,
    },

    -- CloakDisabledState - Cloak and stealth manually disabled, all maintenance off
    CloakDisabledState = State() {
        Main = function(self)
            -- Pre-emptively reset timer
            if self.CloakTimer < self.CloakWait then
                self.CloakTimer = self.CloakWait
            end
            self:SetMaintenanceConsumptionInactive()
            if self:IsIntelEnabled('RadarStealth') then
                self:DisableUnitIntel('RadarStealth')
            end
            if self:IsIntelEnabled('Cloak') then
                self:DisableUnitIntel('Cloak')
            end
        end,

        RequestDecloak = function(self, addtime)
            -- Does nothing
        end,
    },

}

TypeClass = XRL0205
