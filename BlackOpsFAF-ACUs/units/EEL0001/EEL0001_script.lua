-----------------------------------------------------------------
-- Author(s):  Exavier Macbeth
-- Summary  :  BlackOps: Adv Command Unit - UEF ACU
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------
local Shield = import('/lua/shield.lua').Shield
local ACUUnit = import('/lua/defaultunits.lua').ACUUnit
local TerranWeaponFile = import('/lua/terranweapons.lua')
local TANTorpedoAngler = TerranWeaponFile.TANTorpedoAngler
local TDFZephyrCannonWeapon = TerranWeaponFile.TDFZephyrCannonWeapon
local TIFCruiseMissileLauncher = TerranWeaponFile.TIFCruiseMissileLauncher
local TDFOverchargeWeapon = TerranWeaponFile.TDFOverchargeWeapon
local DeathNukeWeapon = import('/lua/sim/defaultweapons.lua').DeathNukeWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')
local Buff = import('/lua/sim/Buff.lua')
local BOWeapons = import('/mods/BlackOpsFAF-ACUs/lua/ACUsWeapons.lua')
local UEFACUHeavyPlasmaGatlingCannonWeapon = BOWeapons.UEFACUHeavyPlasmaGatlingCannonWeapon
local EXFlameCannonWeapon = BOWeapons.HawkGaussCannonWeapon
local UEFACUAntiMatterWeapon = BOWeapons.UEFACUAntiMatterWeapon
local PDLaserGrid = BOWeapons.PDLaserGrid2
local CEMPArrayBeam01 = BOWeapons.CEMPArrayBeam01

