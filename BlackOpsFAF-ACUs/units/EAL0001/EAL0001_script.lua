-----------------------------------------------------------------
-- Author(s):  avier Macbeth
-- Summary  :  BlackOps: Adv Command Unit - Aeon ACU
-- Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local ACUUnit = import('/lua/defaultunits.lua').ACUUnit
local DeathNukeWeapon = import('/lua/sim/defaultweapons.lua').DeathNukeWeapon
local EffectUtil = import('/lua/EffectUtilities.lua')
local Buff = import('/lua/sim/Buff.lua')
local DefineBasicBuff = import('/lua/sim/BuffDefinitions.lua').DefineBasicBuff
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker

local AWeapons = import('/lua/aeonweapons.lua')
local ADFDisruptorCannonWeapon = AWeapons.ADFDisruptorCannonWeapon
local ADFOverchargeWeapon = AWeapons.ADFOverchargeWeapon
local ADFChronoDampener = AWeapons.ADFChronoDampener
local AIFArtilleryMiasmaShellWeapon = AWeapons.AIFArtilleryMiasmaShellWeapon
local AANChronoTorpedoWeapon = AWeapons.AANChronoTorpedoWeapon
local AAMWillOWisp = AWeapons.AAMWillOWisp

local ACUsWeapons = import('/mods/BlackOpsFAF-ACUs/lua/ACUsWeapons.lua')
local PhasonLaser = ACUsWeapons.PhasonLaser
local AIFQuasarAntiTorpedoWeapon = AWeapons.AIFQuasarAntiTorpedoWeapon
local CEMPArrayBeam = ACUsWeapons.CEMPArrayBeam
local QuantumMaelstromWeapon = ACUsWeapons.QuantumMaelstromWeapon

