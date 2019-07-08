-----------------------------------------------------------------
-- Author(s):  Exavier Macbeth
-- Summary  :  BlackOps: Adv Command Unit - UEF ACU
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------
local Shield = import('/lua/shield.lua').Shield
local ACUUnit = import('/lua/defaultunits.lua').ACUUnit
local DeathNukeWeapon = import('/lua/sim/defaultweapons.lua').DeathNukeWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')
local Buff = import('/lua/sim/Buff.lua')
local DefineBasicBuff = import('/lua/sim/BuffDefinitions.lua').DefineBasicBuff

local TerranWeaponFile = import('/lua/terranweapons.lua')
local TANTorpedoAngler = TerranWeaponFile.TANTorpedoAngler
local TDFZephyrCannonWeapon = TerranWeaponFile.TDFZephyrCannonWeapon
local TDFOverchargeWeapon = TerranWeaponFile.TDFOverchargeWeapon
local TIFCruiseMissileLauncher = TerranWeaponFile.TIFCruiseMissileLauncher

local ACUsWeapons = import('/mods/BlackOpsFAF-ACUs/lua/ACUsWeapons.lua')
local HeavyPlasmaGatlingWeapon = ACUsWeapons.HeavyPlasmaGatlingWeapon
local NapalmWeapon = ACUsWeapons.NapalmWeapon
local AntiMatterWeapon = ACUsWeapons.AntiMatterWeapon
local PDLaserGrid = ACUsWeapons.PDLaserGrid
local CEMPArrayBeam = ACUsWeapons.CEMPArrayBeam