EEL0001 = Class(ACUUnit) {
    DeathThreadDestructionWaitTime = 2,
    PainterRange = {},

    Weapons = {
        RightZephyr = Class(TDFZephyrCannonWeapon) {},
        TargetPainter = Class(CEMPArrayBeam01) {},
        DeathWeapon = Class(DeathNukeWeapon) {},
        FlameCannon = Class(EXFlameCannonWeapon) {},
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
                self.ExhaustEffects = EffectUtil.CreateBoneEffects(self.unit, 'Exhaust', self.unit:GetArmy(), EffectTemplate.WeaponSteam01)
                UEFACUHeavyPlasmaGatlingCannonWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
            
            IdleState = State(UEFACUHeavyPlasmaGatlingCannonWeapon.IdleState) {
                Main = function(self)
                    if self.unit.SpinManip then
                        self.unit.SpinManip:SetTargetSpeed(0)
                    end
                end,
            },
        },
        ClusterMissiles = Class(TIFCruiseMissileLauncher) {},
        EnergyLance01 = Class(PDLaserGrid) {
            PlayOnlyOneSoundCue = true,
        }, 
        EnergyLance02 = Class(PDLaserGrid) {
            PlayOnlyOneSoundCue = true,
        },
        OverCharge = Class(TDFOverchargeWeapon) {},
        AutoOverCharge = Class(TDFOverchargeWeapon) {},
        TacMissile = Class(TIFCruiseMissileLauncher) {
            CreateProjectileAtMuzzle = function(self)
                muzzle = self:GetBlueprint().RackBones[1].MuzzleBones[1]
                self.slider = CreateSlider(self.unit, 'Back_MissilePack_B02', 0, 0, 0, 0.25, true)
                self.slider:SetGoal(0, 0, 0.22)
                WaitFor(self.slider)
                local proj = TIFCruiseMissileLauncher.CreateProjectileAtMuzzle(self, muzzle)
                self.slider:SetGoal(0, 0, 0)
                WaitFor(self.slider)
                self.slider:Destroy()

                return proj
            end,
        },
        TacNukeMissile = Class(TIFCruiseMissileLauncher) {
             CreateProjectileAtMuzzle = function(self)
                muzzle = self:GetBlueprint().RackBones[1].MuzzleBones[1]
                self.slider = CreateSlider(self.unit, 'Back_MissilePack_B02', 0, 0, 0, 0.25, true)
                self.slider:SetGoal(0, 0, 0.22)
                WaitFor(self.slider)
                local proj = TIFCruiseMissileLauncher.CreateProjectileAtMuzzle(self, muzzle)
                self.slider:SetGoal(0, 0, 0)
                WaitFor(self.slider)
                self.slider:Destroy()

                return proj
            end,
        },
    },
    
    __init = function(self)
        ACUUnit.__init(self, 'RightZephyr')
    end,

    -- Storage for upgrade weapons status
    WeaponEnabled = {},

    OnCreate = function(self)
        ACUUnit.OnCreate(self)
        self:SetCapturable(false)

        local bp = self:GetBlueprint()
        for _, v in bp.Display.WarpInEffect.HideBones do
            self:HideBone(v, true)
        end

        self:SetupBuildBones()
        self.HasLeftPod = false
        self.HasRightPod = false
        -- Restrict what enhancements will enable later
        self:AddBuildRestriction(categories.UEF * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        ACUUnit.OnStopBeingBuilt(self,builder,layer)
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
        self.Rotator1 = CreateRotator(self, 'Back_ShieldPack_Spinner01', 'z', nil, 0, 20, 0)
        self.Rotator2 = CreateRotator(self, 'Back_ShieldPack_Spinner02', 'z', nil, 0, 40, 0)
        self.RadarDish1 = CreateRotator(self, 'Back_IntelPack_Dish', 'y', nil, 0, 20, 0)
        self.Trash:Add(self.Rotator1)
        self.Trash:Add(self.Rotator2)
        self.Trash:Add(self.RadarDish1)
        self.ShieldEffectsBag2 = {}
        self.FlamerEffectsBag = {}
        self:ForkThread(self.GiveInitialResources)
        self.SpysatEnabled = false
        
        -- Disable Upgrade Weapons
        self:SetWeaponEnabledByLabel('RightZephyr', true)
        self:SetWeaponEnabledByLabel('TorpedoLauncher', false)
        self:SetWeaponEnabledByLabel('FlameCannon', false)
        self:SetWeaponEnabledByLabel('AntiMatterCannon', false)
        self:SetWeaponEnabledByLabel('GatlingEnergyCannon', false)
        self:SetWeaponEnabledByLabel('ClusterMissiles', false)
        self:SetWeaponEnabledByLabel('EnergyLance01', false)
        self:SetWeaponEnabledByLabel('EnergyLance02', false)
        self:SetWeaponEnabledByLabel('TacMissile', false)
        self:SetWeaponEnabledByLabel('TacNukeMissile', false)
        self:SetWeaponEnabledByLabel('DeathWeapon', false)
    end,

    OnStartBuild = function(self, unitBeingBuilt, order)
        ACUUnit.OnStartBuild(self, unitBeingBuilt, order)
        if self.Animator then
            self.Animator:SetRate(0)
        end
        self.UnitBuildOrder = order
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
        ACUUnit.OnStopBuild(self, unitBeingBuilt)
        if self:BeenDestroyed() then return end
        if self.IdleAnim and not self:IsDead() then
            self.Animator:PlayAnim(self.IdleAnim, true)
        end
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

    OnKilled = function(self, instigator, type, overkillRatio)
        if self.Satellite and not self.Satellite:IsDead() and not self.Satellite.IsDying then
            self.Satellite:Kill()
            self.Satellite = nil
        end
        ACUUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
    
    OnDestroy = function(self)
        if self.Satellite and not self.Satellite:IsDead() and not self.Satellite.IsDying then
            self.Satellite:Destroy()
            self.Satellite = nil
        end
        ACUUnit.OnDestroy(self)
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
        elseif bit == 8 then -- cloak toggle
            self:StopUnitAmbientSound('ActiveLoop')
            self:SetMaintenanceConsumptionInactive()
            self:DisableUnitIntel('Radar')
            self:DisableUnitIntel('Sonar')
            self.RadarDish1:SetTargetSpeed(0)
        end
    end,

    -- New function to set up production numbers
    SetProduction = function(self, bp)
        local energy = bp.ProductionPerSecondEnergy or 0
        local mass = bp.ProductionPerSecondMass or 0
        
        local bpEcon = self:GetBlueprint().Economy
        
        self:SetProductionPerSecondEnergy(energy + bpEcon.ProductionPerSecondEnergy or 0)
        self:SetProductionPerSecondMass(mass + bpEcon.ProductionPerSecondMass or 0)
    end,
    
    -- Function to toggle the Zephyr Booster
    TogglePrimaryGun = function(self, damage, radius)
        local wep = self:GetWeaponByLabel('RightZephyr')
        local oc = self:GetWeaponByLabel('OverCharge')
        local aoc = self:GetWeaponByLabel('AutoOverCharge')
    
        local wepRadius = radius or wep:GetBlueprint().MaxRadius
        local ocRadius = radius or oc:GetBlueprint().MaxRadius
        local aocRadius = radius or aoc:GetBlueprint().MaxRadius

        -- Change Damage
        wep:AddDamageMod(damage)
        
        -- Change Radius
        wep:ChangeMaxRadius(wepRadius)
        oc:ChangeMaxRadius(ocRadius)
        aoc:ChangeMaxRadius(aocRadius)
        
        -- As radius is only passed when turning on, use the bool
        if radius then
            self:ShowBone('Zephyr_Amplifier', true)
            self:SetPainterRange('JuryRiggedZephyr', radius, false)
        else
            self:HideBone('Zephyr_Amplifier', true)
            self:SetPainterRange('JuryRiggedZephyrRemove', radius, true)
        end
    end,
    
    SortFlameEffects = function(self, toggle)
        -- Empty the bag
        for k, v in self.FlamerEffectsBag do
            v:Destroy()
        end
        self.FlamerEffectsBag = {}
        
        -- Fill it if we're turning on
        if toggle then
            for k, v in self.FlamerEffects do
                table.insert(self.FlamerEffectsBag, CreateAttachedEmitter(self, 'Flamer_Torch', self:GetArmy(), v):ScaleEmitter(0.0625))
            end
        end
    end,

    -- Target painter. 0 damage as primary weapon, controls targeting
    -- for the variety of changing ranges on the ACU with upgrades.
    SetPainterRange = function(self, enh, newRange, delete)
        if delete and self.PainterRange[string.sub(enh, 0, -7)] then
            self.PainterRange[string.sub(enh, 0, -7)] = nil
        elseif not delete and not self.PainterRange[enh] then
            self.PainterRange[enh] = newRange
        end
        
        local range = 22
        for upgrade, radius in self.PainterRange do
            if radius > range then range = radius end
        end
        
        local wep = self:GetWeaponByLabel('TargetPainter')
        wep:ChangeMaxRadius(range)
    end,

    CreateEnhancement = function(self, enh, removal)
        ACUUnit.CreateEnhancement(self, enh)
        
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
        if enh == 'ImprovedEngineering' then
            self:RemoveBuildRestriction(categories.UEF * (categories.BUILTBYTIER2COMMANDER))
            self:updateBuildRestrictions()
            self:SetProduction(bp)
            
            if not Buffs['UEFACUT2BuildRate'] then
                BuffBlueprint {
                    Name = 'UEFACUT2BuildRate',
                    DisplayName = 'UEFACUT2BuildRate',
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
            Buff.ApplyBuff(self, 'UEFACUT2BuildRate')
        elseif enh == 'ImprovedEngineeringRemove' then
            if Buff.HasBuff(self, 'UEFACUT2BuildRate') then
                Buff.RemoveBuff(self, 'UEFACUT2BuildRate')
            end
            self:AddBuildRestriction(categories.UEF * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            self:SetProduction()
        elseif enh == 'AdvancedEngineering' then
            self:RemoveBuildRestriction(categories.UEF * (categories.BUILTBYTIER3COMMANDER - categories.BUILTBYTIER4COMMANDER))
            self:updateBuildRestrictions()
            self:SetProduction(bp)

            if not Buffs['UEFACUT3BuildRate'] then
                BuffBlueprint {
                    Name = 'UEFACUT3BuildRate',
                    DisplayName = 'UEFCUT3BuildRate',
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
            Buff.ApplyBuff(self, 'UEFACUT3BuildRate')
        elseif enh == 'AdvancedEngineeringRemove' then
            if Buff.HasBuff(self, 'UEFACUT3BuildRate') then
                Buff.RemoveBuff(self, 'UEFACUT3BuildRate')
            end
            self:AddBuildRestriction(categories.UEF * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            self:SetProduction()
        elseif enh == 'ExperimentalEngineering' then
            self:RemoveBuildRestriction(categories.UEF * (categories.BUILTBYTIER4COMMANDER))
            self:updateBuildRestrictions()
            self:SetProduction(bp)
            
            if not Buffs['UEFACUT4BuildRate'] then
                BuffBlueprint {
                    Name = 'UEFACUT4BuildRate',
                    DisplayName = 'UEFCUT4BuildRate',
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
            Buff.ApplyBuff(self, 'UEFACUT4BuildRate')
        elseif enh == 'ExperimentalEngineeringRemove' then
            if Buff.HasBuff(self, 'UEFACUT4BuildRate') then
                Buff.RemoveBuff(self, 'UEFACUT4BuildRate')
            end
            self:AddBuildRestriction(categories.UEF * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            self:SetProduction()
        elseif enh == 'CombatEngineering' then
            self:RemoveBuildRestriction(categories.UEF * (categories.BUILTBYTIER2COMMANDER))
            self:updateBuildRestrictions()
            
            if not Buffs['UEFACUT2BuildCombat'] then
                BuffBlueprint {
                    Name = 'UEFACUT2BuildCombat',
                    DisplayName = 'UEFACUT2BuildCombat',
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
            Buff.ApplyBuff(self, 'UEFACUT2BuildCombat')
            
            self:SetWeaponEnabledByLabel('FlameCannon', true)
            self:SortFlameEffects(true)
        elseif enh == 'CombatEngineeringRemove' then
            if Buff.HasBuff(self, 'UEFACUT2BuildCombat') then
                Buff.RemoveBuff(self, 'UEFACUT2BuildCombat')
            end
            
            self:AddBuildRestriction(categories.UEF * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            self:SetWeaponEnabledByLabel('FlameCannon', false)
            self:SortFlameEffects()
        elseif enh == 'AssaultEngineering' then
            self:RemoveBuildRestriction(categories.UEF * (categories.BUILTBYTIER3COMMANDER - categories.BUILTBYTIER4COMMANDER))
            self:updateBuildRestrictions()
            
            if not Buffs['UEFACUT3BuildCombat'] then
                BuffBlueprint {
                    Name = 'UEFACUT3BuildCombat',
                    DisplayName = 'UEFACUT3BuildCombat',
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
            Buff.ApplyBuff(self, 'UEFACUT3BuildCombat')

            local gun = self:GetWeaponByLabel('FlameCannon')
            gun:AddDamageMod(bp.FlameDamageMod)
            gun:ChangeMaxRadius(bp.FlameMaxRadius)

            self:SetPainterRange(enh, bp.FlameMaxRadius, false)
        elseif enh == 'AssaultEngineeringRemove' then
            if Buff.HasBuff(self, 'UEFACUT3BuildCombat') then
                Buff.RemoveBuff(self, 'UEFACUT3BuildCombat')
            end

            self:AddBuildRestriction(categories.UEF * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))   

            local gun = self:GetWeaponByLabel('FlameCannon')
            gun:AddDamageMod(bp.FlameDamageMod)
            gun:ChangeMaxRadius(gun:GetBlueprint().MaxRadius)

            self:SetPainterRange(enh, 0, true)
        elseif enh == 'ApocalypticEngineering' then
            self:RemoveBuildRestriction(categories.UEF * (categories.BUILTBYTIER4COMMANDER))
            self:updateBuildRestrictions()
            
            if not Buffs['UEFACUT4BuildCombat'] then
                BuffBlueprint {
                    Name = 'UEFACUT4BuildCombat',
                    DisplayName = 'UEFACUT4BuildCombat',
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
            Buff.ApplyBuff(self, 'UEFACUT4BuildCombat')
        elseif enh == 'ApocalypticEngineeringRemove' then
            if Buff.HasBuff(self, 'UEFACUT4BuildCombat') then
                Buff.RemoveBuff(self, 'UEFACUT4BuildCombat')
            end
            self:AddBuildRestriction(categories.UEF * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))

        -- Zephyr Booster
            
        elseif enh == 'JuryRiggedZephyr' then
            self:TogglePrimaryGun(bp.DamageMod, bp.NewMaxRadius)
        elseif enh == 'JuryRiggedZephyrRemove' then
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
            Buff.ApplyBuff(self, 'UEFTorpHealth1')
            
            self:SetWeaponEnabledByLabel('TorpedoLauncher', true)
        elseif enh == 'TorpedoLauncherRemove' then
            if Buff.HasBuff(self, 'UEFTorpHealth1') then
                Buff.RemoveBuff(self, 'UEFTorpHealth1')
            end
            
            self:SetWeaponEnabledByLabel('TorpedoLauncher', false)
        elseif enh == 'ImprovedReloader' then
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
        elseif enh == 'ImprovedReloaderRemove' then
            if Buff.HasBuff(self, 'UEFTorpHealth2') then
                Buff.RemoveBuff(self, 'UEFTorpHealth2')
            end
            
            local torp = self:GetWeaponByLabel('TorpedoLauncher')
            torp:AddDamageMod(bp.TorpDamageMod)
            torp:ChangeRateOfFire(torp:GetBlueprint().RateOfFire)
            
            self:TogglePrimaryGun(bp.DamageMod)
        elseif enh == 'AdvancedWarheads' then
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
        elseif enh == 'AdvancedWarheadsRemove' then
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
            local gun = self:GetWeaponByLabel('AntiMatterCannon')
            gun:ChangeMaxRadius(bp.NewMaxRadius)

            self:SetPainterRange(enh, bp.NewMaxRadius, false)
        elseif enh == 'AntiMatterCannonRemove' then
            if Buff.HasBuff(self, 'UEFAntimatterHealth1') then
                Buff.RemoveBuff(self, 'UEFAntimatterHealth1')
            end

            self:SetWeaponEnabledByLabel('AntiMatterCannon', false)
            local gun = self:GetWeaponByLabel('AntiMatterCannon')
            gun:ChangeMaxRadius(gun:GetBlueprint().MaxRadius)

            self:SetPainterRange(enh, 0, true)
        elseif enh == 'ImprovedParticleAccelerator' then
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
        elseif enh == 'ImprovedParticleAcceleratorRemove' then    
            if Buff.HasBuff(self, 'UEFAntimatterHealth2') then
                Buff.RemoveBuff(self, 'UEFAntimatterHealth2')
            end
            
            local gun = self:GetWeaponByLabel('AntiMatterCannon')
            gun:AddDamageMod(bp.AntiMatterDamageMod)
            gun:ChangeDamageRadius(gun:GetBlueprint().DamageRadius)

            self:TogglePrimaryGun(bp.DamageMod)
        elseif enh == 'EnhancedMagBottle' then
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

            self:SetPainterRange(enh, bp.NewAntiMatterMaxRadius, false)

            -- Use toggle function to increase MaxRadius of Zephyr Cannon
            self:TogglePrimaryGun(0, bp.NewMaxRadius)
        elseif enh == 'EnhancedMagBottleRemove' then
            if Buff.HasBuff(self, 'UEFAntimatterHealth3') then
                Buff.RemoveBuff(self, 'UEFAntimatterHealth3')
            end

            local gun = self:GetWeaponByLabel('AntiMatterCannon')
            gun:AddDamageMod(bp.AntiMatterDamageMod)
            gun:ChangeDamageRadius(gun:GetBlueprint().DamageRadius)
            gun:ChangeMaxRadius(gun:GetBlueprint().MaxRadius)

            self:SetPainterRange(enh, 0, true)

            -- Remove Zephyr Jury Rigging
            self:TogglePrimaryGun(0)

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
            local gun = self:GetWeaponByLabel('GatlingEnergyCannon')
            gun:ChangeMaxRadius(bp.GatlingMaxRadius)

            self:SetPainterRange(enh, bp.GatlingMaxRadius, false)
        elseif enh == 'GatlingEnergyCannonRemove' then
            if Buff.HasBuff(self, 'UEFGatlingHeath1') then
                Buff.RemoveBuff(self, 'UEFGatlingHeath1')
            end

            self:SetWeaponEnabledByLabel('GatlingEnergyCannon', false)
            local gun = self:GetWeaponByLabel('GatlingEnergyCannon')
            gun:ChangeMaxRadius(gun:GetBlueprint().MaxRadius)

            self:SetPainterRange(enh, 0, true)
        elseif enh == 'AutomaticBarrelStabalizers' then
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

            self:SetPainterRange(enh, bp.GatlingMaxRadius, false)

            self:TogglePrimaryGun(bp.DamageMod, bp.NewMaxRadius)
        elseif enh == 'AutomaticBarrelStabalizersRemove' then
            if Buff.HasBuff(self, 'UEFGatlingHeath2') then
                Buff.RemoveBuff(self, 'UEFGatlingHeath2')
            end

            local gun = self:GetWeaponByLabel('GatlingEnergyCannon')
            gun:AddDamageMod(bp.GatlingDamageMod)
            gun:ChangeMaxRadius(gun:GetBlueprint().MaxRadius)

            self:SetPainterRange(enh, 0, true)

            self:TogglePrimaryGun(bp.DamageMod)
        elseif enh == 'EnhancedPowerSubsystems' then
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

            self:SetPainterRange(enh, bp.GatlingMaxRadius, false)
        elseif enh == 'EnhancedPowerSubsystemsRemove' then
            if Buff.HasBuff(self, 'UEFGatlingHeath3') then
                Buff.RemoveBuff(self, 'UEFGatlingHeath3')
            end

            local gun = self:GetWeaponByLabel('GatlingEnergyCannon')
            gun:AddDamageMod(bp.GatlingDamageMod)
            gun:ChangeMaxRadius(gun:GetBlueprint().GatlingMaxRadius)

            self:SetPainterRange(enh, 0, true)
            
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
            if not Buffs['UEFIntelHealth1'] then
                BuffBlueprint {
                    Name = 'UEFIntelHealth1',
                    DisplayName = 'UEFIntelHealth1',
                    BuffType = 'UEFIntelHealth',
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
            Buff.ApplyBuff(self, 'UEFIntelHealth1')
            
            self:SetIntelRadius('Vision', bp.NewVisionRadius)
            self:SetIntelRadius('WaterVision', bp.NewVisionRadius)
            self:SetIntelRadius('Omni', bp.NewOmniRadius)
            self.RadarDish1:SetTargetSpeed(45)

            self:SetWeaponEnabledByLabel('EnergyLance01', true)
        elseif enh == 'ElectronicsEnhancmentRemove' then
            if Buff.HasBuff(self, 'UEFIntelHealth1') then
                Buff.RemoveBuff(self, 'UEFIntelHealth1')
            end
        
            local bpIntel = self:GetBlueprint().Intel
            self:SetIntelRadius('Vision', bpIntel.VisionRadius)
            self:SetIntelRadius('WaterVision', bpIntel.WaterVisionRadius)
            self:SetIntelRadius('Omni', bpIntel.OmniRadius)
            self.RadarDish1:SetTargetSpeed(0)

            self:SetWeaponEnabledByLabel('EnergyLance01', false)
        elseif enh == 'SpySat' then
            if not Buffs['UEFIntelHealth2'] then
                BuffBlueprint {
                    Name = 'UEFIntelHealth2',
                    DisplayName = 'UEFIntelHealth2',
                    BuffType = 'UEFIntelHealth',
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
            Buff.ApplyBuff(self, 'UEFIntelHealth2')
            
            self.SpysatEnabled = true
            self:ForkThread(self.SatSpawn)
            
            self:SetWeaponEnabledByLabel('EnergyLance01', true)
            self:SetWeaponEnabledByLabel('EnergyLance02', true)
        elseif enh == 'SpySatRemove' then
            if Buff.HasBuff(self, 'UEFIntelHealth2') then
                Buff.RemoveBuff(self, 'UEFIntelHealth2')
            end
            
            if self.Satellite and not self.Satellite:IsDead() and not self.Satellite.IsDying then
                self.Satellite:Kill()
            end
            self.SpysatEnabled = false
            self.Satellite = nil
            
            self:SetWeaponEnabledByLabel('EnergyLance01', false)
            self:SetWeaponEnabledByLabel('EnergyLance02', false)
        elseif enh == 'Teleporter' then
            if not Buffs['UEFIntelHealth3'] then
                BuffBlueprint {
                    Name = 'UEFIntelHealth3',
                    DisplayName = 'UEFIntelHealth3',
                    BuffType = 'UEFIntelHealth',
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
            Buff.ApplyBuff(self, 'UEFIntelHealth3')
            
            self:SetWeaponEnabledByLabel('EnergyLance01', true)
            self:SetWeaponEnabledByLabel('EnergyLance02', true)
            self:AddCommandCap('RULEUCC_Teleport')
        elseif enh == 'TeleporterRemove' then
            if Buff.HasBuff(self, 'UEFIntelHealth3') then
                Buff.RemoveBuff(self, 'UEFIntelHealth3')
            end
            
            self:SetWeaponEnabledByLabel('EnergyLance01', false)
            self:SetWeaponEnabledByLabel('EnergyLance02', false)
            self:RemoveCommandCap('RULEUCC_Teleport')
            
        -- Missile System
        
        elseif enh == 'ClusterMissilePack' then
            if not Buffs['UEFMissileHealth1'] then
                BuffBlueprint {
                    Name = 'UEFMissileHealth1',
                    DisplayName = 'UEFMissileHealth1',
                    BuffType = 'UEFMissileHealth',
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
            Buff.ApplyBuff(self, 'UEFMissileHealth1')

            self:SetWeaponEnabledByLabel('ClusterMissiles', true)
            local cluster = self:GetWeaponByLabel('ClusterMissiles')
            cluster:ChangeMaxRadius(bp.ClusterMaxRadius)

            self:SetPainterRange(enh, bp.ClusterMaxRadius, false)

            -- Get rid of the range on the missiles to show this weapon's
            local wep = self:GetWeaponByLabel('TacMissile')
            wep:ChangeMaxRadius(bp.ClusterMaxRadius)
            local wep2 = self:GetWeaponByLabel('TacNukeMissile')
            wep2:ChangeMaxRadius(bp.ClusterMaxRadius)
        elseif enh == 'ClusterMissilePackRemove' then
            if Buff.HasBuff(self, 'UEFMissileHealth1') then
                Buff.RemoveBuff(self, 'UEFMissileHealth1')
            end
            
            self:SetWeaponEnabledByLabel('ClusterMissiles', false)
            local cluster = self:GetWeaponByLabel('ClusterMissiles')
            cluster:ChangeMaxRadius(cluster:GetBlueprint().MaxRadius)
            
            self:SetPainterRange(enh, 0, true)
            
            local wep = self:GetWeaponByLabel('TacMissile')
            wep:ChangeMaxRadius(wep:GetBlueprint().MaxRadius)
            local wep2 = self:GetWeaponByLabel('TacNukeMissile')
            wep2:ChangeMaxRadius(wep2:GetBlueprint().MaxRadius)
        elseif enh == 'TacticalMissilePack' then
            if not Buffs['UEFMissileHealth2'] then
                BuffBlueprint {
                    Name = 'UEFMissileHealth2',
                    DisplayName = 'UEFMissileHealth2',
                    BuffType = 'UEFMissileHealth',
                    Stacks = 'STACKS',
                    Duration = -1,
                    Affects = {
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
            if Buff.HasBuff(self, 'UEFMissileHealth2') then
                Buff.RemoveBuff(self, 'UEFMissileHealth2')
            end
            
            local amt = self:GetTacticalSiloAmmoCount()
            self:RemoveTacticalSiloAmmo(amt or 0)
            self:StopSiloBuild()
            self:SetWeaponEnabledByLabel('TacMissile', false)
            self:RemoveCommandCap('RULEUCC_Tactical')
            self:RemoveCommandCap('RULEUCC_SiloBuildTactical')

            local wep = self:GetWeaponByLabel('ClusterMissiles')
            wep:AddDamageMod(bp.ClusterDamageMod)
        elseif enh == 'TacticalNukeSubstitution' then
            if not Buffs['UEFMissileHealth3'] then
                BuffBlueprint {
                    Name = 'UEFMissileHealth3',
                    DisplayName = 'UEFMissileHealth3',
                    BuffType = 'UEFMissileHealth',
                    Stacks = 'STACKS',
                    Duration = -1,
                    Affects = {
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
            if Buff.HasBuff(self, 'UEFMissileHealth3') then
                Buff.RemoveBuff(self, 'UEFMissileHealth3')
            end
        
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
            if bp.RemoveEnhancements then
                for k, v in bp.RemoveEnhancements do                
                    if string.sub(v, -6) ~= 'Remove' and v ~= string.sub(enh, 0, -7) then
                        self:CreateEnhancement(v .. 'Remove', true)
                    end
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
}

TypeClass = EEL0001