EAL0001 = Class(ACUUnit) {
    DeathThreadDestructionWaitTime = 2,
    PainterRange = {},
    RightGunLabel = 'RightDisruptor',
    RightGunUpgrade = 'DisruptorAmplifier',
    WeaponEnabled = {}, -- Storage for upgrade weapons status

    Weapons = {
        DeathWeapon = Class(DeathNukeWeapon) {},
        TargetPainter = Class(CEMPArrayBeam) {},
        RightDisruptor = Class(ADFDisruptorCannonWeapon) {},
        ChronoDampener = Class(ADFChronoDampener) {},
        ChronoDampener2 = Class(ADFChronoDampener) {},
        TorpedoLauncher = Class(AANChronoTorpedoWeapon) {},
        MiasmaArtillery = Class(AIFArtilleryMiasmaShellWeapon) {},
        PhasonBeam01 = Class(PhasonLaser) {},
        PhasonBeam02 = Class(PhasonLaser) {},
        PhasonBeam03 = Class(PhasonLaser) {},
        QuantumMaelstrom = Class(QuantumMaelstromWeapon) {},
        AntiTorpedo = Class(AIFQuasarAntiTorpedoWeapon) {},
        AntiMissile = Class(AAMWillOWisp) {},
        OverCharge = Class(ADFOverchargeWeapon) {},
        AutoOverCharge = Class(ADFOverchargeWeapon) {},
    },

    -- Hooked Functions
    OnStopBeingBuilt = function(self, builder, layer)
        ACUUnit.OnStopBeingBuilt(self, builder, layer)

        -- Remote Viewing ability setup
        self.RemoteViewingData = {
            RemoteViewingFunctions = {},
            DisableCounter = 0,
            IntelButton = true
        }
        self.Sync.Abilities = self:GetBlueprint().Abilities
        self.Sync.Abilities.TargetLocation.Active = false

        -- Maelstrom effects
        self.MaelstromEffectsBag = {}
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        ACUUnit.OnKilled(self, instigator, type, overkillRatio)

        if self.RemoteViewingData.Satellite then
            self.RemoteViewingData.Satellite:DisableIntel('Vision')
            self.RemoteViewingData.Satellite:Destroy()
        end
    end,

    OnScriptBitClear = function(self, bit)
        if bit == 0 then -- Shield toggle
            self:DisableShield()
            self:StopUnitAmbientSound('ActiveLoop')
        end
    end,

    OnScriptBitSet = function(self, bit)
        if bit == 0 then -- Shield toggle
            self:EnableShield()
            self:PlayUnitAmbientSound('ActiveLoop')
        end
    end,

    CreateBuildEffects = function(self, unitBeingBuilt, order)
        EffectUtil.CreateAeonCommanderBuildingEffects(self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag)
    end,

    CreateEnhancement = function(self, enh, removal)
        ACUUnit.CreateEnhancement(self, enh)

        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end

        if enh == 'ImprovedEngineering' then
            self:RemoveBuildRestriction(categories.AEON * (categories.BUILTBYTIER2COMMANDER))
            self:updateBuildRestrictions()
            self:SetProduction(bp)

            DefineBasicBuff('AEONACUT2BuildRate', 'ACUBUILDRATE', 'STACKS', bp.NewBuildRate, bp.NewHealth, bp.NewRegenRate)
            Buff.ApplyBuff(self, 'AEONACUT2BuildRate')
        elseif enh == 'ImprovedEngineeringRemove' then
            self:SetDefaultBuildRestrictions()
            self:SetProduction()

            Buff.RemoveBuff(self, 'AEONACUT2BuildRate')
        elseif enh == 'AdvancedEngineering' then
            self:RemoveBuildRestriction(categories.AEON * (categories.BUILTBYTIER3COMMANDER))
            self:updateBuildRestrictions()
            self:SetProduction(bp)

            DefineBasicBuff('AEONACUT3BuildRate', 'ACUBUILDRATE', 'STACKS', bp.NewBuildRate, bp.NewHealth, bp.NewRegenRate)
            Buff.ApplyBuff(self, 'AEONACUT3BuildRate')
        elseif enh == 'AdvancedEngineeringRemove' then
            self:SetDefaultBuildRestrictions()
            self:SetProduction()

            Buff.RemoveBuff(self, 'AEONACUT3BuildRate')
        elseif enh == 'ExperimentalEngineering' then
            self:RemoveBuildRestriction(categories.AEON * (categories.BUILTBYTIER4COMMANDER))
            self:updateBuildRestrictions()
            self:SetProduction(bp)

            DefineBasicBuff('AEONACUT4BuildRate', 'ACUBUILDRATE', 'STACKS', bp.NewBuildRate, bp.NewHealth, bp.NewRegenRate)
            Buff.ApplyBuff(self, 'AEONACUT4BuildRate')
        elseif enh == 'ExperimentalEngineeringRemove' then
            self:SetDefaultBuildRestrictions()
            self:SetProduction()

            Buff.RemoveBuff(self, 'AEONACUT4BuildRate')
        elseif enh == 'CombatEngineering' then
            self:RemoveBuildRestriction(categories.AEON * (categories.BUILTBYTIER2COMMANDER))
            self:updateBuildRestrictions()

            DefineBasicBuff('AEONACUT2BuildCombat', 'ACUBUILDRATE', 'STACKS', bp.NewBuildRate, bp.NewHealth, bp.NewRegenRate)
            Buff.ApplyBuff(self, 'AEONACUT2BuildCombat')

            self.ChronoDampener:SetWeaponEnabled(true)
            self.ChronoDampener:ChangeMaxRadius(bp.ChronoRadius)
        elseif enh == 'CombatEngineeringRemove' then
            self:SetDefaultBuildRestrictions()
            self:SetWeaponEnabledByLabel('ChronoDampener', false)

            Buff.RemoveBuff(self, 'AEONACUT2BuildCombat')

            self.ChronoDampener:ChangeMaxRadius(self.ChronoDampener:GetBlueprint().MaxRadius)
        elseif enh == 'AssaultEngineering' then
            self:RemoveBuildRestriction(categories.AEON * (categories.BUILTBYTIER3COMMANDER))
            self:updateBuildRestrictions()

            DefineBasicBuff('AEONACUT3BuildCombat', 'ACUBUILDRATE', 'STACKS', bp.NewBuildRate, bp.NewHealth, bp.NewRegenRate)
            Buff.ApplyBuff(self, 'AEONACUT3BuildCombat')

            self.ChronoDampener:SetWeaponEnabled(false)

            self.ChronoDampener2:SetWeaponEnabled(true)
            self.ChronoDampener2:ChangeMaxRadius(bp.NewChronoRadius)
        elseif enh == 'AssaultEngineeringRemove' then
            self:SetDefaultBuildRestrictions()

            Buff.RemoveBuff(self, 'AEONACUT3BuildCombat')

            self.ChronoDampener2:SetWeaponEnabled(false)
            self.ChronoDampener2:ChangeMaxRadius(self.ChronoDampener2:GetBlueprint().MaxRadius)
        elseif enh == 'ApocalypticEngineering' then
            self:RemoveBuildRestriction(categories.AEON * (categories.BUILTBYTIER4COMMANDER))
            self:updateBuildRestrictions()

            DefineBasicBuff('AEONACUT4BuildCombat', 'ACUBUILDRATE', 'STACKS', bp.NewBuildRate, bp.NewHealth, bp.NewRegenRate)
            Buff.ApplyBuff(self, 'AEONACUT4BuildCombat')
        elseif enh == 'ApocalypticEngineeringRemove' then
            self:SetDefaultBuildRestrictions()

            Buff.RemoveBuff(self, 'AEONACUT4BuildCombat')

        -- Disruptor Amplifier
        elseif enh == 'JuryRiggedDisruptor' then
            self:TogglePrimaryGun(bp.NewDamage)
        elseif enh == 'JuryRiggedDisruptorRemove' then
            self:TogglePrimaryGun(bp.NewDamage)
        elseif enh == 'DisruptorAmplifier' then
            self:TogglePrimaryGun(0, bp.NewRadius)
        elseif enh == 'DisruptorAmplifierRemove' then
            self:TogglePrimaryGun(0)

        -- Torpedoes
        elseif enh == 'TorpedoLauncher' then
            DefineBasicBuff('AeonTorpHealth1', 'AeonTorpHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'AeonTorpHealth1')

            self.TorpedoLauncher:SetWeaponEnabled(true)
            self.AntiTorpedo:SetWeaponEnabled(true)
        elseif enh == 'TorpedoLauncherRemove' then
            Buff.RemoveBuff(self, 'AeonTorpHealth1')

            self.TorpedoLauncher:SetWeaponEnabled(false)
            self.AntiTorpedo:SetWeaponEnabled(false)
        elseif enh == 'ImprovedTorpLoader' then
            DefineBasicBuff('AeonTorpHealth2', 'AeonTorpHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'AeonTorpHealth2')

            self.TorpedoLauncher:AddDamageMod(bp.TorpDamage)
            self.TorpedoLauncher:ChangeRateOfFire(bp.TorpRoF)

            self:TogglePrimaryGun(bp.GunDamage)
        elseif enh == 'ImprovedTorpLoaderRemove' then
            Buff.RemoveBuff(self, 'AeonTorpHealth2')

            self.TorpedoLauncher:AddDamageMod(bp.TorpDamage)
            self.TorpedoLauncher:ChangeRateOfFire(self.TorpedoLauncher:GetBlueprint().RateOfFire)

            self:TogglePrimaryGun(bp.GunDamage)
        elseif enh == 'AdvancedWarheads' then
            DefineBasicBuff('AeonTorpHealth3', 'AeonTorpHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'AeonTorpHealth3')

            self.TorpedoLauncher:AddDamageMod(bp.TorpDamage)

            self:TogglePrimaryGun(bp.GunDamage)
        elseif enh == 'AdvancedWarheadsRemove' then
            Buff.RemoveBuff(self, 'AeonTorpHealth3')

            self.TorpedoLauncher:AddDamageMod(bp.TorpDamage)

            self:TogglePrimaryGun(bp.GunDamage)

        -- Artillery
        elseif enh == 'DualMiasmaArtillery' then
            DefineBasicBuff('AeonArtilleryHealth1', 'AeonArtilleryHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'AeonArtilleryHealth1')

            self.MiasmaArtillery:SetWeaponEnabled(true)
            self.MiasmaArtillery:ChangeMaxRadius(bp.ArtyRadius)
            self.MiasmaArtillery:ChangeMinRadius(bp.ArtyMinRadius)
            self:SetPainterRange(enh, bp.ArtyRadius)

            self:SpecialBones()
        elseif enh == 'DualMiasmaArtilleryRemove' then
            Buff.RemoveBuff(self, 'AeonArtilleryHealth1')

            local wepBp = self.MiasmaArtillery:GetBlueprint()
            self.MiasmaArtillery:SetWeaponEnabled(false)
            self.MiasmaArtillery:ChangeMaxRadius(wepBp.MaxRadius)
            self.MiasmaArtillery:ChangeMinRadius(wepBp.MinRadius)
            self:SetPainterRange('DualMiasmaArtillery')

            self:SpecialBones()
        elseif enh == 'AdvancedWarheadCompression' then
            DefineBasicBuff('AeonArtilleryHealth2', 'AeonArtilleryHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'AeonArtilleryHealth2')

            self.MiasmaArtillery:AddDamageMod(bp.ArtilleryDamage)

            self:TogglePrimaryGun(bp.NewDamage)
        elseif enh == 'AdvancedWarheadCompressionRemove' then
            Buff.RemoveBuff(self, 'AeonArtilleryHealth2')

            self.MiasmaArtillery:AddDamageMod(bp.ArtilleryDamage)

            self:TogglePrimaryGun(bp.NewDamage)
        elseif enh == 'ImprovedAutoLoader' then
            DefineBasicBuff('AeonArtilleryHealth3', 'AeonArtilleryHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'AeonArtilleryHealth3')

            self.MiasmaArtillery:AddDamageMod(bp.ArtilleryDamage)
            self.MiasmaArtillery:ChangeRateOfFire(bp.ArtilleryRoF)
        elseif enh == 'ImprovedAutoLoaderRemove' then
            Buff.RemoveBuff(self, 'AeonArtilleryHealth3')

            self.MiasmaArtillery:AddDamageMod(bp.ArtilleryDamage)
            self.MiasmaArtillery:ChangeRateOfFire(self.MiasmaArtillery:GetBlueprint().RateOfFire)

        --  Beam Weapon
        elseif enh == 'PhasonBeamCannon' then
            DefineBasicBuff('AeonBeamHealth1', 'AeonBeamHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'AeonBeamHealth1')

            self.PhasonBeam01:SetWeaponEnabled(true)
            self.PhasonBeam01:ChangeMaxRadius(bp.BeamRadius)
            self:SetPainterRange(enh, bp.BeamRadius)
        elseif enh == 'PhasonBeamCannonRemove' then
            Buff.RemoveBuff(self, 'AeonBeamHealth1')

            self.PhasonBeam01:SetWeaponEnabled(false)
            self.PhasonBeam01:ChangeMaxRadius(self.PhasonBeam01:GetBlueprint().MaxRadius)
            self:SetPainterRange('PhasonBeamCannon')
        elseif enh == 'DualChannelBooster' then
            DefineBasicBuff('AeonBeamHealth2', 'AeonBeamHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'AeonBeamHealth2')

            self.PhasonBeam01:SetWeaponEnabled(false)
            self.PhasonBeam02:SetWeaponEnabled(true)
            self.PhasonBeam02:ChangeMaxRadius(bp.BeamRadius)
            self:SetPainterRange(enh, bp.BeamRadius)

            self:TogglePrimaryGun(bp.NewDamage)
        elseif enh == 'DualChannelBoosterRemove' then
            Buff.RemoveBuff(self, 'AeonBeamHealth2')

            self.PhasonBeam02:SetWeaponEnabled(false)
            self.PhasonBeam02:ChangeMaxRadius(self.PhasonBeam02:GetBlueprint().MaxRadius)
            self:SetPainterRange('DualChannelBooster')

            self:TogglePrimaryGun(bp.NewDamage)
        elseif enh == 'EnergizedMolecularInducer' then
            DefineBasicBuff('AeonBeamHealth3', 'AeonBeamHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'AeonBeamHealth3')

            self.PhasonBeam02:SetWeaponEnabled(false)
            self.PhasonBeam03:SetWeaponEnabled(true)
            self.PhasonBeam03:ChangeMaxRadius(bp.BeamRadius)

            self:SetPainterRange(enh, bp.BeamRadius)
        elseif enh == 'EnergizedMolecularInducerRemove' then
            Buff.RemoveBuff(self, 'AeonBeamHealth3')

            self.PhasonBeam03:SetWeaponEnabled(false)
            self.PhasonBeam03:ChangeMaxRadius(self.PhasonBeam03:GetBlueprint().MaxRadius)
            self:SetPainterRange('EnergizedMolecularInducer')

        -- Shielding
        elseif enh == 'ShieldBattery' then
            self:AddToggleCap('RULEUTC_ShieldToggle')
            self:CreateShield(bp)
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            self:OnScriptBitSet(0)

            self:SpecialBones()
        elseif enh == 'ShieldBatteryRemove' then
            self:DestroyShield()
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
            self:OnScriptBitClear(0)

            self:SpecialBones()
        elseif enh == 'ImprovedShieldBattery' then
            self:DestroyShield()
            ForkThread(function() WaitTicks(1) self:CreateShield(bp) end)

            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            self:OnScriptBitSet(0)
        elseif enh == 'ImprovedShieldBatteryRemove' then
            self:DestroyShield()
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
            self:OnScriptBitClear(0)
        elseif enh == 'AdvancedShieldBattery' then
            self:DestroyShield()
            ForkThread(function() WaitTicks(1) self:CreateShield(bp) end)

            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            self:OnScriptBitSet(0)

            self.AntiMissile:SetWeaponEnabled(true)
        elseif enh == 'AdvancedShieldBatteryRemove' then
            self:DestroyShield()
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
            self:OnScriptBitClear(0)

            self.AntiMissile:SetWeaponEnabled(false)

        -- Intel
        elseif enh == 'ElectronicsEnhancment' then
            if ScenarioInfo.Options.OmniCheat ~= "on" or self:GetAIBrain().BrainType == 'Human' then
                self:SetIntelRadius('Vision', bp.NewVisionRadius)
                self:SetIntelRadius('WaterVision', bp.NewVisionRadius)
                self:SetIntelRadius('Omni', bp.NewOmniRadius)
            end

            DefineBasicBuff('AeonIntelHealth1', 'AeonIntelHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'AeonIntelHealth1')

            self.AntiMissile:SetWeaponEnabled(true)
        elseif enh == 'ElectronicsEnhancmentRemove' then
            local bpIntel = self:GetBlueprint().Intel
            if ScenarioInfo.Options.OmniCheat ~= "on" or self:GetAIBrain().BrainType == 'Human' then
                self:SetIntelRadius('Vision', bpIntel.VisionRadius)
                self:SetIntelRadius('WaterVision', bpIntel.VisionRadius)
                self:SetIntelRadius('Omni', bpIntel.OmniRadius)
            end

            Buff.RemoveBuff(self, 'AeonIntelHealth1')

            self.AntiMissile:SetWeaponEnabled(false)
        elseif enh == 'FarsightOptics' then
            self:ForkThread(self.EnableRemoteViewingButtons)

            DefineBasicBuff('AeonIntelHealth2', 'AeonIntelHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'AeonIntelHealth2')
        elseif enh == 'FarsightOpticsRemove' then
            self:ForkThread(self.DisableRemoteViewingButtons)

            Buff.RemoveBuff(self, 'AeonIntelHealth2')
        elseif enh == 'Teleporter' then
            self:AddCommandCap('RULEUCC_Teleport')

            DefineBasicBuff('AeonIntelHealth3', 'AeonIntelHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'AeonIntelHealth3')
        elseif enh == 'TeleporterRemove' then
            self:RemoveCommandCap('RULEUCC_Teleport')

            Buff.RemoveBuff(self, 'AeonIntelHealth3')

        -- Maelstrom
        elseif enh == 'MaelstromQuantum' then
            self:RefreshMaelstromEffects()

            DefineBasicBuff('AeonMaelstromHealth1', 'AeonMaelstromHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'AeonMaelstromHealth1')

            self.QuantumMaelstrom:SetWeaponEnabled(true)
            self.QuantumMaelstrom:ChangeMaxRadius(bp.MaelstromRadius)
        elseif enh == 'MaelstromQuantumRemove' then
            self:RefreshMaelstromEffects(true)

            Buff.RemoveBuff(self, 'AeonMaelstromHealth1')

            self.QuantumMaelstrom:SetWeaponEnabled(false)
            self.QuantumMaelstrom:ChangeMaxRadius(self.QuantumMaelstrom:GetBlueprint().MaxRadius)
        elseif enh == 'DistortionAmplifier' then
            DefineBasicBuff('AeonMaelstromHealth2', 'AeonMaelstromHealth', 'STACKS', nil, bp.NewHealth, bp.NewRegenRate)
            Buff.ApplyBuff(self, 'AeonMaelstromHealth2')

            -- Can't use normal methods here due to how the weapon script works
            self.QuantumMaelstrom.CurrentDamage = bp.MaelstromDamage

            self.AntiMissile:SetWeaponEnabled(true)
        elseif enh == 'DistortionAmplifierRemove' then
            self:RefreshMaelstromEffects(true)

            Buff.RemoveBuff(self, 'AeonMaelstromHealth2')

            self.QuantumMaelstrom.CurrentDamage = self.QuantumMaelstrom:GetBlueprint().Damage

            self.AntiMissile:SetWeaponEnabled(false)
        elseif enh == 'QuantumInstability' then
            DefineBasicBuff('AeonMaelstromHealth3', 'AeonMaelstromHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'AeonMaelstromHealth3')

            -- Can't use normal methods here due to how the weapon script works
            self.QuantumMaelstrom.CurrentDamage = bp.MaelstromDamage
            self.QuantumMaelstrom.CurrentDamageRadius = bp.MaelstromRadius
            self.QuantumMaelstrom:ChangeMaxRadius(bp.MaelstromRadius)
        elseif enh == 'QuantumInstabilityRemove' then
            self:RefreshMaelstromEffects(true)

            Buff.RemoveBuff(self, 'AeonMaelstromHealth3')

            local wepBlueprint = self.QuantumMaelstrom:GetBlueprint()
            self.QuantumMaelstrom.CurrentDamage = wepBlueprint.Damage
            self.QuantumMaelstrom.CurrentDamageRadius = wepBlueprint.DamageRadius
            self.QuantumMaelstrom:ChangeMaxRadius(wepBlueprint.MaxRadius)
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
    },

    -- New Functions
    DisableRemoteViewingButtons = function(self)
        self.Sync.Abilities = self:GetBlueprint().Abilities
        self.Sync.Abilities.TargetLocation.Active = false
        self:AddToggleCap('RULEUTC_IntelToggle')
        self:RemoveToggleCap('RULEUTC_IntelToggle')
    end,

    EnableRemoteViewingButtons = function(self)
        self.Sync.Abilities = self:GetBlueprint().Abilities
        self.Sync.Abilities.TargetLocation.Active = true
        self:AddToggleCap('RULEUTC_IntelToggle')
        self:RemoveToggleCap('RULEUTC_IntelToggle')
    end,

    RemoteCheck = function(self)
        if self:HasEnhancement('FarsightOptics') and self.ScryActive then
            self:DisableRemoteViewingButtons()
            WaitSeconds(10)

            if self:HasEnhancement('FarsightOptics') then
                self:EnableRemoteViewingButtons()
            end
        end
    end,

    OnTargetLocation = function(self, location)
        -- Initial energy drain here - we drain resources instantly when an eye is relocated (including initial move)
        local aiBrain = self:GetAIBrain()
        local bp = self:GetBlueprint()
        local have = aiBrain:GetEconomyStored('ENERGY')
        local need = bp.Economy.InitialRemoteViewingEnergyDrain

        if have < need then return end

        local selfpos = self:GetPosition()
        local destRange = VDist2(location[1], location[3], selfpos[1], selfpos[3])
        if destRange <= 300 then
            aiBrain:TakeResource('ENERGY', bp.Economy.InitialRemoteViewingEnergyDrain)

            self.RemoteViewingData.VisibleLocation = location
            self:CreateVisibleEntity()
            self.ScryActive = true
            self:ForkThread(self.RemoteCheck)
        end
    end,

    CreateVisibleEntity = function(self)
        -- Only give a visible area if we have a location and intel button enabled
        if not self.RemoteViewingData.VisibleLocation then return end

        if self.RemoteViewingData.VisibleLocation and self.RemoteViewingData.DisableCounter == 0 and self.RemoteViewingData.IntelButton then
            local bp = self:GetBlueprint()
            -- Create new visible area
            if not self.RemoteViewingData.Satellite then
                local spec = {
                    X = self.RemoteViewingData.VisibleLocation[1],
                    Z = self.RemoteViewingData.VisibleLocation[3],
                    Radius = bp.Intel.RemoteViewingRadius,
                    LifeTime = -1,
                    Omni = false,
                    Radar = false,
                    Vision = true,
                    Army = self:GetAIBrain():GetArmyIndex(),
                }
                self.RemoteViewingData.Satellite = VizMarker(spec)
                self.Trash:Add(self.RemoteViewingData.Satellite)
            else
                -- Move and reactivate old visible area
                if not self.RemoteViewingData.Satellite:BeenDestroyed() then
                    Warp(self.RemoteViewingData.Satellite, self.RemoteViewingData.VisibleLocation)
                    self.RemoteViewingData.Satellite:EnableIntel('Vision')
                end
            end
            self:ForkThread(self.DisableVisibleEntity)
        end
    end,

    DisableVisibleEntity = function(self)
        -- Visible entity already off
        WaitSeconds(5)

        if self.RemoteViewingData.DisableCounter > 1 then return end

        -- Disable vis entity and monitor resources
        if not self:IsDead() and self.RemoteViewingData.Satellite then
            self.RemoteViewingData.Satellite:DisableIntel('Vision')
        end
    end,

    SpecialBones = function(self)
        if self:HasEnhancement('ShieldBattery') and self:HasEnhancement('DualMiasmaArtillery') then
            self:ShowBone('ShieldPack_Arty_LArm', true)
            self:ShowBone('ShieldPack_Arty_RArm', true)
            self:ShowBone('ShieldPack_Artillery', true)
            self:HideBone('ShieldPack_Normal', true)
            self:HideBone('Shoulder_Normal_L', true)
            self:HideBone('Shoulder_Normal_R', true)
        elseif self:HasEnhancement('ShieldBattery') or self:HasEnhancement('DualMiasmaArtillery') then
            self:HideBone('ShieldPack_Arty_LArm', true)
            self:HideBone('ShieldPack_Arty_RArm', true)
            self:HideBone('ShieldPack_Artillery', true)
        end
    end,

    RefreshMaelstromEffects = function(self, remove)
        -- Remove all current effects and reset the bag
        EffectUtil.CleanupEffectBag(self, 'MaelstromEffectsBag')

        -- Just return here if we are only removing
        if remove then return end

        -- Create all the many effects we need
        table.insert(self.MaelstromEffectsBag, CreateAttachedEmitter(self, 'Torso', self:GetArmy(), '/mods/BlackOpsFAF-ACUs/effects/emitters/maelstrom_aura_01_emit.bp'):ScaleEmitter(1):OffsetEmitter(0, -2, 0))
        table.insert(self.MaelstromEffectsBag, CreateAttachedEmitter(self, 'Torso', self:GetArmy(), '/mods/BlackOpsFAF-ACUs/effects/emitters/maelstrom_aura_02_emit.bp'):ScaleEmitter(1):OffsetEmitter(0, -2.75, 0))
        table.insert(self.MaelstromEffectsBag, CreateAttachedEmitter(self, 'DamagePack_LArm', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_02_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.05, 0))
        table.insert(self.MaelstromEffectsBag, CreateAttachedEmitter(self, 'DamagePack_LArm', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_03_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.05, 0))
        table.insert(self.MaelstromEffectsBag, CreateAttachedEmitter(self, 'DamagePack_LArm', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_04_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.05, 0))
        table.insert(self.MaelstromEffectsBag, CreateAttachedEmitter(self, 'DamagePack_RArm', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_02_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.05, 0))
        table.insert(self.MaelstromEffectsBag, CreateAttachedEmitter(self, 'DamagePack_RArm', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_03_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.05, 0))
        table.insert(self.MaelstromEffectsBag, CreateAttachedEmitter(self, 'DamagePack_RArm', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_04_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.05, 0))
        table.insert(self.MaelstromEffectsBag, CreateAttachedEmitter(self, 'DamagePack_RLeg_B01', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_02_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.1, 0))
        table.insert(self.MaelstromEffectsBag, CreateAttachedEmitter(self, 'DamagePack_RLeg_B01', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_03_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.1, 0))
        table.insert(self.MaelstromEffectsBag, CreateAttachedEmitter(self, 'DamagePack_RLeg_B01', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_04_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.1, 0))
        table.insert(self.MaelstromEffectsBag, CreateAttachedEmitter(self, 'DamagePack_RLeg_B02', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_02_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.15, 0))
        table.insert(self.MaelstromEffectsBag, CreateAttachedEmitter(self, 'DamagePack_RLeg_B02', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_03_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.15, 0))
        table.insert(self.MaelstromEffectsBag, CreateAttachedEmitter(self, 'DamagePack_RLeg_B02', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_04_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.15, 0))
        table.insert(self.MaelstromEffectsBag, CreateAttachedEmitter(self, 'DamagePack_LLeg_B01', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_02_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.1, 0))
        table.insert(self.MaelstromEffectsBag, CreateAttachedEmitter(self, 'DamagePack_LLeg_B01', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_03_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.1, 0))
        table.insert(self.MaelstromEffectsBag, CreateAttachedEmitter(self, 'DamagePack_LLeg_B01', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_04_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.1, 0))
        table.insert(self.MaelstromEffectsBag, CreateAttachedEmitter(self, 'DamagePack_LLeg_B02', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_02_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.15, 0))
        table.insert(self.MaelstromEffectsBag, CreateAttachedEmitter(self, 'DamagePack_LLeg_B02', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_03_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.15, 0))
        table.insert(self.MaelstromEffectsBag, CreateAttachedEmitter(self, 'DamagePack_LLeg_B02', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_04_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.15, 0))
    end,
}

TypeClass = EAL0001
