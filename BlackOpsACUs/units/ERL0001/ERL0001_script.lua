-----------------------------------------------------------------
-- Author(s):  Exavier Macbeth
-- Summary  :  BlackOps: Adv Command Unit - Cybran ACU
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------
local ACUUnit = import('/lua/defaultunits.lua').ACUUnit
local CWeapons = import('/lua/cybranweapons.lua')
local CCannonMolecularWeapon = CWeapons.CCannonMolecularWeapon
local CDFHeavyMicrowaveLaserGeneratorCom = CWeapons.CDFHeavyMicrowaveLaserGeneratorCom
local CDFOverchargeWeapon = CWeapons.CDFOverchargeWeapon
local CANTorpedoLauncherWeapon = CWeapons.CANTorpedoLauncherWeapon
local RocketPack = CWeapons.CDFRocketIridiumWeapon02
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')
local Entity = import('/lua/sim/Entity.lua').Entity
local Buff = import('/lua/sim/Buff.lua')
local DeathNukeWeapon = import('/lua/sim/defaultweapons.lua').DeathNukeWeapon
local BOWeapons = import('/mods/BlackOpsUnleashed/lua/BlackOpsweapons.lua')
local CEMPArrayBeam01 = BOWeapons.CEMPArrayBeam01
local CEMPArrayBeam02 = BOWeapons.CEMPArrayBeam02

