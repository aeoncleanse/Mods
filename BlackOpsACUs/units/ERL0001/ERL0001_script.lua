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
local BOWeapons = import('/mods/BlackOpsACUs/lua/EXBlackOpsweapons.lua')
local EMPWeapon = BOWeapons.EMPWeapon
local CEMPArrayBeam02 = BOWeapons.EXCEMPArrayBeam02

ERL0001 = Class(ACUUnit) {
    DeathThreadDestructionWaitTime = 2,

    Weapons = {
        DeathWeapon = Class(DeathNukeWeapon) {},
        RightRipper = Class(CCannonMolecularWeapon) {},
        RocketPack = Class(RocketPack) {},
        TorpedoLauncher = Class(CANTorpedoLauncherWeapon) {},
        EMPShot01 = Class(EMPWeapon) {},
        EMPShot02 = Class(EMPWeapon) {},
        EMPShot03 = Class(EMPWeapon) {},
        MLG = Class(CDFHeavyMicrowaveLaserGeneratorCom) {},
        AA01 = Class(CEMPArrayBeam02) {},
        AA02 = Class(CEMPArrayBeam02) {},
        AA03 = Class(CEMPArrayBeam02) {},
        AA04 = Class(CEMPArrayBeam02) {},
        OverCharge = Class(CDFOverchargeWeapon) {},
        AutoOverCharge = Class(CDFOverchargeWeapon) {},
    },
    
    __init = function(self)
        ACUUnit.__init(self, 'RightRipper')
    end,

    -- Storage for upgrade weapons status
    WeaponEnabled = {},

    OnCreate = function(self)
        ACUUnit.OnCreate(self)
        self:SetCapturable(false)
        self:SetupBuildBones()

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
        self:DisableUnitIntel('Enhancement', 'RadarStealth')
        self:DisableUnitIntel('Enhancement', 'SonarStealth')
        self:DisableUnitIntel('Enhancement', 'Cloak')
        self:DisableUnitIntel('Enhancement', 'Sonar')
        self.EMPArrayEffects01 = {}
        self:ForkThread(self.GiveInitialResources)
        
        -- Disable Upgrade Weapons
        self:SetWeaponEnabledByLabel('RocketPack', false)
        self:SetWeaponEnabledByLabel('TorpedoLauncher', false)
        self:SetWeaponEnabledByLabel('EMPShot01', false)
        self:SetWeaponEnabledByLabel('EMPShot02', false)
        self:SetWeaponEnabledByLabel('EMPShot03', false)
        self:SetWeaponEnabledByLabel('MLG', false)
        self:SetWeaponEnabledByLabel('AA01', false)
        self:SetWeaponEnabledByLabel('AA02', false)
        self:SetWeaponEnabledByLabel('AA03', false)
        self:SetWeaponEnabledByLabel('AA04', false)
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
        local aoc = self:GetWeaponByLabel('AutoOverCharge')
    
        local wepRadius = radius or wep:GetBlueprint().MaxRadius
        local ocRadius = radius or oc:GetBlueprint().MaxRadius
        local aocRadius = radius or aoc:GetBlueprint().MaxRadius

        -- Change RoF
        wep:ChangeRateOfFire(RoF)
        
        -- Change Radius
        wep:ChangeMaxRadius(wepRadius)
        oc:ChangeMaxRadius(ocRadius)
        aoc:ChangeMaxRadius(aocRadius)
        
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
            self:EnableUnitIntel('ToggleBit8', 'Cloak')
            self:EnableUnitIntel('ToggleBit8', 'RadarStealth')
            self:EnableUnitIntel('ToggleBit8', 'SonarStealth')       
        end
    end,

    OnScriptBitSet = function(self, bit)
        if bit == 8 then -- cloak toggle
            self:StopUnitAmbientSound('ActiveLoop')
            self:SetMaintenanceConsumptionInactive()
            self:DisableUnitIntel('ToggleBit8', 'Cloak')
            self:DisableUnitIntel('ToggleBit8', 'RadarStealth')
            self:DisableUnitIntel('ToggleBit8', 'SonarStealth')
        end
    end,

    CreateBuildEffects = function(self, unitBeingBuilt, order)
       EffectUtil.SpawnBuildBots(self, unitBeingBuilt, 5, self.BuildEffectsBag)
       EffectUtil.CreateCybranBuildBeams(self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag)
    end,

    CreateEnhancement = function(self, enh, removal)
        ACUUnit.CreateEnhancement(self, enh)
        
        local bp = self:GetBlueprint().Enhancements[enh]
        local bpIntel = self:GetBlueprint().Intel
        if not bp then return end
        
        if enh =='ImprovedEngineering' then
            self:RemoveBuildRestriction(categories.CYBRAN * categories.BUILTBYTIER2COMMANDER)
            self:updateBuildRestrictions()
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
            self:updateBuildRestrictions()
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
            self:updateBuildRestrictions()
            self:SetProduction(bp)

            if not Buffs['CYBRANACUT4BuildRate'] then
                BuffBlueprint {
                    Name = 'CYBRANACUT4BuildRate',
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
            Buff.ApplyBuff(self, 'CYBRANACUT4BuildRate')
        elseif enh =='ExperimentalEngineeringRemove' then
            if Buff.HasBuff(self, 'CYBRANACUT4BuildRate') then
                Buff.RemoveBuff(self, 'CYBRANACUT4BuildRate')
            end
            self:AddBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            self:SetProduction()
        elseif enh =='CombatEngineering' then
            self:RemoveBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER2COMMANDER))
            self:updateBuildRestrictions()
            
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
            self:updateBuildRestrictions()
            
            if not Buffs['CYBRANACUT3BuildCombat'] then
                BuffBlueprint {
                    Name = 'CYBRANACUT3BuildCombat',
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
        elseif enh =='ApocalypticEngineering' then
            self:RemoveBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER4COMMANDER))
            self:updateBuildRestrictions()
            
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
        elseif enh =='ApocalypticEngineeringRemove' then
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
            self:EnableUnitIntel('Enhancement', 'Sonar')
        elseif enh =='TorpedoLauncherRemove' then
            if Buff.HasBuff(self, 'CybranTorpHealth1') then
                Buff.RemoveBuff(self, 'CybranTorpHealth1')
            end
            
            self:SetWeaponEnabledByLabel('TorpedoLauncher', false)
            self:DisableUnitIntel('Enhancement', 'Sonar')
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
            if not Buffs['CybranEMPHealth1'] then
                BuffBlueprint {
                    Name = 'CybranEMPHealth1',
                    DisplayName = 'CybranEMPHealth1',
                    BuffType = 'CybranEMPHealth',
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
            Buff.ApplyBuff(self, 'CybranEMPHealth1')
            
            self:SetWeaponEnabledByLabel('EMPShot01', true)
            local wep = self:GetWeaponByLabel('EMPShot01')
            wep:ChangeMaxRadius(bp.EMPRange)
        elseif enh =='EMPArrayRemove' then
            if Buff.HasBuff(self, 'CybranEMPHealth1') then
                Buff.RemoveBuff(self, 'CybranEMPHealth1')
            end

            self:SetWeaponEnabledByLabel('EMPShot01', false)
            local wep = self:GetWeaponByLabel('EMPShot01')
            wep:ChangeMaxRadius(wep:GetBlueprint().MaxRadius)
        elseif enh =='ImprovedCapacitors' then
            if not Buffs['CybranEMPHealth2'] then
                BuffBlueprint {
                    Name = 'CybranEMPHealth2',
                    DisplayName = 'CybranEMPHealth2',
                    BuffType = 'CybranEMPHealth',
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
            Buff.ApplyBuff(self, 'CybranEMPHealth2')

            self:SetWeaponEnabledByLabel('EMPShot01', false)
            self:SetWeaponEnabledByLabel('EMPShot02', true)
            
            local wep = self:GetWeaponByLabel('EMPShot02')
            wep:ChangeMaxRadius(bp.EMPRange)

            -- Install Jury Rigged Ripper
            self:TogglePrimaryGun(bp.NewRoF, bp.NewMaxRadius)
        elseif enh =='ImprovedCapacitorsRemove' then    
            if Buff.HasBuff(self, 'CybranEMPHealth2') then
                Buff.RemoveBuff(self, 'CybranEMPHealth2')
            end
            
            self:SetWeaponEnabledByLabel('EMPShot02', false)
            local wep = self:GetWeaponByLabel('EMPShot02')
            wep:ChangeMaxRadius(wep:GetBlueprint().MaxRadius)
            
            self:TogglePrimaryGun(bp.NewRoF)
        elseif enh =='PowerBooster' then
            if not Buffs['CybranEMPHealth3'] then
                BuffBlueprint {
                    Name = 'CybranEMPHealth3',
                    DisplayName = 'CybranEMPHealth3',
                    BuffType = 'CybranEMPHealth',
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
            Buff.ApplyBuff(self, 'CybranEMPHealth3')
            
            self:SetWeaponEnabledByLabel('EMPShot02', false)
            self:SetWeaponEnabledByLabel('EMPShot03', true)
            
            local wep = self:GetWeaponByLabel('EMPShot03')
            wep:ChangeMaxRadius(bp.EMPRange)
        elseif enh =='PowerBoosterRemove' then    
            if Buff.HasBuff(self, 'CybranEMPHealth3') then
                Buff.RemoveBuff(self, 'CybranEMPHealth3')
            end
            
            self:SetWeaponEnabledByLabel('EMPShot03', false)
            local wep = self:GetWeaponByLabel('EMPShot03')
            wep:ChangeMaxRadius(wep:GetBlueprint().MaxRadius)
            
        -- Mazer
            
        elseif enh =='Mazer' then
            if not Buffs['CybranMazerHealth1'] then
                BuffBlueprint {
                    Name = 'CybranMazerHealth1',
                    DisplayName = 'CybranMazerHealth1',
                    BuffType = 'CybranMazerHealth',
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
            Buff.ApplyBuff(self, 'CybranMazerHealth1')
            
            self:SetWeaponEnabledByLabel('MLG', true)
        elseif enh =='MazerRemove' then
            if Buff.HasBuff(self, 'CybranMazerHealth1') then
                Buff.RemoveBuff(self, 'CybranMazerHealth1')
            end
            
            self:SetWeaponEnabledByLabel('MLG', false)
        elseif enh =='ImprovedCoolingSystem' then
            if not Buffs['CybranMazerHealth2'] then
                BuffBlueprint {
                    Name = 'CybranMazerHealth2',
                    DisplayName = 'CybranMazerHealth2',
                    BuffType = 'CybranMazerHealth',
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
            Buff.ApplyBuff(self, 'CybranMazerHealth2')
            
            local laser = self:GetWeaponByLabel('MLG')
            laser:ChangeMaxRadius(bp.LaserRange)
            laser:AddDamageMod(bp.LaserDamageMod)
            
            -- Install Jury Rigged Ripper
            self:TogglePrimaryGun(bp.NewRoF, bp.NewMaxRadius)
        elseif enh =='ImprovedCoolingSystemRemove' then
            if Buff.HasBuff(self, 'CybranMazerHealth2') then
                Buff.RemoveBuff(self, 'CybranMazerHealth2')
            end
            
            local laser = self:GetWeaponByLabel('MLG')
            laser:ChangeMaxRadius(laser:GetBlueprint().MaxRadius)
            laser:AddDamageMod(bp.LaserDamageMod)
            
            self:TogglePrimaryGun(bp.NewRoF)
        elseif enh =='AdvancedEmitterArray' then
            if not Buffs['CybranMazerHealth3'] then
                BuffBlueprint {
                    Name = 'CybranMazerHealth3',
                    DisplayName = 'CybranMazerHealth3',
                    BuffType = 'CybranMazerHealth',
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
            Buff.ApplyBuff(self, 'CybranMazerHealth3')
            
            local laser = self:GetWeaponByLabel('MLG')
            laser:AddDamageMod(bp.LaserDamageMod)
        elseif enh =='AdvancedEmitterArrayRemove' then

            if Buff.HasBuff(self, 'CybranMazerHealth3') then
                Buff.RemoveBuff(self, 'CybranMazerHealth3')
            end
            
            local laser = self:GetWeaponByLabel('MLG')
            laser:AddDamageMod(bp.LaserDamageMod)
            
        -- Armor System
            
        elseif enh == 'ArmorPlating' then
            if not Buffs['CybranArmorHealth1'] then
                BuffBlueprint {
                    Name = 'CybranArmorHealth1',
                    DisplayName = 'CybranArmorHealth1',
                    BuffType = 'CybranArmorHealth',
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
            Buff.ApplyBuff(self, 'CybranArmorHealth1')
            
            self:SetWeaponEnabledByLabel('AA01', true)
            self:SetWeaponEnabledByLabel('AA02', true)
        elseif enh == 'ArmorPlatingRemove' then
            if Buff.HasBuff(self, 'CybranArmorHealth1') then
                Buff.RemoveBuff(self, 'CybranArmorHealth1')
            end
            
            self:SetWeaponEnabledByLabel('AA01', false)
            self:SetWeaponEnabledByLabel('AA02', false)
        elseif enh == 'StructuralIntegrity' then
            if not Buffs['CybranArmorHealth2'] then
                BuffBlueprint {
                    Name = 'CybranArmorHealth2',
                    DisplayName = 'CybranArmorHealth2',
                    BuffType = 'CybranArmorHealth',
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
            Buff.ApplyBuff(self, 'CybranArmorHealth2')
            
            self:SetWeaponEnabledByLabel('AA03', true)
            self:SetWeaponEnabledByLabel('AA04', true)
        elseif enh == 'StructuralIntegrityRemove' then
            if Buff.HasBuff(self, 'CybranArmorHealth2') then
                Buff.RemoveBuff(self, 'CybranArmorHealth2')
            end
            
            self:SetWeaponEnabledByLabel('AA03', false)
            self:SetWeaponEnabledByLabel('AA04', false)
        elseif enh == 'CompositeMaterials' then
            if not Buffs['CybranArmorHealth3'] then
                BuffBlueprint {
                    Name = 'CybranArmorHealth3',
                    DisplayName = 'CybranArmorHealth3',
                    BuffType = 'CybranArmorHealth',
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
            Buff.ApplyBuff(self, 'CybranArmorHealth3')
        elseif enh == 'CompositeMaterialsRemove' then
            if Buff.HasBuff(self, 'CybranArmorHealth3') then
                Buff.RemoveBuff(self, 'CybranArmorHealth3')
            end
            
        -- Counter-Intel Systems
        
        elseif enh == 'ElectronicsEnhancment' then
            if not Buffs['CybranIntelHealth1'] then
                BuffBlueprint {
                    Name = 'CybranIntelHealth1',
                    DisplayName = 'CybranIntelHealth1',
                    BuffType = 'CybranIntelHealth',
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
            Buff.ApplyBuff(self, 'CybranIntelHealth1')

            self:SetIntelRadius('Vision', bp.NewVisionRadius)
            self:SetIntelRadius('WaterVision', bp.NewVisionRadius)
            self:SetIntelRadius('Omni', bp.NewOmniRadius)
        elseif enh == 'ElectronicsEnhancmentRemove' then
            if Buff.HasBuff(self, 'CybranIntelHealth1') then
                Buff.RemoveBuff(self, 'CybranIntelHealth1')
            end
            
            self:SetIntelRadius('Vision', bpIntel.VisionRadius)
            self:SetIntelRadius('WaterVision', bpIntel.VisionRadius)
            self:SetIntelRadius('Omni', bpIntel.OmniRadius)
        elseif enh == 'ElectronicCountermeasures' then
            if not Buffs['CybranIntelHealth2'] then
                BuffBlueprint {
                    Name = 'CybranIntelHealth2',
                    DisplayName = 'CybranIntelHealth2',
                    BuffType = 'CybranIntelHealth',
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
            Buff.ApplyBuff(self, 'CybranIntelHealth2')

            if self.IntelEffectsBag then
                EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
                self.IntelEffectsBag = nil
            end
            self:AddToggleCap('RULEUTC_CloakToggle')
            self:EnableUnitIntel('Enhancement', 'RadarStealth')
            self:EnableUnitIntel('Enhancement', 'SonarStealth')
        elseif enh == 'ElectronicCountermeasuresRemove' then
            if Buff.HasBuff(self, 'CybranIntelHealth2') then
                Buff.RemoveBuff(self, 'CybranIntelHealth2')
            end

            self:RemoveToggleCap('RULEUTC_CloakToggle')
            self:DisableUnitIntel('Enhancement', 'RadarStealth')
            self:DisableUnitIntel('Enhancement', 'SonarStealth')
        elseif enh == 'CloakingSubsystems' then
            if not Buffs['CybranIntelHealth3'] then
                BuffBlueprint {
                    Name = 'CybranIntelHealth3',
                    DisplayName = 'CybranIntelHealth3',
                    BuffType = 'CybranIntelHealth',
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
            Buff.ApplyBuff(self, 'CybranIntelHealth3')
            
            self:EnableUnitIntel('Enhancement', 'Cloak')
        elseif enh == 'CloakingSubsystemsRemove' then
            if Buff.HasBuff(self, 'CybranIntelHealth3') then
                Buff.RemoveBuff(self, 'CybranIntelHealth3')
            end

            self:DisableUnitIntel('Enhancement', 'Cloak')
            
        -- Mobility Systems
            
        elseif enh == 'MobilitySubsystems' then
            if not Buffs['CybranMobilityHealth1'] then
                BuffBlueprint {
                    Name = 'CybranMobilityHealth1',
                    DisplayName = 'CybranMobilityHealth1',
                    BuffType = 'CybranMobilityHealth',
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
            Buff.ApplyBuff(self, 'CybranMobilityHealth1')

            self:SetSpeedMult(1.41176)
        elseif enh == 'MobilitySubsystemsRemove' then
            if Buff.HasBuff(self, 'CybranMobilityHealth1') then
                Buff.RemoveBuff(self, 'CybranMobilityHealth1')
            end

            self:SetSpeedMult(1)
        elseif enh == 'DefensiveSubsystems' then
            if not Buffs['CybranMobilityHealth2'] then
                BuffBlueprint {
                    Name = 'CybranMobilityHealth2',
                    DisplayName = 'CybranMobilityHealth2',
                    BuffType = 'CybranMobilityHealth',
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
            Buff.ApplyBuff(self, 'CybranMobilityHealth2')

            self:AddCommandCap('RULEUCC_Teleport')
            
            self:SetWeaponEnabledByLabel('AA01', true)
            self:SetWeaponEnabledByLabel('AA02', true)
        elseif enh == 'DefensiveSubsystemsRemove' then
            if Buff.HasBuff(self, 'CybranMobilityHealth2') then
                Buff.RemoveBuff(self, 'CybranMobilityHealth2')
            end
            
            self:RemoveCommandCap('RULEUCC_Teleport')
            
            self:SetWeaponEnabledByLabel('AA01', false)
            self:SetWeaponEnabledByLabel('AA02', false)
        elseif enh == 'NanoKickerSubsystems' then
            if not Buffs['CybranMobilityHealth3'] then
                BuffBlueprint {
                    Name = 'CybranMobilityHealth3',
                    DisplayName = 'CybranMobilityHealth3',
                    BuffType = 'CybranMobilityHealth',
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
            Buff.ApplyBuff(self, 'CybranMobilityHealth3')
        elseif enh == 'NanoKickerSubsystemsRemove' then
            if Buff.HasBuff(self, 'CybranMobilityHealth3') then
                Buff.RemoveBuff(self, 'CybranMobilityHealth3')
            end
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
}
    
TypeClass = ERL0001