EEL0001 = Class(ACUUnit) {
    DeathThreadDestructionWaitTime = 2,
    PainterRange = {},
    RightGunLabel = 'RightZephyr',
    RightGunUpgrade = 'JuryRiggedZephyr',
    RightGunBone = 'Zephyr_Amplifier',
    WeaponEnabled = {}, -- Storage for upgrade weapons status

    Weapons = {
        RightZephyr = Class(TDFZephyrCannonWeapon) {},
        TargetPainter = Class(CEMPArrayBeam) {},
        DeathWeapon = Class(DeathNukeWeapon) {},
        FlameCannon = Class(NapalmWeapon) {},
        TorpedoLauncher = Class(TANTorpedoAngler) {},
        AntiMatterCannon = Class(AntiMatterWeapon) {},
        GatlingEnergyCannon = Class(HeavyPlasmaGatlingWeapon) {},
        ClusterMissiles = Class(TIFCruiseMissileLauncher) {},
        EnergyLance01 = Class(PDLaserGrid) {},
        EnergyLance02 = Class(PDLaserGrid) {},
        OverCharge = Class(TDFOverchargeWeapon) {},
        AutoOverCharge = Class(TDFOverchargeWeapon) {},
        TacMissile = Class(TIFCruiseMissileLauncher) {},
        TacNukeMissile = Class(TIFCruiseMissileLauncher) {},
    },

    -- Hooked Functions
    OnCreate = function(self)
        ACUUnit.OnCreate(self)

        self.HasLeftPod = false
        self.HasRightPod = false
        self.SpysatEnabled = false
        self.ShieldEffectsBag = {}
        self.FlamerEffectsBag = {}
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        ACUUnit.OnStopBeingBuilt(self, builder, layer)

        self.Animator = CreateAnimator(self)
        self.Animator:SetPrecedence(0)
        if self.IdleAnim then
            self.Animator:PlayAnim(self:GetBlueprint().Display.AnimationIdle, true)
            for _, v in self.DisabledBones do
                self.Animator:SetBoneEnabled(v, false)
            end
        end

        self:BuildManipulatorSetEnabled(false)
        self.Rotator1 = CreateRotator(self, 'Back_ShieldPack_Spinner01', 'z', nil, 0, 20, 0)
        self.Rotator2 = CreateRotator(self, 'Back_ShieldPack_Spinner02', 'z', nil, 0, 40, 0)
        self.RadarDish = CreateRotator(self, 'Back_IntelPack_Dish', 'y', nil, 0, 20, 0)
        self.Trash:Add(self.Rotator1)
        self.Trash:Add(self.Rotator2)
        self.Trash:Add(self.RadarDish)
    end,

    OnStartBuild = function(self, unitBeingBuilt, order)
        ACUUnit.OnStartBuild(self, unitBeingBuilt, order)

        if self.Animator then
            self.Animator:SetRate(0)
        end
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        if self.Satellite and not self.Satellite.Dead and not self.Satellite.IsDying then
            self.Satellite:Kill()
            self.Satellite:Kill()
            self.Satellite = nil
        end

        ACUUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

    OnScriptBitClear = function(self, bit)
        if bit == 0 then -- Shield toggle
            self.Rotator1:SetTargetSpeed(0)
            self.Rotator2:SetTargetSpeed(0)
            if self.ShieldEffectsBag then
                for k, v in self.ShieldEffectsBag do
                    v:Destroy()
                end
                self.ShieldEffectsBag = {}
            end
            self:DisableShield()
            self:StopUnitAmbientSound('ActiveLoop')
        elseif bit == 8 then -- Cloak toggle
            self:PlayUnitAmbientSound('ActiveLoop')
            self:SetMaintenanceConsumptionActive()
            self:EnableUnitIntel('Radar')
            self:EnableUnitIntel('Sonar')
            self.RadarDish:SetTargetSpeed(45)
        end
    end,

    OnScriptBitSet = function(self, bit)
        if bit == 0 then -- Shield toggle
            self.Rotator1:SetTargetSpeed(90)
            self.Rotator2:SetTargetSpeed(-180)
            if self.ShieldEffectsBag then
                for _, v in self.ShieldEffectsBag do
                    v:Destroy()
                end
                self.ShieldEffectsBag = {}
            end
            for _, v in self.ShieldEffects2 do
                local army = self:GetArmy()
                for i = 1, 8 do
                    table.insert(self.ShieldEffectsBag, CreateAttachedEmitter(self, 'Back_ShieldPack_Emitter0' .. i, army, v))
                end
            end
            self:EnableShield()
            self:PlayUnitAmbientSound('ActiveLoop')
        elseif bit == 8 then -- Cloak toggle
            self:StopUnitAmbientSound('ActiveLoop')
            self:SetMaintenanceConsumptionInactive()
            self:DisableUnitIntel('Radar')
            self:DisableUnitIntel('Sonar')
            self.RadarDish:SetTargetSpeed(0)
        end
    end,

    CreateBuildEffects = function(self, unitBeingBuilt, order)
        local UpgradesFrom = unitBeingBuilt:GetBlueprint().General.UpgradesFrom

        -- If we are assisting an upgrading unit, or repairing a unit, play seperate effects
        if (order == 'Repair' and not unitBeingBuilt:IsBeingBuilt()) or (UpgradesFrom and UpgradesFrom ~= 'none' and self:IsUnitState('Guarding')) then
            EffectUtil.CreateDefaultBuildBeams(self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag)
        else
            EffectUtil.CreateUEFCommanderBuildSliceBeams(self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag)
        end
    end,

    OnStopBuild = function(self, unitBeingBuilt)
        ACUUnit.OnStopBuild(self, unitBeingBuilt)

        if self:BeenDestroyed() then return end
        if self.IdleAnim and not self:IsDead() then
            self.Animator:PlayAnim(self.IdleAnim, true)
        end
    end,

    OnDestroy = function(self)
        if self.Satellite and not self.Satellite.Dead and not self.Satellite.IsDying then
            self.Satellite:Destroy()
            self.Satellite = nil
        end

        ACUUnit.OnDestroy(self)
    end,

    CreateEnhancement = function(self, enh, removal)
        ACUUnit.CreateEnhancement(self, enh)

        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end

        if enh == 'ImprovedEngineering' then
            self:RemoveBuildRestriction(categories.UEF * (categories.BUILTBYTIER2COMMANDER))
            self:updateBuildRestrictions()
            self:SetProduction(bp)

            DefineBasicBuff('UEFACUT2BuildRate', 'ACUBUILDRATE', 'STACKS', bp.NewBuildRate, bp.NewHealth, bp.NewRegenRate)
            Buff.ApplyBuff(self, 'UEFACUT2BuildRate')
        elseif enh == 'ImprovedEngineeringRemove' then
            Buff.RemoveBuff(self, 'UEFACUT2BuildRate')

            self:AddBuildRestriction(categories.UEF * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER))
            self:SetProduction()
        elseif enh == 'AdvancedEngineering' then
            self:RemoveBuildRestriction(categories.UEF * (categories.BUILTBYTIER3COMMANDER))
            self:updateBuildRestrictions()
            self:SetProduction(bp)

            DefineBasicBuff('UEFACUT3BuildRate', 'ACUBUILDRATE', 'STACKS', bp.NewBuildRate, bp.NewHealth, bp.NewRegenRate)
            Buff.ApplyBuff(self, 'UEFACUT3BuildRate')
        elseif enh == 'AdvancedEngineeringRemove' then
            Buff.RemoveBuff(self, 'UEFACUT3BuildRate')

            self:AddBuildRestriction(categories.UEF * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER))
            self:SetProduction()
        elseif enh == 'ExperimentalEngineering' then
            self:RemoveBuildRestriction(categories.UEF * (categories.BUILTBYTIER4COMMANDER))
            self:updateBuildRestrictions()
            self:SetProduction(bp)

            DefineBasicBuff('UEFACUT4BuildRate', 'ACUBUILDRATE', 'STACKS', bp.NewBuildRate, bp.NewHealth, bp.NewRegenRate)
            Buff.ApplyBuff(self, 'UEFACUT4BuildRate')
        elseif enh == 'ExperimentalEngineeringRemove' then
            Buff.RemoveBuff(self, 'UEFACUT4BuildRate')

            self:AddBuildRestriction(categories.UEF * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER))
            self:SetProduction()
        elseif enh == 'CombatEngineering' then
            self:RemoveBuildRestriction(categories.UEF * (categories.BUILTBYTIER2COMMANDER))
            self:updateBuildRestrictions()

            DefineBasicBuff('UEFACUT2BuildCombat', 'ACUBUILDRATE', 'STACKS', bp.NewBuildRate, bp.NewHealth, bp.NewRegenRate)
            Buff.ApplyBuff(self, 'UEFACUT2BuildCombat')

            self:SetWeaponEnabledByLabel('FlameCannon', true)
            self:SortFlameEffects(true)
        elseif enh == 'CombatEngineeringRemove' then
            Buff.RemoveBuff(self, 'UEFACUT2BuildCombat')


            self:AddBuildRestriction(categories.UEF * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER))
            self:SetWeaponEnabledByLabel('FlameCannon', false)
            self:SortFlameEffects()
        elseif enh == 'AssaultEngineering' then
            self:RemoveBuildRestriction(categories.UEF * (categories.BUILTBYTIER3COMMANDER))
            self:updateBuildRestrictions()

            DefineBasicBuff('UEFACUT3BuildCombat', 'ACUBUILDRATE', 'STACKS', bp.NewBuildRate, bp.NewHealth, bp.NewRegenRate)
            Buff.ApplyBuff(self, 'UEFACUT3BuildCombat')

            local gun = self:GetWeaponByLabel('FlameCannon')
            gun:AddDamageMod(bp.FlameDamageMod)
            gun:ChangeMaxRadius(bp.FlameMaxRadius)

            self:SetPainterRange(enh, bp.FlameMaxRadius)
        elseif enh == 'AssaultEngineeringRemove' then
            Buff.RemoveBuff(self, 'UEFACUT3BuildCombat')

            self:AddBuildRestriction(categories.UEF * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER))

            local gun = self:GetWeaponByLabel('FlameCannon')
            gun:AddDamageMod(bp.FlameDamageMod)
            gun:ChangeMaxRadius(gun:GetBlueprint().MaxRadius)

            self:SetPainterRange('AssaultEngineering')
        elseif enh == 'ApocalypticEngineering' then
            self:RemoveBuildRestriction(categories.UEF * (categories.BUILTBYTIER4COMMANDER))
            self:updateBuildRestrictions()

            DefineBasicBuff('UEFACUT4BuildCombat', 'ACUBUILDRATE', 'STACKS', bp.NewBuildRate, bp.NewHealth, bp.NewRegenRate)
            Buff.ApplyBuff(self, 'UEFACUT4BuildCombat')
        elseif enh == 'ApocalypticEngineeringRemove' then
            Buff.RemoveBuff(self, 'UEFACUT4BuildCombat')

            self:AddBuildRestriction(categories.UEF * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER))

        -- Zephyr Booster

        elseif enh == 'JuryRiggedZephyr' then
            self:TogglePrimaryGun(bp.DamageMod, bp.NewMaxRadius)
        elseif enh == 'JuryRiggedZephyrRemove' then
            self:TogglePrimaryGun(bp.DamageMod)

        -- Torpedoes

        elseif enh == 'TorpedoLauncher' then
            DefineBasicBuff('UEFTorpHealth1', 'UEFTorpHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'UEFTorpHealth1')

            self:SetWeaponEnabledByLabel('TorpedoLauncher', true)
        elseif enh == 'TorpedoLauncherRemove' then
            Buff.RemoveBuff(self, 'UEFTorpHealth1')

            self:SetWeaponEnabledByLabel('TorpedoLauncher', false)
        elseif enh == 'ImprovedReloader' then
            DefineBasicBuff('UEFTorpHealth2', 'UEFTorpHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'UEFTorpHealth2')

            local torp = self:GetWeaponByLabel('TorpedoLauncher')
            torp:AddDamageMod(bp.TorpDamageMod)
            torp:ChangeRateOfFire(bp.NewTorpROF)

            -- Install Zephyr Cannon
            self:TogglePrimaryGun(bp.DamageMod, bp.NewMaxRadius)
        elseif enh == 'ImprovedReloaderRemove' then
            Buff.RemoveBuff(self, 'UEFTorpHealth2')

            local torp = self:GetWeaponByLabel('TorpedoLauncher')
            torp:AddDamageMod(bp.TorpDamageMod)
            torp:ChangeRateOfFire(torp:GetBlueprint().RateOfFire)

            self:TogglePrimaryGun(bp.DamageMod)
        elseif enh == 'AdvancedWarheads' then
            DefineBasicBuff('UEFTorpHealth3', 'UEFTorpHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'UEFTorpHealth3')

            local torp = self:GetWeaponByLabel('TorpedoLauncher')
            torp:AddDamageMod(bp.TorpDamageMod)

            -- Improve Zephyr Cannon
            local wep = self:GetWeaponByLabel('RightZephyr')
            wep:AddDamageMod(bp.DamageMod)
        elseif enh == 'AdvancedWarheadsRemove' then
            Buff.RemoveBuff(self, 'UEFTorpHealth3')

            local torp = self:GetWeaponByLabel('TorpedoLauncher')
            torp:AddDamageMod(bp.TorpDamageMod)

            local wep = self:GetWeaponByLabel('RightZephyr')
            wep:AddDamageMod(bp.DamageMod)

        -- AntiMatter Cannon

        elseif enh == 'AntiMatterCannon' then
            DefineBasicBuff('UEFAntimatterHealth1', 'UEFAntimatterHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'UEFAntimatterHealth1')

            self:SetWeaponEnabledByLabel('AntiMatterCannon', true)
            local gun = self:GetWeaponByLabel('AntiMatterCannon')
            gun:ChangeMaxRadius(bp.NewMaxRadius)

            self:SetPainterRange(enh, bp.NewMaxRadius)
        elseif enh == 'AntiMatterCannonRemove' then
            Buff.RemoveBuff(self, 'UEFAntimatterHealth1')

            self:SetWeaponEnabledByLabel('AntiMatterCannon', false)
            local gun = self:GetWeaponByLabel('AntiMatterCannon')
            gun:ChangeMaxRadius(gun:GetBlueprint().MaxRadius)

            self:SetPainterRange('AntiMatterCannon')
        elseif enh == 'ImprovedParticleAccelerator' then
            DefineBasicBuff('UEFAntimatterHealth2', 'UEFAntimatterHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'UEFAntimatterHealth2')

            -- Buff AntiMatter Gun
            local gun = self:GetWeaponByLabel('AntiMatterCannon')
            gun:AddDamageMod(bp.AntiMatterDamageMod)
            gun:ChangeDamageRadius(bp.NewDamageArea)

            -- Install Zephyr Cannon
            self:TogglePrimaryGun(bp.DamageMod, bp.NewMaxRadius)
        elseif enh == 'ImprovedParticleAcceleratorRemove' then
            Buff.RemoveBuff(self, 'UEFAntimatterHealth2')

            local gun = self:GetWeaponByLabel('AntiMatterCannon')
            gun:AddDamageMod(bp.AntiMatterDamageMod)
            gun:ChangeDamageRadius(gun:GetBlueprint().DamageRadius)

            self:TogglePrimaryGun(bp.DamageMod)
        elseif enh == 'EnhancedMagBottle' then
            DefineBasicBuff('UEFAntimatterHealth3', 'UEFAntimatterHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'UEFAntimatterHealth3')

            local gun = self:GetWeaponByLabel('AntiMatterCannon')
            gun:AddDamageMod(bp.AntiMatterDamageMod)
            gun:ChangeDamageRadius(bp.NewDamageArea)
            gun:ChangeMaxRadius(bp.NewAntiMatterMaxRadius)

            self:SetPainterRange(enh, bp.NewAntiMatterMaxRadius)

            -- Use toggle function to increase MaxRadius of Zephyr Cannon
            self:TogglePrimaryGun(0, bp.NewMaxRadius)
        elseif enh == 'EnhancedMagBottleRemove' then
            Buff.RemoveBuff(self, 'UEFAntimatterHealth3')

            local gun = self:GetWeaponByLabel('AntiMatterCannon')
            gun:AddDamageMod(bp.AntiMatterDamageMod)
            gun:ChangeDamageRadius(gun:GetBlueprint().DamageRadius)
            gun:ChangeMaxRadius(gun:GetBlueprint().MaxRadius)

            self:SetPainterRange('EnhancedMagBottle')

            -- Remove Zephyr Jury Rigging
            self:TogglePrimaryGun(0)

        -- Gatling Cannon

        elseif enh == 'GatlingEnergyCannon' then
            DefineBasicBuff('UEFGatlingHeath1', 'UEFGatlingHeath', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'UEFGatlingHeath1')

            self:SetWeaponEnabledByLabel('GatlingEnergyCannon', true)
            local gun = self:GetWeaponByLabel('GatlingEnergyCannon')
            gun:ChangeMaxRadius(bp.GatlingMaxRadius)

            self:SetPainterRange(enh, bp.GatlingMaxRadius)
        elseif enh == 'GatlingEnergyCannonRemove' then
            Buff.RemoveBuff(self, 'UEFGatlingHeath1')

            self:SetWeaponEnabledByLabel('GatlingEnergyCannon', false)
            local gun = self:GetWeaponByLabel('GatlingEnergyCannon')
            gun:ChangeMaxRadius(gun:GetBlueprint().MaxRadius)

            self:SetPainterRange('GatlingEnergyCannon')
        elseif enh == 'AutomaticBarrelStabalizers' then
            DefineBasicBuff('UEFGatlingHeath2', 'UEFGatlingHeath', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'UEFGatlingHeath2')

            local gun = self:GetWeaponByLabel('GatlingEnergyCannon')
            gun:AddDamageMod(bp.GatlingDamageMod)
            gun:ChangeMaxRadius(bp.GatlingMaxRadius)

            self:SetPainterRange(enh, bp.GatlingMaxRadius)

            self:TogglePrimaryGun(bp.DamageMod, bp.NewMaxRadius)
        elseif enh == 'AutomaticBarrelStabalizersRemove' then
            Buff.RemoveBuff(self, 'UEFGatlingHeath2')

            local gun = self:GetWeaponByLabel('GatlingEnergyCannon')
            gun:AddDamageMod(bp.GatlingDamageMod)
            gun:ChangeMaxRadius(gun:GetBlueprint().MaxRadius)

            self:SetPainterRange('AutomaticBarrelStabalizers')

            self:TogglePrimaryGun(bp.DamageMod)
        elseif enh == 'EnhancedPowerSubsystems' then
            DefineBasicBuff('UEFGatlingHeath3', 'UEFGatlingHeath', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'UEFGatlingHeath3')

            local gun = self:GetWeaponByLabel('GatlingEnergyCannon')
            gun:AddDamageMod(bp.GatlingDamageMod)
            gun:ChangeMaxRadius(bp.GatlingMaxRadius)

            self:SetPainterRange(enh, bp.GatlingMaxRadius)
        elseif enh == 'EnhancedPowerSubsystemsRemove' then
            Buff.RemoveBuff(self, 'UEFGatlingHeath3')

            local gun = self:GetWeaponByLabel('GatlingEnergyCannon')
            gun:AddDamageMod(bp.GatlingDamageMod)
            gun:ChangeMaxRadius(gun:GetBlueprint().GatlingMaxRadius)

            self:SetPainterRange('EnhancedPowerSubsystems')

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
        elseif enh == 'ImprovedShieldBattery' then
            self:DestroyShield()
            ForkThread(function()
                WaitTicks(1)
                self:CreateShield(bp)
            end)
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            self:SetWeaponEnabledByLabel('EnergyLance01', true)
            self:OnScriptBitSet(0)
        elseif enh == 'ImprovedShieldBatteryRemove' then
            self:DestroyShield()
            RemoveUnitEnhancement(self, 'ActiveShieldingRemove')
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
            self:SetWeaponEnabledByLabel('EnergyLance01', false)
            self:OnScriptBitClear(0)
        elseif enh == 'AdvancedShieldBattery' then
            self:DestroyShield()
            ForkThread(function()
                WaitTicks(1)
                self:CreateShield(bp)
            end)
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            self:SetWeaponEnabledByLabel('EnergyLance01', true)
            self:OnScriptBitSet(0)
        elseif enh == 'AdvancedShieldBatteryRemove' then
            self:DestroyShield()
            RemoveUnitEnhancement(self, 'ImprovedShieldBatteryRemove')
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
            self:SetWeaponEnabledByLabel('EnergyLance01', false)
            self:OnScriptBitClear(0)
        elseif enh == 'ExpandedShieldBubble' then
            self:DestroyShield()
            ForkThread(function()
                WaitTicks(1)
                self:CreateShield(bp)
            end)
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            self:OnScriptBitSet(0)
        elseif enh == 'ExpandedShieldBubbleRemove' then
            self:DestroyShield()
            RemoveUnitEnhancement(self, 'ExpandedShieldBubbleRemove')
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
            self:OnScriptBitClear(0)

        -- Intel

        elseif enh == 'ElectronicsEnhancment' then
            DefineBasicBuff('UEFIntelHealth1', 'UEFIntelHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'UEFIntelHealth1')

            if ScenarioInfo.Options.OmniCheat ~= "on" or self:GetAIBrain().BrainType == 'Human' then
                self:SetIntelRadius('Vision', bp.NewVisionRadius)
                self:SetIntelRadius('WaterVision', bp.NewVisionRadius)
                self:SetIntelRadius('Omni', bp.NewOmniRadius)
            end

            self.RadarDish:SetTargetSpeed(45)
            self:SetWeaponEnabledByLabel('EnergyLance01', true)
        elseif enh == 'ElectronicsEnhancmentRemove' then
            Buff.RemoveBuff(self, 'UEFIntelHealth1')

            local bpIntel = self:GetBlueprint().Intel

            if ScenarioInfo.Options.OmniCheat ~= "on" or self:GetAIBrain().BrainType == 'Human' then
                self:SetIntelRadius('Vision', bpIntel.VisionRadius)
                self:SetIntelRadius('WaterVision', bpIntel.WaterVisionRadius)
                self:SetIntelRadius('Omni', bpIntel.OmniRadius)
            end

            self.RadarDish:SetTargetSpeed(0)

            self:SetWeaponEnabledByLabel('EnergyLance01', false)
        elseif enh == 'SpySat' then
            DefineBasicBuff('UEFIntelHealth2', 'UEFIntelHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'UEFIntelHealth2')

            self.SpysatEnabled = true
            self:ForkThread(self.SatSpawn)

            self:SetWeaponEnabledByLabel('EnergyLance01', true)
            self:SetWeaponEnabledByLabel('EnergyLance02', true)
        elseif enh == 'SpySatRemove' then
            Buff.RemoveBuff(self, 'UEFIntelHealth2')

            if self.Satellite and not self.Satellite:IsDead() and not self.Satellite.IsDying then
                self.Satellite:Kill()
            end
            self.SpysatEnabled = false
            self.Satellite = nil

            self:SetWeaponEnabledByLabel('EnergyLance01', false)
            self:SetWeaponEnabledByLabel('EnergyLance02', false)
        elseif enh == 'Teleporter' then
            DefineBasicBuff('UEFIntelHealth3', 'UEFIntelHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'UEFIntelHealth3')

            self:SetWeaponEnabledByLabel('EnergyLance01', true)
            self:SetWeaponEnabledByLabel('EnergyLance02', true)
            self:AddCommandCap('RULEUCC_Teleport')
        elseif enh == 'TeleporterRemove' then
            Buff.RemoveBuff(self, 'UEFIntelHealth3')

            self:SetWeaponEnabledByLabel('EnergyLance01', false)
            self:SetWeaponEnabledByLabel('EnergyLance02', false)
            self:RemoveCommandCap('RULEUCC_Teleport')

        -- Missile System

        elseif enh == 'ClusterMissilePack' then
            DefineBasicBuff('UEFMissileHealth1', 'UEFMissileHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'UEFMissileHealth1')

            self:SetWeaponEnabledByLabel('ClusterMissiles', true)
            local cluster = self:GetWeaponByLabel('ClusterMissiles')
            cluster:ChangeMaxRadius(bp.ClusterMaxRadius)

            self:SetPainterRange(enh, bp.ClusterMaxRadius)

            -- Get rid of the range on the missiles to show this weapon's
            local wep = self:GetWeaponByLabel('TacMissile')
            wep:ChangeMaxRadius(bp.ClusterMaxRadius)
            local wep2 = self:GetWeaponByLabel('TacNukeMissile')
            wep2:ChangeMaxRadius(bp.ClusterMaxRadius)
        elseif enh == 'ClusterMissilePackRemove' then
            Buff.RemoveBuff(self, 'UEFMissileHealth1')

            self:SetWeaponEnabledByLabel('ClusterMissiles', false)
            local cluster = self:GetWeaponByLabel('ClusterMissiles')
            cluster:ChangeMaxRadius(cluster:GetBlueprint().MaxRadius)

            self:SetPainterRange('ClusterMissilePack')

            local wep = self:GetWeaponByLabel('TacMissile')
            wep:ChangeMaxRadius(wep:GetBlueprint().MaxRadius)
            local wep2 = self:GetWeaponByLabel('TacNukeMissile')
            wep2:ChangeMaxRadius(wep2:GetBlueprint().MaxRadius)
        elseif enh == 'TacticalMissilePack' then
            DefineBasicBuff('UEFMissileHealth2', 'UEFMissileHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'UEFMissileHealth2')

            -- Enable Tactical Missiles
            self:AddCommandCap('RULEUCC_Tactical')
            self:AddCommandCap('RULEUCC_SiloBuildTactical')
            self:SetWeaponEnabledByLabel('TacMissile', true)
            local wep = self:GetWeaponByLabel('TacMissile')
            wep:ChangeMaxRadius(wep:GetBlueprint().MaxRadius)

            -- Buff Cluster Missiles
            local cluster = self:GetWeaponByLabel('ClusterMissiles')
            cluster:AddDamageMod(bp.ClusterDamageMod)
        elseif enh == 'TacticalMissilePackRemove' then
            Buff.RemoveBuff(self, 'UEFMissileHealth2')

            local amt = self:GetTacticalSiloAmmoCount()
            self:RemoveTacticalSiloAmmo(amt or 0)
            self:StopSiloBuild()
            self:SetWeaponEnabledByLabel('TacMissile', false)
            self:RemoveCommandCap('RULEUCC_Tactical')
            self:RemoveCommandCap('RULEUCC_SiloBuildTactical')

            local wep = self:GetWeaponByLabel('ClusterMissiles')
            wep:AddDamageMod(bp.ClusterDamageMod)
        elseif enh == 'TacticalNukeSubstitution' then
            DefineBasicBuff('UEFMissileHealth3', 'UEFMissileHealth', 'STACKS', nil, bp.NewHealth)
            Buff.ApplyBuff(self, 'UEFMissileHealth3')

            -- Remove Tactical Missile
            local amt = self:GetTacticalSiloAmmoCount()
            self:RemoveTacticalSiloAmmo(amt or 0)
            self:StopSiloBuild()
            self:SetWeaponEnabledByLabel('TacMissile', false)
            self:RemoveCommandCap('RULEUCC_Tactical')
            self:RemoveCommandCap('RULEUCC_SiloBuildTactical')

            -- Add Nuke Missile
            self:AddCommandCap('RULEUCC_Nuke')
            self:AddCommandCap('RULEUCC_SiloBuildNuke')
            self:SetWeaponEnabledByLabel('TacNukeMissile', true)
            local wep = self:GetWeaponByLabel('TacNukeMissile')
            wep:ChangeMaxRadius(wep:GetBlueprint().MaxRadius)

            -- Buff Cluster Missiles
            local cluster = self:GetWeaponByLabel('ClusterMissiles')
            cluster:AddDamageMod(bp.ClusterDamageMod)
        elseif enh == 'TacticalNukeSubstitutionRemove' then
            Buff.RemoveBuff(self, 'UEFMissileHealth3')

            local amt = self:GetNukeSiloAmmoCount()
            self:RemoveNukeSiloAmmo(amt or 0)
            self:StopSiloBuild()
            self:SetWeaponEnabledByLabel('TacNukeMissile', false)
            self:RemoveCommandCap('RULEUCC_Nuke')
            self:RemoveCommandCap('RULEUCC_SiloBuildNuke')

            local wep = self:GetWeaponByLabel('ClusterMissiles')
            wep:AddDamageMod(bp.ClusterDamageMod)

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

    ShieldEffects2 = {
        '/mods/BlackOpsFAF-ACUs/effects/emitters/uef_shieldgen_01_emit.bp',
    },

    FlamerEffects = {
        '/mods/BlackOpsFAF-ACUs/effects/emitters/flamer_torch_01.bp',
    },

    -- New Functions
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

    SortFlameEffects = function(self, toggle)
        -- Empty the bag
        for _, v in self.FlamerEffectsBag do
            v:Destroy()
        end
        self.FlamerEffectsBag = {}

        -- Fill it if we're turning on
        if toggle then
            for _, v in self.FlamerEffects do
                table.insert(self.FlamerEffectsBag, CreateAttachedEmitter(self, 'Flamer_Torch', self:GetArmy(), v):ScaleEmitter(0.0625))
            end
        end
    end,
}

TypeClass = EEL0001
