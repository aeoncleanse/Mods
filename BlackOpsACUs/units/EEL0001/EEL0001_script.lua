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
        GatlingEnergyCannon = Class(UEFACUHeavyPlasmaGatlingCannonWeapon) {
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
        EnergyLance01 = Class(PDLaserGrid) {
            PlayOnlyOneSoundCue = true,
        }, 
        EnergyLance02 = Class(PDLaserGrid) {
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
        self:SetWeaponEnabledByLabel('GatlingEnergyCannon', false)
        self:SetWeaponEnabledByLabel('EXClusterMissles01', false)
        self:SetWeaponEnabledByLabel('EXClusterMissles02', false)
        self:SetWeaponEnabledByLabel('EXClusterMissles03', false)
        self:SetWeaponEnabledByLabel('EnergyLance01', false)
        self:SetWeaponEnabledByLabel('EnergyLance02', false)
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
    
    RebuildPod = function(self, PodNumber)
        if PodNumber == 1 then
            -- Force pod rebuilds to queue up
            if self.RebuildingPod2 ~= nil then
                WaitFor(self.RebuildingPod2)
            end
            if self.HasLeftPod == true then
                self.RebuildingPod = CreateEconomyEvent(self, 1600, 160, 10, self.SetWorkProgress)
                self:RequestRefreshUI()
                WaitFor(self.RebuildingPod)
                self:SetWorkProgress(0.0)
                self.RebuildingPod = nil
                local location = self:GetPosition('AttachSpecial02')
                local pod = CreateUnitHPR('UEA0001', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
                pod:SetParent(self, 'LeftPod')
                pod:SetCreator(self)
                self.Trash:Add(pod)
                self.LeftPod = pod
            end
        elseif PodNumber == 2 then
            -- Force pod rebuilds to queue up
            if self.RebuildingPod ~= nil then
                WaitFor(self.RebuildingPod)
            end
            if self.HasRightPod == true then
                self.RebuildingPod2 = CreateEconomyEvent(self, 1600, 160, 10, self.SetWorkProgress)
                self:RequestRefreshUI()
                WaitFor(self.RebuildingPod2)
                self:SetWorkProgress(0.0)
                self.RebuildingPod2 = nil
                local location = self:GetPosition('AttachSpecial01')
                local pod = CreateUnitHPR('UEA0001', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
                pod:SetParent(self, 'RightPod')
                pod:SetCreator(self)
                self.Trash:Add(pod)
                self.RightPod = pod
            end
        end
        self:RequestRefreshUI()
    end,
    
    NotifyOfPodDeath = function(self, pod, rebuildDrone)
        if rebuildDrone == true then
            if pod == 'LeftPod' then
                if self.HasLeftPod == true then
                    self.RebuildThread = self:ForkThread(self.RebuildPod, 1)
                end
            elseif pod == 'RightPod' then
                if self.HasRightPod == true then
                    self.RebuildThread2 = self:ForkThread(self.RebuildPod, 2)
                end
            elseif pod == 'SpySat' and self.SpysatEnabled then 
                self.Satellite = nil
                self:ForkThread(self.SatSpawn, true)
            end
        else
            self:CreateEnhancement(pod..'Remove')
        end
    end,

    SatSpawn = function(self, respawn)
        if respawn then
            WaitSeconds(300)
        end
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
            
        elseif enh == 'GatlingEnergyCannon' then
            if not Buffs['UEFGatlingHeath1'] then
                BuffBlueprint {
                    Name = 'UEFGatlingHeath1',
                    DisplayName = 'UEFGatlingHeath1',
                    BuffType = 'UEFGatlingHeath',
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
            Buff.ApplyBuff(self, 'UEFGatlingHeath1')
            
            self:SetWeaponEnabledByLabel('GatlingEnergyCannon', true)
        elseif enh == 'GatlingEnergyCannonRemove' then
            if Buff.HasBuff(self, 'UEFGatlingHeath1') then
                Buff.RemoveBuff(self, 'UEFGatlingHeath1')
            end
            
            self:SetWeaponEnabledByLabel('GatlingEnergyCannon', false)
        elseif enh == 'ImprovedCoolingSystem' then
            if not Buffs['UEFGatlingHeath2'] then
                BuffBlueprint {
                    Name = 'UEFGatlingHeath2',
                    DisplayName = 'UEFGatlingHeath2',
                    BuffType = 'UEFGatlingHeath',
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
            Buff.ApplyBuff(self, 'UEFGatlingHeath2')
            
            local gun = self:GetWeaponByLabel('GatlingEnergyCannon')
            gun:AddDamageMod(bp.GatlingDamageMod)
            gun:ChangeMaxRadius(bp.GatlingMaxRadius)
            
            self:TogglePrimaryGun(bp.DamageMod, bp.NewMaxRadius)
        elseif enh == 'ImprovedCoolingSystemRemove' then
            if Buff.HasBuff(self, 'UEFGatlingHeath2') then
                Buff.RemoveBuff(self, 'UEFGatlingHeath2')
            end
            
            local gun = self:GetWeaponByLabel('GatlingEnergyCannon')
            gun:AddDamageMod(bp.GatlingDamageMod)
            gun:ChangeMaxRadius(gun:GetBlueprint().MaxRadius)
            
            self:TogglePrimaryGun(bp.DamageMod)
        elseif enh == 'EnergyShellHardener' then
            if not Buffs['UEFGatlingHeath3'] then
                BuffBlueprint {
                    Name = 'UEFGatlingHeath3',
                    DisplayName = 'UEFGatlingHeath3',
                    BuffType = 'UEFGatlingHeath',
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
            Buff.ApplyBuff(self, 'UEFGatlingHeath3')
            
            local gun = self:GetWeaponByLabel('GatlingEnergyCannon')
            gun:AddDamageMod(bp.GatlingDamageMod)
            gun:ChangeMaxRadius(bp.GatlingMaxRadius)
        elseif enh == 'EnergyShellHardenerRemove' then
            if Buff.HasBuff(self, 'UEFGatlingHeath3') then
                Buff.RemoveBuff(self, 'UEFGatlingHeath3')
            end
            
            local gun = self:GetWeaponByLabel('GatlingEnergyCannon')
            gun:AddDamageMod(bp.GatlingDamageMod)
            gun:ChangeMaxRadius(bp.GatlingMaxRadius)
            
        -- Shielding

        elseif enh == 'ShieldBattery' then
            self:AddToggleCap('RULEUTC_ShieldToggle')
            self:CreateShield(bp)
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            self:OnScriptBitSet(0)
        elseif enh == 'ShieldBatteryRemove' then
            self:DestroyShield()
            RemoveUnitEnhancement(self, 'ShieldBatteryRemove')
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
            self:OnScriptBitClear(0)
        elseif enh == 'ActiveShielding' then
            self:DestroyShield()
            ForkThread(function()
                WaitTicks(1)
                self:CreateShield(bp)
            end)
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            self:OnScriptBitSet(0)
        elseif enh == 'ActiveShieldingRemove' then
            self:DestroyShield()
            RemoveUnitEnhancement(self, 'ActiveShieldingRemove')
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
            self:OnScriptBitClear(0)
        elseif enh == 'EXImprovedShieldBattery' then
            self:DestroyShield()
            ForkThread(function()
                WaitTicks(1)
                self:CreateShield(bp)
            end)
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            self:OnScriptBitSet(0)
        elseif enh == 'ImprovedShieldBatteryRemove' then
            self:DestroyShield()
            RemoveUnitEnhancement(self, 'ImprovedShieldBatteryRemove')
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
            self:OnScriptBitClear(0)
        elseif enh == 'ShieldExpander' then
            self:DestroyShield()
            ForkThread(function()
                WaitTicks(1)
                self:CreateShield(bp)
            end)
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            self:OnScriptBitSet(0)
        elseif enh == 'ShieldExpanderRemove' then
            self:DestroyShield()
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
            self:OnScriptBitClear(0)
            
        -- Jamming
            
        elseif enh == 'ElectronicsEnhancment' then
            if not Buffs['UEFJammingHealth1'] then
                BuffBlueprint {
                    Name = 'UEFJammingHealth1',
                    DisplayName = 'UEFJammingHealth1',
                    BuffType = 'UEFJammingHealth',
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
            Buff.ApplyBuff(self, 'UEFJammingHealth1')
            
            self:SetIntelRadius('Vision', bp.NewVisionRadius)
            self:SetIntelRadius('Omni', bp.NewOmniRadius)
            self.RadarDish1:SetTargetSpeed(45)

            self:SetWeaponEnabledByLabel('EnergyLance01', true)
        elseif enh == 'ElectronicsEnhancmentRemove' then
            if Buff.HasBuff(self, 'UEFJammingHealth1') then
                Buff.RemoveBuff(self, 'UEFJammingHealth1')
            end
        
            local bpIntel = self:GetBlueprint().Intel
            self:SetIntelRadius('Vision', bpIntel.VisionRadius)
            self:SetIntelRadius('Omni', bpIntel.OmniRadius)
            self.RadarDish1:SetTargetSpeed(0)

            self:SetWeaponEnabledByLabel('EnergyLance01', false)
        elseif enh == 'SpySatellite' then
            if not Buffs['UEFJammingHealth2'] then
                BuffBlueprint {
                    Name = 'UEFJammingHealth2',
                    DisplayName = 'UEFJammingHealth2',
                    BuffType = 'UEFJammingHealth',
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
            Buff.ApplyBuff(self, 'UEFJammingHealth2')
            
            self.SpysatEnabled = true
            self:ForkThread(self.SatSpawn)
            
            self:SetWeaponEnabledByLabel('EnergyLance02', true)
        elseif enh == 'SpySatelliteRemove' then
            if Buff.HasBuff(self, 'UEFJammingHealth2') then
                Buff.RemoveBuff(self, 'UEFJammingHealth2')
            end
            
            if self.Satellite and not self.Satellite:IsDead() and not self.Satellite.IsDying then
                self.Satellite:Kill()
            end
            self.SpysatEnabled = false
            self.Satellite = nil
            
            self:SetWeaponEnabledByLabel('EnergyLance02', false)
        elseif enh == 'Teleporter' then
            if not Buffs['UEFJammingHealth3'] then
                BuffBlueprint {
                    Name = 'UEFJammingHealth3',
                    DisplayName = 'UEFJammingHealth3',
                    BuffType = 'UEFJammingHealth',
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
            Buff.ApplyBuff(self, 'UEFJammingHealth3')
            
            self:AddCommandCap('RULEUCC_Teleport')
        elseif enh == 'TeleporterRemove' then
            if Buff.HasBuff(self, 'UEFJammingHealth3') then
                Buff.RemoveBuff(self, 'UEFJammingHealth3')
            end
            
            self:RemoveCommandCap('RULEUCC_Teleport')
            
        -- Missile System
        
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


            self.RBComTier1 = true
            self.RBComTier2 = false
            self.RBComTier3 = false

        elseif enh =='EXClusterMisslePackRemove' then
            if Buff.HasBuff(self, 'EXUEFHealthBoost19') then
                Buff.RemoveBuff(self, 'EXUEFHealthBoost19')
            end
            self.wcCMissiles01 = false
            self.wcCMissiles02 = false
            self.wcCMissiles03 = false
            self.wcTMissiles01 = false
            self.wcNMissiles01 = false


            self:StopSiloBuild()
            self.RBComTier1 = false
            self.RBComTier2 = false
            self.RBComTier3 = false

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

     
            self.RBComTier1 = true
            self.RBComTier2 = true
            self.RBComTier3 = false

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

    
            self.RBComTier1 = true
            self.RBComTier2 = true
            self.RBComTier3 = true

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


            self.RBComTier1 = false
            self.RBComTier2 = false
            self.RBComTier3 = false

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


            self.RBComTier1 = false
            self.RBComTier2 = false
            self.RBComTier3 = false

        -- Pod Subsystems
            
        elseif enh == 'LeftPod' then
            local location = self:GetPosition('AttachSpecial02')
            local pod = CreateUnitHPR('UEA0001', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
            pod:SetParent(self, 'LeftPod')
            pod:SetCreator(self)
            self.Trash:Add(pod)
            self.HasLeftPod = true
            self.LeftPod = pod
        elseif enh == 'RightPod' then
            local location = self:GetPosition('AttachSpecial01')
            local pod = CreateUnitHPR('UEA0001', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
            pod:SetParent(self, 'RightPod')
            pod:SetCreator(self)
            self.Trash:Add(pod)
            self.HasRightPod = true
            self.RightPod = pod
        elseif enh == 'LeftPodRemove' or enh == 'RightPodRemove' then
            if self.HasLeftPod == true then
                self.HasLeftPod = false
                if self.LeftPod and not self.LeftPod.Dead then
                    self.LeftPod:Kill()
                    self.LeftPod = nil
                end
                if self.RebuildingPod ~= nil then
                    RemoveEconomyEvent(self, self.RebuildingPod)
                    self.RebuildingPod = nil
                end
            end
            if self.HasRightPod == true then
                self.HasRightPod = false
                if self.RightPod and not self.RightPod.Dead then
                    self.RightPod:Kill()
                    self.RightPod = nil
                end
                if self.RebuildingPod2 ~= nil then
                    RemoveEconomyEvent(self, self.RebuildingPod2)
                    self.RebuildingPod2 = nil
                end
            end
            KillThread(self.RebuildThread)
            KillThread(self.RebuildThread2)
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