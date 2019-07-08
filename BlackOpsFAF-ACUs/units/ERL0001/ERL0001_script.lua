-----------------------------------------------------------------
-- Author(s):  Exavier Macbeth
-- Summary  :  BlackOps: Adv Command Unit - Cybran ACU
-- Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local ACUUnit = import('/lua/defaultunits.lua').ACUUnit
local CWeapons = import('/lua/cybranweapons.lua')
local CCannonMolecularWeapon = CWeapons.CCannonMolecularWeapon
local CDFHeavyMicrowaveLaserGeneratorCom = CWeapons.CDFHeavyMicrowaveLaserGeneratorCom
local CDFOverchargeWeapon = CWeapons.CDFOverchargeWeapon
local CANTorpedoLauncherWeapon = CWeapons.CANTorpedoLauncherWeapon
local RocketPack = CWeapons.CDFRocketIridiumWeapon02
local EffectUtil = import('/lua/EffectUtilities.lua')
local Entity = import('/lua/sim/Entity.lua').Entity
local Buff = import('/lua/sim/Buff.lua')
local DefineBasicBuff = import('/lua/sim/BuffDefinitions.lua').DefineBasicBuff
local DeathNukeWeapon = import('/lua/sim/defaultweapons.lua').DeathNukeWeapon
local ACUsWeapons = import('/mods/BlackOpsFAF-ACUs/lua/ACUsWeapons.lua')
local EMPWeapon = ACUsWeapons.EMPWeapon
local CEMPArrayBeam = ACUsWeapons.CEMPArrayBeam
local CEMPArrayBeam02 = ACUsWeapons.CEMPArrayBeam02