ERL0001 = Class(ACUUnit) {
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
        RocketPack = Class(RocketPack) {},
        TorpedoLauncher = Class(CANTorpedoLauncherWeapon) {},
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
        ACUUnit.OnCreate(self)
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

    OnStopBeingBuilt = function(self, builder, layer)
        ACUUnit.OnStopBeingBuilt(self, builder, layer)
        self:SetWeaponEnabledByLabel('RightRipper', true)
        self:SetMaintenanceConsumptionInactive()
        self:DisableUnitIntel('RadarStealth')
        self:DisableUnitIntel('SonarStealth')
        self:DisableUnitIntel('Cloak')
        self:DisableUnitIntel('CloakField')
        self:DisableUnitIntel('Sonar')
        self.EMPArrayEffects01 = {}
        self:ForkThread(self.GiveInitialResources)
        
        -- Disable Upgrade Weapons
        self:SetWeaponEnabledByLabel('RightRipper', true)
        self:SetWeaponEnabledByLabel('RocketPack', false)
        self:SetWeaponEnabledByLabel('TorpedoLauncher', false)
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
        ACUUnit.OnStartBuild(self, unitBeingBuilt, order)
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
    TogglePrimaryGun = function(self, RoF, radius)
        local wep = self:GetWeaponByLabel('RightRipper')
        local oc = self:GetWeaponByLabel('OverCharge')
    
        local wepRadius = radius or wep:GetBlueprint().MaxRadius
        local ocRadius = radius or oc:GetBlueprint().MaxRadius

        -- Change RoF
        wep:ChangeRateOfFire(RoF)
        
        -- Change Radius
        wep:ChangeMaxRadius(wepRadius)
        oc:ChangeMaxRadius(ocRadius)
        
        -- As radius is only passed when turning on, use the bool
        if radius then
            self:ShowBone('Right_Upgrade', true)
        else
            self:HideBone('Right_Upgrade', true)
        end
    end,

    OnTransportDetach = function(self, attachBone, unit)
        ACUUnit.OnTransportDetach(self, attachBone, unit)
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
        ACUUnit.CreateEnhancement(self, enh)
        
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
        
        if enh =='ImprovedEngineering' then
            self:RemoveBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER2COMMANDER))
            self:SetProduction(bp)
            
            if not Buffs['CYBRANACUT2BuildRate'] then
                BuffBlueprint {
                    Name = 'CYBRANACUT2BuildRate',
                    DisplayName = 'CYBRANACUT2BuildRate',
                    BuffType = 'ACUBUILDRATE',
                    Stacks = 'STACKS',
                    Duration = -1,
                    Affects = {
                        BuildRate = {
                            Add =  bp.NewBuildRate,
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
            Buff.ApplyBuff(self, 'CYBRANACUT2BuildRate')
        elseif enh =='ImprovedEngineeringRemove' then
            local bp = self:GetBlueprint().Economy.BuildRate
            if Buff.HasBuff(self, 'CYBRANACUT2BuildRate') then
                Buff.RemoveBuff(self, 'CYBRANACUT2BuildRate')
            end
            self:AddBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            self:SetProduction()
        elseif enh =='AdvancedEngineering' then
            self:RemoveBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER3COMMANDER - categories.BUILTBYTIER4COMMANDER))
            self:SetProduction(bp)
            
            if not Buffs['CYBRANACUT3BuildRate'] then
                BuffBlueprint {
                    Name = 'CYBRANACUT3BuildRate',
                    DisplayName = 'CYBRANCUT3BuildRate',
                    BuffType = 'ACUBUILDRATE',
                    Stacks = 'STACKS',
                    Duration = -1,
                    Affects = {
                        BuildRate = {
                            Add =  bp.NewBuildRate,
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
            Buff.ApplyBuff(self, 'CYBRANACUT3BuildRate')
        elseif enh =='AdvancedEngineeringRemove' then
            if Buff.HasBuff(self, 'CYBRANACUT3BuildRate') then
                Buff.RemoveBuff(self, 'CYBRANACUT3BuildRate')
            end
            self:AddBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            self:SetProduction()
        elseif enh =='ExperimentalEngineering' then
            self:RemoveBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER4COMMANDER))
            self:SetProduction(bp)

            if not Buffs['CYBRANACUT4BuildRate'] then
                BuffBlueprint {
                    Name = 'CYBRANACUT4BuildRate',
                    DisplayName = 'CYBRANCUT4BuildRate',
                    BuffType = 'ACUBUILDRATE',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        BuildRate = {
                            Add =  bp.NewBuildRate,
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
            Buff.ApplyBuff(self, 'CYBRANACUT4BuildRate')
        elseif enh =='ExperimentalEngineeringRemove' then
            if Buff.HasBuff(self, 'CYBRANACUT4BuildRate') then
                Buff.RemoveBuff(self, 'CYBRANACUT4BuildRate')
            end
            self:AddBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            self:SetProduction()
        elseif enh =='CombatEngineering' then
            self:RemoveBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER2COMMANDER))
            
            if not Buffs['CYBRANACUT2BuildCombat'] then
                BuffBlueprint {
                    Name = 'CYBRANACUT2BuildCombat',
                    DisplayName = 'CYBRANACUT2BuildCombat',
                    BuffType = 'ACUBUILDRATE',
                    Stacks = 'STACKS',
                    Duration = -1,
                    Affects = {
                        BuildRate = {
                            Add =  bp.NewBuildRate,
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
            Buff.ApplyBuff(self, 'CYBRANACUT2BuildCombat')
            
            self:SetWeaponEnabledByLabel('RocketPack', true)
        elseif enh =='CombatEngineeringRemove' then
            if Buff.HasBuff(self, 'CYBRANACUT2BuildCombat') then
                Buff.RemoveBuff(self, 'CYBRANACUT2BuildCombat')
            end
            
            self:AddBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            self:SetWeaponEnabledByLabel('RocketPack', false)
        elseif enh =='AssaultEngineering' then
            self:RemoveBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER3COMMANDER - categories.BUILTBYTIER4COMMANDER))
            
            if not Buffs['CYBRANACUT3BuildCombat'] then
                BuffBlueprint {
                    Name = 'CYBRANACUT3BuildCombat',
                    DisplayName = 'CYBRANCUT3BuildRate',
                    BuffType = 'ACUBUILDRATE',
                    Stacks = 'STACKS',
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
            Buff.ApplyBuff(self, 'CYBRANACUT3BuildCombat')
            
            local gun = self:GetWeaponByLabel('RocketPack')
            gun:AddDamageMod(bp.RocketDamageMod)
            gun:ChangeMaxRadius(bp.RocketMaxRadius)
        elseif enh =='AssaultEngineeringRemove' then
            if Buff.HasBuff(self, 'CYBRANACUT3BuildCombat') then
                Buff.RemoveBuff(self, 'CYBRANACUT3BuildCombat')
            end
            
            self:AddBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))

            local gun = self:GetWeaponByLabel('RocketPack')
            gun:AddDamageMod(bp.RocketDamageMod)
            gun:ChangeMaxRadius(gun:GetBlueprint().MaxRadius)
        elseif enh =='ApocolypticEngineering' then
            self:RemoveBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER4COMMANDER))
            
            if not Buffs['CYBRANACUT4BuildCombat'] then
                BuffBlueprint {
                    Name = 'CYBRANACUT4BuildCombat',
                    DisplayName = 'CYBRANCUT4BuildRate',
                    BuffType = 'ACUBUILDRATE',
                    Stacks = 'STACKS',
                    Duration = -1,
                    Affects = {
                        BuildRate = {
                            Add =  bp.NewBuildRate,
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
            Buff.ApplyBuff(self, 'CYBRANACUT4BuildCombat')
        elseif enh =='ApocolypticEngineeringRemove' then
            if Buff.HasBuff(self, 'CYBRANACUT4BuildCombat') then
                Buff.RemoveBuff(self, 'CYBRANACUT4BuildCombat')
            end
            
            self:AddBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
        
        -- Jury Rigged Ripper
        
        elseif enh =='RipperBooster' then
            self:TogglePrimaryGun(bp.NewRoF, bp.NewMaxRadius)
        elseif enh =='RipperBoosterRemove' then
            self:TogglePrimaryGun(bp.NewRoF)

        -- Torpedoes
            
        elseif enh =='TorpedoLauncher' then
            if not Buffs['CybranTorpHealth1'] then
                BuffBlueprint {
                    Name = 'CybranTorpHealth1',
                    DisplayName = 'CybranTorpHealth1',
                    BuffType = 'CybranTorpHealth',
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
            Buff.ApplyBuff(self, 'CybranTorpHealth1')
            
            self:SetWeaponEnabledByLabel('TorpedoLauncher', true)
        elseif enh =='TorpedoLauncherRemove' then
            if Buff.HasBuff(self, 'CybranTorpHealth1') then
                Buff.RemoveBuff(self, 'CybranTorpHealth1')
            end
            
            self:SetWeaponEnabledByLabel('TorpedoLauncher', false)
        elseif enh =='TorpedoRapidLoader' then
            if not Buffs['CybranTorpHealth2'] then
                BuffBlueprint {
                    Name = 'CybranTorpHealth2',
                    DisplayName = 'CybranTorpHealth2',
                    BuffType = 'CybranTorpHealth',
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
            Buff.ApplyBuff(self, 'CybranTorpHealth2')
            
            local torp = self:GetWeaponByLabel('TorpedoLauncher')
            torp:AddDamageMod(bp.TorpDamageMod)
            torp:ChangeRateOfFire(bp.NewTorpROF)
            
            -- Install Jury Rigged Ripper
            self:TogglePrimaryGun(bp.NewRoF, bp.NewMaxRadius)
        elseif enh =='TorpedoRapidLoaderRemove' then
            if Buff.HasBuff(self, 'CybranTorpHealth2') then
                Buff.RemoveBuff(self, 'CybranTorpHealth2')
            end
            
            local torp = self:GetWeaponByLabel('TorpedoLauncher')
            torp:AddDamageMod(bp.TorpDamageMod)
            torp:ChangeRateOfFire(torp:GetBlueprint().RateOfFire)
            
            self:TogglePrimaryGun(bp.NewRoF)
        elseif enh =='TorpedoClusterLauncher' then
            if not Buffs['CybranTorpHealth3'] then
                BuffBlueprint {
                    Name = 'CybranTorpHealth3',
                    DisplayName = 'CybranTorpHealth3',
                    BuffType = 'CybranTorpHealth',
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
            Buff.ApplyBuff(self, 'CybranTorpHealth3')
            
            local torp = self:GetWeaponByLabel('TorpedoLauncher')
            torp:AddDamageMod(bp.TorpDamageMod)
            
            -- Improve Ripper
            local wep = self:GetWeaponByLabel('RightRipper')
            wep:AddDamageMod(bp.DamageMod)
        elseif enh =='TorpedoClusterLauncherRemove' then
            if Buff.HasBuff(self, 'CybranTorpHealth3') then
                Buff.RemoveBuff(self, 'CybranTorpHealth3')
            end

            local torp = self:GetWeaponByLabel('TorpedoLauncher')
            torp:AddDamageMod(bp.TorpDamageMod)

            local wep = self:GetWeaponByLabel('RightRipper')
            wep:AddDamageMod(bp.DamageMod)
            
        -- EMP Array
            
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

    
            self.RBDefTier1 = true
            self.RBDefTier2 = false
            self.RBDefTier3 = false

        elseif enh == 'ArmorPlatingRemove' then
            if Buff.HasBuff(self, 'CybranHealthBoost22') then
                Buff.RemoveBuff(self, 'CybranHealthBoost22')
            end
            self.wcAA01 = false
            self.wcAA02 = false

    
            self.RBDefTier1 = false
            self.RBDefTier2 = false
            self.RBDefTier3 = false

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

    
            self.RBDefTier1 = true
            self.RBDefTier2 = true
            self.RBDefTier3 = false

        elseif enh == 'StructuralIntegrityRemove' then
            if Buff.HasBuff(self, 'CybranHealthBoost22') then
                Buff.RemoveBuff(self, 'CybranHealthBoost22')
            end
            if Buff.HasBuff(self, 'CybranHealthBoost23') then
                Buff.RemoveBuff(self, 'CybranHealthBoost23')
            end
            self.wcAA01 = false
            self.wcAA02 = false

    
            self.RBDefTier1 = false
            self.RBDefTier2 = false
            self.RBDefTier3 = false

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

    
            self.RBDefTier1 = false
            self.RBDefTier2 = false
            self.RBDefTier3 = false

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

        elseif enh =='MobilitySubsystemsRemove' then
            self:SetSpeedMult(1)
            if Buff.HasBuff(self, 'CybranHealthBoost19') then
                Buff.RemoveBuff(self, 'CybranHealthBoost19')
            end
            self.RBComTier1 = false
            self.RBComTier2 = false
            self.RBComTier3 = false

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

    
            self.RBComTier1 = true
            self.RBComTier2 = true
            self.RBComTier3 = false

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

    
            self.RBComTier1 = false
            self.RBComTier2 = false
            self.RBComTier3 = false

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

    
            self.RBComTier1 = false
            self.RBComTier2 = false
            self.RBComTier3 = false

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
        ACUUnit.OnIntelEnabled(self)
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
        ACUUnit.OnIntelDisabled(self)
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
