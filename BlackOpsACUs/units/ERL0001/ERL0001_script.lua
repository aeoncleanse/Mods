-----------------------------------------------------------------

-- Author(s):  Exavier Macbeth

-- Summary  :  BlackOps: Adv Command Unit - Cybran ACU

-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------
local CWalkingLandUnit = import('/lua/cybranunits.lua').CWalkingLandUnit
local CWeapons = import('/lua/cybranweapons.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')
local Buff = import('/lua/sim/Buff.lua')

--local CAAMissileNaniteWeapon = CWeapons.CAAMissileNaniteWeapon
local CCannonMolecularWeapon = CWeapons.CCannonMolecularWeapon
local DeathNukeWeapon = import('/lua/sim/defaultweapons.lua').DeathNukeWeapon

local EffectTemplate = import('/lua/EffectTemplates.lua')
local CDFHeavyMicrowaveLaserGeneratorCom = CWeapons.CDFHeavyMicrowaveLaserGeneratorCom
local CDFOverchargeWeapon = CWeapons.CDFOverchargeWeapon
local CANTorpedoLauncherWeapon = CWeapons.CANTorpedoLauncherWeapon
local Entity = import('/lua/sim/Entity.lua').Entity
local CEMPArrayBeam01 = import('/mods/BlackOpsACUs/lua/BlackOpsweapons.lua').CEMPArrayBeam01 
local CEMPArrayBeam02 = import('/mods/BlackOpsACUs/lua/BlackOpsweapons.lua').CEMPArrayBeam02 
local CEMPArrayBeam03 = import('/mods/BlackOpsACUs/lua/BlackOpsweapons.lua').CEMPArrayBeam03 
local RocketPack = CWeapons.CDFRocketIridiumWeapon02

