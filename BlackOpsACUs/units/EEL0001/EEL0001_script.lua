-----------------------------------------------------------------

-- Author(s):  Exavier Macbeth

-- Summary  :  BlackOps: Adv Command Unit - UEF ACU

-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------
local Shield = import('/lua/shield.lua').Shield

local TWalkingLandUnit = import('/lua/terranunits.lua').TWalkingLandUnit
local TerranWeaponFile = import('/lua/terranweapons.lua')
local TDFZephyrCannonWeapon = TerranWeaponFile.TDFZephyrCannonWeapon
local DeathNukeWeapon = import('/lua/sim/defaultweapons.lua').DeathNukeWeapon

local EffectTemplate = import('/lua/EffectTemplates.lua')
local TIFCruiseMissileLauncher = TerranWeaponFile.TIFCruiseMissileLauncher
local TDFOverchargeWeapon = TerranWeaponFile.TDFOverchargeWeapon
local EffectUtil = import('/lua/EffectUtilities.lua')
local Buff = import('/lua/sim/Buff.lua')
local UEFACUHeavyPlasmaGatlingCannonWeapon = import('/mods/BlackOpsACUs/lua/EXBlackOpsweapons.lua').UEFACUHeavyPlasmaGatlingCannonWeapon
local Weapons2 = import('/mods/BlackOpsACUs/lua/EXBlackOpsweapons.lua')
local EXFlameCannonWeapon = Weapons2.HawkGaussCannonWeapon
local UEFACUAntiMatterWeapon = Weapons2.UEFACUAntiMatterWeapon
local PDLaserGrid = import('/mods/BlackOpsACUs/lua/EXBlackOpsweapons.lua').PDLaserGrid2 
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')
local TANTorpedoAngler = import('/lua/terranweapons.lua').TANTorpedoAngler

