-----------------------------------------------------------------

-- Author(s):  Exavier Macbeth

-- Summary  :  BlackOps: Adv Command Unit - Serephim ACU

-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local ACUUnit = import('/lua/defaultunits.lua').ACUUnit
local Buff = import('/lua/sim/Buff.lua')
local SWeapons = import('/lua/seraphimweapons.lua')
local SDFChronotronCannonWeapon = SWeapons.SDFChronotronCannonWeapon
local SDFChronotronOverChargeCannonWeapon = SWeapons.SDFChronotronCannonOverChargeWeapon
local DeathNukeWeapon = import('/lua/sim/defaultweapons.lua').DeathNukeWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')
local SIFLaanseTacticalMissileLauncher = SWeapons.SIFLaanseTacticalMissileLauncher
local AIUtils = import('/lua/ai/aiutilities.lua')
local SDFAireauWeapon = SWeapons.SDFAireauWeapon
local SDFSinnuntheWeapon = SWeapons.SDFSinnuntheWeapon
local SANUallCavitationTorpedo = SWeapons.SANUallCavitationTorpedo
local BOWeapons = import('/mods/BlackOpsACUs/lua/EXBlackOpsweapons.lua')
local SeraACURapidWeapon = BOWeapons.SeraACURapidWeapon 
local SeraACUBigBallWeapon = BOWeapons.SeraACUBigBallWeapon 
local SAAOlarisCannonWeapon = SWeapons.SAAOlarisCannonWeapon
local CEMPArrayBeam01 = BOWeapons.CEMPArrayBeam01 

-- Setup as RemoteViewing child unit rather than ACUUnit
local RemoteViewing = import('/lua/RemoteViewing.lua').RemoteViewing
ACUUnit = RemoteViewing(ACUUnit)