ERL0001 = Class(CWalkingLandUnit) {
    DeathThreadDestructionWaitTime = 2,

    Weapons = {
        DeathWeapon = Class(DeathNukeWeapon) {},
        RightRipper = Class(CCannonMolecularWeapon) {
            OnCreate = function(self)
                CCannonMolecularWeapon.OnCreate(self)
                -- Disable buff 
                self:DisableBuff('STUN')
            end,
        },
        RocketPack01 = Class(RocketPack) {},
        RocketPack02 = Class(RocketPack) {},
        TorpedoLauncher01 = Class(CANTorpedoLauncherWeapon) {},
        TorpedoLauncher02 = Class(CANTorpedoLauncherWeapon) {},
        TorpedoLauncher03 = Class(CANTorpedoLauncherWeapon) {},
        EMPArray01 = Class(CEMPArrayBeam01) {
            OnWeaponFired = function(self)
                CEMPArrayBeam01.OnWeaponFired(self)
                local wep = self.unit:GetWeaponByLabel('EMPArray02')
                local wep2 = self.unit:GetWeaponByLabel('EMPArray03')
                local wep3 = self.unit:GetWeaponByLabel('EMPArray04')
                local wep5 = self.unit:GetWeaponByLabel('EMPShot01')
                local wep6 = self.unit:GetWeaponByLabel('EMPShot02')
                local wep7 = self.unit:GetWeaponByLabel('EMPShot03')
                self.targetaquired = self:GetCurrentTargetPos()
                if self.targetaquired then
                    if self.unit.EMPArrayEffects01 then
                        for k, v in self.unit.EMPArrayEffects01 do
                            v:Destroy()
                        end
                        self.unit.EMPArrayEffects01 = {}
                    end
                    table.insert(self.unit.EMPArrayEffects01, AttachBeamEntityToEntity(self.unit, 'EMP_Array_Beam_01', self.unit, 'EMP_Array_Muzzle_01', self.unit:GetArmy(), '/mods/BlackOpsACUs/effects/emitters/excemparraybeam02_emit.bp'))
                    table.insert(self.unit.EMPArrayEffects01, AttachBeamEntityToEntity(self.unit, 'EMP_Array_Beam_02', self.unit, 'EMP_Array_Muzzle_02', self.unit:GetArmy(), '/mods/BlackOpsACUs/effects/emitters/excemparraybeam02_emit.bp'))
                    table.insert(self.unit.EMPArrayEffects01, AttachBeamEntityToEntity(self.unit, 'EMP_Array_Beam_03', self.unit, 'EMP_Array_Muzzle_03', self.unit:GetArmy(), '/mods/BlackOpsACUs/effects/emitters/excemparraybeam02_emit.bp'))
                    table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Beam_01', self.unit:GetArmy(), '/effects/emitters/microwave_laser_flash_01_emit.bp'):ScaleEmitter(0.05))
                    table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Beam_01', self.unit:GetArmy(), '/effects/emitters/microwave_laser_muzzle_01_emit.bp'):ScaleEmitter(0.05))
                    table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Beam_02', self.unit:GetArmy(), '/effects/emitters/microwave_laser_flash_01_emit.bp'):ScaleEmitter(0.05))
                    table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Beam_02', self.unit:GetArmy(), '/effects/emitters/microwave_laser_muzzle_01_emit.bp'):ScaleEmitter(0.05))
                    table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Beam_03', self.unit:GetArmy(), '/effects/emitters/microwave_laser_flash_01_emit.bp'):ScaleEmitter(0.05))
                    table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Beam_03', self.unit:GetArmy(), '/effects/emitters/microwave_laser_muzzle_01_emit.bp'):ScaleEmitter(0.05))
                    table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Muzzle_01', self.unit:GetArmy(), '/effects/emitters/microwave_laser_end_01_emit.bp'):ScaleEmitter(0.05))
                    table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Muzzle_01', self.unit:GetArmy(), '/effects/emitters/microwave_laser_end_02_emit.bp'):ScaleEmitter(0.05))
                    table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Muzzle_01', self.unit:GetArmy(), '/effects/emitters/microwave_laser_end_03_emit.bp'):ScaleEmitter(0.05))
                    table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Muzzle_01', self.unit:GetArmy(), '/effects/emitters/microwave_laser_end_04_emit.bp'):ScaleEmitter(0.05))
                    table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Muzzle_01', self.unit:GetArmy(), '/effects/emitters/microwave_laser_end_05_emit.bp'):ScaleEmitter(0.05))
                    table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Muzzle_01', self.unit:GetArmy(), '/effects/emitters/microwave_laser_end_06_emit.bp'):ScaleEmitter(0.05))
                    table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Muzzle_02', self.unit:GetArmy(), '/effects/emitters/microwave_laser_end_01_emit.bp'):ScaleEmitter(0.05))
                    table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Muzzle_02', self.unit:GetArmy(), '/effects/emitters/microwave_laser_end_02_emit.bp'):ScaleEmitter(0.05))
                    table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Muzzle_02', self.unit:GetArmy(), '/effects/emitters/microwave_laser_end_03_emit.bp'):ScaleEmitter(0.05))
                    table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Muzzle_02', self.unit:GetArmy(), '/effects/emitters/microwave_laser_end_04_emit.bp'):ScaleEmitter(0.05))
                    table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Muzzle_02', self.unit:GetArmy(), '/effects/emitters/microwave_laser_end_05_emit.bp'):ScaleEmitter(0.05))
                    table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Muzzle_02', self.unit:GetArmy(), '/effects/emitters/microwave_laser_end_06_emit.bp'):ScaleEmitter(0.05))
                    table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Muzzle_03', self.unit:GetArmy(), '/effects/emitters/microwave_laser_end_01_emit.bp'):ScaleEmitter(0.05))
                    table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Muzzle_03', self.unit:GetArmy(), '/effects/emitters/microwave_laser_end_02_emit.bp'):ScaleEmitter(0.05))
                    table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Muzzle_03', self.unit:GetArmy(), '/effects/emitters/microwave_laser_end_03_emit.bp'):ScaleEmitter(0.05))
                    table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Muzzle_03', self.unit:GetArmy(), '/effects/emitters/microwave_laser_end_04_emit.bp'):ScaleEmitter(0.05))
                    table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Muzzle_03', self.unit:GetArmy(), '/effects/emitters/microwave_laser_end_05_emit.bp'):ScaleEmitter(0.05))
                    table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Muzzle_03', self.unit:GetArmy(), '/effects/emitters/microwave_laser_end_06_emit.bp'):ScaleEmitter(0.05))
                    self.unit:SetWeaponEnabledByLabel('EMPArray02', true)
                    self.unit:SetWeaponEnabledByLabel('EMPArray03', true)
                    self.unit:SetWeaponEnabledByLabel('EMPArray04', true)
                    wep:SetTargetGround(self.targetaquired)
                    wep2:SetTargetGround(self.targetaquired)
                    wep3:SetTargetGround(self.targetaquired)
                    wep:OnFire() 
                    wep2:OnFire() 
                    wep3:OnFire()
                    if self.unit.wcEMP01 then
                        self.unit:SetWeaponEnabledByLabel('EMPShot01', true)
                        wep5:SetTargetGround(self.targetaquired)
                        wep5:OnFire()
                    elseif self.unit.wcEMP02 then
                        self.unit:SetWeaponEnabledByLabel('EMPShot02', true)
                        wep6:SetTargetGround(self.targetaquired)
                        wep6:OnFire()
                    elseif self.unit.wcEMP03 then
                        self.unit:SetWeaponEnabledByLabel('EMPShot03', true)
                        wep7:SetTargetGround(self.targetaquired)
                        wep7:OnFire()
                    end
                    self:ForkThread(self.ArrayEffectsCleanup)
                end
            end,
            ArrayEffectsCleanup = function(self)
                WaitTicks(20)
                if self.unit.EMPArrayEffects01 then
                    for k, v in self.unit.EMPArrayEffects01 do
                        v:Destroy()
                    end
                    self.unit.EMPArrayEffects01 = {}
                end
            end,
        },
        EMPArray02 = Class(CEMPArrayBeam02) {
            OnWeaponFired = function(self)
                CEMPArrayBeam02.OnWeaponFired(self)
                    self:SetWeaponEnabled(false)
            end,
        },
        EMPArray03 = Class(CEMPArrayBeam02) {
            OnWeaponFired = function(self)
                CEMPArrayBeam02.OnWeaponFired(self)
                    self:SetWeaponEnabled(false)
            end,
        },
        EMPArray04 = Class(CEMPArrayBeam02) {
            OnWeaponFired = function(self)
                CEMPArrayBeam02.OnWeaponFired(self)
                    self:SetWeaponEnabled(false)
            end,
        },
        EMPShot01 = Class(CCannonMolecularWeapon) {
            OnWeaponFired = function(self)
                CEMPArrayBeam02.OnWeaponFired(self)
                    self:SetWeaponEnabled(false)
            end,
        },
        EMPShot02 = Class(CCannonMolecularWeapon) {
            OnWeaponFired = function(self)
                CEMPArrayBeam02.OnWeaponFired(self)
                    self:SetWeaponEnabled(false)
            end,
        },
        EMPShot03 = Class(CCannonMolecularWeapon) {
            OnWeaponFired = function(self)
                CEMPArrayBeam02.OnWeaponFired(self)
                    self:SetWeaponEnabled(false)
            end,
        },
        MLG01 = Class(CDFHeavyMicrowaveLaserGeneratorCom) {},
        MLG02 = Class(CDFHeavyMicrowaveLaserGeneratorCom) {},
        MLG03 = Class(CDFHeavyMicrowaveLaserGeneratorCom) {},
        AA01 = Class(CEMPArrayBeam02) {},
        AA02 = Class(CEMPArrayBeam02) {},
        AA03 = Class(CEMPArrayBeam02) {},
        AA04 = Class(CEMPArrayBeam02) {},

        OverCharge = Class(CDFOverchargeWeapon) {},
    },
    
    __init = function(self)
        ACUUnit.__init(self, 'RightRipper')
    end,

    OnCreate = function(self)
        CWalkingLandUnit.OnCreate(self)
        self:SetCapturable(false)
        if self:GetBlueprint().General.BuildBones then
            self:SetupBuildBones()
        end
        self:HideBone('Mobility_LLeg_B01', true)
        self:HideBone('Mobility_LLeg_B02', true)
        self:HideBone('Mobility_RLeg_B01', true)
        self:HideBone('Mobility_RLeg_B02', true)
        self:HideBone('Back_AA_B01', true)
        self:HideBone('Back_AA_B02R', true)
        self:HideBone('Back_AA_B02L', true)
        self:HideBone('Engineering', true)
        self:HideBone('Combat_Engineering', true)
        self:HideBone('Right_Upgrade', true)
        self:HideBone('EMP_Array', true)
        self:HideBone('EMP_Array_Cable', true)
        self:HideBone('Back_MobilityPack', true)
        self:HideBone('Back_CounterIntelPack', true)
        self:HideBone('Torpedo_Launcher', true)
        self:HideBone('Combat_B03_Head', true)
        self:HideBone('Combat_B01_LArm', true)
        self:HideBone('Combat_B01_RArm', true)
        self:HideBone('Combat_B02_LLeg', true)
        self:HideBone('Combat_B02_RLeg', true)
        self:HideBone('Back_CombatPack', true)
        self:HideBone('Chest_Open', true)
        -- Restrict what enhancements will enable later
        self:AddBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetWeaponEnabledByLabel('RightRipper', true)
        self:SetMaintenanceConsumptionInactive()
        self:DisableUnitIntel('RadarStealth')
        self:DisableUnitIntel('SonarStealth')
        self:DisableUnitIntel('Cloak')
        self:DisableUnitIntel('CloakField')
        self:DisableUnitIntel('Sonar')
        self.EMPArrayEffects01 = {}
        self.EMPArrayEffects02 = {}
        self.EMPArrayEffects03 = {}
        self:ForkThread(self.GiveInitialResources)
        
        -- Disable Upgrade Weapons
        self:SetWeaponEnabledByLabel('RightRipper', true)
        self:SetWeaponEnabledByLabel('RocketPack01', false)
        self:SetWeaponEnabledByLabel('RocketPack02', false)
        self:SetWeaponEnabledByLabel('TorpedoLauncher01', false)
        self:SetWeaponEnabledByLabel('TorpedoLauncher02', false)
        self:SetWeaponEnabledByLabel('TorpedoLauncher03', false)
        self:SetWeaponEnabledByLabel('EMPArray01', false)
        self:SetWeaponEnabledByLabel('EMPArray02', false)
        self:SetWeaponEnabledByLabel('EMPArray03', false)
        self:SetWeaponEnabledByLabel('EMPArray04', false)
        self:SetWeaponEnabledByLabel('EMPShot01', false)
        self:SetWeaponEnabledByLabel('EMPShot02', false)
        self:SetWeaponEnabledByLabel('EMPShot03', false)
        self:SetWeaponEnabledByLabel('MLG01', false)
        self:SetWeaponEnabledByLabel('MLG02', false)
        self:SetWeaponEnabledByLabel('MLG03', false)
        self:SetWeaponEnabledByLabel('AA01', false)
        self:SetWeaponEnabledByLabel('AA02', false)
        self:SetWeaponEnabledByLabel('AA03', false)
        
        
    end,

    OnStartBuild = function(self, unitBeingBuilt, order)    
        CWalkingLandUnit.OnStartBuild(self, unitBeingBuilt, order)
        self.UnitBuildOrder = order
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
        self:SetMesh('/mods/BlackOpsACUs/units/erl0001/ERL0001_PhaseShield_mesh', true)
        self:ShowBone(0, true)
        self:HideBone('Mobility_LLeg_B01', true)
        self:HideBone('Mobility_LLeg_B02', true)
        self:HideBone('Mobility_RLeg_B01', true)
        self:HideBone('Mobility_RLeg_B02', true)
        self:HideBone('Back_AA_B01', true)
        self:HideBone('Back_AA_B02R', true)
        self:HideBone('Back_AA_B02L', true)
        self:HideBone('Engineering', true)
        self:HideBone('Combat_Engineering', true)
        self:HideBone('Right_Upgrade', true)
        self:HideBone('EMP_Array', true)
        self:HideBone('EMP_Array_Cable', true)
        self:HideBone('Back_MobilityPack', true)
        self:HideBone('Back_CounterIntelPack', true)
        self:HideBone('Torpedo_Launcher', true)
        self:HideBone('Combat_B03_Head', true)
        self:HideBone('Combat_B01_LArm', true)
        self:HideBone('Combat_B01_RArm', true)
        self:HideBone('Combat_B02_LLeg', true)
        self:HideBone('Combat_B02_RLeg', true)
        self:HideBone('Back_CombatPack', true)
        self:HideBone('Chest_Open', true)
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

    -- New function to set up production numbers
    SetProduction = function(self, bp)
        local energy = bp.ProductionPerSecondEnergy or 0
        local mass = bp.ProductionPerSecondMass or 0
        
        local bpEcon = self:GetBlueprint().Economy
        
        self:SetProductionPerSecondEnergy(energy + bpEcon.ProductionPerSecondEnergy or 0)
        self:SetProductionPerSecondMass(mass + bpEcon.ProductionPerSecondMass or 0)
    end,
    
    -- Function to toggle the Ripper
    TogglePrimaryGun = function(self, damage, radius)
        local wep = self:GetWeaponByLabel('RightRipper')
        local oc = self:GetWeaponByLabel('OverCharge')
    
        local wepRadius = radius or wep:GetBlueprint().MaxRadius
        local ocRadius = radius or oc:GetBlueprint().MaxRadius

        -- Change Damage
        wep:AddDamageMod(damage)
        
        -- Change Radius
        wep:ChangeMaxRadius(wepRadius)
        oc:ChangeMaxRadius(ocRadius)
        
        -- As radius is only passed when turning on, use the bool
        if radius then
            self:ShowBone('Right_Turret', true)
            self:ShowBone('Turret_Muzzle_02', true)
        else
            self:HideBone('Right_Turret', true)
            self:HideBone('Turret_Muzzle_02', true)
        end
    end,

    OnTransportDetach = function(self, attachBone, unit)
        CWalkingLandUnit.OnTransportDetach(self, attachBone, unit)
        self:StopSiloBuild()
    end,

    OnScriptBitClear = function(self, bit)
        if bit == 8 then -- cloak toggle
            self:PlayUnitAmbientSound('ActiveLoop')
            self:SetMaintenanceConsumptionActive()
            self:EnableUnitIntel('Cloak')
            self:EnableUnitIntel('RadarStealth')
            self:EnableUnitIntel('RadarStealthField')
            self:EnableUnitIntel('SonarStealth')
            self:EnableUnitIntel('SonarStealthField')          
        end
    end,

    OnScriptBitSet = function(self, bit)
        if bit == 8 then -- cloak toggle
            self:StopUnitAmbientSound('ActiveLoop')
            self:SetMaintenanceConsumptionInactive()
            self:DisableUnitIntel('Cloak')
            self:DisableUnitIntel('RadarStealth')
            self:DisableUnitIntel('RadarStealthField')
            self:DisableUnitIntel('SonarStealth')
            self:DisableUnitIntel('SonarStealthField')
        end
    end,


    CreateBuildEffects = function(self, unitBeingBuilt, order)
       EffectUtil.SpawnBuildBots(self, unitBeingBuilt, 5, self.BuildEffectsBag)
       EffectUtil.CreateCybranBuildBeams(self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag)
    end,

    CreateEnhancement = function(self, enh)
        CWalkingLandUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
        if enh =='ImprovedEngineering' then
            self:RemoveBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER2COMMANDER))
            if not Buffs['CYBRANACUT2BuildRate'] then
                BuffBlueprint {
                    Name = 'CYBRANACUT2BuildRate',
                    DisplayName = 'CYBRANACUT2BuildRate',
                    BuffType = 'ACUBUILDRATE',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        BuildRate = {
                            Add =  bp.NewBuildRate - self:GetBlueprint().Economy.BuildRate,
                            Mult = 1,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'CYBRANACUT2BuildRate')
            local bp = self:GetBlueprint().Enhancements[enh]
            local bpEcon = self:GetBlueprint().Economy
            if not bp then return end
            self:SetProductionPerSecondEnergy(bp.ProductionPerSecondEnergy + bpEcon.ProductionPerSecondEnergy or 0)
            self:SetProductionPerSecondMass(bp.ProductionPerSecondMass + bpEcon.ProductionPerSecondMass or 0)
            if not Buffs['CybranHealthBoost1'] then
                BuffBlueprint {
                    Name = 'CybranHealthBoost1',
                    DisplayName = 'CybranHealthBoost1',
                    BuffType = 'CybranHealthBoost1',
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
            Buff.ApplyBuff(self, 'CybranHealthBoost1')
            self.RBImpEngineering = true
            self.RBAdvEngineering = false
            self.RBExpEngineering = false
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='ImprovedEngineeringRemove' then
            local bp = self:GetBlueprint().Economy.BuildRate
            if Buff.HasBuff(self, 'CYBRANACUT2BuildRate') then
                Buff.RemoveBuff(self, 'CYBRANACUT2BuildRate')
            end
            if not bp then return end
            self:RestoreBuildRestrictions()
            self:AddBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            local bpEcon = self:GetBlueprint().Economy
            self:SetProductionPerSecondEnergy(bpEcon.ProductionPerSecondEnergy or 0)
            self:SetProductionPerSecondMass(bpEcon.ProductionPerSecondMass or 0)
            if Buff.HasBuff(self, 'CybranHealthBoost1') then
                Buff.RemoveBuff(self, 'CybranHealthBoost1')
            end
            self.RBImpEngineering = false
            self.RBAdvEngineering = false
            self.RBExpEngineering = false
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='AdvancedEngineering' then
            self:RemoveBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER3COMMANDER - categories.BUILTBYTIER4COMMANDER))
            if not Buffs['CYBRANACUT3BuildRate'] then
                BuffBlueprint {
                    Name = 'CYBRANACUT3BuildRate',
                    DisplayName = 'CYBRANCUT3BuildRate',
                    BuffType = 'ACUBUILDRATE',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        BuildRate = {
                            Add =  bp.NewBuildRate - self:GetBlueprint().Economy.BuildRate,
                            Mult = 1,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'CYBRANACUT3BuildRate')
            local bp = self:GetBlueprint().Enhancements[enh]
            local bpEcon = self:GetBlueprint().Economy
            if not bp then return end
            self:SetProductionPerSecondEnergy(bp.ProductionPerSecondEnergy + bpEcon.ProductionPerSecondEnergy or 0)
            self:SetProductionPerSecondMass(bp.ProductionPerSecondMass + bpEcon.ProductionPerSecondMass or 0)
            if not Buffs['CybranHealthBoost2'] then
                BuffBlueprint {
                    Name = 'CybranHealthBoost2',
                    DisplayName = 'CybranHealthBoost2',
                    BuffType = 'CybranHealthBoost2',
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
            Buff.ApplyBuff(self, 'CybranHealthBoost2')
            self.RBImpEngineering = true
            self.RBAdvEngineering = true
            self.RBExpEngineering = false
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='AdvancedEngineeringRemove' then
            local bp = self:GetBlueprint().Economy.BuildRate
            if not bp then return end
            self:RestoreBuildRestrictions()
            if Buff.HasBuff(self, 'CYBRANACUT3BuildRate') then
                Buff.RemoveBuff(self, 'CYBRANACUT3BuildRate')
            end
            self:AddBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            local bpEcon = self:GetBlueprint().Economy
            self:SetProductionPerSecondEnergy(bpEcon.ProductionPerSecondEnergy or 0)
            self:SetProductionPerSecondMass(bpEcon.ProductionPerSecondMass or 0)
            if Buff.HasBuff(self, 'CybranHealthBoost1') then
                Buff.RemoveBuff(self, 'CybranHealthBoost1')
            end
            if Buff.HasBuff(self, 'CybranHealthBoost2') then
                Buff.RemoveBuff(self, 'CybranHealthBoost2')
            end
            self.RBImpEngineering = false
            self.RBAdvEngineering = false
            self.RBExpEngineering = false
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='ExperimentalEngineering' then
            self:RemoveBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER4COMMANDER))
            local bp = self:GetBlueprint().Enhancements[enh]
            local bpEcon = self:GetBlueprint().Economy
            if not bp then return end
            self:SetProductionPerSecondEnergy(bp.ProductionPerSecondEnergy + bpEcon.ProductionPerSecondEnergy or 0)
            self:SetProductionPerSecondMass(bp.ProductionPerSecondMass + bpEcon.ProductionPerSecondMass or 0)
            if not Buffs['CYBRANACUT4BuildRate'] then
                BuffBlueprint {
                    Name = 'CYBRANACUT4BuildRate',
                    DisplayName = 'CYBRANCUT4BuildRate',
                    BuffType = 'ACUBUILDRATE',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        BuildRate = {
                            Add =  bp.NewBuildRate - self:GetBlueprint().Economy.BuildRate,
                            Mult = 1,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'CYBRANACUT4BuildRate')
            if not Buffs['CybranHealthBoost3'] then
                BuffBlueprint {
                    Name = 'CybranHealthBoost3',
                    DisplayName = 'CybranHealthBoost3',
                    BuffType = 'CybranHealthBoost3',
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
            Buff.ApplyBuff(self, 'CybranHealthBoost3')
            self.RBImpEngineering = true
            self.RBAdvEngineering = true
            self.RBExpEngineering = true
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='ExperimentalEngineeringRemove' then
            local bp = self:GetBlueprint().Economy.BuildRate
            if not bp then return end
            self:RestoreBuildRestrictions()
            if Buff.HasBuff(self, 'CYBRANACUT4BuildRate') then
                Buff.RemoveBuff(self, 'CYBRANACUT4BuildRate')
            end
            self:AddBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            local bpEcon = self:GetBlueprint().Economy
            self:SetProductionPerSecondEnergy(bpEcon.ProductionPerSecondEnergy or 0)
            self:SetProductionPerSecondMass(bpEcon.ProductionPerSecondMass or 0)
            if Buff.HasBuff(self, 'CybranHealthBoost1') then
                Buff.RemoveBuff(self, 'CybranHealthBoost1')
            end
            if Buff.HasBuff(self, 'CybranHealthBoost2') then
                Buff.RemoveBuff(self, 'CybranHealthBoost2')
            end
            if Buff.HasBuff(self, 'CybranHealthBoost3') then
                Buff.RemoveBuff(self, 'CybranHealthBoost3')
            end
            self.RBImpEngineering = false
            self.RBAdvEngineering = false
            self.RBExpEngineering = false
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='CombatEngineering' then
            self:RemoveBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER2COMMANDER))
            if not Buffs['CYBRANACUT2BuildRate'] then
                BuffBlueprint {
                    Name = 'CYBRANACUT2BuildRate',
                    DisplayName = 'CYBRANACUT2BuildRate',
                    BuffType = 'ACUBUILDRATE',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        BuildRate = {
                            Add =  bp.NewBuildRate - self:GetBlueprint().Economy.BuildRate,
                            Mult = 1,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'CYBRANACUT2BuildRate')
            if not Buffs['CybranHealthBoost4'] then
                BuffBlueprint {
                    Name = 'CybranHealthBoost4',
                    DisplayName = 'CybranHealthBoost4',
                    BuffType = 'CybranHealthBoost4',
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
            Buff.ApplyBuff(self, 'CybranHealthBoost4')
            self.wcRocket01 = true
            self.wcRocket02 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self.RBComEngineering = true
            self.RBAssEngineering = false
            self.RBApoEngineering = false
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='CombatEngineeringRemove' then
            local bp = self:GetBlueprint().Economy.BuildRate
            if Buff.HasBuff(self, 'CYBRANACUT2BuildRate') then
                Buff.RemoveBuff(self, 'CYBRANACUT2BuildRate')
            end
            if not bp then return end
            self:RestoreBuildRestrictions()
            self:AddBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            if Buff.HasBuff(self, 'CybranHealthBoost4') then
                Buff.RemoveBuff(self, 'CybranHealthBoost4')
            end
            self.wcRocket01 = false
            self.wcRocket02 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self.RBComEngineering = false
            self.RBAssEngineering = false
            self.RBApoEngineering = false
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='AssaultEngineering' then
            self:RemoveBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER3COMMANDER - categories.BUILTBYTIER4COMMANDER))
            if not Buffs['CYBRANACUT3BuildRate'] then
                BuffBlueprint {
                    Name = 'CYBRANACUT3BuildRate',
                    DisplayName = 'CYBRANCUT3BuildRate',
                    BuffType = 'ACUBUILDRATE',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        BuildRate = {
                            Add =  bp.NewBuildRate - self:GetBlueprint().Economy.BuildRate,
                            Mult = 1,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'CYBRANACUT3BuildRate')
            if not Buffs['CybranHealthBoost5'] then
                BuffBlueprint {
                    Name = 'CybranHealthBoost5',
                    DisplayName = 'CybranHealthBoost5',
                    BuffType = 'CybranHealthBoost5',
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
            Buff.ApplyBuff(self, 'CybranHealthBoost5')
            self.wcRocket01 = false
            self.wcRocket02 = true
            self:ForkThread(self.WeaponRangeReset)
          
            self.RBComEngineering = true
            self.RBAssEngineering = true
            self.RBApoEngineering = false
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='AssaultEngineeringRemove' then
            local bp = self:GetBlueprint().Economy.BuildRate
            if not bp then return end
            self:RestoreBuildRestrictions()
            if Buff.HasBuff(self, 'CYBRANACUT3BuildRate') then
                Buff.RemoveBuff(self, 'CYBRANACUT3BuildRate')
            end
            self:AddBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            if Buff.HasBuff(self, 'CybranHealthBoost4') then
                Buff.RemoveBuff(self, 'CybranHealthBoost4')
            end
            if Buff.HasBuff(self, 'CybranHealthBoost5') then
                Buff.RemoveBuff(self, 'CybranHealthBoost5')
            end
            self.wcRocket01 = false
            self.wcRocket02 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self.RBComEngineering = false
            self.RBAssEngineering = false
            self.RBApoEngineering = false
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='ApocolypticEngineering' then
            self:RemoveBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER4COMMANDER))
            if not Buffs['CYBRANACUT4BuildRate'] then
                BuffBlueprint {
                    Name = 'CYBRANACUT4BuildRate',
                    DisplayName = 'CYBRANCUT4BuildRate',
                    BuffType = 'ACUBUILDRATE',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        BuildRate = {
                            Add =  bp.NewBuildRate - self:GetBlueprint().Economy.BuildRate,
                            Mult = 1,
                        },
                    },
                }
            end
            Buff.ApplyBuff(self, 'CYBRANACUT4BuildRate')
            if not Buffs['CybranHealthBoost6'] then
                BuffBlueprint {
                    Name = 'CybranHealthBoost6',
                    DisplayName = 'CybranHealthBoost6',
                    BuffType = 'CybranHealthBoost6',
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
            Buff.ApplyBuff(self, 'CybranHealthBoost6')
            self.RBComEngineering = true
            self.RBAssEngineering = true
            self.RBApoEngineering = true
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='ApocolypticEngineeringRemove' then
            local bp = self:GetBlueprint().Economy.BuildRate
            if not bp then return end
            self:RestoreBuildRestrictions()
            if Buff.HasBuff(self, 'CYBRANACUT4BuildRate') then
                Buff.RemoveBuff(self, 'CYBRANACUT4BuildRate')
            end
            self:AddBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            if Buff.HasBuff(self, 'CybranHealthBoost4') then
                Buff.RemoveBuff(self, 'CybranHealthBoost4')
            end
            if Buff.HasBuff(self, 'CybranHealthBoost5') then
                Buff.RemoveBuff(self, 'CybranHealthBoost5')
            end
            if Buff.HasBuff(self, 'CybranHealthBoost6') then
                Buff.RemoveBuff(self, 'CybranHealthBoost6')
            end
            self.wcRocket01 = false
            self.wcRocket02 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self.RBComEngineering = false
            self.RBAssEngineering = false
            self.RBApoEngineering = false
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='RipperBooster' then
            local wepRipper = self:GetWeaponByLabel('RightRipper')
            wepRipper:ChangeMaxRadius(30)
            self:ForkThread(self.RegenBuffThread)
            self:ForkThread(self.DefaultGunBuffThread)
        elseif enh =='RipperBoosterRemove' then
            local wepRipper = self:GetWeaponByLabel('RightRipper')
            local bpDisruptRipperRadius = self:GetBlueprint().Weapon[1].MaxRadius
            wepRipper:ChangeMaxRadius(bpDisruptRipperRadius or 22)
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='TorpedoLauncher' then
            if not Buffs['CybranHealthBoost7'] then
                BuffBlueprint {
                    Name = 'CybranHealthBoost7',
                    DisplayName = 'CybranHealthBoost7',
                    BuffType = 'CybranHealthBoost7',
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
            Buff.ApplyBuff(self, 'CybranHealthBoost7')
            local wepRipper = self:GetWeaponByLabel('RightRipper')
            wepRipper:ChangeMaxRadius(30)
            self.wcTorp01 = true
            self.wcTorp02 = false
            self.wcTorp03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='TorpedoLauncherRemove' then
            if Buff.HasBuff(self, 'CybranHealthBoost7') then
                Buff.RemoveBuff(self, 'CybranHealthBoost7')
            end
            local wepRipper = self:GetWeaponByLabel('RightRipper')
            local bpDisruptRipperRadius = self:GetBlueprint().Weapon[1].MaxRadius
            wepRipper:ChangeMaxRadius(bpDisruptRipperRadius or 22)
            self.wcTorp01 = false
            self.wcTorp02 = false
            self.wcTorp03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='TorpedoRapidLoader' then
            if not Buffs['CybranHealthBoost8'] then
                BuffBlueprint {
                    Name = 'CybranHealthBoost8',
                    DisplayName = 'CybranHealthBoost8',
                    BuffType = 'CybranHealthBoost8',
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
            Buff.ApplyBuff(self, 'CybranHealthBoost8')
            local wepRipper = self:GetWeaponByLabel('RightRipper')
            wepRipper:AddDamageMod(50)
            self.wcTorp01 = false
            self.wcTorp02 = true
            self.wcTorp03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.RegenBuffThread)
            self:ForkThread(self.DefaultGunBuffThread)
        elseif enh =='TorpedoRapidLoaderRemove' then
            if Buff.HasBuff(self, 'CybranHealthBoost7') then
                Buff.RemoveBuff(self, 'CybranHealthBoost7')
            end
            if Buff.HasBuff(self, 'CybranHealthBoost8') then
                Buff.RemoveBuff(self, 'CybranHealthBoost8')
            end
            local wepRipper = self:GetWeaponByLabel('RightRipper')
            local bpDisruptRipperRadius = self:GetBlueprint().Weapon[1].MaxRadius
            wepRipper:ChangeMaxRadius(bpDisruptRipperRadius or 22)
            wepRipper:AddDamageMod(-50)
            self.wcTorp01 = false
            self.wcTorp02 = false
            self.wcTorp03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='TorpedoClusterLauncher' then
            if not Buffs['CybranHealthBoost9'] then
                BuffBlueprint {
                    Name = 'CybranHealthBoost9',
                    DisplayName = 'CybranHealthBoost9',
                    BuffType = 'CybranHealthBoost9',
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
            Buff.ApplyBuff(self, 'CybranHealthBoost9')
            local wepRipper = self:GetWeaponByLabel('RightRipper')
            wepRipper:AddDamageMod(100)
            self.wcTorp01 = false
            self.wcTorp02 = false
            self.wcTorp03 = true
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='TorpedoClusterLauncherRemove' then
            if Buff.HasBuff(self, 'CybranHealthBoost7') then
                Buff.RemoveBuff(self, 'CybranHealthBoost7')
            end
            if Buff.HasBuff(self, 'CybranHealthBoost8') then
                Buff.RemoveBuff(self, 'CybranHealthBoost8')
            end
            if Buff.HasBuff(self, 'CybranHealthBoost9') then
                Buff.RemoveBuff(self, 'CybranHealthBoost9')
            end
            local wepRipper = self:GetWeaponByLabel('RightRipper')
            local bpDisruptRipperRadius = self:GetBlueprint().Weapon[1].MaxRadius
            wepRipper:ChangeMaxRadius(bpDisruptRipperRadius or 22)
            wepRipper:AddDamageMod(-150)
            self.wcTorp01 = false
            self.wcTorp02 = false
            self.wcTorp03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='EMPArray' then
            if not Buffs['CybranHealthBoost10'] then
                BuffBlueprint {
                    Name = 'CybranHealthBoost10',
                    DisplayName = 'CybranHealthBoost10',
                    BuffType = 'CybranHealthBoost10',
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
            Buff.ApplyBuff(self, 'CybranHealthBoost10')
            local wepRipper = self:GetWeaponByLabel('RightRipper')
            wepRipper:ChangeMaxRadius(35)
            self.wcEMP01 = true
            self.wcEMP02 = false
            self.wcEMP03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='EMPArrayRemove' then
            if Buff.HasBuff(self, 'CybranHealthBoost10') then
                Buff.RemoveBuff(self, 'CybranHealthBoost10')
            end
            local wepRipper = self:GetWeaponByLabel('RightRipper')
            local bpDisruptRipperRadius = self:GetBlueprint().Weapon[1].MaxRadius
            wepRipper:ChangeMaxRadius(bpDisruptRipperRadius or 22)
            self.wcEMP01 = false
            self.wcEMP02 = false
            self.wcEMP03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='ImprovedCapacitors' then
            if not Buffs['CybranHealthBoost11'] then
                BuffBlueprint {
                    Name = 'CybranHealthBoost11',
                    DisplayName = 'CybranHealthBoost11',
                    BuffType = 'CybranHealthBoost11',
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
            Buff.ApplyBuff(self, 'CybranHealthBoost11')
            local wepRipper = self:GetWeaponByLabel('RightRipper')
            wepRipper:ChangeMaxRadius(40)
            self.wcEMP01 = false
            self.wcEMP02 = true
            self.wcEMP03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.RegenBuffThread)
            self:ForkThread(self.DefaultGunBuffThread)
        elseif enh =='ImprovedCapacitorsRemove' then    
            if Buff.HasBuff(self, 'CybranHealthBoost10') then
                Buff.RemoveBuff(self, 'CybranHealthBoost10')
            end
            if Buff.HasBuff(self, 'CybranHealthBoost11') then
                Buff.RemoveBuff(self, 'CybranHealthBoost11')
            end
            local wepRipper = self:GetWeaponByLabel('RightRipper')
            local bpDisruptRipperRadius = self:GetBlueprint().Weapon[1].MaxRadius
            wepRipper:ChangeMaxRadius(bpDisruptRipperRadius or 22)
            self.wcEMP01 = false
            self.wcEMP02 = false
            self.wcEMP03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='PowerBooster' then
            if not Buffs['CybranHealthBoost12'] then
                BuffBlueprint {
                    Name = 'CybranHealthBoost12',
                    DisplayName = 'CybranHealthBoost12',
                    BuffType = 'CybranHealthBoost12',
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
            Buff.ApplyBuff(self, 'CybranHealthBoost12')
            local wepRipper = self:GetWeaponByLabel('RightRipper')
            wepRipper:ChangeMaxRadius(45)
            self.wcEMP01 = false
            self.wcEMP02 = false
            self.wcEMP03 = true
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='PowerBoosterRemove' then    
            self:SetWeaponEnabledByLabel('EMPArray01', false)
            if Buff.HasBuff(self, 'CybranHealthBoost10') then
                Buff.RemoveBuff(self, 'CybranHealthBoost10')
            end
            if Buff.HasBuff(self, 'CybranHealthBoost11') then
                Buff.RemoveBuff(self, 'CybranHealthBoost11')
            end
            if Buff.HasBuff(self, 'CybranHealthBoost12') then
                Buff.RemoveBuff(self, 'CybranHealthBoost12')
            end
            local wepRipper = self:GetWeaponByLabel('RightRipper')
            local bpDisruptRipperRadius = self:GetBlueprint().Weapon[1].MaxRadius
            wepRipper:ChangeMaxRadius(bpDisruptRipperRadius or 22)
            self.wcEMP01 = false
            self.wcEMP02 = false
            self.wcEMP03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='Masor' then
            if not Buffs['CybranHealthBoost13'] then
                BuffBlueprint {
                    Name = 'CybranHealthBoost13',
                    DisplayName = 'CybranHealthBoost13',
                    BuffType = 'CybranHealthBoost13',
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
            Buff.ApplyBuff(self, 'CybranHealthBoost13')
            local wepRipper = self:GetWeaponByLabel('RightRipper')
            wepRipper:ChangeMaxRadius(30)
            self.wcMasor01 = true
            self.wcMasor02 = false
            self.wcMasor03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='MasorRemove' then
            if Buff.HasBuff(self, 'CybranHealthBoost13') then
                Buff.RemoveBuff(self, 'CybranHealthBoost13')
            end
            local wepRipper = self:GetWeaponByLabel('RightRipper')
            local bpDisruptRipperRadius = self:GetBlueprint().Weapon[1].MaxRadius
            wepRipper:ChangeMaxRadius(bpDisruptRipperRadius or 22)
            self.wcMasor01 = false
            self.wcMasor02 = false
            self.wcMasor03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='ImprovedCoolingSystem' then
            if not Buffs['CybranHealthBoost14'] then
                BuffBlueprint {
                    Name = 'CybranHealthBoost14',
                    DisplayName = 'CybranHealthBoost14',
                    BuffType = 'CybranHealthBoost14',
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
            Buff.ApplyBuff(self, 'CybranHealthBoost14')
            local wepRipper = self:GetWeaponByLabel('RightRipper')
            wepRipper:ChangeMaxRadius(30)
            self.wcMasor01 = false
            self.wcMasor02 = true
            self.wcMasor03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.RegenBuffThread)
            self:ForkThread(self.DefaultGunBuffThread)
        elseif enh =='ImprovedCoolingSystemRemove' then
            if Buff.HasBuff(self, 'CybranHealthBoost13') then
                Buff.RemoveBuff(self, 'CybranHealthBoost13')
            end
            if Buff.HasBuff(self, 'CybranHealthBoost14') then
                Buff.RemoveBuff(self, 'CybranHealthBoost14')
            end
            local wepRipper = self:GetWeaponByLabel('RightRipper')
            local bpDisruptRipperRadius = self:GetBlueprint().Weapon[1].MaxRadius
            wepRipper:ChangeMaxRadius(bpDisruptRipperRadius or 22)
            self.wcMasor01 = false
            self.wcMasor02 = false
            self.wcMasor03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='AdvancedEmitterArray' then
            if not Buffs['CybranHealthBoost15'] then
                BuffBlueprint {
                    Name = 'CybranHealthBoost15',
                    DisplayName = 'CybranHealthBoost15',
                    BuffType = 'CybranHealthBoost15',
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
            Buff.ApplyBuff(self, 'CybranHealthBoost15')
            local wepRipper = self:GetWeaponByLabel('RightRipper')
            wepRipper:ChangeMaxRadius(30)
            self.wcMasor01 = false
            self.wcMasor02 = false
            self.wcMasor03 = true
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='AdvancedEmitterArrayRemove' then
            if Buff.HasBuff(self, 'CybranHealthBoost13') then
                Buff.RemoveBuff(self, 'CybranHealthBoost13')
            end
            if Buff.HasBuff(self, 'CybranHealthBoost14') then
                Buff.RemoveBuff(self, 'CybranHealthBoost14')
            end
            if Buff.HasBuff(self, 'CybranHealthBoost15') then
                Buff.RemoveBuff(self, 'CybranHealthBoost15')
            end
            local wepRipper = self:GetWeaponByLabel('RightRipper')
            local bpDisruptRipperRadius = self:GetBlueprint().Weapon[1].MaxRadius
            wepRipper:ChangeMaxRadius(bpDisruptRipperRadius or 22)
            self.wcMasor01 = false
            self.wcMasor02 = false
            self.wcMasor03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.RegenBuffThread)
        elseif enh == 'ArmorPlating' then
            if not Buffs['CybranHealthBoost22'] then
                BuffBlueprint {
                    Name = 'CybranHealthBoost22',
                    DisplayName = 'CybranHealthBoost22',
                    BuffType = 'CybranHealthBoost22',
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
            Buff.ApplyBuff(self, 'CybranHealthBoost22')
            self.wcAA01 = true
            self.wcAA02 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self.RBDefTier1 = true
            self.RBDefTier2 = false
            self.RBDefTier3 = false
            self:ForkThread(self.RegenBuffThread)
        elseif enh == 'ArmorPlatingRemove' then
            if Buff.HasBuff(self, 'CybranHealthBoost22') then
                Buff.RemoveBuff(self, 'CybranHealthBoost22')
            end
            self.wcAA01 = false
            self.wcAA02 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self.RBDefTier1 = false
            self.RBDefTier2 = false
            self.RBDefTier3 = false
            self:ForkThread(self.RegenBuffThread)
        elseif enh == 'StructuralIntegrity' then
            if not Buffs['CybranHealthBoost23'] then
                BuffBlueprint {
                    Name = 'CybranHealthBoost23',
                    DisplayName = 'CybranHealthBoost23',
                    BuffType = 'CybranHealthBoost23',
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
            Buff.ApplyBuff(self, 'CybranHealthBoost23')
            self.wcAA01 = true
            self.wcAA02 = true
            self:ForkThread(self.WeaponRangeReset)
    
            self.RBDefTier1 = true
            self.RBDefTier2 = true
            self.RBDefTier3 = false
            self:ForkThread(self.RegenBuffThread)
        elseif enh == 'StructuralIntegrityRemove' then
            if Buff.HasBuff(self, 'CybranHealthBoost22') then
                Buff.RemoveBuff(self, 'CybranHealthBoost22')
            end
            if Buff.HasBuff(self, 'CybranHealthBoost23') then
                Buff.RemoveBuff(self, 'CybranHealthBoost23')
            end
            self.wcAA01 = false
            self.wcAA02 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self.RBDefTier1 = false
            self.RBDefTier2 = false
            self.RBDefTier3 = false
            self:ForkThread(self.RegenBuffThread)
        elseif enh == 'CompositeMaterials' then
            if not Buffs['CybranHealthBoost24'] then
                BuffBlueprint {
                    Name = 'CybranHealthBoost24',
                    DisplayName = 'CybranHealthBoost24',
                    BuffType = 'CybranHealthBoost24',
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
            Buff.ApplyBuff(self, 'CybranHealthBoost24')
            self.RBDefTier1 = true
            self.RBDefTier2 = true
            self.RBDefTier3 = true
            self:ForkThread(self.RegenBuffThread)
        elseif enh == 'CompositeMaterialsRemove' then
            if Buff.HasBuff(self, 'CybranHealthBoost22') then
                Buff.RemoveBuff(self, 'CybranHealthBoost22')
            end
            if Buff.HasBuff(self, 'CybranHealthBoost23') then
                Buff.RemoveBuff(self, 'CybranHealthBoost23')
            end
            if Buff.HasBuff(self, 'CybranHealthBoost24') then
                Buff.RemoveBuff(self, 'CybranHealthBoost24')
            end
            self.wcAA01 = false
            self.wcAA02 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self.RBDefTier1 = false
            self.RBDefTier2 = false
            self.RBDefTier3 = false
            self:ForkThread(self.RegenBuffThread)
        elseif enh == 'ElectronicsEnhancment' then
            self:SetIntelRadius('Vision', bp.NewVisionRadius or 50)
            self:SetIntelRadius('Omni', bp.NewOmniRadius or 50)
            if not Buffs['CybranHealthBoost16'] then
                BuffBlueprint {
                    Name = 'CybranHealthBoost16',
                    DisplayName = 'CybranHealthBoost16',
                    BuffType = 'CybranHealthBoost16',
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
            Buff.ApplyBuff(self, 'CybranHealthBoost16')
            self.RBIntTier1 = true
            self.RBIntTier2 = false
            self.RBIntTier3 = false
            self:ForkThread(self.RegenBuffThread)
        elseif enh == 'ElectronicsEnhancmentRemove' then
            local bpIntel = self:GetBlueprint().Intel
            self:SetIntelRadius('Vision', bpIntel.VisionRadius or 26)
            self:SetIntelRadius('Omni', bpIntel.OmniRadius or 26)
            if Buff.HasBuff(self, 'CybranHealthBoost16') then
                Buff.RemoveBuff(self, 'CybranHealthBoost16')
            end
            self.RBIntTier1 = false
            self.RBIntTier2 = false
            self.RBIntTier3 = false
            self:ForkThread(self.RegenBuffThread)
        elseif enh == 'ElectronicCountermeasures' then
            self:AddToggleCap('RULEUTC_CloakToggle')
            if self.IntelEffectsBag then
                EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
                self.IntelEffectsBag = nil
            end
            self.CloakEnh = false        
            self.StealthEnh = true
            self:EnableUnitIntel('RadarStealth')
            self:EnableUnitIntel('SonarStealth')
            if not Buffs['CybranHealthBoost17'] then
                BuffBlueprint {
                    Name = 'CybranHealthBoost17',
                    DisplayName = 'CybranHealthBoost17',
                    BuffType = 'CybranHealthBoost17',
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
            Buff.ApplyBuff(self, 'CybranHealthBoost17')
            self.RBIntTier1 = true
            self.RBIntTier2 = true
            self.RBIntTier3 = false
            self:ForkThread(self.RegenBuffThread)
        elseif enh == 'ElectronicCountermeasuresRemove' then
            self:RemoveToggleCap('RULEUTC_CloakToggle')
            self:DisableUnitIntel('RadarStealth')
            self:DisableUnitIntel('SonarStealth')           
            self.StealthEnh = false
            self.CloakEnh = false 
            self.StealthFieldEffects = false
            self.CloakingEffects = false     
            local bpIntel = self:GetBlueprint().Intel
            self:SetIntelRadius('Vision', bpIntel.VisionRadius or 26)
            self:SetIntelRadius('Omni', bpIntel.OmniRadius or 26)
            if Buff.HasBuff(self, 'CybranHealthBoost16') then
                Buff.RemoveBuff(self, 'CybranHealthBoost16')
            end
            if Buff.HasBuff(self, 'CybranHealthBoost17') then
                Buff.RemoveBuff(self, 'CybranHealthBoost17')
            end
            self.RBIntTier1 = false
            self.RBIntTier2 = false
            self.RBIntTier3 = false
            self:ForkThread(self.RegenBuffThread)
        elseif enh == 'CloakingSubsystems' then
            local bp = self:GetBlueprint().Enhancements[enh]
            if not bp then return end
            self.StealthEnh = false
            self.CloakEnh = true 
            self:EnableUnitIntel('Cloak')
            if not Buffs['CybranHealthBoost18'] then
                BuffBlueprint {
                    Name = 'CybranHealthBoost18',
                    DisplayName = 'CybranHealthBoost18',
                    BuffType = 'CybranHealthBoost18',
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
            Buff.ApplyBuff(self, 'CybranHealthBoost18')
            self.RBIntTier1 = true
            self.RBIntTier2 = true
            self.RBIntTier3 = true
            self:ForkThread(self.RegenBuffThread)
        elseif enh == 'CloakingSubsystemsRemove' then
            self:RemoveToggleCap('RULEUTC_CloakToggle')
            self:DisableUnitIntel('Cloak')
            self.CloakEnh = false 
            local bpIntel = self:GetBlueprint().Intel
            self:SetIntelRadius('Vision', bpIntel.VisionRadius or 26)
            self:SetIntelRadius('Omni', bpIntel.OmniRadius or 26)
            if Buff.HasBuff(self, 'CybranHealthBoost16') then
                Buff.RemoveBuff(self, 'CybranHealthBoost16')
            end
            if Buff.HasBuff(self, 'CybranHealthBoost17') then
                Buff.RemoveBuff(self, 'CybranHealthBoost17')
            end
            if Buff.HasBuff(self, 'CybranHealthBoost18') then
                Buff.RemoveBuff(self, 'CybranHealthBoost18')
            end
            self.RBIntTier1 = false
            self.RBIntTier2 = false
            self.RBIntTier3 = false
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='MobilitySubsystems' then
            self:SetSpeedMult(1.41176)
            if not Buffs['CybranHealthBoost19'] then
                BuffBlueprint {
                    Name = 'CybranHealthBoost19',
                    DisplayName = 'CybranHealthBoost19',
                    BuffType = 'CybranHealthBoost19',
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
            Buff.ApplyBuff(self, 'CybranHealthBoost19')
            self.RBComTier1 = true
            self.RBComTier2 = false
            self.RBComTier3 = false
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='MobilitySubsystemsRemove' then
            self:SetSpeedMult(1)
            if Buff.HasBuff(self, 'CybranHealthBoost19') then
                Buff.RemoveBuff(self, 'CybranHealthBoost19')
            end
            self.RBComTier1 = false
            self.RBComTier2 = false
            self.RBComTier3 = false
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='DefensiveSubsystems' then
            if not Buffs['CybranHealthBoost20'] then
                BuffBlueprint {
                    Name = 'CybranHealthBoost20',
                    DisplayName = 'CybranHealthBoost20',
                    BuffType = 'CybranHealthBoost20',
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
            Buff.ApplyBuff(self, 'CybranHealthBoost20')
            self:AddCommandCap('RULEUCC_Teleport')
            self.wcAA01 = true
            self.wcAA02 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self.RBComTier1 = true
            self.RBComTier2 = true
            self.RBComTier3 = false
            self:ForkThread(self.RegenBuffThread)
        elseif enh == 'DefensiveSubsystemsRemove' then
            self:SetSpeedMult(1)
            if Buff.HasBuff(self, 'CybranHealthBoost19') then
                Buff.RemoveBuff(self, 'CybranHealthBoost19')
            end
            if Buff.HasBuff(self, 'CybranHealthBoost20') then
                Buff.RemoveBuff(self, 'CybranHealthBoost20')
            end
            self:RemoveCommandCap('RULEUCC_Teleport')
            self.wcAA01 = false
            self.wcAA02 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self.RBComTier1 = false
            self.RBComTier2 = false
            self.RBComTier3 = false
            self:ForkThread(self.RegenBuffThread)
        elseif enh =='NanoKickerSubsystems' then
            if not Buffs['CybranHealthBoost21'] then
                BuffBlueprint {
                    Name = 'CybranHealthBoost21',
                    DisplayName = 'CybranHealthBoost21',
                    BuffType = 'CybranHealthBoost21',
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
            Buff.ApplyBuff(self, 'CybranHealthBoost21')
            self.RBComTier1 = true
            self.RBComTier2 = true
            self.RBComTier3 = true
            self:ForkThread(self.RegenBuffThread)
        elseif enh == 'NanoKickerSubsystemsRemove' then
            self:SetSpeedMult(1)
            if Buff.HasBuff(self, 'CybranHealthBoost19') then
                Buff.RemoveBuff(self, 'CybranHealthBoost19')
            end
            if Buff.HasBuff(self, 'CybranHealthBoost20') then
                Buff.RemoveBuff(self, 'CybranHealthBoost20')
            end
            if Buff.HasBuff(self, 'CybranHealthBoost21') then
                Buff.RemoveBuff(self, 'CybranHealthBoost21')
            end
            self:RemoveCommandCap('RULEUCC_Teleport')
            self.wcAA01 = false
            self.wcAA02 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self.RBComTier1 = false
            self.RBComTier2 = false
            self.RBComTier3 = false
            self:ForkThread(self.RegenBuffThread)
        end
    end,

    IntelEffects = {
        Cloak = {
            {
                Bones = {
                    'Head',
                    'Right_Turret',
                    'Left_Turret',
                    'Right_Arm_B01',
                    'Left_Arm_B01',
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
                    'Right_Turret',
                    'Left_Turret',
                    'Right_Arm_B01',
                    'Left_Arm_B01',
                    'Left_Leg_B01',
                    'Left_Leg_B02',
                    'Right_Leg_B01',
                    'Right_Leg_B02',
                },
                Scale = 1.6,
                Type = 'Cloak01',
            },    
        },    
    },

    OnIntelEnabled = function(self)
        CWalkingLandUnit.OnIntelEnabled(self)
        if self.CloakEnh and self:IsIntelEnabled('Cloak') then 
            self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Enhancements['CloakingSubsystems'].MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            if not self.IntelEffectsBag then
                self.IntelEffectsBag = {}
                self.CreateTerrainTypeEffects(self, self.IntelEffects.Cloak, 'FXIdle',  self:GetCurrentLayer(), nil, self.IntelEffectsBag)
            end            
        elseif self.StealthEnh and self:IsIntelEnabled('RadarStealth') and self:IsIntelEnabled('SonarStealth') then
            self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Enhancements['ElectronicCountermeasures'].MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()  
            if not self.IntelEffectsBag then 
                self.IntelEffectsBag = {}
                self.CreateTerrainTypeEffects(self, self.IntelEffects.Field, 'FXIdle',  self:GetCurrentLayer(), nil, self.IntelEffectsBag)
            end                  
        end        
    end,

    OnIntelDisabled = function(self)
        CWalkingLandUnit.OnIntelDisabled(self)
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
}   
    
TypeClass = ERL0001