ERL0001 = Class(ACUUnit) {
    DeathThreadDestructionWaitTime = 2,
    PainterRange = {},
    RightGunLabel = 'RightRipper',
    RightGunUpgrade = 'JuryRiggedRipper',
    RightGunBone = 'Right_Upgrade',
    WeaponEnabled = {}, -- Storage for upgrade weapons status

    Weapons = {
        DeathWeapon = Class(DeathNukeWeapon) {},
        RightRipper = Class(CCannonMolecularWeapon) {},
        TargetPainter = Class(CEMPArrayBeam) {},
        RocketPack = Class(RocketPack) {},
        TorpedoLauncher = Class(CANTorpedoLauncherWeapon) {},
        EMPShot01 = Class(EMPWeapon) {},
        EMPShot02 = Class(EMPWeapon) {},
        EMPShot03 = Class(EMPWeapon) {},
        MLG01 = Class(CDFHeavyMicrowaveLaserGeneratorCom) {},
        MLG02 = Class(CDFHeavyMicrowaveLaserGeneratorCom) {},
        MLG03 = Class(CDFHeavyMicrowaveLaserGeneratorCom) {},
        AA01 = Class(CEMPArrayBeam02) {},
        AA02 = Class(CEMPArrayBeam02) {},
        AA03 = Class(CEMPArrayBeam02) {},
        AA04 = Class(CEMPArrayBeam02) {},
        OverCharge = Class(CDFOverchargeWeapon) {},
        AutoOverCharge = Class(CDFOverchargeWeapon) {},
    },

    -- Hooked Functions
    OnCreate = function(self)
        ACUUnit.OnCreate(self)

        self.EMPArrayEffects01 = {}
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        ACUUnit.OnStopBeingBuilt(self, builder, layer)

        -- Shut off intel to be enabled later
        self:DisableUnitIntel('Enhancement', 'RadarStealth')
        self:DisableUnitIntel('Enhancement', 'SonarStealth')
        self:DisableUnitIntel('Enhancement', 'Cloak')
        self:DisableUnitIntel('Enhancement', 'Sonar')
    end,

    OnScriptBitClear = function(self, bit)
        if bit == 8 then -- Cloak toggle
            self:PlayUnitAmbientSound('ActiveLoop')
            self:SetMaintenanceConsumptionActive()
            self:EnableUnitIntel('ToggleBit8', 'Cloak')
            self:EnableUnitIntel('ToggleBit8', 'RadarStealth')
            self:EnableUnitIntel('ToggleBit8', 'SonarStealth')

            if self.MaintenanceConsumption then
                self.ToggledOff = false
            end
        else
            ACUUnit.OnScriptBitClear(self, bit)
        end
    end,

    OnScriptBitSet = function(self, bit)
        if bit == 8 then -- Cloak toggle
            self:StopUnitAmbientSound('ActiveLoop')
            self:SetMaintenanceConsumptionInactive()
            self:DisableUnitIntel('ToggleBit8', 'Cloak')
            self:DisableUnitIntel('ToggleBit8', 'RadarStealth')
            self:DisableUnitIntel('ToggleBit8', 'SonarStealth')

            if not self.MaintenanceConsumption then
                self.ToggledOff = true
            end
        else
            ACUUnit.OnScriptBitSet(self, bit)
        end
    end,

    CreateBuildEffects = function(self, unitBeingBuilt, order)
       EffectUtil.SpawnBuildBots(self, unitBeingBuilt, 5, self.BuildEffectsBag)
       EffectUtil.CreateCybranBuildBeams(self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag)
    end,

    CreateEnhancement = function(self, enh, removal)
        ACUUnit.CreateEnhancement(self, enh)

        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end

        if enh == 'ImprovedEngineering' then
            self:RemoveBuildRestriction(categories.CYBRAN * categories.BUILTBYTIER2COMMANDER)
            self:updateBuildRestrictions()
            self:SetProduction(bp)

            DefineBasicBuff('CYBRANACUT2BuildRate', 'ACUBUILDRATE', 'STACKS', bp.NewBuildRate, bp.NewHealth, bp.NewRegenRate)
            Buff.ApplyBuff(self, 'CYBRANACUT2BuildRate')
        elseif enh == 'ImprovedEngineeringRemove' then
            Buff.RemoveBuff(self, 'CYBRANACUT2BuildRate')

            self:AddBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER))
            self:SetProduction()
        elseif enh == 'AdvancedEngineering' then
            self:RemoveBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER3COMMANDER))
            self:updateBuildRestrictions()
            self:SetProduction(bp)

            DefineBasicBuff('CYBRANACUT3BuildRate', 'ACUBUILDRATE', 'STACKS', bp.NewBuildRate, bp.NewHealth, bp.NewRegenRate)
            Buff.ApplyBuff(self, 'CYBRANACUT3BuildRate')
        elseif enh == 'AdvancedEngineeringRemove' then
            Buff.RemoveBuff(self, 'CYBRANACUT3BuildRate')

            self:AddBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER))
            self:SetProduction()
        elseif enh == 'ExperimentalEngineering' then
            self:RemoveBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER4COMMANDER))
            self:updateBuildRestrictions()
            self:SetProduction(bp)

            DefineBasicBuff('CYBRANACUT4BuildRate', 'ACUBUILDRATE', 'STACKS', bp.NewBuildRate, bp.NewHealth, bp.NewRegenRate)
            Buff.ApplyBuff(self, 'CYBRANACUT4BuildRate')
        elseif enh == 'ExperimentalEngineeringRemove' then
            Buff.RemoveBuff(self, 'CYBRANACUT4BuildRate')

            self:AddBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER))
            self:SetProduction()
        elseif enh == 'CombatEngineering' then
            self:RemoveBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER2COMMANDER))
            self:updateBuildRestrictions()

            DefineBasicBuff('CYBRANACUT2BuildCombat', 'ACUBUILDRATE', 'STACKS', bp.NewBuildRate, bp.NewHealth, bp.NewRegenRate)
            Buff.ApplyBuff(self, 'CYBRANACUT2BuildCombat')

            self:SetWeaponEnabledByLabel('RocketPack', true)
        elseif enh == 'CombatEngineeringRemove' then
            Buff.RemoveBuff(self, 'CYBRANACUT2BuildCombat')

            self:AddBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER))
            self:SetWeaponEnabledByLabel('RocketPack', false)
        elseif enh == 'AssaultEngineering' then
            self:RemoveBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER3COMMANDER))
            self:updateBuildRestrictions()

            DefineBasicBuff('CYBRANACUT3BuildCombat', 'ACUBUILDRATE', 'STACKS', bp.NewBuildRate, bp.NewHealth, bp.NewRegenRate)
            Buff.ApplyBuff(self, 'CYBRANACUT3BuildCombat')

            local gun = self:GetWeaponByLabel('RocketPack')
            gun:AddDamageMod(bp.RocketDamageMod)
            gun:ChangeMaxRadius(bp.RocketMaxRadius)

            self:SetPainterRange(enh, bp.RocketMaxRadius)
        elseif enh == 'AssaultEngineeringRemove' then
            Buff.RemoveBuff(self, 'CYBRANACUT3BuildCombat')

            self:AddBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER))

            local gun = self:GetWeaponByLabel('RocketPack')
            gun:AddDamageMod(bp.RocketDamageMod)
            gun:ChangeMaxRadius(gun:GetBlueprint().MaxRadius)

            self:SetPainterRange('AssaultEngineering')
        elseif enh == 'ApocalypticEngineering' then
            self:RemoveBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER4COMMANDER))
            self:updateBuildRestrictions()

            DefineBasicBuff('CYBRANACUT4BuildCombat', 'ACUBUILDRATE', 'STACKS', bp.NewBuildRate, bp.NewHealth, bp.NewRegenRate)
            Buff.ApplyBuff(self, 'CYBRANACUT4BuildCombat')
        elseif enh == 'ApocalypticEngineeringRemove' then
            Buff.RemoveBuff(self, 'CYBRANACUT4BuildCombat')

            self:AddBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER))

        -- Jury Rigged Ripper

        elseif enh == 'JuryRiggedRipper' then
            self:TogglePrimaryGun(bp.NewRoF, bp.NewMaxRadius)
        elseif enh == 'JuryRiggedRipperRemove' then
            self:TogglePrimaryGun(bp.NewRoF)

        -- Torpedoes

        elseif enh == 'TorpedoLauncher' then
            DefineBasicBuff('CybranTorpHealth1', 'CybranTorpHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'CybranTorpHealth1')

            self:SetWeaponEnabledByLabel('TorpedoLauncher', true)
            self:EnableUnitIntel('Enhancement', 'Sonar')
        elseif enh == 'TorpedoLauncherRemove' then
            Buff.RemoveBuff(self, 'CybranTorpHealth1')

            self:SetWeaponEnabledByLabel('TorpedoLauncher', false)
            self:DisableUnitIntel('Enhancement', 'Sonar')
        elseif enh == 'ImprovedReloader' then
            DefineBasicBuff('CybranTorpHealth2', 'CybranTorpHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'CybranTorpHealth2')

            local torp = self:GetWeaponByLabel('TorpedoLauncher')
            torp:AddDamageMod(bp.TorpDamageMod)
            torp:ChangeRateOfFire(bp.NewTorpROF)

            -- Install Jury Rigged Ripper
            self:TogglePrimaryGun(bp.NewRoF, bp.NewMaxRadius)
        elseif enh == 'ImprovedReloaderRemove' then
            Buff.RemoveBuff(self, 'CybranTorpHealth2')

            local torp = self:GetWeaponByLabel('TorpedoLauncher')
            torp:AddDamageMod(bp.TorpDamageMod)
            torp:ChangeRateOfFire(torp:GetBlueprint().RateOfFire)

            self:TogglePrimaryGun(bp.NewRoF)
        elseif enh == 'AdvancedWarheads' then
            DefineBasicBuff('CybranTorpHealth3', 'CybranTorpHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'CybranTorpHealth3')

            local torp = self:GetWeaponByLabel('TorpedoLauncher')
            torp:AddDamageMod(bp.TorpDamageMod)

            -- Improve Ripper
            local wep = self:GetWeaponByLabel('RightRipper')
            wep:AddDamageMod(bp.DamageMod)
        elseif enh == 'AdvancedWarheadsRemove' then
            Buff.RemoveBuff(self, 'CybranTorpHealth3')

            local torp = self:GetWeaponByLabel('TorpedoLauncher')
            torp:AddDamageMod(bp.TorpDamageMod)

            local wep = self:GetWeaponByLabel('RightRipper')
            wep:AddDamageMod(bp.DamageMod)

        -- EMP Array

        elseif enh == 'EMPArray' then
            DefineBasicBuff('CybranEMPHealth1', 'CybranEMPHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'CybranEMPHealth1')

            self:SetWeaponEnabledByLabel('EMPShot01', true)
            local wep = self:GetWeaponByLabel('EMPShot01')
            wep:ChangeMaxRadius(bp.EMPRange)

            self:SetPainterRange(enh, bp.EMPRange)
        elseif enh == 'EMPArrayRemove' then
            Buff.RemoveBuff(self, 'CybranEMPHealth1')

            self:SetWeaponEnabledByLabel('EMPShot01', false)
            local wep = self:GetWeaponByLabel('EMPShot01')
            wep:ChangeMaxRadius(wep:GetBlueprint().MaxRadius)

            self:SetPainterRange('EMPArray')
        elseif enh == 'AdjustedCrystalMatrix' then
            DefineBasicBuff('CybranEMPHealth2', 'CybranEMPHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'CybranEMPHealth2')

            self:SetWeaponEnabledByLabel('EMPShot01', false)
            self:SetWeaponEnabledByLabel('EMPShot02', true)

            local wep = self:GetWeaponByLabel('EMPShot02')
            wep:ChangeMaxRadius(bp.EMPRange)

            self:SetPainterRange(enh, bp.EMPRange)

            -- Install Jury Rigged Ripper
            self:TogglePrimaryGun(bp.NewRoF, bp.NewMaxRadius)
        elseif enh == 'AdjustedCrystalMatrixRemove' then
            Buff.RemoveBuff(self, 'CybranEMPHealth2')

            self:SetWeaponEnabledByLabel('EMPShot02', false)
            local wep = self:GetWeaponByLabel('EMPShot02')
            wep:ChangeMaxRadius(wep:GetBlueprint().MaxRadius)

            self:SetPainterRange('AdjustedCrystalMatrix')

            self:TogglePrimaryGun(bp.NewRoF)
        elseif enh == 'EnhancedLaserEmitters' then
            DefineBasicBuff('CybranEMPHealth3', 'CybranEMPHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'CybranEMPHealth3')

            self:SetWeaponEnabledByLabel('EMPShot02', false)
            self:SetWeaponEnabledByLabel('EMPShot03', true)

            local wep = self:GetWeaponByLabel('EMPShot03')
            wep:ChangeMaxRadius(bp.EMPRange)

            self:SetPainterRange(enh, bp.EMPRange)
        elseif enh == 'EnhancedLaserEmittersRemove' then
            Buff.RemoveBuff(self, 'CybranEMPHealth3')

            self:SetWeaponEnabledByLabel('EMPShot03', false)
            local wep = self:GetWeaponByLabel('EMPShot03')
            wep:ChangeMaxRadius(wep:GetBlueprint().MaxRadius)

            self:SetPainterRange('EnhancedLaserEmitters')

        -- Mazer

        elseif enh == 'Mazer' then
            DefineBasicBuff('CybranMazerHealth1', 'CybranMazerHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'CybranMazerHealth1')

            self:SetWeaponEnabledByLabel('MLG01', true)
        elseif enh == 'MazerRemove' then
            Buff.RemoveBuff(self, 'CybranMazerHealth1')

            self:SetWeaponEnabledByLabel('MLG01', false)
        elseif enh == 'AlternatingLaserAssembly' then
            DefineBasicBuff('CybranMazerHealth2', 'CybranMazerHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'CybranMazerHealth2')

            self:SetWeaponEnabledByLabel('MLG01', false)
            self:SetWeaponEnabledByLabel('MLG02', true)
            local laser = self:GetWeaponByLabel('MLG02')
            laser:ChangeMaxRadius(bp.LaserRange)

            self:SetPainterRange(enh, bp.LaserRange)

            -- Install Jury Rigged Ripper
            self:TogglePrimaryGun(bp.NewRoF, bp.NewMaxRadius)
        elseif enh == 'AlternatingLaserAssemblyRemove' then
            Buff.RemoveBuff(self, 'CybranMazerHealth2')

            self:SetWeaponEnabledByLabel('MLG02', false)
            local laser = self:GetWeaponByLabel('MLG02')
            laser:ChangeMaxRadius(laser:GetBlueprint().MaxRadius)

            self:SetPainterRange('AlternatingLaserAssembly')

            self:TogglePrimaryGun(bp.NewRoF)
        elseif enh == 'SuperconductivePowerConduits' then
            DefineBasicBuff('CybranMazerHealth3', 'CybranMazerHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'CybranMazerHealth3')

            self:SetWeaponEnabledByLabel('MLG02', false)
            self:SetWeaponEnabledByLabel('MLG03', true)
            local laser = self:GetWeaponByLabel('MLG03')
            laser:ChangeMaxRadius(bp.LaserRange)

            self:SetPainterRange(enh, bp.LaserRange)
        elseif enh == 'SuperconductivePowerConduitsRemove' then
            Buff.RemoveBuff(self, 'CybranMazerHealth3')

            self:SetWeaponEnabledByLabel('MLG03', false)
            local laser = self:GetWeaponByLabel('MLG03')
            laser:ChangeMaxRadius(laser:GetBlueprint().MaxRadius)

            self:SetPainterRange('SuperconductivePowerConduits')

        -- Armor System

        elseif enh == 'ArmorPlating' then
            DefineBasicBuff('CybranArmorHealth1', 'CybranArmorHealth', 'STACKS', nil, bp.NewHealth, bp.NewRegenRate)
            Buff.ApplyBuff(self, 'CybranArmorHealth1')

            self:SetWeaponEnabledByLabel('AA01', true)
            self:SetWeaponEnabledByLabel('AA02', true)
        elseif enh == 'ArmorPlatingRemove' then
            Buff.RemoveBuff(self, 'CybranArmorHealth1')

            self:SetWeaponEnabledByLabel('AA01', false)
            self:SetWeaponEnabledByLabel('AA02', false)
        elseif enh == 'StructuralIntegrityFields' then
            DefineBasicBuff('CybranArmorHealth2', 'CybranArmorHealth', 'STACKS', nil, bp.NewHealth, bp.NewRegenRate)
            Buff.ApplyBuff(self, 'CybranArmorHealth2')

            self:SetWeaponEnabledByLabel('AA03', true)
            self:SetWeaponEnabledByLabel('AA04', true)
        elseif enh == 'StructuralIntegrityFieldsRemove' then
            Buff.RemoveBuff(self, 'CybranArmorHealth2')

            self:SetWeaponEnabledByLabel('AA03', false)
            self:SetWeaponEnabledByLabel('AA04', false)
        elseif enh == 'CompositeMaterials' then
            DefineBasicBuff('CybranArmorHealth3', 'CybranArmorHealth', 'STACKS', nil, bp.NewHealth, bp.NewRegenRate)
            Buff.ApplyBuff(self, 'CybranArmorHealth3')
        elseif enh == 'CompositeMaterialsRemove' then
            Buff.RemoveBuff(self, 'CybranArmorHealth3')

        -- Counter-Intel Systems

        elseif enh == 'ElectronicsEnhancment' then
            DefineBasicBuff('CybranIntelHealth1', 'CybranIntelHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'CybranIntelHealth1')

            if ScenarioInfo.Options.OmniCheat ~= "on" or self:GetAIBrain().BrainType == 'Human' then
                self:SetIntelRadius('Vision', bp.NewVisionRadius)
                self:SetIntelRadius('WaterVision', bp.NewVisionRadius)
                self:SetIntelRadius('Omni', bp.NewOmniRadius)
            end
        elseif enh == 'ElectronicsEnhancmentRemove' then
            Buff.RemoveBuff(self, 'CybranIntelHealth1')

            local bpIntel = self:GetBlueprint().Intel
            if ScenarioInfo.Options.OmniCheat ~= "on" or self:GetAIBrain().BrainType == 'Human' then
                self:SetIntelRadius('Vision', bpIntel.VisionRadius)
                self:SetIntelRadius('WaterVision', bpIntel.VisionRadius)
                self:SetIntelRadius('Omni', bpIntel.OmniRadius)
            end
        elseif enh == 'ElectronicCountermeasures' then
            DefineBasicBuff('CybranIntelHealth2', 'CybranIntelHealth', 'STACKS', nil, bp.NewHealth, bp.NewRegenRate)
            Buff.ApplyBuff(self, 'CybranIntelHealth2')

            if self.IntelEffectsBag then
                EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
                self.IntelEffectsBag = nil
            end

            self:AddToggleCap('RULEUTC_StealthToggle')
            self:EnableUnitIntel('Enhancement', 'RadarStealth')
            self:EnableUnitIntel('Enhancement', 'SonarStealth')
        elseif enh == 'ElectronicCountermeasuresRemove' then
            Buff.RemoveBuff(self, 'CybranIntelHealth2')

            self:RemoveToggleCap('RULEUTC_StealthToggle')
            self:DisableUnitIntel('Enhancement', 'RadarStealth')
            self:DisableUnitIntel('Enhancement', 'SonarStealth')
        elseif enh == 'CloakingSubsystems' then
            DefineBasicBuff('CybranIntelHealth3', 'CybranIntelHealth', 'STACKS', nil, bp.NewHealth, bp.NewRegenRate)
            Buff.ApplyBuff(self, 'CybranIntelHealth3')

            self:RemoveToggleCap('RULEUTC_StealthToggle')
            self:AddToggleCap('RULEUTC_CloakToggle')
            self:EnableUnitIntel('Enhancement', 'Cloak')
        elseif enh == 'CloakingSubsystemsRemove' then
            Buff.RemoveBuff(self, 'CybranIntelHealth3')

            self:RemoveToggleCap('RULEUTC_CloakToggle')
            self:DisableUnitIntel('Enhancement', 'Cloak')

        -- Mobility Systems

        elseif enh == 'ActuatorReplacement' then
            DefineBasicBuff('CybranMobilityHealth1', 'CybranMobilityHealth', 'STACKS', nil, bp.NewHealth, bp.NewRegenRate)
            Buff.ApplyBuff(self, 'CybranMobilityHealth1')

            self:SetSpeedMult(2)
        elseif enh == 'ActuatorReplacementRemove' then
            Buff.RemoveBuff(self, 'CybranMobilityHealth1')

            self:SetSpeedMult(1)
        elseif enh == 'AntiAirSubsystem' then
            DefineBasicBuff('CybranMobilityHealth2', 'CybranMobilityHealth', 'STACKS', nil, bp.NewHealth, bp.NewRegenRate)
            Buff.ApplyBuff(self, 'CybranMobilityHealth2')

            self:AddCommandCap('RULEUCC_Teleport')

            self:SetWeaponEnabledByLabel('AA01', true)
            self:SetWeaponEnabledByLabel('AA02', true)
        elseif enh == 'AntiAirSubsystemRemove' then
            Buff.RemoveBuff(self, 'CybranMobilityHealth2')

            self:RemoveCommandCap('RULEUCC_Teleport')

            self:SetWeaponEnabledByLabel('AA01', false)
            self:SetWeaponEnabledByLabel('AA02', false)
        elseif enh == 'NanoRegenerationSubsystem' then
            DefineBasicBuff('CybranMobilityHealth3', 'CybranMobilityHealth', 'STACKS', nil, bp.NewHealth, bp.NewRegenRate)
            Buff.ApplyBuff(self, 'CybranMobilityHealth3')
        elseif enh == 'NanoRegenerationSubsystemRemove' then
            Buff.RemoveBuff(self, 'CybranMobilityHealth3')
        end

        -- Remove prerequisites
        if not removal then
            for _, v in bp.RemoveEnhancements or {} do
                if string.sub(v, -6) ~= 'Remove' and v ~= string.sub(enh, 0, -7) then
                    self:CreateEnhancement(v .. 'Remove', true)
                end
            end
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
        if self:HasEnhancement('CloakingSubsystems') and self:IsIntelEnabled('Cloak') then
            self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Enhancements['CloakingSubsystems'].MaintenanceConsumptionPerSecondEnergy)
            self:SetMaintenanceConsumptionActive()
            if not self.IntelEffectsBag then
                self.IntelEffectsBag = {}
                self.CreateTerrainTypeEffects(self, self.IntelEffects.Cloak, 'FXIdle',  self:GetCurrentLayer(), nil, self.IntelEffectsBag)
            end
        elseif self:HasEnhancement('ElectronicCountermeasures') and self:IsIntelEnabled('RadarStealth') and self:IsIntelEnabled('SonarStealth') then
            self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Enhancements['ElectronicCountermeasures'].MaintenanceConsumptionPerSecondEnergy)
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
        if self:HasEnhancement('CloakingSubsystems') and not self:IsIntelEnabled('Cloak') then
            self:SetMaintenanceConsumptionInactive()
        elseif self:HasEnhancement('ElectronicCountermeasures') and not self:IsIntelEnabled('RadarStealth') and not self:IsIntelEnabled('SonarStealth') then
            self:SetMaintenanceConsumptionInactive()
        end
    end,

    -- New Functions

    -- Overwrite, Cybran changes RateOfFire not Damage
    TogglePrimaryGun = function(self, rof, radius)
        local wep = self:GetWeaponByLabel(self.RightGunLabel)
        local oc = self:GetWeaponByLabel('OverCharge')
        local aoc = self:GetWeaponByLabel('AutoOverCharge')

        local wepRadius = radius or wep:GetBlueprint().MaxRadius
        local ocRadius = radius or oc:GetBlueprint().MaxRadius
        local aocRadius = radius or aoc:GetBlueprint().MaxRadius

        -- Change Damage
        wep:ChangeRateOfFire(rof)

        -- Change Radius
        wep:ChangeMaxRadius(wepRadius)
        oc:ChangeMaxRadius(ocRadius)
        aoc:ChangeMaxRadius(aocRadius)

        self:SetPainterRange(self.RightGunUpgrade, radius)

        -- As radius is only passed when turning on, use the bool
        if radius then
            self:ShowBone('Right_Upgrade', true)
        else
            self:HideBone('Right_Upgrade', true)
        end
    end,
}

TypeClass = ERL0001