ESL0001 = Class(ACUUnit) {
    DeathThreadDestructionWaitTime = 2,
    PainterRange = {},
    
    Weapons = {
        DeathWeapon = Class(DeathNukeWeapon) {},
        TargetPainter = Class(CEMPArrayBeam01) {},
        ChronotronCannon = Class(SDFChronotronCannonWeapon) {},
        TorpedoLauncher01 = Class(SANUallCavitationTorpedo) {},
        TorpedoLauncher02 = Class(SANUallCavitationTorpedo) {},
        TorpedoLauncher03 = Class(SANUallCavitationTorpedo) {},
        BigBallCannon01 = Class(SeraACUBigBallWeapon) {
            PlayFxMuzzleChargeSequence = function(self, muzzle)
                --CreateRotator(unit, bone, axis, [goal], [speed], [accel], [goalspeed])
                if not self.ClawTopRotator then 
                    self.ClawTopRotator = CreateRotator(self.unit, 'Pincer_Upper', 'x')
                    self.ClawBottomRotator = CreateRotator(self.unit, 'Pincer_Lower', 'x')
                    
                    self.unit.Trash:Add(self.ClawTopRotator)
                    self.unit.Trash:Add(self.ClawBottomRotator)
                end
                
                self.ClawTopRotator:SetGoal(-15):SetSpeed(10)
                self.ClawBottomRotator:SetGoal(15):SetSpeed(10)
                
                SDFSinnuntheWeapon.PlayFxMuzzleChargeSequence(self, muzzle)
                
                self:ForkThread(function()
                    WaitSeconds(self.unit:GetBlueprint().Weapon[7].MuzzleChargeDelay)
                    
                    self.ClawTopRotator:SetGoal(0):SetSpeed(50)
                    self.ClawBottomRotator:SetGoal(0):SetSpeed(50)
                end)
            end,
        },
        BigBallCannon02 = Class(SeraACUBigBallWeapon) {
            PlayFxMuzzleChargeSequence = function(self, muzzle)
                --CreateRotator(unit, bone, axis, [goal], [speed], [accel], [goalspeed])
                if not self.ClawTopRotator then 
                    self.ClawTopRotator = CreateRotator(self.unit, 'Pincer_Upper', 'x')
                    self.ClawBottomRotator = CreateRotator(self.unit, 'Pincer_Lower', 'x')
                    
                    self.unit.Trash:Add(self.ClawTopRotator)
                    self.unit.Trash:Add(self.ClawBottomRotator)
                end
                
                self.ClawTopRotator:SetGoal(-15):SetSpeed(10)
                self.ClawBottomRotator:SetGoal(15):SetSpeed(10)
                
                SDFSinnuntheWeapon.PlayFxMuzzleChargeSequence(self, muzzle)
                
                self:ForkThread(function()
                    WaitSeconds(self.unit:GetBlueprint().Weapon[8].MuzzleChargeDelay)
                    
                    self.ClawTopRotator:SetGoal(0):SetSpeed(50)
                    self.ClawBottomRotator:SetGoal(0):SetSpeed(50)
                end)
            end,
        },
        BigBallCannon03 = Class(SeraACUBigBallWeapon) {
            PlayFxMuzzleChargeSequence = function(self, muzzle)
                --CreateRotator(unit, bone, axis, [goal], [speed], [accel], [goalspeed])
                if not self.ClawTopRotator then 
                    self.ClawTopRotator = CreateRotator(self.unit, 'Pincer_Upper', 'x')
                    self.ClawBottomRotator = CreateRotator(self.unit, 'Pincer_Lower', 'x')
                    
                    self.unit.Trash:Add(self.ClawTopRotator)
                    self.unit.Trash:Add(self.ClawBottomRotator)
                end
                
                self.ClawTopRotator:SetGoal(-15):SetSpeed(10)
                self.ClawBottomRotator:SetGoal(15):SetSpeed(10)
                
                SDFSinnuntheWeapon.PlayFxMuzzleChargeSequence(self, muzzle)
                
                self:ForkThread(function()
                    WaitSeconds(self.unit:GetBlueprint().Weapon[9].MuzzleChargeDelay)
                    
                    self.ClawTopRotator:SetGoal(0):SetSpeed(50)
                    self.ClawBottomRotator:SetGoal(0):SetSpeed(50)
                end)
            end,
        },
        RapidCannon01 = Class(SeraACURapidWeapon) {},
        RapidCannon02 = Class(SeraACURapidWeapon) {},
        RapidCannon03 = Class(SeraACURapidWeapon) {},
        AA01 = Class(SAAOlarisCannonWeapon) {},
        AA02 = Class(SAAOlarisCannonWeapon) {},
        Missile = Class(SIFLaanseTacticalMissileLauncher) {
            CurrentRack = 1,
                
            PlayFxMuzzleSequence = function(self, muzzle)
                local bp = self:GetBlueprint()
                self.MissileRotator = CreateRotator(self.unit, bp.RackBones[self.CurrentRack].RackBone, 'x', nil, 0, 0, 0)
                muzzle = bp.RackBones[self.CurrentRack].MuzzleBones[1]
                self.MissileRotator:SetGoal(-10):SetSpeed(10)
                SIFLaanseTacticalMissileLauncher.PlayFxMuzzleSequence(self, muzzle)
                WaitFor(self.MissileRotator)
                WaitTicks(1)
            end,
                
            CreateProjectileAtMuzzle = function(self, muzzle)
                muzzle = self:GetBlueprint().RackBones[self.CurrentRack].MuzzleBones[1]
                if self.CurrentRack >= 2 then
                    self.CurrentRack = 1
                else
                    self.CurrentRack = self.CurrentRack + 1
                end
                SIFLaanseTacticalMissileLauncher.CreateProjectileAtMuzzle(self, muzzle)
            end,
                
            PlayFxRackReloadSequence = function(self)
                WaitTicks(1)
                self.MissileRotator:SetGoal(0):SetSpeed(10)
                WaitFor(self.MissileRotator)
                self.MissileRotator:Destroy()
                self.MissileRotator = nil
            end,
        },
        OverCharge = Class(SDFChronotronOverChargeCannonWeapon) {},
        AutoOverCharge = Class(SDFChronotronOverChargeCannonWeapon) {},
    },

    __init = function(self)
        ACUUnit.__init(self, 'ChronotronCannon')
    end,
    
    -- Storage for upgrade weapons status
    WeaponEnabled = {},

    OnCreate = function(self)
        ACUUnit.OnCreate(self)
        self:SetCapturable(false)
        self:SetupBuildBones()
        
        self:HideBone('Engineering', true)
        self:HideBone('Combat_Engineering', true)
        self:HideBone('Rapid_Cannon', true)
        self:HideBone('Basic_Gun_Up', true)
        self:HideBone('Big_Ball_Cannon', true)
        self:HideBone('Torpedo_Launcher', true)
        self:HideBone('Missile_Launcher', true)
        self:HideBone('IntelPack', true)
        self:HideBone('L_Spinner_B01', true)
        self:HideBone('L_Spinner_B02', true)
        self:HideBone('L_Spinner_B03', true)
        self:HideBone('S_Spinner_B01', true)
        self:HideBone('S_Spinner_B02', true)
        self:HideBone('S_Spinner_B03', true)
        self:HideBone('Left_AA_Mount', true)
        self:HideBone('Right_AA_Mount', true)
        
        -- Restrict what enhancements will enable later
        self:AddBuildRestriction(categories.SERAPHIM * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        ACUUnit.OnStopBeingBuilt(self,builder,layer)
        self:DisableRemoteViewingButtons()
        
        self:SetWeaponEnabledByLabel('TorpedoLauncher01', false)
        self:SetWeaponEnabledByLabel('TorpedoLauncher02', false)
        self:SetWeaponEnabledByLabel('TorpedoLauncher03', false)
        self:SetWeaponEnabledByLabel('BigBallCannon01', false)
        self:SetWeaponEnabledByLabel('BigBallCannon02', false)
        self:SetWeaponEnabledByLabel('BigBallCannon03', false)
        self:SetWeaponEnabledByLabel('RapidCannon01', false)
        self:SetWeaponEnabledByLabel('RapidCannon02', false)
        self:SetWeaponEnabledByLabel('RapidCannon03', false)
        self:SetWeaponEnabledByLabel('AA01', false)
        self:SetWeaponEnabledByLabel('AA02', false)
        self:SetWeaponEnabledByLabel('Missile', false)
        
        self:ForkThread(self.GiveInitialResources)
        self.ShieldEffectsBag = {}
        self.lambdaEmitterTable = {}
        StartRotators()
    end,
    
    StartRotators = function()
        if not self.RotatorManipulator1 then
            self.RotatorManipulator1 = CreateRotator(self, 'S_Spinner_B01', 'y')
            self.Trash:Add(self.RotatorManipulator1)
        end
        self.RotatorManipulator1:SetAccel(30)
        self.RotatorManipulator1:SetTargetSpeed(120)
        if not self.RotatorManipulator2 then
            self.RotatorManipulator2 = CreateRotator(self, 'L_Spinner_B01', 'y')
            self.Trash:Add(self.RotatorManipulator2)
        end
        self.RotatorManipulator2:SetAccel(-15)
        self.RotatorManipulator2:SetTargetSpeed(-60)
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
        self:ShowBone(0, true)
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
    end,

    CreateBuildEffects = function(self, unitBeingBuilt, order)
        EffectUtil.CreateSeraphimUnitEngineerBuildingEffects(self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag)
    end,

    OnTransportDetach = function(self, attachBone, unit)
        ACUUnit.OnTransportDetach(self, attachBone, unit)
        self:StopSiloBuild()

    end,

    OnScriptBitClear = function(self, bit)
        if bit == 0 then -- shield toggle
            self:DisableShield()
            self:StopUnitAmbientSound('ActiveLoop')        
        end
    end,

    OnScriptBitSet = function(self, bit)
        if bit == 0 then -- shield toggle
            self:EnableShield()
            self:PlayUnitAmbientSound('ActiveLoop')
        end
    end,

    GetUnitsToBuff = function(self, bp)
        local unitCat = ParseEntityCategory(bp.UnitCategory or 'BUILTBYTIER3FACTORY + BUILTBYQUANTUMGATE + NEEDMOBILEBUILD')
        local brain = self:GetAIBrain()
        local all = brain:GetUnitsAroundPoint(unitCat, self:GetPosition(), bp.Radius, 'Ally')
        local units = {}

        for _, u in all do
            if not u.Dead and not u:IsBeingBuilt() then
                table.insert(units, u)
            end
        end

        return units
    end,

    RegenBuffThread = function(self, type)
        local bp = self:GetBlueprint().Enhancements[type]
        local buff = 'SeraphimACU' .. type

        while not self.Dead do
            local units = self:GetUnitsToBuff(bp)
            for _,unit in units do
                Buff.ApplyBuff(unit, buff)
                unit:RequestRefreshUI()
            end
            WaitSeconds(5)
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

    -- Function to toggle the Ripper
    TogglePrimaryGun = function(self, damage, radius)
        local wep = self:GetWeaponByLabel('ChronotronCannon')
        local oc = self:GetWeaponByLabel('OverCharge')
        local aoc = self:GetWeaponByLabel('AutoOverCharge')

        local wepRadius = radius or wep:GetBlueprint().MaxRadius
        local ocRadius = radius or oc:GetBlueprint().MaxRadius
        local aocRadius = radius or aoc:GetBlueprint().MaxRadius

        -- Change RoF
        wep:AddDamageMod(damage)

        -- Change Radius
        wep:ChangeMaxRadius(wepRadius)
        oc:ChangeMaxRadius(ocRadius)
        aoc:ChangeMaxRadius(aocRadius)
        
        -- As radius is only passed when turning on, use the bool
        if radius then
            self:ShowBone('Basic_GunUp_Range', true)
            self:SetPainterRange('DisruptorAmplifier', radius, false)
        else
            self:HideBone('Basic_GunUp_Range', false)
            self:SetPainterRange('DisruptorAmplifierRemove', radius, true)
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

    CreateEnhancement = function(self, enh)
        ACUUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
        if enh =='ImprovedEngineering' then
            self:RemoveBuildRestriction(categories.SERAPHIM * (categories.BUILTBYTIER2COMMANDER))
            if not Buffs['SERAPHIMACUT2BuildRate'] then
                BuffBlueprint {
                    Name = 'SERAPHIMACUT2BuildRate',
                    DisplayName = 'SERAPHIMACUT2BuildRate',
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
            Buff.ApplyBuff(self, 'SERAPHIMACUT2BuildRate')
            local bp = self:GetBlueprint().Enhancements[enh]
            local bpEcon = self:GetBlueprint().Economy
            if not bp then return end
            self:SetProductionPerSecondEnergy(bp.ProductionPerSecondEnergy + bpEcon.ProductionPerSecondEnergy or 0)
            self:SetProductionPerSecondMass(bp.ProductionPerSecondMass + bpEcon.ProductionPerSecondMass or 0)
            if not Buffs['SeraHealthBoost1'] then
                BuffBlueprint {
                    Name =  'SeraHealthBoost1',
                    DisplayName =  'SeraHealthBoost1',
                    BuffType =  'SeraHealthBoost1',
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
            Buff.ApplyBuff(self,  'SeraHealthBoost1')
            self.RBImpEngineering = true
            self.RBAdvEngineering = false
            self.RBExpEngineering = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'ImprovedEngineeringRemove' then
            local bp = self:GetBlueprint().Economy.BuildRate
            if Buff.HasBuff(self, 'SERAPHIMACUT2BuildRate') then
                Buff.RemoveBuff(self, 'SERAPHIMACUT2BuildRate')
            end
            if not bp then return end
            self:RestoreBuildRestrictions()
            self:AddBuildRestriction(categories.SERAPHIM * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            local bpEcon = self:GetBlueprint().Economy
            self:SetProductionPerSecondEnergy(bpEcon.ProductionPerSecondEnergy or 0)
            self:SetProductionPerSecondMass(bpEcon.ProductionPerSecondMass or 0)
            if Buff.HasBuff(self, 'SeraHealthBoost1') then
                Buff.RemoveBuff(self, 'SeraHealthBoost1')
            end
            self.RBImpEngineering = false
            self.RBAdvEngineering = false
            self.RBExpEngineering = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='AdvancedEngineering' then
            self:RemoveBuildRestriction(categories.SERAPHIM * (categories.BUILTBYTIER3COMMANDER - categories.BUILTBYTIER4COMMANDER))
            if not Buffs['SERAPHIMACUT3BuildRate'] then
                BuffBlueprint {
                    Name = 'SERAPHIMACUT3BuildRate',
                    DisplayName = 'SERAPHIMCUT3BuildRate',
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
            Buff.ApplyBuff(self, 'SERAPHIMACUT3BuildRate')
            local bp = self:GetBlueprint().Enhancements[enh]
            local bpEcon = self:GetBlueprint().Economy
            if not bp then return end
            self:SetProductionPerSecondEnergy(bp.ProductionPerSecondEnergy + bpEcon.ProductionPerSecondEnergy or 0)
            self:SetProductionPerSecondMass(bp.ProductionPerSecondMass + bpEcon.ProductionPerSecondMass or 0)
            if not Buffs['SeraHealthBoost2'] then
                BuffBlueprint {
                    Name = 'SeraHealthBoost2',
                    DisplayName = 'SeraHealthBoost2',
                    BuffType = 'SeraHealthBoost2',
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
            Buff.ApplyBuff(self, 'SeraHealthBoost2')
            self.RBImpEngineering = true
            self.RBAdvEngineering = true
            self.RBExpEngineering = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='AdvancedEngineeringRemove' then
            local bp = self:GetBlueprint().Economy.BuildRate
            if not bp then return end
            self:RestoreBuildRestrictions()
            if Buff.HasBuff(self, 'SERAPHIMACUT3BuildRate') then
                Buff.RemoveBuff(self, 'SERAPHIMACUT3BuildRate')
            end
            self:AddBuildRestriction(categories.SERAPHIM * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            local bpEcon = self:GetBlueprint().Economy
            self:SetProductionPerSecondEnergy(bpEcon.ProductionPerSecondEnergy or 0)
            self:SetProductionPerSecondMass(bpEcon.ProductionPerSecondMass or 0)
            if Buff.HasBuff(self, 'SeraHealthBoost1') then
                Buff.RemoveBuff(self, 'SeraHealthBoost1')
            end
            if Buff.HasBuff(self, 'SeraHealthBoost2') then
                Buff.RemoveBuff(self, 'SeraHealthBoost2')
            end
            self.RBImpEngineering = false
            self.RBAdvEngineering = false
            self.RBExpEngineering = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='ExperimentalEngineering' then
            self:RemoveBuildRestriction(categories.SERAPHIM * (categories.BUILTBYTIER4COMMANDER))
            local bp = self:GetBlueprint().Enhancements[enh]
            local bpEcon = self:GetBlueprint().Economy
            if not bp then return end
            self:SetProductionPerSecondEnergy(bp.ProductionPerSecondEnergy + bpEcon.ProductionPerSecondEnergy or 0)
            self:SetProductionPerSecondMass(bp.ProductionPerSecondMass + bpEcon.ProductionPerSecondMass or 0)
            if not Buffs['SERAPHIMACUT4BuildRate'] then
                BuffBlueprint {
                    Name = 'SERAPHIMACUT4BuildRate',
                    DisplayName = 'SERAPHIMCUT4BuildRate',
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
            Buff.ApplyBuff(self, 'SERAPHIMACUT4BuildRate')
            if not Buffs['SeraHealthBoost3'] then
                BuffBlueprint {
                    Name = 'SeraHealthBoost3',
                    DisplayName = 'SeraHealthBoost3',
                    BuffType = 'SeraHealthBoost3',
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
            Buff.ApplyBuff(self, 'SeraHealthBoost3')
            self.RBImpEngineering = true
            self.RBAdvEngineering = true
            self.RBExpEngineering = true
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='ExperimentalEngineeringRemove' then
            local bp = self:GetBlueprint().Economy.BuildRate
            if not bp then return end
            self:RestoreBuildRestrictions()
            if Buff.HasBuff(self, 'SERAPHIMACUT4BuildRate') then
                Buff.RemoveBuff(self, 'SERAPHIMACUT4BuildRate')
            end
            self:AddBuildRestriction(categories.SERAPHIM * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            local bpEcon = self:GetBlueprint().Economy
            self:SetProductionPerSecondEnergy(bpEcon.ProductionPerSecondEnergy or 0)
            self:SetProductionPerSecondMass(bpEcon.ProductionPerSecondMass or 0)
            if Buff.HasBuff(self, 'SeraHealthBoost1') then
                Buff.RemoveBuff(self, 'SeraHealthBoost1')
            end
            if Buff.HasBuff(self, 'SeraHealthBoost2') then
                Buff.RemoveBuff(self, 'SeraHealthBoost2')
            end
            if Buff.HasBuff(self, 'SeraHealthBoost3') then
                Buff.RemoveBuff(self, 'SeraHealthBoost3')
            end
            self.RBImpEngineering = false
            self.RBAdvEngineering = false
            self.RBExpEngineering = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='CombatEngineering' then
            local bp = self:GetBlueprint().Enhancements[enh]
            if not Buffs['SeraphimACURegenAura'] then
                BuffBlueprint {
                    Name = 'SeraphimACURegenAura',
                    DisplayName = 'SeraphimACURegenAura',
                    BuffType = 'COMMANDERAURA',
                    Stacks = 'REPLACE',
                    Duration = 5,
                    Affects = {
                        Regen = {
                            Add = 0,
                            Mult = bp.RegenPerSecond or 0.1,
                            Ceil = bp.RegenCeiling,
                            Floor = bp.RegenFloor,
                        },
                    },
                }
                
            end
            if not Buffs['SeraphimACURegenAura2'] then
                BuffBlueprint {
                    Name = 'SeraphimACURegenAura2',
                    DisplayName = 'SeraphimACURegenAura2',
                    BuffType = 'COMMANDERAURA',
                    Stacks = 'REPLACE',
                    Duration = 5,
                    Affects = {
                        Regen = {
                            Add = 0,
                            Mult = bp.RegenPerSecond2 or 0.1,
                            Ceil = bp.RegenCeiling,
                            Floor = bp.RegenFloor,
                        },
                    },
                }
                
            end
            if not Buffs['SeraphimACURegenAura3'] then
                BuffBlueprint {
                    Name = 'SeraphimACURegenAura3',
                    DisplayName = 'SeraphimACURegenAura3',
                    BuffType = 'COMMANDERAURA',
                    Stacks = 'REPLACE',
                    Duration = 5,
                    Affects = {
                        Regen = {
                            Add = 0,
                            Mult = bp.RegenPerSecond3 or 0.1,
                            Ceil = bp.RegenCeiling,
                            Floor = bp.RegenFloor,
                        },
                    },
                }
                
            end
            table.insert(self.ShieldEffectsBag, CreateAttachedEmitter(self, 'XSL0001', self:GetArmy(), '/effects/emitters/seraphim_regenerative_aura_01_emit.bp'))
            self.RegenThreadHandle = self:ForkThread(self.RegenBuffThread)
            self:RemoveBuildRestriction(categories.SERAPHIM * (categories.BUILTBYTIER2COMMANDER))
            if not Buffs['SERAPHIMACUT2BuildRate'] then
                BuffBlueprint {
                    Name = 'SERAPHIMACUT2BuildRate',
                    DisplayName = 'SERAPHIMACUT2BuildRate',
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
            Buff.ApplyBuff(self, 'SERAPHIMACUT2BuildRate')
            if not Buffs['SeraHealthBoost4'] then
                BuffBlueprint {
                    Name = 'SeraHealthBoost4',
                    DisplayName = 'SeraHealthBoost4',
                    BuffType = 'SeraHealthBoost4',
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
            Buff.ApplyBuff(self, 'SeraHealthBoost4')
            self.RBComEngineering = true
            self.RBAssEngineering = false
            self.RBApoEngineering = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='CombatEngineeringRemove' then
            if self.ShieldEffectsBag then
                for k, v in self.ShieldEffectsBag do
                    v:Destroy()
                end
                self.ShieldEffectsBag = {}
            end
            KillThread(self.RegenThreadHandle)
            local bp = self:GetBlueprint().Economy.BuildRate
            if Buff.HasBuff(self, 'SERAPHIMACUT2BuildRate') then
                Buff.RemoveBuff(self, 'SERAPHIMACUT2BuildRate')
            end
            if not bp then return end
            self:RestoreBuildRestrictions()
            self:AddBuildRestriction(categories.SERAPHIM * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            if Buff.HasBuff(self, 'SeraHealthBoost4') then
                Buff.RemoveBuff(self, 'SeraHealthBoost4')
            end
            self.RBComEngineering = false
            self.RBAssEngineering = false
            self.RBApoEngineering = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='AssaultEngineering' then
            if self.RegenThreadHandle then
                if self.ShieldEffectsBag then
                    for k, v in self.ShieldEffectsBag do
                        v:Destroy()
                    end
                    self.ShieldEffectsBag = {}
                end
                KillThread(self.RegenThreadHandle)
                
            end
            local bp = self:GetBlueprint().Enhancements[enh]
            if not Buffs['SeraphimAdvancedACURegenAura'] then
                BuffBlueprint {
                    Name = 'SeraphimAdvancedACURegenAura',
                    DisplayName = 'SeraphimAdvancedACURegenAura',
                    BuffType = 'COMMANDERAURA',
                    Stacks = 'REPLACE',
                    Duration = 5,
                    Affects = {
                        Regen = {
                            Add = 0,
                            Mult = bp.RegenPerSecond or 0.1,
                            Ceil = bp.RegenCeiling,
                            Floor = bp.RegenFloor,
                        },
                    },
                }
            end
            if not Buffs['SeraphimAdvancedACURegenAura2'] then
                BuffBlueprint {
                    Name = 'SeraphimAdvancedACURegenAura2',
                    DisplayName = 'SeraphimAdvancedACURegenAura2',
                    BuffType = 'COMMANDERAURA',
                    Stacks = 'REPLACE',
                    Duration = 5,
                    Affects = {
                        Regen = {
                            Add = 0,
                            Mult = bp.RegenPerSecond2 or 0.1,
                            Ceil = bp.RegenCeiling,
                            Floor = bp.RegenFloor,
                        },
                    },
                }
            end
            if not Buffs['SeraphimAdvancedACURegenAura3'] then
                BuffBlueprint {
                    Name = 'SeraphimAdvancedACURegenAura3',
                    DisplayName = 'SeraphimAdvancedACURegenAura3',
                    BuffType = 'COMMANDERAURA',
                    Stacks = 'REPLACE',
                    Duration = 5,
                    Affects = {
                        Regen = {
                            Add = 0,
                            Mult = bp.RegenPerSecond3 or 0.1,
                            Ceil = bp.RegenCeiling,
                            Floor = bp.RegenFloor,
                        },
                    },
                }
            end
            table.insert(self.ShieldEffectsBag, CreateAttachedEmitter(self, 'XSL0001', self:GetArmy(), '/effects/emitters/seraphim_regenerative_aura_01_emit.bp'))
            self.AdvancedRegenThreadHandle = self:ForkThread(self.AdvancedRegenBuffThread)
            self:RemoveBuildRestriction(categories.SERAPHIM * (categories.BUILTBYTIER3COMMANDER - categories.BUILTBYTIER4COMMANDER))
            if not Buffs['SERAPHIMACUT3BuildRate'] then
                BuffBlueprint {
                    Name = 'SERAPHIMACUT3BuildRate',
                    DisplayName = 'SERAPHIMCUT3BuildRate',
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
            Buff.ApplyBuff(self, 'SERAPHIMACUT3BuildRate')
            if not Buffs['SeraHealthBoost5'] then
                BuffBlueprint {
                    Name = 'SeraHealthBoost5',
                    DisplayName = 'SeraHealthBoost5',
                    BuffType = 'SeraHealthBoost5',
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
            Buff.ApplyBuff(self, 'SeraHealthBoost5')  
            self.RBComEngineering = true
            self.RBAssEngineering = true
            self.RBApoEngineering = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='AssaultEngineeringRemove' then
            if self.ShieldEffectsBag then
                for k, v in self.ShieldEffectsBag do
                    v:Destroy()
                end
                self.ShieldEffectsBag = {}
            end
            KillThread(self.AdvancedRegenThreadHandle)
            local bp = self:GetBlueprint().Economy.BuildRate
            if not bp then return end
            self:RestoreBuildRestrictions()
            if Buff.HasBuff(self, 'SERAPHIMACUT3BuildRate') then
                Buff.RemoveBuff(self, 'SERAPHIMACUT3BuildRate')
            end
            self:AddBuildRestriction(categories.SERAPHIM * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER)) 
            if Buff.HasBuff(self, 'SeraHealthBoost4') then
                Buff.RemoveBuff(self, 'SeraHealthBoost4')
            end
            if Buff.HasBuff(self, 'SeraHealthBoost5') then
                Buff.RemoveBuff(self, 'SeraHealthBoost5')
            end
            self.RBComEngineering = false
            self.RBAssEngineering = false
            self.RBApoEngineering = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='ApocolypticEngineering' then
            self:RemoveBuildRestriction(categories.SERAPHIM * (categories.BUILTBYTIER4COMMANDER))
            if not Buffs['SERAPHIMACUT4BuildRate'] then
                BuffBlueprint {
                    Name = 'SERAPHIMACUT4BuildRate',
                    DisplayName = 'SERAPHIMCUT4BuildRate',
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
            Buff.ApplyBuff(self, 'SERAPHIMACUT4BuildRate')
            if not Buffs['SeraHealthBoost6'] then
                BuffBlueprint {
                    Name = 'SeraHealthBoost6',
                    DisplayName = 'SeraHealthBoost6',
                    BuffType = 'SeraHealthBoost6',
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
            Buff.ApplyBuff(self, 'SeraHealthBoost6')
            self.RBComEngineering = true
            self.RBAssEngineering = true
            self.RBApoEngineering = true
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='ApocolypticEngineeringRemove' then
            if self.ShieldEffectsBag then
                for k, v in self.ShieldEffectsBag do
                    v:Destroy()
                end
                self.ShieldEffectsBag = {}
            end
            KillThread(self.AdvancedRegenThreadHandle)
            local bp = self:GetBlueprint().Economy.BuildRate
            if not bp then return end
            self:RestoreBuildRestrictions()
            if Buff.HasBuff(self, 'SERAPHIMACUT4BuildRate') then
                Buff.RemoveBuff(self, 'SERAPHIMACUT4BuildRate')
            end
            self:AddBuildRestriction(categories.SERAPHIM * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            if Buff.HasBuff(self, 'SeraHealthBoost4') then
                Buff.RemoveBuff(self, 'SeraHealthBoost4')
            end
            if Buff.HasBuff(self, 'SeraHealthBoost5') then
                Buff.RemoveBuff(self, 'SeraHealthBoost5')
            end
            if Buff.HasBuff(self, 'SeraHealthBoost6') then
                Buff.RemoveBuff(self, 'SeraHealthBoost6')
            end
            self.RBComEngineering = false
            self.RBAssEngineering = false
            self.RBApoEngineering = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='ChronotonBooster' then
            local wepChronotron = self:GetWeaponByLabel('ChronotronCannon')
            wepChronotron:ChangeMaxRadius(30)
            self:ForkThread(self.EXRegenBuffThread)
            self:ForkThread(self.DefaultGunBuffThread)
        elseif enh =='ChronotonBoosterRemove' then
            local wepChronotron = self:GetWeaponByLabel('ChronotronCannon')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[1].MaxRadius
            wepChronotron:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='TorpedoLauncher' then
            if not Buffs['SeraHealthBoost7'] then
                BuffBlueprint {
                    Name = 'SeraHealthBoost7',
                    DisplayName = 'SeraHealthBoost7',
                    BuffType = 'SeraHealthBoost7',
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
            Buff.ApplyBuff(self, 'SeraHealthBoost7')
            local wepChronotron = self:GetWeaponByLabel('ChronotronCannon')
            wepChronotron:ChangeMaxRadius(30)
            self.wcTorp01 = true
            self.wcTorp02 = false
            self.wcTorp03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='TorpedoLauncherRemove' then
            if Buff.HasBuff(self, 'SeraHealthBoost7') then
                Buff.RemoveBuff(self, 'SeraHealthBoost7')
            end
            local wepChronotron = self:GetWeaponByLabel('ChronotronCannon')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[1].MaxRadius
            wepChronotron:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            self.wcTorp01 = false
            self.wcTorp02 = false
            self.wcTorp03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='TorpedoRapidLoader' then
            if not Buffs['SeraHealthBoost8'] then
                BuffBlueprint {
                    Name = 'SeraHealthBoost8',
                    DisplayName = 'SeraHealthBoost8',
                    BuffType = 'SeraHealthBoost8',
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
            Buff.ApplyBuff(self, 'SeraHealthBoost8')
            local wepChronotron = self:GetWeaponByLabel('ChronotronCannon')
            wepChronotron:AddDamageMod(100)
            self.wcTorp01 = false
            self.wcTorp02 = true
            self.wcTorp03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.EXRegenBuffThread)
            self:ForkThread(self.DefaultGunBuffThread)
        elseif enh =='TorpedoRapidLoaderRemove' then
            if Buff.HasBuff(self, 'SeraHealthBoost7') then
                Buff.RemoveBuff(self, 'SeraHealthBoost7')
            end
            if Buff.HasBuff(self, 'SeraHealthBoost8') then
                Buff.RemoveBuff(self, 'SeraHealthBoost8')
            end
            local wepChronotron = self:GetWeaponByLabel('ChronotronCannon')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[1].MaxRadius
            wepChronotron:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            wepChronotron:AddDamageMod(-100)
            self.wcTorp01 = false
            self.wcTorp02 = false
            self.wcTorp03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='TorpedoClusterLauncher' then
            if not Buffs['SeraHealthBoost9'] then
                BuffBlueprint {
                    Name = 'SeraHealthBoost9',
                    DisplayName = 'SeraHealthBoost9',
                    BuffType = 'SeraHealthBoost9',
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
            Buff.ApplyBuff(self, 'SeraHealthBoost9')
            local wepChronotron = self:GetWeaponByLabel('ChronotronCannon')
            wepChronotron:AddDamageMod(200)
            self.wcTorp01 = false
            self.wcTorp02 = false
            self.wcTorp03 = true
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='TorpedoClusterLauncherRemove' then
            if Buff.HasBuff(self, 'SeraHealthBoost7') then
                Buff.RemoveBuff(self, 'SeraHealthBoost7')
            end
            if Buff.HasBuff(self, 'SeraHealthBoost8') then
                Buff.RemoveBuff(self, 'SeraHealthBoost8')
            end
            if Buff.HasBuff(self, 'SeraHealthBoost9') then
                Buff.RemoveBuff(self, 'SeraHealthBoost9')
            end
            local wepChronotron = self:GetWeaponByLabel('ChronotronCannon')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[1].MaxRadius
            wepChronotron:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            wepChronotron:AddDamageMod(-300)
            self.wcTorp01 = false
            self.wcTorp02 = false
            self.wcTorp03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='CannonBigBall' then
            if not Buffs['SeraHealthBoost10'] then
                BuffBlueprint {
                    Name = 'SeraHealthBoost10',
                    DisplayName = 'SeraHealthBoost10',
                    BuffType = 'SeraHealthBoost10',
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
            Buff.ApplyBuff(self, 'SeraHealthBoost10')
            local wepChronotron = self:GetWeaponByLabel('ChronotronCannon')
            wepChronotron:ChangeMaxRadius(35)
            self.wcBigBall01 = true
            self.wcBigBall02 = false
            self.wcBigBall03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='CannonBigBallRemove' then
            if Buff.HasBuff(self, 'SeraHealthBoost10') then
                Buff.RemoveBuff(self, 'SeraHealthBoost10')
            end
            local wepChronotron = self:GetWeaponByLabel('ChronotronCannon')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[1].MaxRadius
            wepChronotron:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            self.wcBigBall01 = false
            self.wcBigBall02 = false
            self.wcBigBall03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='ImprovedContainmentBottle' then
            if not Buffs['SeraHealthBoost11'] then
                BuffBlueprint {
                    Name = 'SeraHealthBoost11',
                    DisplayName = 'SeraHealthBoost11',
                    BuffType = 'SeraHealthBoost11',
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
            Buff.ApplyBuff(self, 'SeraHealthBoost11')
            local wepChronotron = self:GetWeaponByLabel('ChronotronCannon')
            wepChronotron:ChangeMaxRadius(40)
            self.wcBigBall01 = false
            self.wcBigBall02 = true
            self.wcBigBall03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.EXRegenBuffThread)
            self:ForkThread(self.DefaultGunBuffThread)
        elseif enh =='ImprovedContainmentBottleRemove' then    
            if Buff.HasBuff(self, 'SeraHealthBoost10') then
                Buff.RemoveBuff(self, 'SeraHealthBoost10')
            end
            if Buff.HasBuff(self, 'SeraHealthBoost11') then
                Buff.RemoveBuff(self, 'SeraHealthBoost11')
            end
            local wepChronotron = self:GetWeaponByLabel('ChronotronCannon')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[1].MaxRadius
            wepChronotron:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            self.wcBigBall01 = false
            self.wcBigBall02 = false
            self.wcBigBall03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='PowerBooster' then
            if not Buffs['SeraHealthBoost12'] then
                BuffBlueprint {
                    Name = 'SeraHealthBoost12',
                    DisplayName = 'SeraHealthBoost12',
                    BuffType = 'SeraHealthBoost12',
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
            Buff.ApplyBuff(self, 'SeraHealthBoost12')
            local wepChronotron = self:GetWeaponByLabel('ChronotronCannon')
            wepChronotron:ChangeMaxRadius(45)
            self.wcBigBall01 = false
            self.wcBigBall02 = false
            self.wcBigBall03 = true
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='PowerBoosterRemove' then    
            self:SetWeaponEnabledByLabel('BigBallCannon', false)
            if Buff.HasBuff(self, 'SeraHealthBoost10') then
                Buff.RemoveBuff(self, 'SeraHealthBoost10')
            end
            if Buff.HasBuff(self, 'SeraHealthBoost11') then
                Buff.RemoveBuff(self, 'SeraHealthBoost11')
            end
            if Buff.HasBuff(self, 'SeraHealthBoost12') then
                Buff.RemoveBuff(self, 'SeraHealthBoost12')
            end
            local wepChronotron = self:GetWeaponByLabel('ChronotronCannon')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[1].MaxRadius
            wepChronotron:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            self.wcBigBall01 = false
            self.wcBigBall02 = false
            self.wcBigBall03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='CannonRapid' then
            if not Buffs['SeraHealthBoost13'] then
                BuffBlueprint {
                    Name = 'SeraHealthBoost13',
                    DisplayName = 'SeraHealthBoost13',
                    BuffType = 'SeraHealthBoost13',
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
            Buff.ApplyBuff(self, 'SeraHealthBoost13')
            local wepChronotron = self:GetWeaponByLabel('ChronotronCannon')
            wepChronotron:ChangeMaxRadius(30)
            self.wcRapid01 = true
            self.wcRapid02 = false
            self.wcRapid03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='CannonRapidRemove' then
            if Buff.HasBuff(self, 'SeraHealthBoost13') then
                Buff.RemoveBuff(self, 'SeraHealthBoost13')
            end
            local wepChronotron = self:GetWeaponByLabel('ChronotronCannon')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[1].MaxRadius
            wepChronotron:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            self.wcRapid01 = false
            self.wcRapid02 = false
            self.wcRapid03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='ImprovedCoolingSystem' then
            if not Buffs['SeraHealthBoost14'] then
                BuffBlueprint {
                    Name = 'SeraHealthBoost14',
                    DisplayName = 'SeraHealthBoost14',
                    BuffType = 'SeraHealthBoost14',
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
            Buff.ApplyBuff(self, 'SeraHealthBoost14')
            local wepChronotron = self:GetWeaponByLabel('ChronotronCannon')
            wepChronotron:ChangeMaxRadius(35)
            self.wcRapid01 = false
            self.wcRapid02 = true
            self.wcRapid03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.EXRegenBuffThread)
            self:ForkThread(self.DefaultGunBuffThread)
        elseif enh =='ImprovedCoolingSystemRemove' then
            if Buff.HasBuff(self, 'SeraHealthBoost13') then
                Buff.RemoveBuff(self, 'SeraHealthBoost13')
            end
            if Buff.HasBuff(self, 'SeraHealthBoost14') then
                Buff.RemoveBuff(self, 'SeraHealthBoost14')
            end
            local wepChronotron = self:GetWeaponByLabel('ChronotronCannon')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[1].MaxRadius
            wepChronotron:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            self.wcRapid01 = false
            self.wcRapid02 = false
            self.wcRapid03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='EnergyShellHardener' then
            if not Buffs['SeraHealthBoost15'] then
                BuffBlueprint {
                    Name = 'SeraHealthBoost15',
                    DisplayName = 'SeraHealthBoost15',
                    BuffType = 'SeraHealthBoost15',
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
            Buff.ApplyBuff(self, 'SeraHealthBoost15')
            local wepChronotron = self:GetWeaponByLabel('ChronotronCannon')
            wepChronotron:ChangeMaxRadius(35)
            self.wcRapid01 = false
            self.wcRapid02 = false
            self.wcRapid03 = true
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='EnergyShellHardenerRemove' then
            if Buff.HasBuff(self, 'SeraHealthBoost13') then
                Buff.RemoveBuff(self, 'SeraHealthBoost13')
            end
            if Buff.HasBuff(self, 'SeraHealthBoost14') then
                Buff.RemoveBuff(self, 'SeraHealthBoost14')
            end
            if Buff.HasBuff(self, 'SeraHealthBoost15') then
                Buff.RemoveBuff(self, 'SeraHealthBoost15')
            end
            local wepChronotron = self:GetWeaponByLabel('ChronotronCannon')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[1].MaxRadius
            wepChronotron:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            self.wcRapid01 = false
            self.wcRapid02 = false
            self.wcRapid03 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'L1Lambda' then
            self.WeaponCheckAA01 = true
            self:SetWeaponEnabledByLabel('AA01', true)
            self:SetWeaponEnabledByLabel('AA02', true)
            local platOrientSm01 = self:GetOrientation()
            local platOrientLg01 = self:GetOrientation()
            local locationSm01 = self:GetPosition('S_Lambda_B01')
            local locationLg01 = self:GetPosition('L_Lambda_B01')
            local lambdaEmitterSm01 = CreateUnit('esb0002', self:GetArmy(), locationSm01[1], locationSm01[2], locationSm01[3], platOrientSm01[1], platOrientSm01[2], platOrientSm01[3], platOrientSm01[4], 'Land')
            local lambdaEmitterLg01 = CreateUnit('esb0001', self:GetArmy(), locationLg01[1], locationLg01[2], locationLg01[3], platOrientLg01[1], platOrientLg01[2], platOrientLg01[3], platOrientLg01[4], 'Land')
            table.insert (self.lambdaEmitterTable, lambdaEmitterSm01)
            table.insert (self.lambdaEmitterTable, lambdaEmitterLg01)
            lambdaEmitterSm01:AttachTo(self, 'S_Lambda_B01')
            lambdaEmitterLg01:AttachTo(self, 'L_Lambda_B01')
            lambdaEmitterSm01:SetParent(self, 'esl0001')
            lambdaEmitterLg01:SetParent(self, 'esl0001')
            lambdaEmitterSm01:SetCreator(self)
            lambdaEmitterLg01:SetCreator(self)
            self.Trash:Add(lambdaEmitterSm01)
            self.Trash:Add(lambdaEmitterLg01)
            --[[
            local platOrientSm01 = self:GetOrientation()
            local platOrientLg01 = self:GetOrientation()
            local locationSm01 = self:GetPosition('S_Lambda_B01')
            local locationLg01 = self:GetPosition('L_Lambda_B01')
            --local lambdaEmitterSm01 = CreateUnitHPR('esb0005', self:GetArmy(), locationSm01[1], locationSm01[2], locationSm01[3], 0, 0, 0)
            --local lambdaEmitterLg01 = CreateUnitHPR('esb0005', self:GetArmy(), locationLg01[1], locationLg01[2], locationLg01[3], 0, 0, 0)
            local lambdaEmitterSm01 = CreateUnit('esb0005', self:GetArmy(), locationSm01[1], locationSm01[2], locationSm01[3], platOrientSm01[1], platOrientSm01[2], platOrientSm01[3], platOrientSm01[4], 'Air')
            local lambdaEmitterLg01 = CreateUnit('esb0005', self:GetArmy(), locationLg01[1], locationLg01[2], locationLg01[3], platOrientLg01[1], platOrientLg01[2], platOrientLg01[3], platOrientLg01[4], 'Air')
            table.insert (self.lambdaEmitterTable, lambdaEmitterSm01)
            table.insert (self.lambdaEmitterTable, lambdaEmitterLg01)
            lambdaEmitterSm01:AttachTo(self, 'S_Lambda_B01')
            lambdaEmitterLg01:AttachTo(self, 'L_Lambda_B01')
            lambdaEmitterSm01:SetParent(self, 'esl0001')
            lambdaEmitterLg01:SetParent(self, 'esl0001')
            lambdaEmitterSm01:SetCreator(self)
            lambdaEmitterLg01:SetCreator(self)
            self.Trash:Add(lambdaEmitterSm01)
            self.Trash:Add(lambdaEmitterLg01)
            ]]--
            if not Buffs['SeraHealthBoost22'] then
                BuffBlueprint {
                    Name = 'SeraHealthBoost22',
                    DisplayName = 'SeraHealthBoost22',
                    BuffType = 'SeraHealthBoost22',
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
            Buff.ApplyBuff(self, 'SeraHealthBoost22')
            self.RBDefTier1 = true
            self.RBDefTier2 = false
            self.RBDefTier3 = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'L1LambdaRemove' then
            self.WeaponCheckAA01 = false
            self:SetWeaponEnabledByLabel('AA01', false)
            self:SetWeaponEnabledByLabel('AA02', false)
            if Buff.HasBuff(self, 'SeraHealthBoost22') then
                Buff.RemoveBuff(self, 'SeraHealthBoost22')
            end
            if table.getn({self.lambdaEmitterTable}) > 0 then
                for k, v in self.lambdaEmitterTable do 
                    IssueClearCommands({self.lambdaEmitterTable[k]}) 
                    IssueKillSelf({self.lambdaEmitterTable[k]})
                end
            end
            self.RBDefTier1 = false
            self.RBDefTier2 = false
            self.RBDefTier3 = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'L2Lambda' then
            if table.getn({self.lambdaEmitterTable}) > 0 then
                for k, v in self.lambdaEmitterTable do 
                    IssueClearCommands({self.lambdaEmitterTable[k]}) 
                    IssueKillSelf({self.lambdaEmitterTable[k]})
                end
            end
            local platOrientSm01 = self:GetOrientation()
            local platOrientLg01 = self:GetOrientation()
            local locationSm01 = self:GetPosition('S_Lambda_B01')
            local locationLg01 = self:GetPosition('L_Lambda_B01')
            local lambdaEmitterSm01 = CreateUnit('esb0002', self:GetArmy(), locationSm01[1], locationSm01[2], locationSm01[3], platOrientSm01[1], platOrientSm01[2], platOrientSm01[3], platOrientSm01[4], 'Land')
            local lambdaEmitterLg01 = CreateUnit('esb0001', self:GetArmy(), locationLg01[1], locationLg01[2], locationLg01[3], platOrientLg01[1], platOrientLg01[2], platOrientLg01[3], platOrientLg01[4], 'Land')
            table.insert (self.lambdaEmitterTable, lambdaEmitterSm01)
            table.insert (self.lambdaEmitterTable, lambdaEmitterLg01)
            lambdaEmitterSm01:AttachTo(self, 'S_Lambda_B01')
            lambdaEmitterLg01:AttachTo(self, 'L_Lambda_B01')
            lambdaEmitterSm01:SetParent(self, 'esl0001')
            lambdaEmitterLg01:SetParent(self, 'esl0001')
            lambdaEmitterSm01:SetCreator(self)
            lambdaEmitterLg01:SetCreator(self)
            self.Trash:Add(lambdaEmitterSm01)
            self.Trash:Add(lambdaEmitterLg01)
             local platOrientSm02 = self:GetOrientation()
            local platOrientLg02 = self:GetOrientation()
            local locationSm02 = self:GetPosition('S_Lambda_B02')
            local locationLg02 = self:GetPosition('L_Lambda_B02')
            local lambdaEmitterSm02 = CreateUnit('esb0003', self:GetArmy(), locationSm02[1], locationSm02[2], locationSm02[3], platOrientSm02[1], platOrientSm02[2], platOrientSm02[3], platOrientSm02[4], 'Land')
            local lambdaEmitterLg02 = CreateUnit('esb0001', self:GetArmy(), locationLg02[1], locationLg02[2], locationLg02[3], platOrientLg02[1], platOrientLg02[2], platOrientLg02[3], platOrientLg02[4], 'Land')
            table.insert (self.lambdaEmitterTable, lambdaEmitterSm02)
            table.insert (self.lambdaEmitterTable, lambdaEmitterLg02)
            lambdaEmitterSm02:AttachTo(self, 'S_Lambda_B02')
            lambdaEmitterLg02:AttachTo(self, 'L_Lambda_B02')
            lambdaEmitterSm02:SetParent(self, 'esl0001')
            lambdaEmitterLg02:SetParent(self, 'esl0001')
            lambdaEmitterSm02:SetCreator(self)
            lambdaEmitterLg02:SetCreator(self)
            self.Trash:Add(lambdaEmitterSm02)
            self.Trash:Add(lambdaEmitterLg02)
            if not Buffs['SeraHealthBoost23'] then
                BuffBlueprint {
                    Name = 'SeraHealthBoost23',
                    DisplayName = 'SeraHealthBoost23',
                    BuffType = 'SeraHealthBoost23',
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
            Buff.ApplyBuff(self, 'SeraHealthBoost23')
            self.RBDefTier1 = true
            self.RBDefTier2 = true
            self.RBDefTier3 = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'L2LambdaRemove' then
            self.WeaponCheckAA01 = false
            self:SetWeaponEnabledByLabel('AA01', false)
            self:SetWeaponEnabledByLabel('AA02', false)
            if Buff.HasBuff(self, 'SeraHealthBoost22') then
                Buff.RemoveBuff(self, 'SeraHealthBoost22')
            end
            if Buff.HasBuff(self, 'SeraHealthBoost23') then
                Buff.RemoveBuff(self, 'SeraHealthBoost23')
            end
            if table.getn({self.lambdaEmitterTable}) > 0 then
                for k, v in self.lambdaEmitterTable do 
                    IssueClearCommands({self.lambdaEmitterTable[k]}) 
                    IssueKillSelf({self.lambdaEmitterTable[k]})
                end
            end
            self.RBDefTier1 = false
            self.RBDefTier2 = false
            self.RBDefTier3 = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'L3Lambda' then
            if table.getn({self.lambdaEmitterTable}) > 0 then
                for k, v in self.lambdaEmitterTable do 
                    IssueClearCommands({self.lambdaEmitterTable[k]}) 
                    IssueKillSelf({self.lambdaEmitterTable[k]})
                end
            end
            local platOrientSm01 = self:GetOrientation()
            local platOrientLg01 = self:GetOrientation()
            local locationSm01 = self:GetPosition('S_Lambda_B01')
            local locationLg01 = self:GetPosition('L_Lambda_B01')
            local lambdaEmitterSm01 = CreateUnit('esb0002', self:GetArmy(), locationSm01[1], locationSm01[2], locationSm01[3], platOrientSm01[1], platOrientSm01[2], platOrientSm01[3], platOrientSm01[4], 'Land')
            local lambdaEmitterLg01 = CreateUnit('esb0001', self:GetArmy(), locationLg01[1], locationLg01[2], locationLg01[3], platOrientLg01[1], platOrientLg01[2], platOrientLg01[3], platOrientLg01[4], 'Land')
            table.insert (self.lambdaEmitterTable, lambdaEmitterSm01)
            table.insert (self.lambdaEmitterTable, lambdaEmitterLg01)
            lambdaEmitterSm01:AttachTo(self, 'S_Lambda_B01')
            lambdaEmitterLg01:AttachTo(self, 'L_Lambda_B01')
            lambdaEmitterSm01:SetParent(self, 'esl0001')
            lambdaEmitterLg01:SetParent(self, 'esl0001')
            lambdaEmitterSm01:SetCreator(self)
            lambdaEmitterLg01:SetCreator(self)
            self.Trash:Add(lambdaEmitterSm01)
            self.Trash:Add(lambdaEmitterLg01)
             local platOrientSm02 = self:GetOrientation()
            local platOrientLg02 = self:GetOrientation()
            local locationSm02 = self:GetPosition('S_Lambda_B02')
            local locationLg02 = self:GetPosition('L_Lambda_B02')
            local lambdaEmitterSm02 = CreateUnit('esb0003', self:GetArmy(), locationSm02[1], locationSm02[2], locationSm02[3], platOrientSm02[1], platOrientSm02[2], platOrientSm02[3], platOrientSm02[4], 'Land')
            local lambdaEmitterLg02 = CreateUnit('esb0001', self:GetArmy(), locationLg02[1], locationLg02[2], locationLg02[3], platOrientLg02[1], platOrientLg02[2], platOrientLg02[3], platOrientLg02[4], 'Land')
            table.insert (self.lambdaEmitterTable, lambdaEmitterSm02)
            table.insert (self.lambdaEmitterTable, lambdaEmitterLg02)
            lambdaEmitterSm02:AttachTo(self, 'S_Lambda_B02')
            lambdaEmitterLg02:AttachTo(self, 'L_Lambda_B02')
            lambdaEmitterSm02:SetParent(self, 'esl0001')
            lambdaEmitterLg02:SetParent(self, 'esl0001')
            lambdaEmitterSm02:SetCreator(self)
            lambdaEmitterLg02:SetCreator(self)
            self.Trash:Add(lambdaEmitterSm02)
            self.Trash:Add(lambdaEmitterLg02)
            local platOrientSm03 = self:GetOrientation()
            local platOrientLg03 = self:GetOrientation()
            local locationSm03 = self:GetPosition('S_Lambda_B03')
            local locationLg03 = self:GetPosition('L_Lambda_B03')
            local lambdaEmitterSm03 = CreateUnit('esb0004', self:GetArmy(), locationSm03[1], locationSm03[2], locationSm03[3], platOrientSm03[1], platOrientSm03[2], platOrientSm03[3], platOrientSm03[4], 'Land')
            local lambdaEmitterLg03 = CreateUnit('esb0004', self:GetArmy(), locationLg03[1], locationLg03[2], locationLg03[3], platOrientLg03[1], platOrientLg03[2], platOrientLg03[3], platOrientLg03[4], 'Land')
            table.insert (self.lambdaEmitterTable, lambdaEmitterSm03)
            table.insert (self.lambdaEmitterTable, lambdaEmitterLg03)
            lambdaEmitterSm03:AttachTo(self, 'S_Lambda_B03')
            lambdaEmitterLg03:AttachTo(self, 'L_Lambda_B03')
            lambdaEmitterSm03:SetParent(self, 'esl0001')
            lambdaEmitterLg03:SetParent(self, 'esl0001')
            lambdaEmitterSm03:SetCreator(self)
            lambdaEmitterLg03:SetCreator(self)
            self.Trash:Add(lambdaEmitterSm03)
            self.Trash:Add(lambdaEmitterLg03)
            if not Buffs['SeraHealthBoost24'] then
                BuffBlueprint {
                    Name = 'SeraHealthBoost24',
                    DisplayName = 'SeraHealthBoost24',
                    BuffType = 'SeraHealthBoost24',
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
            Buff.ApplyBuff(self, 'SeraHealthBoost24')
            self.RBDefTier1 = true
            self.RBDefTier2 = true
            self.RBDefTier3 = true
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'L3LambdaRemove' then
            self.WeaponCheckAA01 = false
            self:SetWeaponEnabledByLabel('AA01', false)
            self:SetWeaponEnabledByLabel('AA02', false)
            if Buff.HasBuff(self, 'SeraHealthBoost22') then
                Buff.RemoveBuff(self, 'SeraHealthBoost22')
            end
            if Buff.HasBuff(self, 'SeraHealthBoost23') then
                Buff.RemoveBuff(self, 'SeraHealthBoost23')
            end
            if Buff.HasBuff(self, 'SeraHealthBoost24') then
                Buff.RemoveBuff(self, 'SeraHealthBoost24')
            end
            if table.getn({self.lambdaEmitterTable}) > 0 then
                for k, v in self.lambdaEmitterTable do 
                    IssueClearCommands({self.lambdaEmitterTable[k]}) 
                    IssueKillSelf({self.lambdaEmitterTable[k]})
                end
            end
            self.RBDefTier1 = false
            self.RBDefTier2 = false
            self.RBDefTier3 = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'ElectronicsEnhancment' then
            if table.getn({self.lambdaEmitterTable}) > 0 then
                for k, v in self.lambdaEmitterTable do 
                    IssueClearCommands({self.lambdaEmitterTable[k]}) 
                    IssueKillSelf({self.lambdaEmitterTable[k]})
                end
            end
            local platOrientSm01 = self:GetOrientation()
            local platOrientLg01 = self:GetOrientation()
            local locationSm01 = self:GetPosition('S_Lambda_B01')
            local locationLg01 = self:GetPosition('L_Lambda_B01')
            local lambdaEmitterSm01 = CreateUnit('esb0002', self:GetArmy(), locationSm01[1], locationSm01[2], locationSm01[3], platOrientSm01[1], platOrientSm01[2], platOrientSm01[3], platOrientSm01[4], 'Land')
            local lambdaEmitterLg01 = CreateUnit('esb0001', self:GetArmy(), locationLg01[1], locationLg01[2], locationLg01[3], platOrientLg01[1], platOrientLg01[2], platOrientLg01[3], platOrientLg01[4], 'Land')
            table.insert (self.lambdaEmitterTable, lambdaEmitterSm01)
            table.insert (self.lambdaEmitterTable, lambdaEmitterLg01)
            lambdaEmitterSm01:AttachTo(self, 'S_Lambda_B01')
            lambdaEmitterLg01:AttachTo(self, 'L_Lambda_B01')
            lambdaEmitterSm01:SetParent(self, 'esl0001')
            lambdaEmitterLg01:SetParent(self, 'esl0001')
            lambdaEmitterSm01:SetCreator(self)
            lambdaEmitterLg01:SetCreator(self)
            self.Trash:Add(lambdaEmitterSm01)
            self.Trash:Add(lambdaEmitterLg01)
            self:SetIntelRadius('Vision', bp.NewVisionRadius or 50)
            self:SetIntelRadius('Omni', bp.NewOmniRadius or 50)
            if not Buffs['SeraHealthBoost16'] then
                BuffBlueprint {
                    Name = 'SeraHealthBoost16',
                    DisplayName = 'SeraHealthBoost16',
                    BuffType = 'SeraHealthBoost16',
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
            Buff.ApplyBuff(self, 'SeraHealthBoost16')
            self.RBIntTier1 = true
            self.RBIntTier2 = false
            self.RBIntTier3 = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'ElectronicsEnhancmentRemove' then
            local bpIntel = self:GetBlueprint().Intel
            self:SetIntelRadius('Vision', bpIntel.VisionRadius or 26)
            self:SetIntelRadius('Omni', bpIntel.OmniRadius or 26)
            if Buff.HasBuff(self, 'SeraHealthBoost16') then
                Buff.RemoveBuff(self, 'SeraHealthBoost16')
            end
            if table.getn({self.lambdaEmitterTable}) > 0 then
                for k, v in self.lambdaEmitterTable do 
                    IssueClearCommands({self.lambdaEmitterTable[k]}) 
                    IssueKillSelf({self.lambdaEmitterTable[k]})
                end
            end
            self.RBIntTier1 = false
            self.RBIntTier2 = false
            self.RBIntTier3 = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'ElectronicCountermeasures' then
            if table.getn({self.lambdaEmitterTable}) > 0 then
                for k, v in self.lambdaEmitterTable do 
                    IssueClearCommands({self.lambdaEmitterTable[k]}) 
                    IssueKillSelf({self.lambdaEmitterTable[k]})
                end
            end
            local platOrientSm01 = self:GetOrientation()
            local platOrientLg01 = self:GetOrientation()
            local locationSm01 = self:GetPosition('S_Lambda_B01')
            local locationLg01 = self:GetPosition('L_Lambda_B01')
            local lambdaEmitterSm01 = CreateUnit('esb0002', self:GetArmy(), locationSm01[1], locationSm01[2], locationSm01[3], platOrientSm01[1], platOrientSm01[2], platOrientSm01[3], platOrientSm01[4], 'Land')
            local lambdaEmitterLg01 = CreateUnit('esb0001', self:GetArmy(), locationLg01[1], locationLg01[2], locationLg01[3], platOrientLg01[1], platOrientLg01[2], platOrientLg01[3], platOrientLg01[4], 'Land')
            table.insert (self.lambdaEmitterTable, lambdaEmitterSm01)
            table.insert (self.lambdaEmitterTable, lambdaEmitterLg01)
            lambdaEmitterSm01:AttachTo(self, 'S_Lambda_B01')
            lambdaEmitterLg01:AttachTo(self, 'L_Lambda_B01')
            lambdaEmitterSm01:SetParent(self, 'esl0001')
            lambdaEmitterLg01:SetParent(self, 'esl0001')
            lambdaEmitterSm01:SetCreator(self)
            lambdaEmitterLg01:SetCreator(self)
            self.Trash:Add(lambdaEmitterSm01)
            self.Trash:Add(lambdaEmitterLg01)
             local platOrientSm02 = self:GetOrientation()
            local platOrientLg02 = self:GetOrientation()
            local locationSm02 = self:GetPosition('S_Lambda_B02')
            local locationLg02 = self:GetPosition('L_Lambda_B02')
            local lambdaEmitterSm02 = CreateUnit('esb0003', self:GetArmy(), locationSm02[1], locationSm02[2], locationSm02[3], platOrientSm02[1], platOrientSm02[2], platOrientSm02[3], platOrientSm02[4], 'Land')
            local lambdaEmitterLg02 = CreateUnit('esb0001', self:GetArmy(), locationLg02[1], locationLg02[2], locationLg02[3], platOrientLg02[1], platOrientLg02[2], platOrientLg02[3], platOrientLg02[4], 'Land')
            table.insert (self.lambdaEmitterTable, lambdaEmitterSm02)
            table.insert (self.lambdaEmitterTable, lambdaEmitterLg02)
            lambdaEmitterSm02:AttachTo(self, 'S_Lambda_B02')
            lambdaEmitterLg02:AttachTo(self, 'L_Lambda_B02')
            lambdaEmitterSm02:SetParent(self, 'esl0001')
            lambdaEmitterLg02:SetParent(self, 'esl0001')
            lambdaEmitterSm02:SetCreator(self)
            lambdaEmitterLg02:SetCreator(self)
            self.Trash:Add(lambdaEmitterSm02)
            self.Trash:Add(lambdaEmitterLg02)
            self:AddCommandCap('RULEUCC_Teleport')
            if not Buffs['SeraHealthBoost17'] then
                BuffBlueprint {
                    Name = 'SeraHealthBoost17',
                    DisplayName = 'SeraHealthBoost17',
                    BuffType = 'SeraHealthBoost17',
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
            Buff.ApplyBuff(self, 'SeraHealthBoost17')
            self.wcAA01 = true
            self.wcAA02 = true
            self:ForkThread(self.WeaponRangeReset)
    
            self.RBIntTier1 = true
            self.RBIntTier2 = true
            self.RBIntTier3 = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'ElectronicCountermeasuresRemove' then
            self:RemoveCommandCap('RULEUCC_Teleport')
            local bpIntel = self:GetBlueprint().Intel
            self:SetIntelRadius('Vision', bpIntel.VisionRadius or 26)
            self:SetIntelRadius('Omni', bpIntel.OmniRadius or 26)
            if Buff.HasBuff(self, 'SeraHealthBoost16') then
                Buff.RemoveBuff(self, 'SeraHealthBoost16')
            end
            if Buff.HasBuff(self, 'SeraHealthBoost17') then
                Buff.RemoveBuff(self, 'SeraHealthBoost17')
            end
            if table.getn({self.lambdaEmitterTable}) > 0 then
                for k, v in self.lambdaEmitterTable do 
                    IssueClearCommands({self.lambdaEmitterTable[k]}) 
                    IssueKillSelf({self.lambdaEmitterTable[k]})
                end
            end
            self.wcAA01 = false
            self.wcAA02 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self.RBIntTier1 = false
            self.RBIntTier2 = false
            self.RBIntTier3 = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'CloakingSubsystems' then
            local bp = self:GetBlueprint().Enhancements[enh]
            if not bp then return end
            --self:AddToggleCap('RULEUTC_CloakToggle')
            if self.IntelEffectsBag then
                EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
                self.IntelEffectsBag = nil
            end
            self.StealthEnh = false
            self.CloakEnh = true 
            self:EnableUnitIntel('RadarStealth')
            self:EnableUnitIntel('SonarStealth')
            self:EnableUnitIntel('Cloak')
            if not Buffs['SeraHealthBoost18'] then
                BuffBlueprint {
                    Name = 'SeraHealthBoost18',
                    DisplayName = 'SeraHealthBoost18',
                    BuffType = 'SeraHealthBoost18',
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
            Buff.ApplyBuff(self, 'SeraHealthBoost18')
            self.RBIntTier1 = true
            self.RBIntTier2 = true
            self.RBIntTier3 = true
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'CloakingSubsystemsRemove' then
            --self:RemoveToggleCap('RULEUTC_CloakToggle')
            self:DisableUnitIntel('Cloak')
            self:DisableUnitIntel('RadarStealth')
            self:DisableUnitIntel('SonarStealth')
            self.CloakEnh = false 
            self:RemoveCommandCap('RULEUCC_Teleport')
            local bpIntel = self:GetBlueprint().Intel
            self:SetIntelRadius('Vision', bpIntel.VisionRadius or 26)
            self:SetIntelRadius('Omni', bpIntel.OmniRadius or 26)
            if Buff.HasBuff(self, 'SeraHealthBoost16') then
                Buff.RemoveBuff(self, 'SeraHealthBoost16')
            end
            if Buff.HasBuff(self, 'SeraHealthBoost17') then
                Buff.RemoveBuff(self, 'SeraHealthBoost17')
            end
            if Buff.HasBuff(self, 'SeraHealthBoost18') then
                Buff.RemoveBuff(self, 'SeraHealthBoost18')
            end
            if table.getn({self.lambdaEmitterTable}) > 0 then
                for k, v in self.lambdaEmitterTable do 
                    IssueClearCommands({self.lambdaEmitterTable[k]}) 
                    IssueKillSelf({self.lambdaEmitterTable[k]})
                end
            end
            self.wcAA01 = false
            self.wcAA02 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self.RBIntTier1 = false
            self.RBIntTier2 = false
            self.RBIntTier3 = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='BasicDefence' then
            if table.getn({self.lambdaEmitterTable}) > 0 then
                for k, v in self.lambdaEmitterTable do 
                    IssueClearCommands({self.lambdaEmitterTable[k]}) 
                    IssueKillSelf({self.lambdaEmitterTable[k]})
                end
            end
            local platOrientSm01 = self:GetOrientation()
            local platOrientLg01 = self:GetOrientation()
            local locationSm01 = self:GetPosition('S_Lambda_B01')
            local locationLg01 = self:GetPosition('L_Lambda_B01')
            local lambdaEmitterSm01 = CreateUnit('esb0002', self:GetArmy(), locationSm01[1], locationSm01[2], locationSm01[3], platOrientSm01[1], platOrientSm01[2], platOrientSm01[3], platOrientSm01[4], 'Land')
            local lambdaEmitterLg01 = CreateUnit('esb0001', self:GetArmy(), locationLg01[1], locationLg01[2], locationLg01[3], platOrientLg01[1], platOrientLg01[2], platOrientLg01[3], platOrientLg01[4], 'Land')
            table.insert (self.lambdaEmitterTable, lambdaEmitterSm01)
            table.insert (self.lambdaEmitterTable, lambdaEmitterLg01)
            lambdaEmitterSm01:AttachTo(self, 'S_Lambda_B01')
            lambdaEmitterLg01:AttachTo(self, 'L_Lambda_B01')
            lambdaEmitterSm01:SetParent(self, 'esl0001')
            lambdaEmitterLg01:SetParent(self, 'esl0001')
            lambdaEmitterSm01:SetCreator(self)
            lambdaEmitterLg01:SetCreator(self)
            self.Trash:Add(lambdaEmitterSm01)
            self.Trash:Add(lambdaEmitterLg01)
            if not Buffs['SeraHealthBoost19'] then
                BuffBlueprint {
                    Name = 'SeraHealthBoost19',
                    DisplayName = 'SeraHealthBoost19',
                    BuffType = 'SeraHealthBoost19',
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
            Buff.ApplyBuff(self, 'SeraHealthBoost19')
            local wepOC = self:GetWeaponByLabel('OverCharge')
            wepOC:ChangeMaxRadius(bp.OverchargeRangeMod or 44)
            wepOC:AddDamageMod(bp.OverchargeDamageMod)        
            self.RBComTier1 = true
            self.RBComTier2 = false
            self.RBComTier3 = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='BasicDefenceRemove' then
            if Buff.HasBuff(self, 'SeraHealthBoost19') then
                Buff.RemoveBuff(self, 'SeraHealthBoost19')
            end
            if table.getn({self.lambdaEmitterTable}) > 0 then
                for k, v in self.lambdaEmitterTable do 
                    IssueClearCommands({self.lambdaEmitterTable[k]}) 
                    IssueKillSelf({self.lambdaEmitterTable[k]})
                end
            end
            local wepOC = self:GetWeaponByLabel('OverCharge')
            local bpDisruptOCRadius = self:GetBlueprint().Weapon[2].MaxRadius
            wepOC:ChangeMaxRadius(bpDisruptOCRadius or 22)
            wepOC:AddDamageMod(-bp.OverchargeDamageMod)        
            self:StopSiloBuild()
            self.RBComTier1 = false
            self.RBComTier2 = false
            self.RBComTier3 = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='TacticalMisslePack' then
            self:AddCommandCap('RULEUCC_Tactical')
            self:AddCommandCap('RULEUCC_SiloBuildTactical')
            if not Buffs['SeraHealthBoost20'] then
                BuffBlueprint {
                    Name = 'SeraHealthBoost20',
                    DisplayName = 'SeraHealthBoost20',
                    BuffType = 'SeraHealthBoost20',
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
            Buff.ApplyBuff(self, 'SeraHealthBoost20')
            local wepOC = self:GetWeaponByLabel('OverCharge')
            wepOC:AddDamageMod(bp.OverchargeDamageMod2)        
            self.wcTMissiles01 = true
            self:ForkThread(self.WeaponRangeReset)
    
            self.RBComTier1 = true
            self.RBComTier2 = true
            self.RBComTier3 = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'TacticalMisslePackRemove' then
            self:RemoveCommandCap('RULEUCC_Tactical')
            self:RemoveCommandCap('RULEUCC_SiloBuildTactical')
            local amt = self:GetTacticalSiloAmmoCount()
            self:RemoveTacticalSiloAmmo(amt or 0)
            self:StopSiloBuild()
            if Buff.HasBuff(self, 'SeraHealthBoost19') then
                Buff.RemoveBuff(self, 'SeraHealthBoost19')
            end
            if Buff.HasBuff(self, 'SeraHealthBoost20') then
                Buff.RemoveBuff(self, 'SeraHealthBoost20')
            end
            if Buff.HasBuff(self, 'SeraHealthBoost21') then
                Buff.RemoveBuff(self, 'SeraHealthBoost21')
            end
            if table.getn({self.lambdaEmitterTable}) > 0 then
                for k, v in self.lambdaEmitterTable do 
                    IssueClearCommands({self.lambdaEmitterTable[k]}) 
                    IssueKillSelf({self.lambdaEmitterTable[k]})
                end
            end
            local wepOC = self:GetWeaponByLabel('OverCharge')
            local bpDisruptOCRadius = self:GetBlueprint().Weapon[2].MaxRadius
            wepOC:ChangeMaxRadius(bpDisruptOCRadius or 22)
            wepOC:AddDamageMod(-bp.OverchargeDamageMod)        
            wepOC:AddDamageMod(-bp.OverchargeDamageMod2)        
            self.wcTMissiles01 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self.RBComTier1 = false
            self.RBComTier2 = false
            self.RBComTier3 = false
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh =='OverchargeOverdrive' then
            if not Buffs['SeraHealthBoost21'] then
                BuffBlueprint {
                    Name = 'SeraHealthBoost21',
                    DisplayName = 'SeraHealthBoost21',
                    BuffType = 'SeraHealthBoost21',
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
            Buff.ApplyBuff(self, 'SeraHealthBoost21')   
            local wepOC = self:GetWeaponByLabel('OverCharge')
            wepOC:ChangeMaxRadius(bp.OverchargeRangeMod or 44)
            wepOC:AddDamageMod(bp.OverchargeDamageMod3)        
            wepOC:ChangeProjectileBlueprint(bp.NewProjectileBlueprint)
            self.RBComTier1 = true
            self.RBComTier2 = true
            self.RBComTier3 = true
            self:ForkThread(self.EXRegenBuffThread)
        elseif enh == 'OverchargeOverdriveRemove' then
            self:RemoveCommandCap('RULEUCC_Tactical')
            self:RemoveCommandCap('RULEUCC_SiloBuildTactical')
            local amt = self:GetTacticalSiloAmmoCount()
            self:RemoveTacticalSiloAmmo(amt or 0)
            self:StopSiloBuild()
            if Buff.HasBuff(self, 'SeraHealthBoost19') then
                Buff.RemoveBuff(self, 'SeraHealthBoost19')
            end
            if Buff.HasBuff(self, 'SeraHealthBoost20') then
                Buff.RemoveBuff(self, 'SeraHealthBoost20')
            end
            if Buff.HasBuff(self, 'SeraHealthBoost21') then
                Buff.RemoveBuff(self, 'SeraHealthBoost21')
            end
            if table.getn({self.lambdaEmitterTable}) > 0 then
                for k, v in self.lambdaEmitterTable do 
                    IssueClearCommands({self.lambdaEmitterTable[k]}) 
                    IssueKillSelf({self.lambdaEmitterTable[k]})
                end
            end
            local wepOC = self:GetWeaponByLabel('OverCharge')
            local bpDisruptOCRadius = self:GetBlueprint().Weapon[2].MaxRadius
            wepOC:ChangeMaxRadius(bpDisruptOCRadius or 22)
            wepOC:AddDamageMod(-bp.OverchargeDamageMod)        
            wepOC:AddDamageMod(-bp.OverchargeDamageMod2)        
            wepOC:AddDamageMod(-bp.OverchargeDamageMod3)        
            wepOC:ChangeProjectileBlueprint(bp.NewProjectileBlueprint)
            self.wcTMissiles01 = false
            self:ForkThread(self.WeaponRangeReset)
    
            self.RBComTier1 = false
            self.RBComTier2 = false
            self.RBComTier3 = false
            self:ForkThread(self.EXRegenBuffThread)
        end
    end,

    IntelEffects = {
        Cloak = {
            {
                Bones = {
                    'Body',
--                    'Right_Turret',
--                    'Left_Turret',
                    'Right_Arm_B01',
                    'Left_Arm_B01',
                    'Torso',
--                    'Chest_Left',
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
                    'Body',
--                    'Right_Turret',
--                    'Left_Turret',
                    'Right_Arm_B01',
                    'Left_Arm_B01',
                    'Torso',
--                    'Chest_Left',
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

    OnPaused = function(self)
        ACUUnit.OnPaused(self)
        if self.BuildingUnit then
            ACUUnit.StopBuildingEffects(self, self.UnitBeingBuilt)
        end
    end,

    OnUnpaused = function(self)
        if self.BuildingUnit then
            ACUUnit.StartBuildingEffects(self, self.UnitBeingBuilt, self.UnitBuildOrder)
        end
        ACUUnit.OnUnpaused(self)
    end,

    OnMotionHorzEventChange = function(self, new, old)
        if self.RBIntTier3 then
            if ((new == 'Stopped' or new == 'Stopping') and (old == 'Cruise' or old == 'TopSpeed')) then
                self.EXMoving = false
            elseif (old == 'Stopped' or (old == 'Stopping' and (new == 'Cruise' or new == 'TopSpeed'))) then
                self.EXMoving = true
            end
        end
        ACUUnit.OnMotionHorzEventChange(self, new, old)
    end,

    EXRecloakDelayThread = function(self)
        WaitSeconds(3)
        self.EXCloakTele = false
    end,

    EXOCCloakTiming = function(self)
        WaitSeconds(5)
        self.EXOCFire = false
    end,

    OnFailedTeleport = function(self)
        ACUUnit.OnFailedTeleport(self)
        self:ForkThread(self.EXRecloakDelayThread)
    end,

    PlayTeleportChargeEffects = function(self, location)
        self.EXCloakTele = true
        ACUUnit.PlayTeleportChargeEffects(self, location)
    end,
    
    PlayTeleportInEffects = function(self)
        ACUUnit.PlayTeleportInEffects(self)
        self:ForkThread(self.EXRecloakDelayThread)
    end,

}

TypeClass = ESL0001