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
local EffectUtil = import('/lua/EffectUtilities.lua')
local AIUtils = import('/lua/ai/aiutilities.lua')
local SANUallCavitationTorpedo = SWeapons.SANUallCavitationTorpedo
local BOWeapons = import('/mods/BlackOpsFAF-ACUs/lua/ACUsWeapons.lua')
local SeraACURapidWeapon = BOWeapons.SeraACURapidWeapon
local SeraACUBigBallWeapon = BOWeapons.SeraACUBigBallWeapon
local SAAOlarisCannonWeapon = SWeapons.SAAOlarisCannonWeapon
local CEMPArrayBeam01 = BOWeapons.CEMPArrayBeam01
local SeraACUMissile = BOWeapons.SeraACUMissile

ESL0001 = Class(ACUUnit) {
    DeathThreadDestructionWaitTime = 2,
    PainterRange = {},
    
    Weapons = {
        DeathWeapon = Class(DeathNukeWeapon) {},
        TargetPainter = Class(CEMPArrayBeam01) {},
        ChronotronCannon = Class(SDFChronotronCannonWeapon) {},
        TorpedoLauncher = Class(SANUallCavitationTorpedo) {},
        BigBallCannon = Class(SeraACUBigBallWeapon) {},
        RapidCannon = Class(SeraACURapidWeapon) {},
        AA01 = Class(SAAOlarisCannonWeapon) {},
        AA02 = Class(SAAOlarisCannonWeapon) {},
        Missile = Class(SeraACUMissile) {},
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

        local bp = self:GetBlueprint()
        for _, v in bp.Display.WarpInEffect.HideBones do
            self:HideBone(v, true)
        end

        -- Restrict what enhancements will enable later
        self:AddBuildRestriction(categories.SERAPHIM * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        ACUUnit.OnStopBeingBuilt(self,builder,layer)
        
        self:SetWeaponEnabledByLabel('TorpedoLauncher', false)
        self:SetWeaponEnabledByLabel('BigBallCannon', false)
        self:SetWeaponEnabledByLabel('RapidCannon', false)
        self:SetWeaponEnabledByLabel('AA01', false)
        self:SetWeaponEnabledByLabel('AA02', false)
        self:SetWeaponEnabledByLabel('Missile', false)

        self:DisableUnitIntel('ToggleBit5', 'RadarStealth')
        self:DisableUnitIntel('ToggleBit5', 'SonarStealth')
        self:DisableUnitIntel('ToggleBit8', 'Cloak')

        self:ForkThread(self.GiveInitialResources)
        self.RegenFieldFXBag = {}
        self.lambdaEmitterTable = {}
        self:StartRotators()
    end,
    
    StartRotators = function(self)
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

    CreateBuildEffects = function(self, unitBeingBuilt, order)
        EffectUtil.CreateSeraphimUnitEngineerBuildingEffects(self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag)
    end,

    OnTransportDetach = function(self, attachBone, unit)
        ACUUnit.OnTransportDetach(self, attachBone, unit)
        self:StopSiloBuild()

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

    RegenBuffThread = function(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        local buff

        if enh == 'CombatEngineering' then
            buff = 'SeraphimACURegenAura'
        elseif enh == 'AssaultEngineering' then
            buff = 'SeraphimACUAdvancedRegenAura'
        end

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

        -- Change Damage
        wep:AddDamageMod(damage)

        -- Change Radius
        wep:ChangeMaxRadius(wepRadius)
        oc:ChangeMaxRadius(ocRadius)
        aoc:ChangeMaxRadius(aocRadius)
        
        -- As radius is only passed when turning on, use the bool
        if radius then
            self:SetPainterRange('JuryRiggedChronotron', radius, false)
        else
            self:SetPainterRange('JuryRiggedChronotronRemove', radius, true)
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

    -- Size is 'L' or 'S', bone is 1 through 4, unit is the unit ID ending
    CreateLambdaUnit = function(self, size, bone, unit, removal)
        local boneLabel = size .. '_Lambda_B0' .. bone
        
        -- If this is a removal, take the quick way out
        if removal and self.lambdaEmitterTable[boneLabel] then
            IssueClearCommands({self.lambdaEmitterTable[boneLabel]})
            IssueKillSelf({self.lambdaEmitterTable[boneLabel]})
            self.lambdaEmitterTable[boneLabel] = nil
            return
        end

        local orientation = self:GetOrientation()
        local boneLocation = self:GetPosition(boneLabel)
        local unitID = 'esb000' .. unit

        local lambdaUnit = CreateUnit(unitID, self:GetArmy(),
                                      boneLocation[1], boneLocation[2], boneLocation[3],
                                      orientation[1], orientation[2], orientation[3], orientation[4], 'Land')

        self.lambdaEmitterTable[boneLabel] = lambdaUnit
        lambdaUnit:AttachTo(self, boneLabel)
        lambdaUnit:SetParent(self, 'esl0001')
        lambdaUnit:SetCreator(self)
        self.Trash:Add(lambdaUnit)
    end,

    OnMotionHorzEventChange = function(self, new, old)
        if new ~= 'Stopped' and self.HiddenACU then
            self:SetScriptBit('RULEUTC_CloakToggle', true) -- Disable counter-intel
        end

        ACUUnit.OnMotionHorzEventChange(self, new, old)
    end,

    OnIntelEnabled = function(self)
        ACUUnit.OnIntelEnabled(self)
        if self:HasEnhancement('CloakingSubsystems') and self.HiddenACU then
            self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Enhancements['CloakingSubsystems'].MaintenanceConsumptionPerSecondEnergy)
            self:SetMaintenanceConsumptionActive()
            if not self.IntelEffectsBag then
                self.IntelEffectsBag = {}
                self.CreateTerrainTypeEffects(self, self.IntelEffects.Cloak, 'FXIdle',  self:GetCurrentLayer(), nil, self.IntelEffectsBag)
            end
        end
    end,

    OnIntelDisabled = function(self)
        ACUUnit.OnIntelDisabled(self)
        if self.IntelEffectsBag then
            EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
            self.IntelEffectsBag = nil
        end
        if self:HasEnhancement('CloakingSubsystems') and not self.HiddenACU then
            self:SetMaintenanceConsumptionInactive()
        end
    end,

    -- Set custom flag and add Stealth and Cloak toggles to the switch
    OnScriptBitSet = function(self, bit)
        if bit == 8 then
            if self.CloakThread then
                KillThread(self.CloakThread)
                self.CloakThread = nil
            end

            self.HiddenACU = false
            self:SetFireState(2)
            self:SetMaintenanceConsumptionInactive()
            self:DisableUnitIntel('ToggleBit5', 'RadarStealth')
            self:DisableUnitIntel('ToggleBit5', 'SonarStealth')
            self:DisableUnitIntel('ToggleBit8', 'Cloak')

            if not self.MaintenanceConsumption then
                self.ToggledOff = true
            end
        else
            ACUUnit.OnScriptBitSet(self, bit)
        end
    end,

    OnScriptBitClear = function(self, bit)
        if bit == 8 then
            if not self.CloakThread then
                self.CloakThread = ForkThread(function()
                    WaitSeconds(2)

                    self.HiddenACU = true
                    self:SetFireState(1)
                    self:SetMaintenanceConsumptionActive()
                    self:EnableUnitIntel('ToggleBit5', 'RadarStealth')
                    self:EnableUnitIntel('ToggleBit5', 'SonarStealth')
                    self:EnableUnitIntel('ToggleBit8', 'Cloak')

                    IssueStop({self}) -- This later stop stops people circumventing the no-motion clause
                    IssueClearCommands({self})

                    if self.MaintenanceConsumption then
                        self.ToggledOff = false
                    end
                end)
            end

            -- This sends one stop, to force the unit to a halt etc
            IssueStop({self})
            IssueClearCommands({self})
        else
            ACUUnit.OnScriptBitClear(self, bit)
        end
    end,

    CreateEnhancement = function(self, enh, removal)
        ACUUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
        if enh == 'ImprovedEngineering' then
            self:RemoveBuildRestriction(categories.SERAPHIM * categories.BUILTBYTIER2COMMANDER)
            self:updateBuildRestrictions()
            self:SetProduction(bp)
            
            if not Buffs['SERAPHIMACUT2BuildRate'] then
                BuffBlueprint {
                    Name = 'SERAPHIMACUT2BuildRate',
                    DisplayName = 'SERAPHIMACUT2BuildRate',
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
            Buff.ApplyBuff(self, 'SERAPHIMACUT2BuildRate')            
        elseif enh == 'ImprovedEngineeringRemove' then
            if Buff.HasBuff(self, 'SERAPHIMACUT2BuildRate') then
                Buff.RemoveBuff(self, 'SERAPHIMACUT2BuildRate')
            end

            self:AddBuildRestriction(categories.SERAPHIM * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            self:SetProduction()
        elseif enh == 'AdvancedEngineering' then
            self:RemoveBuildRestriction(categories.SERAPHIM * (categories.BUILTBYTIER3COMMANDER - categories.BUILTBYTIER4COMMANDER))
            self:updateBuildRestrictions()
            self:SetProduction(bp)
            
            if not Buffs['SERAPHIMACUT3BuildRate'] then
                BuffBlueprint {
                    Name = 'SERAPHIMACUT3BuildRate',
                    DisplayName = 'SERAPHIMCUT3BuildRate',
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
            Buff.ApplyBuff(self, 'SERAPHIMACUT3BuildRate')
        elseif enh == 'AdvancedEngineeringRemove' then
            if Buff.HasBuff(self, 'SERAPHIMACUT3BuildRate') then
                Buff.RemoveBuff(self, 'SERAPHIMACUT3BuildRate')
            end
            self:AddBuildRestriction(categories.SERAPHIM * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            self:SetProduction()
        elseif enh == 'ExperimentalEngineering' then
            self:RemoveBuildRestriction(categories.SERAPHIM * (categories.BUILTBYTIER4COMMANDER))
            self:updateBuildRestrictions()
            self:SetProduction(bp)

            if not Buffs['SERAPHIMACUT4BuildRate'] then
                BuffBlueprint {
                    Name = 'SERAPHIMACUT4BuildRate',
                    DisplayName = 'SERAPHIMCUT4BuildRate',
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
            Buff.ApplyBuff(self, 'SERAPHIMACUT4BuildRate')
        elseif enh == 'ExperimentalEngineeringRemove' then
            if Buff.HasBuff(self, 'SERAPHIMACUT4BuildRate') then
                Buff.RemoveBuff(self, 'SERAPHIMACUT4BuildRate')
            end
            self:AddBuildRestriction(categories.SERAPHIM * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            self:SetProduction()
        elseif enh == 'CombatEngineering' then
            self:RemoveBuildRestriction(categories.SERAPHIM * categories.BUILTBYTIER2COMMANDER)
            self:updateBuildRestrictions()

            -- Build buff tables
            if not Buffs['SeraphimACURegenAura'] then
                BuffBlueprint {
                    Name = 'SeraphimACURegenAura',
                    DisplayName = 'SeraphimACURegenAura',
                    BuffType = 'COMMANDERAURA_RegenAura',
                    Stacks = 'REPLACE',
                    Duration = 5,
                    Affects = {
                        Regen = {
                            Add = 0,
                            Mult = bp.RegenPerSecond,
                            Ceil = bp.RegenCeiling,
                        },
                    },
                }
            end
            
            if not Buffs['SERAPHIMACUT2BuildCombat'] then -- Self Buff
                BuffBlueprint {
                    Name = 'SERAPHIMACUT2BuildCombat',
                    DisplayName = 'SERAPHIMACUT2BuildCombat',
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
                            Mult = 1,
                        },
                        Regen = {
                            Add = bp.NewRegenRate,
                            Mult = 1.0,
                        },
                    },
                }
            end
            
            -- Remove existing threads, then re-apply
            if self.RegenFieldFXBag then
                for k, v in self.RegenFieldFXBag do
                    v:Destroy()
                end
                self.RegenFieldFXBag = {}
            end

            if self.RegenThreadHandler then
                KillThread(self.RegenThreadHandler)
                self.RegenThreadHandler = nil
            end
            self.RegenThreadHandler = self:ForkThread(self.RegenBuffThread, enh)
            table.insert(self.RegenFieldFXBag, CreateAttachedEmitter(self, 'XSL0001', self:GetArmy(), '/effects/emitters/seraphim_regenerative_aura_01_emit.bp'))

            -- Affect the ACU
            Buff.ApplyBuff(self, 'SERAPHIMACUT2BuildCombat')
        elseif enh == 'CombatEngineeringRemove' then
            if Buff.HasBuff(self, 'SERAPHIMACUT2BuildCombat') then
                Buff.RemoveBuff(self, 'SERAPHIMACUT2BuildCombat')
            end

            self:AddBuildRestriction(categories.SERAPHIM * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))

            -- Kill regen aura
            if self.RegenThreadHandler then
                KillThread(self.RegenThreadHandler)
                self.RegenThreadHandler = nil
            end

            if self.RegenFieldFXBag then
                for k, v in self.RegenFieldFXBag do
                    v:Destroy()
                end
                self.RegenFieldFXBag = {}
            end
        elseif enh == 'AssaultEngineering' then
            self:RemoveBuildRestriction(categories.SERAPHIM * (categories.BUILTBYTIER3COMMANDER - categories.BUILTBYTIER4COMMANDER))
            self:updateBuildRestrictions()
        
            -- Build buff tables
            if not Buffs['SeraphimACUAdvancedRegenAura'] then
                BuffBlueprint {
                    Name = 'SeraphimACUAdvancedRegenAura',
                    DisplayName = 'SeraphimACUAdvancedRegenAura',
                    BuffType = 'COMMANDERAURA_AdvancedRegenAura',
                    Stacks = 'REPLACE',
                    Duration = 5,
                    Affects = {
                        Regen = {
                            Add = 0,
                            Mult = bp.RegenPerSecond,
                            Ceil = bp.RegenCeiling,
                        },
                        MaxHealth = {
                            Add = 0,
                            Mult = bp.MaxHealthFactor,
                            DoNoFill = true,
                        }
                    },
                }
            end
        
            if not Buffs['SERAPHIMACUT3BuildCombat'] then -- Self Buff
                BuffBlueprint {
                    Name = 'SERAPHIMACUT3BuildCombat',
                    DisplayName = 'SERAPHIMACUT3BuildCombat',
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
                            Mult = 1,
                        },
                        Regen = {
                            Add = bp.NewRegenRate,
                            Mult = 1.0,
                        },
                    },
                }
            end
        
            -- Remove existing threads, then re-apply
            if self.RegenFieldFXBag then
                for k, v in self.RegenFieldFXBag do
                    v:Destroy()
                end
                self.RegenFieldFXBag = {}
            end
            
            if self.RegenThreadHandler then
                KillThread(self.RegenThreadHandler)
                self.RegenThreadHandler = nil
            end
            self.RegenThreadHandler = self:ForkThread(self.RegenBuffThread, enh)
            table.insert(self.RegenFieldFXBag, CreateAttachedEmitter(self, 'XSL0001', self:GetArmy(), '/effects/emitters/seraphim_regenerative_aura_01_emit.bp'))

            -- Affect the ACU
            Buff.ApplyBuff(self, 'SERAPHIMACUT3BuildCombat')
        elseif enh == 'AssaultEngineeringRemove' then
            if Buff.HasBuff(self, 'SERAPHIMACUT3BuildCombat') then
                Buff.RemoveBuff(self, 'SERAPHIMACUT3BuildCombat')
            end

            self:AddBuildRestriction(categories.SERAPHIM * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER)) 

            -- Kill regen aura
            if self.RegenThreadHandler then
                KillThread(self.RegenThreadHandler)
                self.RegenThreadHandler = nil
            end

            if self.RegenFieldFXBag then
                for k, v in self.RegenFieldFXBag do
                    v:Destroy()
                end
                self.RegenFieldFXBag = {}
            end
        elseif enh == 'ApocalypticEngineering' then
            self:RemoveBuildRestriction(categories.SERAPHIM * (categories.BUILTBYTIER4COMMANDER))
            self:updateBuildRestrictions()
        
            if not Buffs['SERAPHIMACUT4BuildCombat'] then
                BuffBlueprint {
                    Name = 'SERAPHIMACUT4BuildCombat',
                    DisplayName = 'SERAPHIMACUT4BuildCombat',
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
                            Mult = 1,
                        },
                        Regen = {
                            Add = bp.NewRegenRate,
                            Mult = 1.0,
                        },
                    },
                }
            end
        
            Buff.ApplyBuff(self, 'SERAPHIMACUT4BuildCombat')
        elseif enh == 'ApocalypticEngineeringRemove' then
            if Buff.HasBuff(self, 'SERAPHIMACUT4BuildCombat') then
                Buff.RemoveBuff(self, 'SERAPHIMACUT4BuildCombat')
            end
        
            self:AddBuildRestriction(categories.SERAPHIM * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))

        -- Chronoton Booster
        
        elseif enh == 'JuryRiggedChronotron' then
            self:TogglePrimaryGun(bp.NewDamage, bp.NewRadius)
        elseif enh == 'JuryRiggedChronotronRemove' then
            self:TogglePrimaryGun(bp.NewDamage)
        elseif enh == 'TorpedoLauncher' then
            if not Buffs['SeraphimTorpHealth1'] then
                BuffBlueprint {
                    Name = 'SeraphimTorpHealth1',
                    DisplayName = 'SeraphimTorpHealth1',
                    BuffType = 'SeraphimTorpHealth',
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
            Buff.ApplyBuff(self, 'SeraphimTorpHealth1')
            
            self:SetWeaponEnabledByLabel('TorpedoLauncher', true)
        elseif enh == 'TorpedoLauncherRemove' then
            if Buff.HasBuff(self, 'SeraphimTorpHealth1') then
                Buff.RemoveBuff(self, 'SeraphimTorpHealth1')
            end
            
            self:SetWeaponEnabledByLabel('TorpedoLauncher', true)
        elseif enh == 'ImprovedReloader' then
            if not Buffs['SeraphimTorpHealth2'] then
                BuffBlueprint {
                    Name = 'SeraphimTorpHealth2',
                    DisplayName = 'SeraphimTorpHealth2',
                    BuffType = 'SeraphimTorpHealth',
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
            Buff.ApplyBuff(self, 'SeraphimTorpHealth2')

            local torp = self:GetWeaponByLabel('TorpedoLauncher')
            torp:AddDamageMod(bp.NewTorpDamage)
            torp:ChangeRateOfFire(bp.NewTorpROF)

            self:TogglePrimaryGun(bp.NewDamage, bp.NewRadius)
        elseif enh == 'ImprovedReloaderRemove' then
            if Buff.HasBuff(self, 'SeraphimTorpHealth2') then
                Buff.RemoveBuff(self, 'SeraphimTorpHealth2')
            end

            local torp = self:GetWeaponByLabel('TorpedoLauncher')
            torp:AddDamageMod(bp.NewTorpDamage)
            torp:ChangeRateOfFire(torp:GetBlueprint().RateOfFire)
            
            self:TogglePrimaryGun(bp.NewDamage)
        elseif enh == 'AdvancedWarheads' then
            if not Buffs['SeraphimTorpHealth3'] then
                BuffBlueprint {
                    Name = 'SeraphimTorpHealth3',
                    DisplayName = 'SeraphimTorpHealth3',
                    BuffType = 'SeraphimTorpHealth',
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
            Buff.ApplyBuff(self, 'SeraphimTorpHealth3')

            local torp = self:GetWeaponByLabel('TorpedoLauncher')
            torp:AddDamageMod(bp.NewTorpDamage)

            local gun = self:GetWeaponByLabel('ChronotronCannon')
            gun:AddDamageMod(bp.NewDamage)
        elseif enh == 'AdvancedWarheadsRemove' then
            if Buff.HasBuff(self, 'SeraphimTorpHealth3') then
                Buff.RemoveBuff(self, 'SeraphimTorpHealth3')
            end

            local torp = self:GetWeaponByLabel('TorpedoLauncher')
            torp:AddDamageMod(bp.NewTorpDamage)

            local gun = self:GetWeaponByLabel('ChronotronCannon')
            gun:AddDamageMod(bp.NewDamage)

        -- Big Cannon Ball

        elseif enh == 'QuantumStormCannon' then
            if not Buffs['SeraphimBallHealth1'] then
                BuffBlueprint {
                    Name = 'SeraphimBallHealth1',
                    DisplayName = 'SeraphimBallHealth1',
                    BuffType = 'SeraphimBallHealth',
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
            Buff.ApplyBuff(self, 'SeraphimBallHealth1')

            self:SetWeaponEnabledByLabel('BigBallCannon', true)

            local wep = self:GetWeaponByLabel('BigBallCannon')
            wep:ChangeMaxRadius(bp.CannonMaxRadius)

            self:SetPainterRange(enh, bp.CannonMaxRadius, false)
        elseif enh == 'QuantumStormCannonRemove' then
            if Buff.HasBuff(self, 'SeraphimBallHealth1') then
                Buff.RemoveBuff(self, 'SeraphimBallHealth1')
            end

            self:SetWeaponEnabledByLabel('BigBallCannon', false)

            local wep = self:GetWeaponByLabel('BigBallCannon')
            wep:ChangeMaxRadius(wep:GetBlueprint().MaxRadius)

            self:SetPainterRange(enh, 0, true)
        elseif enh == 'PowerConversionEnhancer' then
            if not Buffs['SeraphimBallHealth2'] then
                BuffBlueprint {
                    Name = 'SeraphimBallHealth2',
                    DisplayName = 'SeraphimBallHealth2',
                    BuffType = 'SeraphimBallHealth',
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
            Buff.ApplyBuff(self, 'SeraphimBallHealth2')

            local cannon = self:GetWeaponByLabel('BigBallCannon')
            cannon:AddDamageMod(bp.StormDamage)
            cannon:ChangeMaxRadius(bp.StormRange)
            cannon:ChangeDamageRadius(bp.StormRadius)

            self:SetPainterRange(enh, bp.StormRange, false)

            -- Enable main gun upgrade
            self:TogglePrimaryGun(bp.NewDamage, bp.NewRadius)
        elseif enh == 'PowerConversionEnhancerRemove' then
            if Buff.HasBuff(self, 'SeraphimBallHealth2') then
                Buff.RemoveBuff(self, 'SeraphimBallHealth2')
            end

            local cannon = self:GetWeaponByLabel('BigBallCannon')
            cannon:AddDamageMod(bp.StormDamage)
            cannon:ChangeMaxRadius(cannon:GetBlueprint().MaxRadius)
            cannon:ChangeDamageRadius(cannon:GetBlueprint().DamageRadius)

            self:SetPainterRange(enh, 0, true)

            -- Turn off main gun upgrade
            self:TogglePrimaryGun(bp.NewDamage)
        elseif enh == 'AdvancedDistortionAlgorithms' then
            if not Buffs['SeraphimBallHealth3'] then
                BuffBlueprint {
                    Name = 'SeraphimBallHealth3',
                    DisplayName = 'SeraphimBallHealth3',
                    BuffType = 'SeraphimBallHealth',
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
            Buff.ApplyBuff(self, 'SeraphimBallHealth3')

            local cannon = self:GetWeaponByLabel('BigBallCannon')
            cannon:AddDamageMod(bp.StormDamage)
            cannon:ChangeMaxRadius(bp.StormRange)

            self:SetPainterRange(enh, bp.StormRange, false)
        elseif enh == 'AdvancedDistortionAlgorithmsRemove' then    
            if Buff.HasBuff(self, 'SeraphimBallHealth3') then
                Buff.RemoveBuff(self, 'SeraphimBallHealth3')
            end

            local cannon = self:GetWeaponByLabel('BigBallCannon')
            cannon:AddDamageMod(bp.StormDamage)
            cannon:ChangeMaxRadius(cannon:GetBlueprint().MaxRadius)

            self:SetPainterRange(enh, 0, true)

        -- Gatling Cannon

        elseif enh == 'PlasmaGatlingCannon' then
            if not Buffs['SeraphimGatlingHealth1'] then
                BuffBlueprint {
                    Name = 'SeraphimGatlingHealth1',
                    DisplayName = 'SeraphimGatlingHealth1',
                    BuffType = 'SeraphimGatlingHealth',
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
            Buff.ApplyBuff(self, 'SeraphimGatlingHealth1')

            self:SetWeaponEnabledByLabel('RapidCannon', true)

            local wep = self:GetWeaponByLabel('RapidCannon')
            wep:ChangeMaxRadius(bp.GatlingRange)

            self:SetPainterRange(enh, bp.GatlingRange, false)
        elseif enh == 'PlasmaGatlingCannonRemove' then
            if Buff.HasBuff(self, 'SeraphimGatlingHealth1') then
                Buff.RemoveBuff(self, 'SeraphimGatlingHealth1')
            end

            self:SetWeaponEnabledByLabel('RapidCannon', false)

            self:SetPainterRange(enh, 0, true)
        elseif enh == 'PhasedEnergyFields' then
            if not Buffs['SeraphimGatlingHealth2'] then
                BuffBlueprint {
                    Name = 'SeraphimGatlingHealth2',
                    DisplayName = 'SeraphimGatlingHealth2',
                    BuffType = 'SeraphimGatlingHealth',
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
            Buff.ApplyBuff(self, 'SeraphimGatlingHealth2')

            local gun = self:GetWeaponByLabel('RapidCannon')
            gun:AddDamageMod(bp.GatlingDamage)
            gun:ChangeMaxRadius(bp.GatlingRange)

            self:SetPainterRange(enh, bp.GatlingRange, false)

            -- Enable main gun upgrade
            self:TogglePrimaryGun(bp.NewDamage, bp.NewRadius)
        elseif enh == 'PhasedEnergyFieldsRemove' then
            if Buff.HasBuff(self, 'SeraphimGatlingHealth2') then
                Buff.RemoveBuff(self, 'SeraphimGatlingHealth2')
            end

            local gun = self:GetWeaponByLabel('RapidCannon')
            gun:AddDamageMod(bp.GatlingDamage)
            gun:ChangeMaxRadius(gun:GetBlueprint().MaxRadius)

            self:SetPainterRange(enh, 0, true)

            -- Turn off main gun upgrade
            self:TogglePrimaryGun(bp.NewDamage)
        elseif enh == 'SecondaryPowerFeeds' then
            if not Buffs['SeraphimGatlingHealth3'] then
                BuffBlueprint {
                    Name = 'SeraphimGatlingHealth3',
                    DisplayName = 'SeraphimGatlingHealth3',
                    BuffType = 'SeraphimGatlingHealth',
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
            Buff.ApplyBuff(self, 'SeraphimGatlingHealth3')

            local gun = self:GetWeaponByLabel('RapidCannon')
            gun:AddDamageMod(bp.GatlingDamage)
        elseif enh == 'SecondaryPowerFeedsRemove' then
            if Buff.HasBuff(self, 'SeraphimGatlingHealth3') then
                Buff.RemoveBuff(self, 'SeraphimGatlingHealth3')
            end

            local gun = self:GetWeaponByLabel('RapidCannon')
            gun:AddDamageMod(bp.GatlingDamage)

        -- Lambda System

        elseif enh == 'LambdaFieldEmitters' then
            if not Buffs['SeraphimLambdaHealth1'] then
                BuffBlueprint {
                    Name = 'SeraphimLambdaHealth1',
                    DisplayName = 'SeraphimLambdaHealth1',
                    BuffType = 'SeraphimLambdaHealth',
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
            Buff.ApplyBuff(self, 'SeraphimLambdaHealth1')

            -- Create Lambda units and attach
            self:CreateLambdaUnit('S', '1', '2')
            self:CreateLambdaUnit('L', '1', '1')
        elseif enh == 'LambdaFieldEmittersRemove' then
            if Buff.HasBuff(self, 'SeraphimLambdaHealth1') then
                Buff.RemoveBuff(self, 'SeraphimLambdaHealth1')
            end

            self:CreateLambdaUnit('S', '1', '2', true)
            self:CreateLambdaUnit('L', '1', '1', true)
        elseif enh == 'EnhancedLambdaEmitters' then
            if not Buffs['SeraphimLambdaHealth2'] then
                BuffBlueprint {
                    Name = 'SeraphimLambdaHealth2',
                    DisplayName = 'SeraphimLambdaHealth2',
                    BuffType = 'SeraphimLambdaHealth',
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
            Buff.ApplyBuff(self, 'SeraphimLambdaHealth2')

            
            self:CreateLambdaUnit('S', '2', '3')
            self:CreateLambdaUnit('L', '2', '1')
        elseif enh == 'EnhancedLambdaEmittersRemove' then
            if Buff.HasBuff(self, 'SeraphimLambdaHealth2') then
                Buff.RemoveBuff(self, 'SeraphimLambdaHealth2')
            end

            self:CreateLambdaUnit('S', '2', '3', true)
            self:CreateLambdaUnit('L', '2', '1', true)
        elseif enh == 'ControlledQuantumRuptures' then
            if not Buffs['SeraphimLambdaHealth3'] then
                BuffBlueprint {
                    Name = 'SeraphimLambdaHealth3',
                    DisplayName = 'SeraphimLambdaHealth3',
                    BuffType = 'SeraphimLambdaHealth',
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
            Buff.ApplyBuff(self, 'SeraphimLambdaHealth3')

            self:CreateLambdaUnit('S', '3', '4')
            self:CreateLambdaUnit('L', '3', '4')
        elseif enh == 'ControlledQuantumRupturesRemove' then
            if Buff.HasBuff(self, 'SeraphimLambdaHealth3') then
                Buff.RemoveBuff(self, 'SeraphimLambdaHealth3')
            end

            self:CreateLambdaUnit('S', '3', '4', true)
            self:CreateLambdaUnit('L', '3', '4', true)
            
        -- Intel Systems

        elseif enh == 'ElectronicsEnhancment' then
            if not Buffs['SeraphimIntelHealth1'] then
                BuffBlueprint {
                    Name = 'SeraphimIntelHealth1',
                    DisplayName = 'SeraphimIntelHealth1',
                    BuffType = 'SeraphimIntelHealth',
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
            Buff.ApplyBuff(self, 'SeraphimIntelHealth1')

            self:SetIntelRadius('Vision', bp.NewVisionRadius)
            self:SetIntelRadius('WaterVision', bp.NewVisionRadius)
            self:SetIntelRadius('Omni', bp.NewOmniRadius)
        elseif enh == 'ElectronicsEnhancmentRemove' then
            if Buff.HasBuff(self, 'SeraphimIntelHealth1') then
                Buff.RemoveBuff(self, 'SeraphimIntelHealth1')
            end

            local bpIntel = self:GetBlueprint().Intel
            self:SetIntelRadius('Vision', bpIntel.VisionRadius)
            self:SetIntelRadius('WaterVision', bpIntel.VisionRadius)
            self:SetIntelRadius('Omni', bpIntel.OmniRadius)
        elseif enh == 'PersonalTeleporter' then
            if not Buffs['SeraphimIntelHealth2'] then
                BuffBlueprint {
                    Name = 'SeraphimIntelHealth2',
                    DisplayName = 'SeraphimIntelHealth2',
                    BuffType = 'SeraphimIntelHealth',
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
            Buff.ApplyBuff(self, 'SeraphimIntelHealth2')

            self:AddCommandCap('RULEUCC_Teleport')

            self:SetWeaponEnabledByLabel('AA01', true)
            self:SetWeaponEnabledByLabel('AA02', true)
        elseif enh == 'PersonalTeleporterRemove' then
            if Buff.HasBuff(self, 'SeraphimIntelHealth2') then
                Buff.RemoveBuff(self, 'SeraphimIntelHealth2')
            end

            self:RemoveCommandCap('RULEUCC_Teleport')

            self:SetWeaponEnabledByLabel('AA01', false)
            self:SetWeaponEnabledByLabel('AA02', false)
        elseif enh == 'CloakingSubsystems' then
            if not Buffs['SeraphimIntelHealth3'] then
                BuffBlueprint {
                    Name = 'SeraphimIntelHealth3',
                    DisplayName = 'SeraphimIntelHealth3',
                    BuffType = 'SeraphimIntelHealth',
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
            Buff.ApplyBuff(self, 'SeraphimIntelHealth3')

            if self.IntelEffectsBag then
                EffectUtil.CleanupEffectBag(self, 'IntelEffectsBag')
                self.IntelEffectsBag = nil
            end

            self:AddToggleCap('RULEUTC_CloakToggle')
            self:SetScriptBit('RULEUTC_CloakToggle', true)
        elseif enh == 'CloakingSubsystemsRemove' then
            if Buff.HasBuff(self, 'SeraphimIntelHealth3') then
                Buff.RemoveBuff(self, 'SeraphimIntelHealth3')
            end

            if self.IntelEffectsBag then
                EffectUtil.CleanupEffectBag(self, 'IntelEffectsBag')
                self.IntelEffectsBag = nil
            end

            self:RemoveToggleCap('RULEUTC_CloakToggle')

        -- Defensive Systems

        elseif enh == 'ImprovedCombatSystems' then
            if not Buffs['SeraphimCombatHealth1'] then
                BuffBlueprint {
                    Name = 'SeraphimCombatHealth1',
                    DisplayName = 'SeraphimCombatHealth1',
                    BuffType = 'SeraphimCombatHealth',
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
            Buff.ApplyBuff(self, 'SeraphimCombatHealth1')

            local wepOC = self:GetWeaponByLabel('OverCharge')
            local wepAutoOC = self:GetWeaponByLabel('AutoOverCharge')
            wepOC:AddDamageMod(bp.OverchargeDamageMod)
            wepAutoOC:AddDamageMod(bp.OverchargeDamageMod)
        elseif enh == 'ImprovedCombatSystemsRemove' then
            if Buff.HasBuff(self, 'SeraphimCombatHealth1') then
                Buff.RemoveBuff(self, 'SeraphimCombatHealth1')
            end

            local wepOC = self:GetWeaponByLabel('OverCharge')
            local wepAutoOC = self:GetWeaponByLabel('AutoOverCharge')
            wepOC:AddDamageMod(bp.OverchargeDamageMod)
            wepAutoOC:AddDamageMod(bp.OverchargeDamageMod)
        elseif enh == 'TacticalMisslePack' then
            if not Buffs['SeraphimCombatHealth2'] then
                BuffBlueprint {
                    Name = 'SeraphimCombatHealth2',
                    DisplayName = 'SeraphimCombatHealth2',
                    BuffType = 'SeraphimCombatHealth',
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
            Buff.ApplyBuff(self, 'SeraphimCombatHealth2')

            self:AddCommandCap('RULEUCC_Tactical')
            self:AddCommandCap('RULEUCC_SiloBuildTactical')

            local wepOC = self:GetWeaponByLabel('OverCharge')
            local wepAutoOC = self:GetWeaponByLabel('AutoOverCharge')
            wepOC:AddDamageMod(bp.OverchargeDamageMod)
            wepAutoOC:AddDamageMod(bp.OverchargeDamageMod)

            self:SetWeaponEnabledByLabel('Missile', true)
        elseif enh == 'TacticalMisslePackRemove' then
            if Buff.HasBuff(self, 'SeraphimCombatHealth2') then
                Buff.RemoveBuff(self, 'SeraphimCombatHealth2')
            end

            self:RemoveCommandCap('RULEUCC_Tactical')
            self:RemoveCommandCap('RULEUCC_SiloBuildTactical')

            local amt = self:GetTacticalSiloAmmoCount()
            self:RemoveTacticalSiloAmmo(amt or 0)
            self:StopSiloBuild()

            local wepOC = self:GetWeaponByLabel('OverCharge')
            local wepAutoOC = self:GetWeaponByLabel('AutoOverCharge')
            wepOC:AddDamageMod(bp.OverchargeDamageMod)
            wepAutoOC:AddDamageMod(bp.OverchargeDamageMod)
        elseif enh == 'OverchargeAmplifier' then
            if not Buffs['SeraphimCombatHealth3'] then
                BuffBlueprint {
                    Name = 'SeraphimCombatHealth3',
                    DisplayName = 'SeraphimCombatHealth3',
                    BuffType = 'SeraphimCombatHealth',
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
            Buff.ApplyBuff(self, 'SeraphimCombatHealth3')

            local wepOC = self:GetWeaponByLabel('OverCharge')
            local wepAutoOC = self:GetWeaponByLabel('AutoOverCharge')
            wepOC:AddDamageMod(bp.OverchargeDamageMod)
            wepAutoOC:AddDamageMod(bp.OverchargeDamageMod)
        elseif enh == 'OverchargeAmplifierRemove' then
            if Buff.HasBuff(self, 'SeraphimCombatHealth3') then
                Buff.RemoveBuff(self, 'SeraphimCombatHealth3')
            end

            local wepOC = self:GetWeaponByLabel('OverCharge')
            local wepAutoOC = self:GetWeaponByLabel('AutoOverCharge')
            wepOC:AddDamageMod(bp.OverchargeDamageMod)
            wepAutoOC:AddDamageMod(bp.OverchargeDamageMod)
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
                    'Body',
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
                    'Body',
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
}

TypeClass = ESL0001