EEL0001 = Class(TWalkingLandUnit) {   
    DeathThreadDestructionWaitTime = 2,

    Weapons = {
        DeathWeapon = Class(DeathNukeWeapon) {},
        RightZephyr = Class(TDFZephyrCannonWeapon) {},
        EXFlameCannon01 = Class(EXFlameCannonWeapon) {},
        EXFlameCannon02 = Class(EXFlameCannonWeapon) {},
        TorpedoLauncher = Class(TANTorpedoAngler) {},
        AntiMatterCannon = Class(UEFACUAntiMatterWeapon) {},
        EXGattlingEnergyCannon01 = Class(UEFACUHeavyPlasmaGatlingCannonWeapon) {
            OnCreate = function(self)
                UEFACUHeavyPlasmaGatlingCannonWeapon.OnCreate(self)
                if not self.unit.SpinManip then 
                    self.unit.SpinManip = CreateRotator(self.unit, 'Gatling_Cannon_Barrel', 'z', nil, 270, 300, 60)
                    self.unit.Trash:Add(self.unit.SpinManip)
                end
                self.unit.SpinManip:SetTargetSpeed(0)
            end,
            PlayFxRackSalvoChargeSequence = function(self)
                if self.unit.SpinManip then
                    self.unit.SpinManip:SetTargetSpeed(500)
                end
                UEFACUHeavyPlasmaGatlingCannonWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
            PlayFxRackSalvoReloadSequence = function(self)
                if self.unit.SpinManip then
                    self.unit.SpinManip:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects(self.unit, 'Exhaust', self.unit:GetArmy(), Effects.WeaponSteam01)
                UEFACUHeavyPlasmaGatlingCannonWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
        },
        EXGattlingEnergyCannon02 = Class(UEFACUHeavyPlasmaGatlingCannonWeapon) {
            OnCreate = function(self)
                UEFACUHeavyPlasmaGatlingCannonWeapon.OnCreate(self)
                if not self.unit.SpinManip then 
                    self.unit.SpinManip = CreateRotator(self.unit, 'Gatling_Cannon_Barrel', 'z', nil, 270, 300, 60)
                    self.unit.Trash:Add(self.unit.SpinManip)
                end
                self.unit.SpinManip:SetTargetSpeed(0)
            end,
            PlayFxRackSalvoChargeSequence = function(self)
                if self.unit.SpinManip then
                    self.unit.SpinManip:SetTargetSpeed(500)
                end
                UEFACUHeavyPlasmaGatlingCannonWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
            PlayFxRackSalvoReloadSequence = function(self)
                if self.unit.SpinManip then
                    self.unit.SpinManip:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects(self.unit, 'Exhaust', self.unit:GetArmy(), Effects.WeaponSteam01)
                UEFACUHeavyPlasmaGatlingCannonWeapon.PlayFxRackSalvoChargeSequence(self)
            end,    
        },
        EXGattlingEnergyCannon03 = Class(UEFACUHeavyPlasmaGatlingCannonWeapon) {
            OnCreate = function(self)
                UEFACUHeavyPlasmaGatlingCannonWeapon.OnCreate(self)
                if not self.unit.SpinManip then 
                    self.unit.SpinManip = CreateRotator(self.unit, 'Gatling_Cannon_Barrel', 'z', nil, 270, 300, 60)
                    self.unit.Trash:Add(self.unit.SpinManip)
                end
                self.unit.SpinManip:SetTargetSpeed(0)
            end,
            PlayFxRackSalvoChargeSequence = function(self)
                if self.unit.SpinManip then
                    self.unit.SpinManip:SetTargetSpeed(500)
                end
                UEFACUHeavyPlasmaGatlingCannonWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
            PlayFxRackSalvoReloadSequence = function(self)
                if self.unit.SpinManip then
                    self.unit.SpinManip:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects(self.unit, 'Exhaust', self.unit:GetArmy(), Effects.WeaponSteam01)
                UEFACUHeavyPlasmaGatlingCannonWeapon.PlayFxRackSalvoChargeSequence(self)
            end,    
        },
        EXClusterMissles01 = Class(TIFCruiseMissileLauncher) {},
        EXClusterMissles02 = Class(TIFCruiseMissileLauncher) {},
        EXClusterMissles03 = Class(TIFCruiseMissileLauncher) {},
        EXEnergyLance01 = Class(PDLaserGrid) {
            PlayOnlyOneSoundCue = true,
        }, 
        EXEnergyLance02 = Class(PDLaserGrid) {
            PlayOnlyOneSoundCue = true,
        }, 
        OverCharge = Class(TDFOverchargeWeapon) {},
        TacMissile = Class(TIFCruiseMissileLauncher) {
            CreateProjectileAtMuzzle = function(self)
                muzzle = self:GetBlueprint().RackBones[1].MuzzleBones[1]
                self.slider = CreateSlider(self.unit, 'Back_MissilePack_B02', 0, 0, 0, 0.25, true)
                self.slider:SetGoal(0, 0, 0.22)
                WaitFor(self.slider)
                TIFCruiseMissileLauncher.CreateProjectileAtMuzzle(self, muzzle)
                self.slider:SetGoal(0, 0, 0)
                WaitFor(self.slider)
                self.slider:Destroy()
            end,
        },
        TacNukeMissile = Class(TIFCruiseMissileLauncher) {
             CreateProjectileAtMuzzle = function(self)
                muzzle = self:GetBlueprint().RackBones[1].MuzzleBones[1]
                self.slider = CreateSlider(self.unit, 'Back_MissilePack_B02', 0, 0, 0, 0.25, true)
                self.slider:SetGoal(0, 0, 0.22)
                WaitFor(self.slider)
                TIFCruiseMissileLauncher.CreateProjectileAtMuzzle(self, muzzle)
                self.slider:SetGoal(0, 0, 0)
                WaitFor(self.slider)
                self.slider:Destroy()
            end,
       },
    },

    OnCreate = function(self)
        TWalkingLandUnit.OnCreate(self)
        self:SetCapturable(false)
        self:HideBone('Engineering_Suite', true)
        self:HideBone('Flamer', true)
        self:HideBone('HAC', true)
        self:HideBone('Gatling_Cannon', true)
        self:HideBone('Back_MissilePack_B01', true)
        self:HideBone('Back_SalvoLauncher', true)
        self:HideBone('Back_ShieldPack', true)
        self:HideBone('Left_Lance_Turret', true)
        self:HideBone('Right_Lance_Turret', true)
        self:HideBone('Zephyr_Amplifier', true)
        self:HideBone('Back_IntelPack', true)
        self:HideBone('Torpedo_Launcher', true)
        self:SetupBuildBones()
        self.HasLeftPod = false
        self.HasRightPod = false
        -- Restrict what enhancements will enable later
        self:AddBuildRestriction(categories.UEF * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
    end,

    OnPrepareArmToBuild = function(self)
        TWalkingLandUnit.OnPrepareArmToBuild(self)
        if self:BeenDestroyed() then return end
        self:BuildManipulatorSetEnabled(true)
        self.BuildArmManipulator:SetPrecedence(20)
        self.wcBuildMode = true
        self:ForkThread(self.WeaponConfigCheck)
        self.BuildArmManipulator:SetHeadingPitch(self:GetWeaponManipulatorByLabel('RightZephyr'):GetHeadingPitch())
    end,

    OnStopCapture = function(self, target)
        TWalkingLandUnit.OnStopCapture(self, target)
        if self:BeenDestroyed() then return end
        self:BuildManipulatorSetEnabled(false)
        self.BuildArmManipulator:SetPrecedence(0)
        self.wcBuildMode = false
        self:ForkThread(self.WeaponConfigCheck)
        self:GetWeaponManipulatorByLabel('RightZephyr'):SetHeadingPitch(self.BuildArmManipulator:GetHeadingPitch())
    end,

    OnFailedCapture = function(self, target)
        TWalkingLandUnit.OnFailedCapture(self, target)
        self:BuildManipulatorSetEnabled(false)
        self.BuildArmManipulator:SetPrecedence(0)
        self.wcBuildMode = false
        self:ForkThread(self.WeaponConfigCheck)
        self:GetWeaponManipulatorByLabel('RightZephyr'):SetHeadingPitch(self.BuildArmManipulator:GetHeadingPitch())
    end,

    OnStopReclaim = function(self, target)
        TWalkingLandUnit.OnStopReclaim(self, target)
        if self:BeenDestroyed() then return end
        self:BuildManipulatorSetEnabled(false)
        self.BuildArmManipulator:SetPrecedence(0)
        self.wcBuildMode = false
        self:ForkThread(self.WeaponConfigCheck)
        self:GetWeaponManipulatorByLabel('RightZephyr'):SetHeadingPitch(self.BuildArmManipulator:GetHeadingPitch())
    end,

    GiveInitialResources = function(self)
        WaitTicks(5)
        self:GetAIBrain():GiveResource('Energy', self:GetBlueprint().Economy.StorageEnergy)
        self:GetAIBrain():GiveResource('Mass', self:GetBlueprint().Economy.StorageMass)
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        TWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
        if self:BeenDestroyed() then return end
        self.Animator = CreateAnimator(self)
        self.Animator:SetPrecedence(0)
        if self.IdleAnim then
            self.Animator:PlayAnim(self:GetBlueprint().Display.AnimationIdle, true)
            for k, v in self.DisabledBones do
                self.Animator:SetBoneEnabled(v, false)
            end
        end
        self:BuildManipulatorSetEnabled(false)
        self:DisableUnitIntel('Radar')
        self:DisableUnitIntel('Sonar')
        self:DisableUnitIntel('Spoof')
        self:DisableUnitIntel('RadarStealth')
        self:DisableUnitIntel('SonarStealth')
        self:DisableUnitIntel('Cloak')
        self:DisableUnitIntel('CloakField')
        self:SetMaintenanceConsumptionInactive()
        self.Rotator1 = CreateRotator(self, 'Back_ShieldPack_Spinner01', 'z', nil, 0, 20, 0)
        self.Rotator2 = CreateRotator(self, 'Back_ShieldPack_Spinner02', 'z', nil, 0, 40, 0)
        self.RadarDish1 = CreateRotator(self, 'Back_IntelPack_Dish', 'y', nil, 0, 20, 0)
        self.Trash:Add(self.Rotator1)
        self.Trash:Add(self.Rotator2)
        self.Trash:Add(self.RadarDish1)
        self.ShieldEffectsBag2 = {}
        self.FlamerEffectsBag = {}
        self.wcBuildMode = false
        self.wcOCMode = false
        self.wcFlamer01 = false
        self.wcFlamer02 = false
        self.wcAMC01 = false
        self.wcAMC02 = false
        self.wcAMC03 = false
        self.wcGatling01 = false
        self.wcGatling02 = false
        self.wcGatling03 = false
        self.wcLance01 = false
        self.wcLance02 = false
        self.wcCMissiles01 = false
        self.wcCMissiles02 = false
        self.wcCMissiles03 = false
        self.wcTMissiles01 = false
        self.wcNMissiles01 = false
        self:ForkThread(self.GiveInitialResources)
        self.RBDefTier1 = false
        self.RBDefTier2 = false
        self.RBDefTier3 = false
        self.RBComTier1 = false
        self.RBComTier2 = false
        self.RBComTier3 = false
        self.RBIntTier1 = false
        self.RBIntTier2 = false
        self.RBIntTier3 = false
        self.SpysatEnabled = false
        self.DefaultGunBuffApplied = false
        
        -- Disable Upgrade Weapons
        self:SetWeaponEnabledByLabel('RightZephyr', false)
        self:SetWeaponEnabledByLabel('OverCharge', false)
        self:SetWeaponEnabledByLabel('TorpedoLauncher', false)
        self:SetWeaponEnabledByLabel('EXFlameCannon01', false)
        self:SetWeaponEnabledByLabel('EXFlameCannon02', false)
        self:SetWeaponEnabledByLabel('AntiMatterCannon', false)
        self:SetWeaponEnabledByLabel('EXGattlingEnergyCannon01', false)
        self:SetWeaponEnabledByLabel('EXGattlingEnergyCannon02', false)
        self:SetWeaponEnabledByLabel('EXGattlingEnergyCannon03', false)
        self:SetWeaponEnabledByLabel('EXClusterMissles01', false)
        self:SetWeaponEnabledByLabel('EXClusterMissles02', false)
        self:SetWeaponEnabledByLabel('EXClusterMissles03', false)
        self:SetWeaponEnabledByLabel('EXEnergyLance01', false)
        self:SetWeaponEnabledByLabel('EXEnergyLance02', false)
        self:SetWeaponEnabledByLabel('TacMissile', false)
        self:SetWeaponEnabledByLabel('TacNukeMissile', false)
        self:SetWeaponEnabledByLabel('DeathWeapon', false)
        
    end,
    


    PlayCommanderWarpInEffect = function(self)
        self:HideBone(0, true)
        self:SetUnSelectable(true)
        self:SetBusy(true)
        self:SetBlockCommandQueue(true)
        self:ForkThread(self.WarpInEffectThread)
    end,

    WarpInEffectThread = function(self)
        self:PlayUnitSound('CommanderArrival')
        self:CreateProjectile('/effects/entities/UnitTeleport01/UnitTeleport01_proj.bp', 0, 1.35, 0, nil, nil, nil):SetCollision(false)
        WaitSeconds(2.1)
        self:SetMesh('/mods/BlackOpsACUs/units/eel0001/EEL0001_PhaseShield_mesh', true)
        self:ShowBone(0, true)
        self:HideBone('Engineering_Suite', true)
        self:HideBone('Flamer', true)
        self:HideBone('HAC', true)
        self:HideBone('Gatling_Cannon', true)
        self:HideBone('Back_MissilePack_B01', true)
        self:HideBone('Back_SalvoLauncher', true)
        self:HideBone('Back_ShieldPack', true)
        self:HideBone('Left_Lance_Turret', true)
        self:HideBone('Right_Lance_Turret', true)
        self:HideBone('Zephyr_Amplifier', true)
        self:HideBone('Back_IntelPack', true)
        self:HideBone('Torpedo_Launcher', true)
        self:SetUnSelectable(false)
        self:SetBusy(false)
        self:SetBlockCommandQueue(false)

        local totalBones = self:GetBoneCount() - 1
        local army = self:GetArmy()
        for k, v in EffectTemplate.UnitTeleportSteam01 do
            for bone = 1, totalBones do
                CreateAttachedEmitter(self,bone,army, v)
            end
        end

        WaitSeconds(6)
        self:SetMesh(self:GetBlueprint().Display.MeshBlueprint, true)
    end,

    OnStartBuild = function(self, unitBeingBuilt, order)
        TWalkingLandUnit.OnStartBuild(self, unitBeingBuilt, order)
        if self.Animator then
            self.Animator:SetRate(0)
        end
        self.UnitBeingBuilt = unitBeingBuilt
        self.UnitBuildOrder = order
        self.BuildingUnit = true        
    end,

    OnFailedToBuild = function(self)
        TWalkingLandUnit.OnFailedToBuild(self)
        if self:BeenDestroyed() then return end
        self:BuildManipulatorSetEnabled(false)
        self.BuildArmManipulator:SetPrecedence(0)
        self.wcBuildMode = false
        self:ForkThread(self.WeaponConfigCheck)
        self:GetWeaponManipulatorByLabel('RightZephyr'):SetHeadingPitch(self.BuildArmManipulator:GetHeadingPitch())
    end,

    CreateBuildEffects = function(self, unitBeingBuilt, order)
        local UpgradesFrom = unitBeingBuilt:GetBlueprint().General.UpgradesFrom
        -- If we are assisting an upgrading unit, or repairing a unit, play seperate effects
        if (order == 'Repair' and not unitBeingBuilt:IsBeingBuilt()) or (UpgradesFrom and UpgradesFrom ~= 'none' and self:IsUnitState('Guarding'))then
            EffectUtil.CreateDefaultBuildBeams(self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag)
        else
            EffectUtil.CreateUEFCommanderBuildSliceBeams(self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag)        
        end           
    end,

    OnStopBuild = function(self, unitBeingBuilt)
        TWalkingLandUnit.OnStopBuild(self, unitBeingBuilt)
        if self:BeenDestroyed() then return end
        if (self.IdleAnim and not self:IsDead()) then
            self.Animator:PlayAnim(self.IdleAnim, true)
        end
        self:BuildManipulatorSetEnabled(false)
        self.BuildArmManipulator:SetPrecedence(0)
        self.wcBuildMode = false
        self:ForkThread(self.WeaponConfigCheck)
        self:GetWeaponManipulatorByLabel('RightZephyr'):SetHeadingPitch(self.BuildArmManipulator:GetHeadingPitch())
        self.UnitBeingBuilt = nil
        self.UnitBuildOrder = nil
        self.BuildingUnit = false          
    end,

    NotifyOfPodDeath = function(self, pod)
        if pod == 'LeftPod' then
            if self.HasRightPod then
                TWalkingLandUnit.CreateEnhancement(self, 'RightPodRemove') -- cant use CreateEnhancement function
                TWalkingLandUnit.CreateEnhancement(self, 'LeftPod') --makes the correct upgrade icon light up
                if self.LeftPod and not self.LeftPod:IsDead() then
                    self.LeftPod:Kill()
                end
            else
                self:CreateEnhancement('LeftPodRemove')
            end
            self.HasLeftPod = false
        elseif pod == 'RightPod' then   --basically the same as above but we can use the CreateEnhancement function this time
            if self.HasLeftPod then
                TWalkingLandUnit.CreateEnhancement(self, 'RightPodRemove') -- cant use CreateEnhancement function
                TWalkingLandUnit.CreateEnhancement(self, 'LeftPod') --makes the correct upgrade icon light up
                if self.LeftPod and not self.LeftPod:IsDead() then
                    self.RightPod:Kill()
                end
            else
                self:CreateEnhancement('LeftPodRemove')
            end
            self.HasRightPod = false

        elseif pod == 'SpySat' and self.SpysatEnabled then 
            self.Satellite = nil
            self:ForkThread(self.EXSatRespawn)
        end
        self:RequestRefreshUI()
    end,

    EXSatSpawn = function(self)
        if not self.Satellite and self.SpysatEnabled then
            local location = self:GetPosition('Torso')
            self.Satellite = CreateUnitHPR('EEA0002', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
            self.Satellite:AttachTo(self, 'Back_IntelPack')
            self.Trash:Add(self.Satellite)
            self.Satellite.Parent = self
            self.Satellite:SetParent(self, 'SpySat')
            self:PlayUnitSound('LaunchSat')
            self.Satellite:DetachFrom()
            self.Satellite:Open()
        end
    end,

    EXSatRespawn = function(self)
        if self.SpysatEnabled then
            WaitSeconds(300)
            if self.SpysatEnabled and not self.Satellite then
                local location = self:GetPosition('Torso')
                self.Satellite = CreateUnitHPR('EEA0002', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
                self.Satellite:AttachTo(self, 'Back_IntelPack')
                self.Trash:Add(self.Satellite)
                self.Satellite.Parent = self
                self.Satellite:SetParent(self, 'SpySat')
                self:PlayUnitSound('LaunchSat')
                self.Satellite:DetachFrom()
                self.Satellite:Open()
            end
        end
    end,

    OnScriptBitClear = function(self, bit)
        if bit == 0 then -- shield toggle
            self.Rotator1:SetTargetSpeed(0)
            self.Rotator2:SetTargetSpeed(0)
            if self.ShieldEffectsBag2 then
                for k, v in self.ShieldEffectsBag2 do
                    v:Destroy()
                end
                self.ShieldEffectsBag2 = {}
            end
            self:DisableShield()
            self:StopUnitAmbientSound('ActiveLoop')
        elseif bit == 2 then 

        elseif bit == 8 then -- cloak toggle
            self:PlayUnitAmbientSound('ActiveLoop')
            self:SetMaintenanceConsumptionActive()
            self:EnableUnitIntel('Radar')
            self:EnableUnitIntel('Sonar')
            self.RadarDish1:SetTargetSpeed(45)
        end
    end,

    OnScriptBitSet = function(self, bit)
        if bit == 0 then -- shield toggle
            self.Rotator1:SetTargetSpeed(90)
            self.Rotator2:SetTargetSpeed(-180)
            if self.ShieldEffectsBag2 then
                for k, v in self.ShieldEffectsBag2 do
                    v:Destroy()
                end
                self.ShieldEffectsBag2 = {}
            end
            for k, v in self.ShieldEffects2 do
                table.insert(self.ShieldEffectsBag2, CreateAttachedEmitter(self, 'Back_ShieldPack_Emitter01', self:GetArmy(), v))
                table.insert(self.ShieldEffectsBag2, CreateAttachedEmitter(self, 'Back_ShieldPack_Emitter02', self:GetArmy(), v))
                table.insert(self.ShieldEffectsBag2, CreateAttachedEmitter(self, 'Back_ShieldPack_Emitter03', self:GetArmy(), v))
                table.insert(self.ShieldEffectsBag2, CreateAttachedEmitter(self, 'Back_ShieldPack_Emitter04', self:GetArmy(), v))
                table.insert(self.ShieldEffectsBag2, CreateAttachedEmitter(self, 'Back_ShieldPack_Emitter05', self:GetArmy(), v))
                table.insert(self.ShieldEffectsBag2, CreateAttachedEmitter(self, 'Back_ShieldPack_Emitter06', self:GetArmy(), v))
                table.insert(self.ShieldEffectsBag2, CreateAttachedEmitter(self, 'Back_ShieldPack_Emitter07', self:GetArmy(), v))
                table.insert(self.ShieldEffectsBag2, CreateAttachedEmitter(self, 'Back_ShieldPack_Emitter08', self:GetArmy(), v))
            end
            self:EnableShield()
            self:PlayUnitAmbientSound('ActiveLoop')
        elseif bit == 2 then

        elseif bit == 8 then -- cloak toggle
            self:StopUnitAmbientSound('ActiveLoop')
            self:SetMaintenanceConsumptionInactive()
            self:DisableUnitIntel('Radar')
            self:DisableUnitIntel('Sonar')
            self.RadarDish1:SetTargetSpeed(0)
        end
    end,

    OnTransportDetach = function(self, attachBone, unit)
        TWalkingLandUnit.OnTransportDetach(self, attachBone, unit)
        self:StopSiloBuild()
        self:ForkThread(self.WeaponConfigCheck)
    end,

    -- New function to set up production numbers
    SetProduction = function(self, bp)
        local energy = bp.ProductionPerSecondEnergy or 0
        local mass = bp.ProductionPerSecondMass or 0
        
        local bpEcon = self:GetBlueprint().Economy
        
        self:SetProductionPerSecondEnergy(energy + bpEcon.ProductionPerSecondEnergy or 0)
        self:SetProductionPerSecondMass(mass + bpEcon.ProductionPerSecondEnergy or 0)
    end,
    
    -- Function to toggle the Zephyr Booster
    TogglePrimaryGun = function(self, damage, radius)
        local wep = self:GetWeaponByLabel('RightZephyr')
        local oc = self:GetWeaponByLabel('OverCharge')
    
        local wepRadius = radius or GetBlueprint().MaxRadius
        local ocRadius = radius or GetBlueprint().MaxRadius
    
        -- Change Damage
        wep:AddDamageMod(damage)
        
        -- Change Radius
        wep:ChangeMaxRadius(wepRadius)
        oc:ChangeMaxRadius(ocRadius)
        
        -- As radius is only passed when turning on, use the bool
        if radius then
            self:ShowBone('Zephyr_Amplifier', true)
        else
            self:HideBone('Zephyr_Amplifier', true)
        end
    end,
    
    CreateEnhancement = function(self, enh)
        TWalkingLandUnit.CreateEnhancement(self, enh)
        
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
        
        if enh == 'ImprovedEngineering' then
            self:RemoveBuildRestriction(categories.UEF * categories.BUILTBYTIER2COMMANDER)
            self:SetProduction(bp)
            
            if not Buffs['UEFACUT2BuildRate'] then
                BuffBlueprint {
                    Name = 'UEFACUT2BuildRate',
                    DisplayName = 'UEFACUT2BuildRate',
                    BuffType = 'ACUBUILDRATE',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        BuildRate = {
                            Add =  bp.NewBuildRate - self:GetBlueprint().Economy.BuildRate,
                            Mult = 1,
                        },
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                        Regen = {
                            Add = bp.NewRegenRate,
                            Mult = 1.0,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'UEFACUT2BuildRate')
        elseif enh == 'ImprovedEngineeringRemove' then
            if Buff.HasBuff(self, 'UEFACUT2BuildRate') then
                Buff.RemoveBuff(self, 'UEFACUT2BuildRate')
            end
            self:AddBuildRestriction(categories.UEF * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            self:SetProduction()
        elseif enh == 'AdvancedEngineering' then
            self:RemoveBuildRestriction(categories.UEF * (categories.BUILTBYTIER3COMMANDER - categories.BUILTBYTIER4COMMANDER))
            self:SetProduction(bp)

            if not Buffs['UEFACUT3BuildRate'] then
                BuffBlueprint {
                    Name = 'UEFACUT3BuildRate',
                    DisplayName = 'UEFCUT3BuildRate',
                    BuffType = 'ACUBUILDRATE',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        BuildRate = {
                            Add =  bp.NewBuildRate - self:GetBlueprint().Economy.BuildRate,
                            Mult = 1,
                        },
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                        Regen = {
                            Add = bp.NewRegenRate,
                            Mult = 1.0,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'UEFACUT3BuildRate')
        elseif enh == 'AdvancedEngineeringRemove' then
            if Buff.HasBuff(self, 'UEFACUT3BuildRate') then
                Buff.RemoveBuff(self, 'UEFACUT3BuildRate')
            end
            self:AddBuildRestriction(categories.UEF * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            self:SetProduction()
        elseif enh == 'ExperimentalEngineering' then
            self:RemoveBuildRestriction(categories.UEF * (categories.BUILTBYTIER4COMMANDER))
            self:SetProduction(bp)
            
            if not Buffs['UEFACUT4BuildRate'] then
                BuffBlueprint {
                    Name = 'UEFACUT4BuildRate',
                    DisplayName = 'UEFCUT4BuildRate',
                    BuffType = 'ACUBUILDRATE',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        BuildRate = {
                            Add =  bp.NewBuildRate - self:GetBlueprint().Economy.BuildRate,
                            Mult = 1,
                        },
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                        Regen = {
                            Add = bp.NewRegenRate,
                            Mult = 1.0,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'UEFACUT4BuildRate')
        elseif enh == 'ExperimentalEngineeringRemove' then
            if Buff.HasBuff(self, 'UEFACUT4BuildRate') then
                Buff.RemoveBuff(self, 'UEFACUT4BuildRate')
            end
            self:AddBuildRestriction(categories.UEF * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            self:SetProduction()
        elseif enh == 'CombatEngineering' then
            self:RemoveBuildRestriction(categories.UEF * (categories.BUILTBYTIER2COMMANDER))
            if not Buffs['UEFACUT2BuildCombat'] then
                BuffBlueprint {
                    Name = 'UEFACUT2BuildCombat',
                    DisplayName = 'UEFACUT2BuildCombat',
                    BuffType = 'ACUBUILDRATE',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        BuildRate = {
                            Add =  bp.NewBuildRate - self:GetBlueprint().Economy.BuildRate,
                            Mult = 1,
                        },
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                        Regen = {
                            Add = bp.NewRegenRate,
                            Mult = 1.0,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'UEFACUT2BuildCombat')

            if self.FlamerEffectsBag then
                for k, v in self.FlamerEffectsBag do
                    v:Destroy()
                end
                self.FlamerEffectsBag = {}
            end
            for k, v in self.FlamerEffects do
                table.insert(self.FlamerEffectsBag, CreateAttachedEmitter(self, 'Flamer_Torch', self:GetArmy(), v):ScaleEmitter(0.0625))
            end
            self.wcFlamer01 = true
            self.wcFlamer02 = false
            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)
        elseif enh == 'CombatEngineeringRemove' then
            if Buff.HasBuff(self, 'UEFACUT2BuildCombat') then
                Buff.RemoveBuff(self, 'UEFACUT2BuildCombat')
            end
            self:AddBuildRestriction(categories.UEF * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            
            if self.FlamerEffectsBag then
                for k, v in self.FlamerEffectsBag do
                    v:Destroy()
                end
                self.FlamerEffectsBag = {}
            end
            self.wcFlamer01 = false
            self.wcFlamer02 = false
            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)
        elseif enh == 'AssaultEngineering' then
            self:RemoveBuildRestriction(categories.UEF * (categories.BUILTBYTIER3COMMANDER - categories.BUILTBYTIER4COMMANDER))
            if not Buffs['UEFACUT3BuildCombat'] then
                BuffBlueprint {
                    Name = 'UEFACUT3BuildCombat',
                    DisplayName = 'UEFCUT3BuildCombat',
                    BuffType = 'ACUBUILDRATE',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        BuildRate = {
                            Add =  bp.NewBuildRate - self:GetBlueprint().Economy.BuildRate,
                            Mult = 1,
                        },
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                        Regen = {
                            Add = bp.NewRegenRate,
                            Mult = 1.0,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'UEFACUT3BuildCombat')

            self.wcFlamer01 = false
            self.wcFlamer02 = true
            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)
        elseif enh == 'AssaultEngineeringRemove' then
            if Buff.HasBuff(self, 'UEFACUT3BuildCombat') then
                Buff.RemoveBuff(self, 'UEFACUT3BuildCombat')
            end
            self:AddBuildRestriction(categories.UEF * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))   

            if self.FlamerEffectsBag then
                for k, v in self.FlamerEffectsBag do
                    v:Destroy()
                end
                self.FlamerEffectsBag = {}
            end
            self.wcFlamer01 = false
            self.wcFlamer02 = false
            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)
        elseif enh == 'ApocolypticEngineering' then
            self:RemoveBuildRestriction(categories.UEF * (categories.BUILTBYTIER4COMMANDER))
            if not Buffs['UEFACUT4BuildCombat'] then
                BuffBlueprint {
                    Name = 'UEFACUT4BuildCombat',
                    DisplayName = 'UEFACUT4BuildCombat',
                    BuffType = 'ACUBUILDRATE',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        BuildRate = {
                            Add =  bp.NewBuildRate - self:GetBlueprint().Economy.BuildRate,
                            Mult = 1,
                        },
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                        Regen = {
                            Add = bp.NewRegenRate,
                            Mult = 1.0,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'UEFACUT4BuildCombat')
        elseif enh == 'ApocolypticEngineeringRemove' then
            if Buff.HasBuff(self, 'UEFACUT4BuildCombat') then
                Buff.RemoveBuff(self, 'UEFACUT4BuildCombat')
            end
            self:AddBuildRestriction(categories.UEF * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))

            if self.FlamerEffectsBag then
                for k, v in self.FlamerEffectsBag do
                    v:Destroy()
                end
                self.FlamerEffectsBag = {}
            end
            self.wcFlamer01 = false
            self.wcFlamer02 = false
            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)
            
        -- Zephyr Booster
            
        elseif enh =='ZephyrBooster' then
            self:TogglePrimaryGun(bp.DamageMod, bp.NewMaxRadius)
        elseif enh =='ZephyrBoosterRemove' then
            self:TogglePrimaryGun(bp.DamageMod)

        -- Torpedoes
        
        elseif enh == 'TorpedoLauncher' then
            if not Buffs['UEFTorpHealth1'] then
                BuffBlueprint {
                    Name = 'UEFTorpHealth1',
                    DisplayName = 'UEFTorpHealth1',
                    BuffType = 'UEFTorpHealth',
                    Stacks = 'STACKS',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                    },
                }
            end
            
            self:SetWeaponEnabledByLabel('TorpedoLauncher', true)
        elseif enh == 'TorpedoLauncherRemove' then
            if Buff.HasBuff(self, 'UEFTorpHealth1') then
                Buff.RemoveBuff(self, 'UEFTorpHealth1')
            end
            
            self:SetWeaponEnabledByLabel('TorpedoLauncher', false)
        elseif enh == 'TorpedoRapidLoader' then
            if not Buffs['UEFTorpHealth2'] then
                BuffBlueprint {
                    Name = 'UEFTorpHealth2',
                    DisplayName = 'UEFTorpHealth2',
                    BuffType = 'UEFTorpHealth',
                    Stacks = 'STACKS',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'UEFTorpHealth2')

            local torp = self:GetWeaponByLabel('TorpedoLauncher')
            torp:AddDamageMod(bp.TorpDamageMod)
            torp:ChangeRateOfFire(bp.NewTorpROF)
            
            -- Install Zephyr Cannon
            self:TogglePrimaryGun(bp.DamageMod, bp.NewMaxRadius)
        elseif enh == 'TorpedoRapidLoaderRemove' then
            if Buff.HasBuff(self, 'UEFTorpHealth2') then
                Buff.RemoveBuff(self, 'UEFTorpHealth2')
            end
            
            local torp = self:GetWeaponByLabel('TorpedoLauncher')
            torp:AddDamageMod(bp.TorpDamageMod)
            torp:ChangeRateOfFire(torp:GetBlueprint().RateOfFire)
            
            self:TogglePrimaryGun(bp.DamageMod)
        elseif enh == 'TorpedoClusterLauncher' then
            if not Buffs['UEFTorpHealth3'] then
                BuffBlueprint {
                    Name = 'UEFTorpHealth3',
                    DisplayName = 'UEFTorpHealth3',
                    BuffType = 'UEFTorpHealth',
                    Stacks = 'STACKS',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'UEFTorpHealth3')
            
            local torp = self:GetWeaponByLabel('TorpedoLauncher')
            torp:AddDamageMod(bp.TorpDamageMod)
            
            -- Improve Zephyr Cannon
            local wep = self:GetWeaponByLabel('RightZephyr')
            wep:AddDamageMod(bp.DamageMod)
        elseif enh == 'EXTorpedoClusterLauncherRemove' then
            if Buff.HasBuff(self, 'UEFTorpHealth3') then
                Buff.RemoveBuff(self, 'UEFTorpHealth3')
            end

            local torp = self:GetWeaponByLabel('TorpedoLauncher')
            torp:AddDamageMod(bp.TorpDamageMod)
            
            local wep = self:GetWeaponByLabel('RightZephyr')
            wep:AddDamageMod(bp.DamageMod)
            
        -- AntiMatter Cannon
        
        elseif enh == 'AntiMatterCannon' then
            if not Buffs['UEFAntimatterHealth1'] then
                BuffBlueprint {
                    Name = 'UEFAntimatterHealth1',
                    DisplayName = 'UEFAntimatterHealth1',
                    BuffType = 'UEFAntimatterHealth',
                    Stacks = 'STACKS',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'UEFAntimatterHealth1')

            self:SetWeaponEnabledByLabel('AntiMatterCannon', true)
        elseif enh == 'AntiMatterCannonRemove' then
            if Buff.HasBuff(self, 'UEFAntimatterHealth1') then
                Buff.RemoveBuff(self, 'UEFAntimatterHealth1')
            end
            
            self:SetWeaponEnabledByLabel('AntiMatterCannon', false)
        elseif enh == 'ImprovedContainmentBottle' then
            if not Buffs['UEFAntimatterHealth2'] then
                BuffBlueprint {
                    Name = 'UEFAntimatterHealth2',
                    DisplayName = 'UEFAntimatterHealth2',
                    BuffType = 'UEFAntimatterHealth',
                    Stacks = 'STACKS',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'UEFAntimatterHealth2')
            
            -- Buff AntiMatter Gun
            local gun = self:GetWeaponByLabel('AntiMatterCannon')
            gun:AddDamageMod(bp.AntiMatterDamageMod)
            gun:ChangeDamageRadius(bp.NewDamageArea)
            
            -- Install Zephyr Cannon
            self:TogglePrimaryGun(bp.DamageMod, bp.NewMaxRadius)
        elseif enh == 'ImprovedContainmentBottleRemove' then    
            if Buff.HasBuff(self, 'UEFAntimatterHealth2') then
                Buff.RemoveBuff(self, 'UEFAntimatterHealth2')
            end
            
            local gun = self:GetWeaponByLabel('AntiMatterCannon')
            gun:AddDamageMod(bp.AntiMatterDamageMod)
            gun:ChangeDamageRadius(gun:GetBlueprint().DamageRadius)

            self:TogglePrimaryGun(bp.DamageMod)
        elseif enh == 'PowerBooster' then
            if not Buffs['UEFAntimatterHealth3'] then
                BuffBlueprint {
                    Name = 'UEFAntimatterHealth3',
                    DisplayName = 'UEFAntimatterHealth3',
                    BuffType = 'UEFAntimatterHealth',
                    Stacks = 'STACKS',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'UEFAntimatterHealth3')

            local gun = self:GetWeaponByLabel('AntiMatterCannon')
            gun:AddDamageMod(bp.AntiMatterDamageMod)
            gun:ChangeDamageRadius(bp.NewDamageArea)
            gun:ChangeMaxRadius(bp.NewAntiMatterMaxRadius)
            
            -- Use toggle function to increase MaxRadius of Zephyr Cannon
            self:TogglePrimaryGun(0, bp.NewMaxRadius)
        elseif enh == 'PowerBoosterRemove' then
            if Buff.HasBuff(self, 'UEFAntimatterHealth3') then
                Buff.RemoveBuff(self, 'UEFAntimatterHealth3')
            end
            
            local gun = self:GetWeaponByLabel('AntiMatterCannon')
            gun:AddDamageMod(bp.AntiMatterDamageMod)
            gun:ChangeDamageRadius(gun:GetBlueprint().DamageRadius)
            gun:ChangeMaxRadius(gun:GetBlueprint().MaxRadius)

            -- Remove Zephyr Jury Rigging
            self:TogglePrimaryGun(0, bp.NewMaxRadius)
            
        -- Gatling Cannon
            
        elseif enh =='EXGattlingEnergyCannon' then
            if not Buffs['EXUEFHealthBoost13'] then
                BuffBlueprint {
                    Name = 'EXUEFHealthBoost13',
                    DisplayName = 'EXUEFHealthBoost13',
                    BuffType = 'EXUEFHealthBoost13',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'EXUEFHealthBoost13')
            local wepZephyr = self:GetWeaponByLabel('RightZephyr')
            wepZephyr:ChangeMaxRadius(35)
            self.wcGatling01 = true
            self.wcGatling02 = false
            self.wcGatling03 = false
            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='EXGattlingEnergyCannonRemove' then
            if Buff.HasBuff(self, 'EXUEFHealthBoost13') then
                Buff.RemoveBuff(self, 'EXUEFHealthBoost13')
            end
            local wepZephyr = self:GetWeaponByLabel('RightZephyr')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[1].MaxRadius
            wepZephyr:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            self.wcGatling01 = false
            self.wcGatling02 = false
            self.wcGatling03 = false
            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='EXImprovedCoolingSystem' then
            if not Buffs['EXUEFHealthBoost14'] then
                BuffBlueprint {
                    Name = 'EXUEFHealthBoost14',
                    DisplayName = 'EXUEFHealthBoost14',
                    BuffType = 'EXUEFHealthBoost14',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'EXUEFHealthBoost14')
            local wepZephyr = self:GetWeaponByLabel('RightZephyr')
            wepZephyr:ChangeMaxRadius(40)
            self.wcGatling01 = false
            self.wcGatling02 = true
            self.wcGatling03 = false
            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)
            self:ForkThread(self.EXRegenBuffThread)
            self:ForkThread(self.DefaultGunBuffThread)
        elseif enh =='EXImprovedCoolingSystemRemove' then
            if Buff.HasBuff(self, 'EXUEFHealthBoost13') then
                Buff.RemoveBuff(self, 'EXUEFHealthBoost13')
            end
            if Buff.HasBuff(self, 'EXUEFHealthBoost14') then
                Buff.RemoveBuff(self, 'EXUEFHealthBoost14')
            end
            local wepZephyr = self:GetWeaponByLabel('RightZephyr')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[1].MaxRadius
            wepZephyr:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            self.wcGatling01 = false
            self.wcGatling02 = false
            self.wcGatling03 = false
            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='EXEnergyShellHardener' then
            if not Buffs['EXUEFHealthBoost15'] then
                BuffBlueprint {
                    Name = 'EXUEFHealthBoost15',
                    DisplayName = 'EXUEFHealthBoost15',
                    BuffType = 'EXUEFHealthBoost15',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'EXUEFHealthBoost15')
            local wepZephyr = self:GetWeaponByLabel('RightZephyr')
            wepZephyr:ChangeMaxRadius(45)
            self.wcGatling01 = false
            self.wcGatling02 = false
            self.wcGatling03 = true
            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='EXEnergyShellHardenerRemove' then
            if Buff.HasBuff(self, 'EXUEFHealthBoost13') then
                Buff.RemoveBuff(self, 'EXUEFHealthBoost13')
            end
            if Buff.HasBuff(self, 'EXUEFHealthBoost14') then
                Buff.RemoveBuff(self, 'EXUEFHealthBoost14')
            end
            if Buff.HasBuff(self, 'EXUEFHealthBoost15') then
                Buff.RemoveBuff(self, 'EXUEFHealthBoost15')
            end
            local wepZephyr = self:GetWeaponByLabel('RightZephyr')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[1].MaxRadius
            wepZephyr:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            self.wcGatling01 = false
            self.wcGatling02 = false
            self.wcGatling03 = false
            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'EXShieldBattery' then
            self:AddToggleCap('RULEUTC_ShieldToggle')
            self:CreateShield(bp)
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            self.Rotator1:SetTargetSpeed(90)
            self.Rotator2:SetTargetSpeed(-180)
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'EXShieldBatteryRemove' then
            self:DestroyShield()
            RemoveUnitEnhancement(self, 'EXShieldBatteryRemove')
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
            if self.ShieldEffectsBag2 then
                for k, v in self.ShieldEffectsBag2 do
                    v:Destroy()
                end
                self.ShieldEffectsBag2 = {}
            end
            self.Rotator1:SetTargetSpeed(0)
            self.Rotator2:SetTargetSpeed(0)
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'EXActiveShielding' then
            self:DestroyShield()
            ForkThread(function()
                WaitTicks(1)
                self:CreateShield(bp)
            end)
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            self.wcLance01 = true
            self.wcLance02 = false
            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'EXActiveShieldingRemove' then
            self:DestroyShield()
            RemoveUnitEnhancement(self, 'EXActiveShieldingRemove')
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
            if self.ShieldEffectsBag2 then
                for k, v in self.ShieldEffectsBag2 do
                    v:Destroy()
                end
                self.ShieldEffectsBag2 = {}
            end
            self.Rotator1:SetTargetSpeed(0)
            self.Rotator2:SetTargetSpeed(0)
            self.wcLance01 = false
            self.wcLance02 = false
            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'EXImprovedShieldBattery' then
            self:DestroyShield()
            ForkThread(function()
                WaitTicks(1)
                self:CreateShield(bp)
            end)
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'EXImprovedShieldBatteryRemove' then
            self:DestroyShield()
            RemoveUnitEnhancement(self, 'EXImprovedShieldBatteryRemove')
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
            if self.ShieldEffectsBag2 then
                for k, v in self.ShieldEffectsBag2 do
                    v:Destroy()
                end
                self.ShieldEffectsBag2 = {}
            end
            self.Rotator1:SetTargetSpeed(0)
            self.Rotator2:SetTargetSpeed(0)
            self.wcLance01 = false
            self.wcLance02 = false
            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'EXShieldExpander' then
            self:DestroyShield()
            ForkThread(function()
                WaitTicks(1)
                self:CreateShield(bp)
            end)
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'EXShieldExpanderRemove' then
            self:DestroyShield()
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
            if self.ShieldEffectsBag2 then
                for k, v in self.ShieldEffectsBag2 do
                    v:Destroy()
                end
                self.ShieldEffectsBag2 = {}
            end
            self.Rotator1:SetTargetSpeed(0)
            self.Rotator2:SetTargetSpeed(0)
            self.wcLance01 = false
            self.wcLance02 = false
            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'EXElectronicsEnhancment' then
            self:SetIntelRadius('Vision', bp.NewVisionRadius or 50)
            self:SetIntelRadius('Omni', bp.NewOmniRadius or 50)
            self.RadarDish1:SetTargetSpeed(45)
            if not Buffs['EXUEFHealthBoost16'] then
                BuffBlueprint {
                    Name = 'EXUEFHealthBoost16',
                    DisplayName = 'EXUEFHealthBoost16',
                    BuffType = 'EXUEFHealthBoost16',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'EXUEFHealthBoost16')
            self.wcLance01 = true
            self.wcLance02 = false
            self.RBIntTier1 = true
            self.RBIntTier2 = false
            self.RBIntTier3 = false
            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'EXElectronicsEnhancmentRemove' then
            local bpIntel = self:GetBlueprint().Intel
            self:SetIntelRadius('Vision', bpIntel.VisionRadius or 26)
            self:SetIntelRadius('Omni', bpIntel.OmniRadius or 26)
            self.RadarDish1:SetTargetSpeed(0)
            if Buff.HasBuff(self, 'EXUEFHealthBoost16') then
                Buff.RemoveBuff(self, 'EXUEFHealthBoost16')
            end
            self.wcLance01 = false
            self.wcLance02 = false
            self.RBIntTier1 = false
            self.RBIntTier2 = false
            self.RBIntTier3 = false
            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'EXElectronicCountermeasures' then
            self.SpysatEnabled = true
            self:ForkThread(self.EXSatSpawn)
            if self.IntelEffectsBag then
                EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
                self.IntelEffectsBag = nil
            end
            self.CloakEnh = false        
            self.StealthEnh = true
            if not Buffs['EXUEFHealthBoost17'] then
                BuffBlueprint {
                    Name = 'EXUEFHealthBoost17',
                    DisplayName = 'EXUEFHealthBoost17',
                    BuffType = 'EXUEFHealthBoost17',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'EXUEFHealthBoost17')
            self.wcLance01 = true
            self.wcLance02 = true
            self.RBIntTier1 = true
            self.RBIntTier2 = true
            self.RBIntTier3 = false
            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'EXElectronicCountermeasuresRemove' then
            self.SpysatEnabled = false
            if self.Satellite and not self.Satellite:IsDead() and not self.Satellite.IsDying then
                self.Satellite:Kill()
            end
            self.Satellite = nil
            self.StealthEnh = false
            self.CloakEnh = false 
            self.StealthFieldEffects = false
            self.CloakingEffects = false     
            local bpIntel = self:GetBlueprint().Intel
            self:SetIntelRadius('Vision', bpIntel.VisionRadius or 26)
            self:SetIntelRadius('Omni', bpIntel.OmniRadius or 26)
            self.RadarDish1:SetTargetSpeed(0)
            if Buff.HasBuff(self, 'EXUEFHealthBoost16') then
                Buff.RemoveBuff(self, 'EXUEFHealthBoost16')
            end
            if Buff.HasBuff(self, 'EXUEFHealthBoost17') then
                Buff.RemoveBuff(self, 'EXUEFHealthBoost17')
            end
            self.wcLance01 = false
            self.wcLance02 = false
            self.RBIntTier1 = false
            self.RBIntTier2 = false
            self.RBIntTier3 = false
            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'EXCloakingSubsystems' then
            self:AddCommandCap('RULEUCC_Teleport')
            if not Buffs['EXUEFHealthBoost18'] then
                BuffBlueprint {
                    Name = 'EXUEFHealthBoost18',
                    DisplayName = 'EXUEFHealthBoost18',
                    BuffType = 'EXUEFHealthBoost18',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'EXUEFHealthBoost18')
            self.RBIntTier1 = true
            self.RBIntTier2 = true
            self.RBIntTier3 = true
            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'EXCloakingSubsystemsRemove' then
            self.SpysatEnabled = false
            if self.Satellite and not self.Satellite:IsDead() and not self.Satellite.IsDying then
                self.Satellite:Kill()
            end
            self.Satellite = nil
            self.StealthEnh = false
            self.CloakEnh = false 
            self.StealthFieldEffects = false
            self.CloakingEffects = false     
            self:RemoveCommandCap('RULEUCC_Teleport')
            local bpIntel = self:GetBlueprint().Intel
            self:SetIntelRadius('Vision', bpIntel.VisionRadius or 26)
            self:SetIntelRadius('Omni', bpIntel.OmniRadius or 26)
            self.RadarDish1:SetTargetSpeed(0)
            if Buff.HasBuff(self, 'EXUEFHealthBoost16') then
                Buff.RemoveBuff(self, 'EXUEFHealthBoost16')
            end
            if Buff.HasBuff(self, 'EXUEFHealthBoost17') then
                Buff.RemoveBuff(self, 'EXUEFHealthBoost17')
            end
            if Buff.HasBuff(self, 'EXUEFHealthBoost18') then
                Buff.RemoveBuff(self, 'EXUEFHealthBoost18')
            end
            self.wcLance01 = false
            self.wcLance02 = false
            self.RBIntTier1 = false
            self.RBIntTier2 = false
            self.RBIntTier3 = false
            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='EXClusterMisslePack' then
            if not Buffs['EXUEFHealthBoost19'] then
                BuffBlueprint {
                    Name = 'EXUEFHealthBoost19',
                    DisplayName = 'EXUEFHealthBoost19',
                    BuffType = 'EXUEFHealthBoost19',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'EXUEFHealthBoost19')
            self.wcCMissiles01 = true
            self.wcCMissiles02 = false
            self.wcCMissiles03 = false
            self.wcTMissiles01 = false
            self.wcNMissiles01 = false
            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)
            self.RBComTier1 = true
            self.RBComTier2 = false
            self.RBComTier3 = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='EXClusterMisslePackRemove' then
            if Buff.HasBuff(self, 'EXUEFHealthBoost19') then
                Buff.RemoveBuff(self, 'EXUEFHealthBoost19')
            end
            self.wcCMissiles01 = false
            self.wcCMissiles02 = false
            self.wcCMissiles03 = false
            self.wcTMissiles01 = false
            self.wcNMissiles01 = false
            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)
            self:StopSiloBuild()
            self.RBComTier1 = false
            self.RBComTier2 = false
            self.RBComTier3 = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='EXTacticalMisslePack' then
            self:AddCommandCap('RULEUCC_Tactical')
            self:AddCommandCap('RULEUCC_SiloBuildTactical')
            if not Buffs['EXUEFHealthBoost20'] then
                BuffBlueprint {
                    Name = 'EXUEFHealthBoost20',
                    DisplayName = 'EXUEFHealthBoost20',
                    BuffType = 'EXUEFHealthBoost20',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'EXUEFHealthBoost20')
            self.wcCMissiles01 = false
            self.wcCMissiles02 = true
            self.wcCMissiles03 = false
            self.wcTMissiles01 = true
            self.wcNMissiles01 = false
            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)     
            self.RBComTier1 = true
            self.RBComTier2 = true
            self.RBComTier3 = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='EXTacticalNukeSubstitution' then
            self:RemoveCommandCap('RULEUCC_Tactical')
            self:RemoveCommandCap('RULEUCC_SiloBuildTactical')
            self:AddCommandCap('RULEUCC_Nuke')
            self:AddCommandCap('RULEUCC_SiloBuildNuke')
            local amt = self:GetTacticalSiloAmmoCount()
            self:RemoveTacticalSiloAmmo(amt or 0)
            self:StopSiloBuild()
            if not Buffs['EXUEFHealthBoost21'] then
                BuffBlueprint {
                    Name = 'EXUEFHealthBoost21',
                    DisplayName = 'EXUEFHealthBoost21',
                    BuffType = 'EXUEFHealthBoost21',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'EXUEFHealthBoost21')
            self.wcCMissiles01 = false
            self.wcCMissiles02 = false
            self.wcCMissiles03 = true
            self.wcTMissiles01 = false
            self.wcNMissiles01 = true
            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)    
            self.RBComTier1 = true
            self.RBComTier2 = true
            self.RBComTier3 = true
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'EXTacticalMisslePackRemove' then
            self:RemoveCommandCap('RULEUCC_Nuke')
            self:RemoveCommandCap('RULEUCC_SiloBuildNuke')
            self:RemoveCommandCap('RULEUCC_Tactical')
            self:RemoveCommandCap('RULEUCC_SiloBuildTactical')
            local amt = self:GetTacticalSiloAmmoCount()
            self:RemoveTacticalSiloAmmo(amt or 0)
            local amt = self:GetNukeSiloAmmoCount()
            self:RemoveNukeSiloAmmo(amt or 0)
            self:StopSiloBuild()
            if Buff.HasBuff(self, 'EXUEFHealthBoost19') then
                Buff.RemoveBuff(self, 'EXUEFHealthBoost19')
            end
            if Buff.HasBuff(self, 'EXUEFHealthBoost20') then
                Buff.RemoveBuff(self, 'EXUEFHealthBoost20')
            end
            if Buff.HasBuff(self, 'EXUEFHealthBoost21') then
                Buff.RemoveBuff(self, 'EXUEFHealthBoost21')
            end
            self.wcCMissiles01 = false
            self.wcCMissiles02 = false
            self.wcCMissiles03 = false
            self.wcTMissiles01 = false
            self.wcNMissiles01 = false
            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)
            self.RBComTier1 = false
            self.RBComTier2 = false
            self.RBComTier3 = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'EXTacticalNukeSubstitutionRemove' then
            self:RemoveCommandCap('RULEUCC_Nuke')
            self:RemoveCommandCap('RULEUCC_SiloBuildNuke')
            self:RemoveCommandCap('RULEUCC_Tactical')
            self:RemoveCommandCap('RULEUCC_SiloBuildTactical')
            local amt = self:GetTacticalSiloAmmoCount()
            self:RemoveTacticalSiloAmmo(amt or 0)
            local amt = self:GetNukeSiloAmmoCount()
            self:RemoveNukeSiloAmmo(amt or 0)
            self:StopSiloBuild()
            if Buff.HasBuff(self, 'EXUEFHealthBoost19') then
                Buff.RemoveBuff(self, 'EXUEFHealthBoost19')
            end
            if Buff.HasBuff(self, 'EXUEFHealthBoost20') then
                Buff.RemoveBuff(self, 'EXUEFHealthBoost20')
            end
            if Buff.HasBuff(self, 'EXUEFHealthBoost21') then
                Buff.RemoveBuff(self, 'EXUEFHealthBoost21')
            end
            self.wcCMissiles01 = false
            self.wcCMissiles02 = false
            self.wcCMissiles03 = false
            self.wcTMissiles01 = false
            self.wcNMissiles01 = false
            self:ForkThread(self.WeaponRangeReset)
            self:ForkThread(self.WeaponConfigCheck)
            self.RBComTier1 = false
            self.RBComTier2 = false
            self.RBComTier3 = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'LeftPod' or enh == 'RightPod' then
            TWalkingLandUnit.CreateEnhancement(self, enh) -- moved from top to here so this happens only once for each enhancement
            -- making sure we have up to date information (dont delete! needed for bug fix below)
            if not self.LeftPod or self.LeftPod:IsDead() then
                self.HasLeftPod = false
            end
            if not self.RightPod or self.RightPod:IsDead() then
                self.HasRightPod = false
            end
            -- fix for a bug that occurs when pod 1 is destroyed while upgrading to get pod 2
            if enh == 'RightPod' and (not self.HasLeftPod or not self.HasRightPod) then
                TWalkingLandUnit.CreateEnhancement(self, 'RightPodRemove')
                TWalkingLandUnit.CreateEnhancement(self, 'LeftPod')
            end
            -- add new pod to left or right
            if not self.HasLeftPod then
                local location = self:GetPosition('AttachSpecial02')
                local pod = CreateUnitHPR('UEA0001', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
                pod:SetCreator(self)
                pod:SetParent(self, 'LeftPod')
                self.Trash:Add(pod)
                self.LeftPod = pod
                self.HasLeftPod = true
            else
                local location = self:GetPosition('AttachSpecial01')
                local pod = CreateUnitHPR('UEA0001', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
                pod:SetCreator(self)
                pod:SetParent(self, 'RightPod')
                self.Trash:Add(pod)
                self.RightPod = pod
                self.HasRightPod = true
            end
            -- highlight correct icons: right if we have 2 pods, left if we have 1 pod (no other possibilities)
            if self.HasLeftPod and self.HasRightPod then
                TWalkingLandUnit.CreateEnhancement(self, 'RightPod')
            else
                TWalkingLandUnit.CreateEnhancement(self, 'LeftPod')
            end
        -- for removing the pod upgrades
        elseif enh == 'RightPodRemove' then
            TWalkingLandUnit.CreateEnhancement(self, enh) -- moved from top to here so this happens only once for each enhancement
            if self.RightPod and not self.RightPod:IsDead() then
                self.RightPod:Kill()
                self.HasRightPod = false
            end
            if self.LeftPod and not self.LeftPod:IsDead() then
                self.LeftPod:Kill()
                self.HasLeftPod = false
            end
        elseif enh == 'LeftPodRemove' then
            TWalkingLandUnit.CreateEnhancement(self, enh) -- moved from top to here so this happens only once for each enhancement
            if self.LeftPod and not self.LeftPod:IsDead() then
                self.LeftPod:Kill()
                self.HasLeftPod = false
            end
        end
    end,

    IntelEffects = {
        Cloak = {
            {
                Bones = {
                    'Head',
                    'Right_Arm_B01',
                    'Left_Arm_B01',
                    'Torso',
                    'Left_Leg_B01',
                    'Left_Leg_B02',
                    'Right_Leg_B01',
                    'Right_Leg_B02',
                },
                Scale = 1.0,
                Type = 'Cloak01',
            },
        },
        Field = {
            {
                Bones = {
                    'Head',
                    'Right_Arm_B01',
                    'Left_Arm_B01',
                    'Torso',
                    'Left_Leg_B01',
                    'Left_Leg_B02',
                    'Right_Leg_B01',
                    'Right_Leg_B02',
                },
                Scale = 1.6,
                Type = 'Cloak01',
            },    
        },    
        Jammer = {
            {
                Bones = {
                    'Torso',
                },
                Scale = 0.5,
                Type = 'Jammer01',
            },    
        },    
    },
    
    OnIntelEnabled = function(self)
        TWalkingLandUnit.OnIntelEnabled(self)
        if self.CloakEnh and self:IsIntelEnabled('Cloak') then 
            self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Enhancements['EXCloakingSubsystems'].MaintenanceConsumptionPerSecondEnergy or 1)
            self:SetMaintenanceConsumptionActive()
            if not self.IntelEffectsBag then
                self.IntelEffectsBag = {}
                self.CreateTerrainTypeEffects(self, self.IntelEffects.Cloak, 'FXIdle',  self:GetCurrentLayer(), nil, self.IntelEffectsBag)
            end            
        elseif self.StealthEnh and self:IsIntelEnabled('RadarStealth') and self:IsIntelEnabled('SonarStealth') then
            self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Enhancements['EXElectronicCountermeasures'].MaintenanceConsumptionPerSecondEnergy or 1)
            self:SetMaintenanceConsumptionActive()  
            if not self.IntelEffectsBag then 
                self.IntelEffectsBag = {}
                self.CreateTerrainTypeEffects(self, self.IntelEffects.Field, 'FXIdle',  self:GetCurrentLayer(), nil, self.IntelEffectsBag)
            end                  
        end        
    end,

    OnIntelDisabled = function(self)
        TWalkingLandUnit.OnIntelDisabled(self)
        if self.IntelEffectsBag then
            EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
            self.IntelEffectsBag = nil
        end
        if self.CloakEnh and not self:IsIntelEnabled('Cloak') then
            self:SetMaintenanceConsumptionInactive()
        elseif self.StealthEnh and not self:IsIntelEnabled('RadarStealth') and not self:IsIntelEnabled('SonarStealth') then
            self:SetMaintenanceConsumptionInactive()
        end         

    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        if self.Satellite and not self.Satellite:IsDead() and not self.Satellite.IsDying then
            self.Satellite:Kill()
            self.Satellite = nil
        end
        TWalkingLandUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
    
    OnDestroy = function(self)
        if self.Satellite and not self.Satellite:IsDead() and not self.Satellite.IsDying then
            self.Satellite:Destroy()
            self.Satellite = nil
        end
        TWalkingLandUnit.OnDestroy(self)
    end,

    OnPaused = function(self)
        TWalkingLandUnit.OnPaused(self)
        if self.BuildingUnit then
            TWalkingLandUnit.StopBuildingEffects(self, self.UnitBeingBuilt)
        end
    end,
    
    OnUnpaused = function(self)
        if self.BuildingUnit then
            TWalkingLandUnit.StartBuildingEffects(self, self.UnitBeingBuilt, self.UnitBuildOrder)
        end
        TWalkingLandUnit.OnUnpaused(self)
    end,      

    ShieldEffects2 = {
        '/mods/BlackOpsACUs/effects/emitters/ex_uef_shieldgen_01_emit.bp',
    },

    FlamerEffects = {
        '/mods/BlackOpsACUs/effects/emitters/ex_flamer_torch_01.bp',
    },

}

TypeClass = EEL0001