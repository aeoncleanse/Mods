-----------------------------------------------------------------
-- Author(s):  avier Macbeth
-- Summary  :  BlackOps: Adv Command Unit - Aeon ACU
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local ACUUnit = import('/lua/defaultunits.lua').ACUUnit
local AWeapons = import('/lua/aeonweapons.lua')
local ADFDisruptorCannonWeapon = AWeapons.ADFDisruptorCannonWeapon
local ADFOverchargeWeapon = AWeapons.ADFOverchargeWeapon
local ADFChronoDampener = AWeapons.ADFChronoDampener
local AIFArtilleryMiasmaShellWeapon = AWeapons.AIFArtilleryMiasmaShellWeapon
local AANChronoTorpedoWeapon = AWeapons.AANChronoTorpedoWeapon
local ADFPhasonLaser = AWeapons.ADFPhasonLaser
local AAMWillOWisp = AWeapons.AAMWillOWisp
local DeathNukeWeapon = import('/lua/sim/defaultweapons.lua').DeathNukeWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')
local Buff = import('/lua/sim/Buff.lua')
local CSoothSayerAmbient = EffectTemplate.CSoothSayerAmbient
local BOWeapons = import('/mods/BlackOpsACUs/lua/EXBlackOpsweapons.lua')
local AeonACUPhasonLaser = BOWeapons.AeonACUPhasonLaser 
local AIFQuasarAntiTorpedoWeapon = AWeapons.AIFQuasarAntiTorpedoWeapon
local CEMPArrayBeam01 = BOWeapons.CEMPArrayBeam01 
local QuantumMaelstromWeapon = BOWeapons.QuantumMaelstromWeapon
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker

EAL0001 = Class(ACUUnit) {
    DeathThreadDestructionWaitTime = 2,
    PainterRange = {},

    Weapons = {
        DeathWeapon = Class(DeathNukeWeapon) {},
        TargetPainter = Class(CEMPArrayBeam01) {},
        RightDisruptor = Class(ADFDisruptorCannonWeapon) {},
        ChronoDampener = Class(ADFChronoDampener) {},
        TorpedoLauncher = Class(AANChronoTorpedoWeapon) {},
        MiasmaArtillery = Class(AIFArtilleryMiasmaShellWeapon) {},
        PhasonBeam = Class(AeonACUPhasonLaser) {},
        QuantumMaelstrom = Class(QuantumMaelstromWeapon) {},
        AntiTorpedo = Class(AIFQuasarAntiTorpedoWeapon) {},
        AntiMissile = Class(AAMWillOWisp) {},
        OverCharge = Class(ADFOverchargeWeapon) {},
        AutoOverCharge = Class(ADFOverchargeWeapon) {},
    },

    __init = function(self)
        ACUUnit.__init(self, 'RightDisruptor')
    end,

    -- Storage for upgrade weapons status
    WeaponEnabled = {},
    
    OnCreate = function(self)
        ACUUnit.OnCreate(self)
        self:SetCapturable(false)
        self:SetupBuildBones()
        
        self:HideBone('Engineering', true)
        self:HideBone('Combat_Engineering', true)
        self:HideBone('Left_Turret_Plates', true)
        self:HideBone('Basic_GunUp_Range', true)
        self:HideBone('Basic_GunUp_RoF', true)
        self:HideBone('Torpedo_Launcher', true)
        self:HideBone('Laser_Cannon', true)
        self:HideBone('IntelPack_Torso', true)
        self:HideBone('IntelPack_Head', true)
        self:HideBone('IntelPack_LShoulder', true)
        self:HideBone('IntelPack_RShoulder', true)
        self:HideBone('DamagePack_LArm', true)
        self:HideBone('DamagePack_RArm', true)
        self:HideBone('DamagePack_Torso', true)
        self:HideBone('DamagePack_RLeg_B01', true)
        self:HideBone('DamagePack_RLeg_B02', true)
        self:HideBone('DamagePack_LLeg_B01', true)
        self:HideBone('DamagePack_LLeg_B02', true)
        self:HideBone('ShieldPack_Normal', true)
        self:HideBone('Shoulder_Arty_L', true)
        self:HideBone('ShieldPack_Arty_LArm', true)
        self:HideBone('Shoulder_Arty_R', true)
        self:HideBone('ShieldPack_Arty_RArm', true)
        self:HideBone('Artillery_Torso', true)
        self:HideBone('ShieldPack_Artillery', true)
        self:HideBone('Artillery_Barrel_Left', true)
        self:HideBone('Artillery_Barrel_Right', true)
        self:HideBone('Artillery_Pitch', true)

        -- Restrict what enhancements will enable later
        self:AddBuildRestriction(categories.AEON * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
        self.RemoteViewingData = {}
        self.RemoteViewingData.RemoteViewingFunctions = {}
        self.RemoteViewingData.DisableCounter = 0
        self.RemoteViewingData.IntelButton = true
        self.MaelstromEffects01 = {}
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        ACUUnit.OnStopBeingBuilt(self, builder, layer)
        self:DisableUnitIntel('Enhancement', 'RadarStealth')
        self:DisableUnitIntel('Enhancement', 'SonarStealth')
        self:DisableUnitIntel('Enhancement', 'Cloak')
        self:DisableUnitIntel('Enhancement', 'CloakField')

        -- Disable Upgrade Weapons
        self:SetWeaponEnabledByLabel('ChronoDampener', false)
        self:SetWeaponEnabledByLabel('TorpedoLauncher', false)
        self:SetWeaponEnabledByLabel('MiasmaArtillery', false)
        self:SetWeaponEnabledByLabel('PhasonBeam', false)
        self:SetWeaponEnabledByLabel('QuantumMaelstrom', false)
        self:SetWeaponEnabledByLabel('AntiTorpedo', false)
        self:SetWeaponEnabledByLabel('AntiMissile', false)        
        
        self.Sync.Abilities = self:GetBlueprint().Abilities
        self.Sync.Abilities.ScryTarget.Active = false
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        ACUUnit.OnKilled(self, instigator, type, overkillRatio)
        if self.RemoteViewingData.Satellite then
            self.RemoteViewingData.Satellite:DisableIntel('Vision')
            self.RemoteViewingData.Satellite:Destroy()
        end
    end,

    DisableRemoteViewingButtons = function(self)
        self.Sync.Abilities = self:GetBlueprint().Abilities
        self.Sync.Abilities.ScryTarget.Active = false
        self:AddToggleCap('RULEUTC_IntelToggle')
        self:RemoveToggleCap('RULEUTC_IntelToggle')
    end,

    EnableRemoteViewingButtons = function(self)
        self.Sync.Abilities = self:GetBlueprint().Abilities
        self.Sync.Abilities.ScryTarget.Active = true
        self:AddToggleCap('RULEUTC_IntelToggle')
        self:RemoveToggleCap('RULEUTC_IntelToggle')
    end,

    RemoteCheck = function(self)
        if self:HasEnhancement('ElectronicCountermeasures') and self.ScryActive then
            self:DisableRemoteViewingButtons()
            WaitSeconds(10)
            if self:HasEnhancement('ElectronicCountermeasures') then
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
        if not (have > need) then
            return
        end
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
        if not self.RemoteViewingData.VisibleLocation then
            return
        end
        
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
                    Army = self:GetAIBrain():GetArmyInd(),
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
        -- visible entity already off
        WaitSeconds(5)
        if self.RemoteViewingData.DisableCounter > 1 then return end
        -- disable vis entity and monitor resources
        if not self:IsDead() and self.RemoteViewingData.Satellite then
            self.RemoteViewingData.Satellite:DisableIntel('Vision')
        end
    end,
    
    OnStartBuild = function(self, unitBeingBuilt, order)
        ACUUnit.OnStartBuild(self, unitBeingBuilt, order)
        self.UnitBuildOrder = order  
    end,
    
    CreateBuildEffects = function(self, unitBeingBuilt, order)
        EffectUtil.CreateAeonCommanderBuildingEffects(self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag)
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
        self:SetMesh('/mods/BlackOpsACUs/units/eal0001/EAL0001_PhaseShield_mesh', true)
        self:ShowBone(0, true)
        self:HideBone('Engineering', true)
        self:HideBone('Combat_Engineering', true)
        self:HideBone('Left_Turret_Plates', true)
        self:HideBone('Basic_GunUp_Range', true)
        self:HideBone('Basic_GunUp_RoF', true)
        self:HideBone('Torpedo_Launcher', true)
        self:HideBone('Laser_Cannon', true)
        self:HideBone('IntelPack_Torso', true)
        self:HideBone('IntelPack_Head', true)
        self:HideBone('IntelPack_LShoulder', true)
        self:HideBone('IntelPack_RShoulder', true)
        self:HideBone('DamagePack_LArm', true)
        self:HideBone('DamagePack_RArm', true)
        self:HideBone('DamagePack_Torso', true)
        self:HideBone('DamagePack_RLeg_B01', true)
        self:HideBone('DamagePack_RLeg_B02', true)
        self:HideBone('DamagePack_LLeg_B01', true)
        self:HideBone('DamagePack_LLeg_B02', true)
        self:HideBone('ShieldPack_Normal', true)
        self:HideBone('Shoulder_Arty_L', true)
        self:HideBone('ShieldPack_Arty_LArm', true)
        self:HideBone('Shoulder_Arty_R', true)
        self:HideBone('ShieldPack_Arty_RArm', true)
        self:HideBone('Artillery_Torso', true)
        self:HideBone('ShieldPack_Artillery', true)
        self:HideBone('Artillery_Barrel_Left', true)
        self:HideBone('Artillery_Barrel_Right', true)
        self:HideBone('Artillery_Pitch', true)
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

    OnTransportDetach = function(self, attachBone, unit)
        ACUUnit.OnTransportDetach(self, attachBone, unit)
        self:StopSiloBuild()
    end,

    OnScriptBitClear = function(self, bit)
        if bit == 0 then -- shield toggle
            self:DisableShield()
            self:StopUnitAmbientSound('ActiveLoop')
        elseif bit == 8 then -- cloak toggle
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
        if bit == 0 then -- shield toggle
            self:EnableShield()
            self:PlayUnitAmbientSound('ActiveLoop')
        elseif bit == 8 then -- cloak toggle
            self:StopUnitAmbientSound('ActiveLoop')
            self:SetMaintenanceConsumptionInactive()
            self:DisableUnitIntel('Cloak')
            self:DisableUnitIntel('RadarStealth')
            self:DisableUnitIntel('RadarStealthField')
            self:DisableUnitIntel('SonarStealth')
            self:DisableUnitIntel('SonarStealthField')
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
        local wep = self:GetWeaponByLabel('RightDisruptor')
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
            self:SetPainterRange('DisruptorEnhancer', radius, false)
        else
            self:HideBone('Basic_GunUp_Range', false)
            self:SetPainterRange('DisruptorEnhancer', radius, true)
        end
    end,
    
    -- Target painter. 0 damage as primary weapon, controls targeting
    -- for the variety of changing ranges on the ACU with upgrades.
    SetPainterRange = function(self, enh, newRange, delete)
        if delete and self.PainterRange[enh] then
            self.PainterRange[enh] = nil
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
            self:RemoveBuildRestriction(categories.AEON * (categories.BUILTBYTIER2COMMANDER))
            self:updateBuildRestrictions()
            self:SetProduction(bp)
            
            if not Buffs['AEONACUT2BuildRate'] then
                BuffBlueprint {
                    Name = 'AEONACUT2BuildRate',
                    DisplayName = 'AEONACUT2BuildRate',
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
            Buff.ApplyBuff(self, 'AEONACUT2BuildRate')            
        elseif enh == 'ImprovedEngineeringRemove' then
            if Buff.HasBuff(self, 'AEONACUT2BuildRate') then
                Buff.RemoveBuff(self, 'AEONACUT2BuildRate')
            end
            self:AddBuildRestriction(categories.AEON * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            self:SetProduction()
        elseif enh == 'AdvancedEngineering' then
            self:RemoveBuildRestriction(categories.AEON * (categories.BUILTBYTIER3COMMANDER - categories.BUILTBYTIER4COMMANDER))
            self:updateBuildRestrictions()
            self:SetProduction(bp)
            
            if not Buffs['AEONACUT3BuildRate'] then
                BuffBlueprint {
                    Name = 'AEONACUT3BuildRate',
                    DisplayName = 'AEONCUT3BuildRate',
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
            Buff.ApplyBuff(self, 'AEONACUT3BuildRate')
        elseif enh == 'AdvancedEngineeringRemove' then
            if Buff.HasBuff(self, 'AEONACUT3BuildRate') then
                Buff.RemoveBuff(self, 'AEONACUT3BuildRate')
            end
            self:AddBuildRestriction(categories.AEON * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            self:SetProduction()
        elseif enh == 'ExperimentalEngineering' then
            self:RemoveBuildRestriction(categories.AEON * (categories.BUILTBYTIER4COMMANDER))
            self:updateBuildRestrictions()
            self:SetProduction(bp)

            if not Buffs['AEONACUT4BuildRate'] then
                BuffBlueprint {
                    Name = 'AEONACUT4BuildRate',
                    DisplayName = 'AEONCUT4BuildRate',
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
            Buff.ApplyBuff(self, 'AEONACUT4BuildRate')
        elseif enh == 'ExperimentalEngineeringRemove' then
            if Buff.HasBuff(self, 'AEONACUT4BuildRate') then
                Buff.RemoveBuff(self, 'AEONACUT4BuildRate')
            end
            self:AddBuildRestriction(categories.AEON * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            self:SetProduction()
        elseif enh == 'CombatEngineering' then
            self:RemoveBuildRestriction(categories.AEON * (categories.BUILTBYTIER2COMMANDER))
            self:updateBuildRestrictions()
            
            if not Buffs['AEONACUT2BuildCombat'] then
                BuffBlueprint {
                    Name = 'AEONACUT2BuildCombat',
                    DisplayName = 'AEONACUT2BuildCombat',
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
            Buff.ApplyBuff(self, 'AEONACUT2BuildCombat')

            self:SetWeaponEnabledByLabel('ChronoDampener', true)
        elseif enh == 'CombatEngineeringRemove' then
            if Buff.HasBuff(self, 'AEONACUT2BuildCombat') then
                Buff.RemoveBuff(self, 'AEONACUT2BuildCombat')
            end

            self:AddBuildRestriction(categories.AEON * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            self:SetWeaponEnabledByLabel('ChronoDampener', false)
        elseif enh == 'AssaultEngineering' then
            self:RemoveBuildRestriction(categories.AEON * (categories.BUILTBYTIER3COMMANDER - categories.BUILTBYTIER4COMMANDER))
            self:updateBuildRestrictions()

            if not Buffs['AEONACUT3BuildCombat'] then
                BuffBlueprint {
                    Name = 'AEONACUT3BuildCombat',
                    DisplayName = 'AEONACUT3BuildCombat',
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
            Buff.ApplyBuff(self, 'AEONACUT3BuildCombat')

            local gun = self:GetWeaponByLabel('ChronoDampener')
            gun:ChangeMaxRadius(bp.ChronoMaxRadius)
            self:SetPainterRange(enh, bp.ChronoMaxRadius)
        elseif enh == 'AssaultEngineeringRemove' then
            if Buff.HasBuff(self, 'AEONACUT3BuildCombat') then
                Buff.RemoveBuff(self, 'AEONACUT3BuildCombat')
            end

            self:AddBuildRestriction(categories.AEON * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))   
            local gun = self:GetWeaponByLabel('ChronoDampener')
            gun:ChangeMaxRadius(gun:GetBlueprint().MaxRadius)
            self:SetPainterRange(enh, 0, true)
        elseif enh == 'ApocolypticEngineering' then
            self:RemoveBuildRestriction(categories.AEON * (categories.BUILTBYTIER4COMMANDER))
            self:updateBuildRestrictions()

            if not Buffs['AEONACUT4BuildCombat'] then
                BuffBlueprint {
                    Name = 'AEONACUT4BuildCombat',
                    DisplayName = 'AEONACUT4BuildCombat',
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
            Buff.ApplyBuff(self, 'AEONACUT4BuildCombat')
        elseif enh == 'ApocolypticEngineeringRemove' then
            if Buff.HasBuff(self, 'AEONACUT4BuildCombat') then
                Buff.RemoveBuff(self, 'AEONACUT4BuildCombat')
            end

            self:AddBuildRestriction(categories.AEON * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))

        -- Disruptor Amplifier
            
        elseif enh == 'DisruptorBooster' then
            self:TogglePrimaryGun(bp.NewDamage)
        elseif enh == 'DisruptorBoosterRemove' then
            self:TogglePrimaryGun(bp.NewDamage)
        elseif enh == 'DisruptorEnhancer' then
            self:TogglePrimaryGun(0, bp.NewRadius)
        elseif enh == 'DisruptorEnhancerRemove' then
            self:TogglePrimaryGun(0)
            
        -- Torpedoes
            
        elseif enh == 'TorpedoLauncher' then
            if not Buffs['AeonTorpHealth1'] then
                BuffBlueprint {
                    Name = 'AeonTorpHealth1',
                    DisplayName = 'AeonTorpHealth1',
                    BuffType = 'AeonTorpHealth',
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
            Buff.ApplyBuff(self, 'AeonTorpHealth1')
            
            local torp = self:SetWeaponEnabledByLabel('TorpedoLauncher', true)
            local antiTorp = self:SetWeaponEnabledByLabel('AntiTorpedo', true)
        elseif enh == 'TorpedoLauncherRemove' then
            if Buff.HasBuff(self, 'AeonTorpHealth1') then
                Buff.RemoveBuff(self, 'AeonTorpHealth1')
            end
            
            local torp = self:SetWeaponEnabledByLabel('TorpedoLauncher', false)
            local antiTorp = self:SetWeaponEnabledByLabel('AntiTorpedo', false)
        elseif enh == 'TorpedoRapidLoader' then
            if not Buffs['AeonTorpHealth2'] then
                BuffBlueprint {
                    Name = 'AeonTorpHealth2',
                    DisplayName = 'AeonTorpHealth2',
                    BuffType = 'AeonTorpHealth',
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
            Buff.ApplyBuff(self, 'AeonTorpHealth2')
            
            local torp = self:GetWeaponByLabel('TorpedoLauncher')
            torp:AddDamageMod(bp.TorpDamage)
            torp:ChangeRateOfFire(bp.TorpRoF)
            
            self:TogglePrimaryGun(bp.GunDamage)
        elseif enh == 'TorpedoRapidLoaderRemove' then
            if Buff.HasBuff(self, 'AeonTorpHealth2') then
                Buff.RemoveBuff(self, 'AeonTorpHealth2')
            end
            
            local torp = self:GetWeaponByLabel('TorpedoLauncher')
            torp:AddDamageMod(bp.TorpDamage)
            torp:ChangeRateOfFire(torp:GetBlueprint().RateOfFire)
            
            self:TogglePrimaryGun(bp.GunDamage)
        elseif enh == 'TorpedoClusterLauncher' then
            if not Buffs['AeonTorpHealth3'] then
                BuffBlueprint {
                    Name = 'AeonTorpHealth3',
                    DisplayName = 'AeonTorpHealth3',
                    BuffType = 'AeonTorpHealth',
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
            Buff.ApplyBuff(self, 'AeonTorpHealth3')
            
            local torp = self:GetWeaponByLabel('TorpedoLauncher')
            torp:AddDamageMod(bp.TorpDamage)
            
            self:TogglePrimaryGun(bp.GunDamage)
        elseif enh == 'TorpedoClusterLauncherRemove' then
            if Buff.HasBuff(self, 'AeonTorpHealth3') then
                Buff.RemoveBuff(self, 'AeonTorpHealth3')
            end
            
            local torp = self:GetWeaponByLabel('TorpedoLauncher')
            torp:AddDamageMod(bp.TorpDamage)
            
            self:TogglePrimaryGun(bp.GunDamage)
            
        -- Artillery
            
        elseif enh == 'ArtilleryMiasma' then
            if not Buffs['AeonArtilleryHealth1'] then
                BuffBlueprint {
                    Name = 'AeonArtilleryHealth1',
                    DisplayName = 'AeonArtilleryHealth1',
                    BuffType = 'AeonArtilleryHealth',
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
            Buff.ApplyBuff(self, 'AeonArtilleryHealth1')
            
            self:SetWeaponEnabledByLabel('MiasmaArtillery', true)
            
            local wep = self:GetWeaponByLabel('MiasmaArtillery')
            self:SetPainterRange(enh, wep:GetBlueprint().MaxRadius, false)
        elseif enh == 'ArtilleryMiasmaRemove' then
            if Buff.HasBuff(self, 'AeonArtilleryHealth1') then
                Buff.RemoveBuff(self, 'AeonArtilleryHealth1')
            end
            
            self:SetWeaponEnabledByLabel('MiasmaArtillery', false)
            self:SetPainterRange(enh, 0, true)
        elseif enh == 'AdvancedShells' then
            if not Buffs['AeonArtilleryHealth2'] then
                BuffBlueprint {
                    Name = 'AeonArtilleryHealth2',
                    DisplayName = 'AeonArtilleryHealth2',
                    BuffType = 'AeonArtilleryHealth',
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
            Buff.ApplyBuff(self, 'AeonArtilleryHealth2')
            
            local arty = self:GetWeaponByLabel('MiasmaArtillery')
            arty:AddDamageMod(bp.Artillery)
            
            self:TogglePrimaryGun(bp.NewDamage)
        elseif enh == 'AdvancedShellsRemove' then
            if Buff.HasBuff(self, 'AeonArtilleryHealth2') then
                Buff.RemoveBuff(self, 'AeonArtilleryHealth2')
            end
            
            local arty = self:GetWeaponByLabel('MiasmaArtillery')
            arty:AddDamageMod(bp.Artillery)
            
            self:TogglePrimaryGun(bp.NewDamage)
        elseif enh == 'ImprovedReloader' then
            if not Buffs['AeonArtilleryHealth3'] then
                BuffBlueprint {
                    Name = 'AeonArtilleryHealth3',
                    DisplayName = 'AeonArtilleryHealth3',
                    BuffType = 'AeonArtilleryHealth',
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
            Buff.ApplyBuff(self, 'AeonArtilleryHealth3')
            
            local arty = self:GetWeaponByLabel('MiasmaArtillery')
            arty:AddDamageMod(bp.ArtilleryDamage)
            arty:ChangeRateOfFire(bp.ArtilleryRoF)
        elseif enh == 'ImprovedReloaderRemove' then    
            if Buff.HasBuff(self, 'AeonArtilleryHealth3') then
                Buff.RemoveBuff(self, 'AeonArtilleryHealth3')
            end
            
            local arty = self:GetWeaponByLabel('MiasmaArtillery')
            arty:AddDamageMod(bp.ArtilleryDamage)
            arty:ChangeRateOfFire(arty:GetBlueprint().RateOfFire)
            
        --  Beam Weapon
            
        elseif enh == 'BeamPhason' then
            if not Buffs['AeonBeamHealth1'] then
                BuffBlueprint {
                    Name = 'AeonBeamHealth1',
                    DisplayName = 'AeonBeamHealth1',
                    BuffType = 'AeonBeamHealth',
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
            Buff.ApplyBuff(self, 'AeonBeamHealth1')
            
            self:SetWeaponEnabledByLabel('PhasonBeam', true)
            local beam = self:GetWeaponByLabel('PhasonBeam')
            beam:ChangeMaxRadius(bp.BeamRadius)
            self:SetPainterRange(enh, bp.BeamRadius, false)
        elseif enh == 'BeamPhasonRemove' then
            if Buff.HasBuff(self, 'AeonBeamHealth1') then
                Buff.RemoveBuff(self, 'AeonBeamHealth1')
            end
            
            self:SetWeaponEnabledByLabel('PhasonBeam', false)
            local beam = self:GetWeaponByLabel('PhasonBeam')
            beam:ChangeMaxRadius(beam:GetBlueprint().MaxRadius)
            self:SetPainterRange(string.sub(enh, -6), 0, true)
        elseif enh == 'ImprovedCoolingSystem' then
            if not Buffs['AeonBeamHealth2'] then
                BuffBlueprint {
                    Name = 'AeonBeamHealth2',
                    DisplayName = 'AeonBeamHealth2',
                    BuffType = 'AeonBeamHealth',
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
            Buff.ApplyBuff(self, 'AeonBeamHealth2')
            
            local beam = self:GetWeaponByLabel('PhasonBeam')
            beam:ChangeMaxRadius(bp.BeamRadius)
            beam:AddDamageMod(bp.BeamDamage)
            self:SetPainterRange(enh, bp.BeamRadius, false)
            
            self:TogglePrimaryGun(bp.NewDamage)
        elseif enh == 'ImprovedCoolingSystemRemove' then
            if Buff.HasBuff(self, 'AeonBeamHealth2') then
                Buff.RemoveBuff(self, 'AeonBeamHealth2')
            end
            
            local beam = self:GetWeaponByLabel('PhasonBeam')
            beam:ChangeMaxRadius(beam:GetBlueprint().MaxRadius)
            beam:AddDamageMod(bp.BeamDamage)
            self:SetPainterRange(enh, 0, true)
            
            self:TogglePrimaryGun(bp.NewDamage)
        elseif enh == 'PowerBooster' then
            if not Buffs['AeonBeamHealth3'] then
                BuffBlueprint {
                    Name = 'AeonBeamHealth3',
                    DisplayName = 'AeonBeamHealth3',
                    BuffType = 'AeonBeamHealth',
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
            Buff.ApplyBuff(self, 'AeonBeamHealth3')
            
            local beam = self:GetWeaponByLabel('PhasonBeam')
            beam:AddDamageMod(bp.BeamDamage)
            beam:ChangeDamageRadius(bp.BeamArea)
        elseif enh == 'PowerBoosterRemove' then
            if Buff.HasBuff(self, 'AeonBeamHealth3') then
                Buff.RemoveBuff(self, 'AeonBeamHealth3')
            end
            
            local beam = self:GetWeaponByLabel('PhasonBeam')
            beam:AddDamageMod(bp.BeamDamage)
            beam:ChangeDamageRadius(beam:GetBlueprint().DamageRadius)
            
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
        elseif enh == 'ImprovedShieldBattery' then
            self:DestroyShield()
            ForkThread(function()
                WaitTicks(1)
                self:CreateShield(bp)
            end)
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            self:SetWeaponEnabledByLabel('AntiMissile', true)
            self:OnScriptBitSet(0)
        elseif enh == 'ImprovedShieldBatteryRemove' then
            self:DestroyShield()
            RemoveUnitEnhancement(self, 'ImprovedShieldBatteryRemove')
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
            self:SetWeaponEnabledByLabel('AntiMissile', false)
            self:OnScriptBitClear(0)

        -- Intel
            
        elseif enh == 'ElectronicsEnhancment' then
            if not Buffs['AeonIntelHealth1'] then
                BuffBlueprint {
                    Name = 'AeonIntelHealth1',
                    DisplayName = 'AeonIntelHealth1',
                    BuffType = 'AeonIntelHealth',
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
            Buff.ApplyBuff(self, 'AeonIntelHealth1')
            
            self:SetIntelRadius('Vision', bp.NewVisionRadius)
            self:SetIntelRadius('WaterVision', bp.NewVisionRadius)
            self:SetIntelRadius('Omni', bp.NewOmniRadius)
            
            self:SetWeaponEnabledByLabel('AntiMissile', true)
        elseif enh == 'ElectronicsEnhancmentRemove' then
            if Buff.HasBuff(self, 'AeonIntelHealth1') then
                Buff.RemoveBuff(self, 'AeonIntelHealth1')
            end
            
            local bpIntel = self:GetBlueprint().Intel
            self:SetIntelRadius('Vision', bpIntel.VisionRadius)
            self:SetIntelRadius('WaterVision', bpIntel.VisionRadius)
            self:SetIntelRadius('Omni', bpIntel.OmniRadius)
            
            self:SetWeaponEnabledByLabel('AntiMissile', false)
        elseif enh == 'ElectronicCountermeasures' then
            if not Buffs['AeonIntelHealth2'] then
                BuffBlueprint {
                    Name = 'AeonIntelHealth2',
                    DisplayName = 'AeonIntelHealth2',
                    BuffType = 'AeonIntelHealth',
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
            Buff.ApplyBuff(self, 'AeonIntelHealth2')

            self:ForkThread(self.EnableRemoteViewingButtons)
        elseif enh == 'ElectronicCountermeasuresRemove' then
            if Buff.HasBuff(self, 'AeonIntelHealth2') then
                Buff.RemoveBuff(self, 'AeonIntelHealth2')
            end

            self:ForkThread(self.DisableRemoteViewingButtons)
        elseif enh == 'Teleporter' then
            if not Buffs['AeonIntelHealth3'] then
                BuffBlueprint {
                    Name = 'AeonIntelHealth3',
                    DisplayName = 'AeonIntelHealth3',
                    BuffType = 'AeonIntelHealth',
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
            Buff.ApplyBuff(self, 'AeonIntelHealth3')
            
            self:AddCommandCap('RULEUCC_Teleport')
        elseif enh == 'TeleporterRemove' then
            if Buff.HasBuff(self, 'AeonIntelHealth3') then
                Buff.RemoveBuff(self, 'AeonIntelHealth3')
            end

            self:RemoveCommandCap('RULEUCC_Teleport')
            
        -- Maelstrom
            
        elseif enh == 'MaelstromQuantum' then
            if self.MaelstromEffects01 then
                for k, v in self.MaelstromEffects01 do
                    v:Destroy()
                end
                self.MaelstromEffects01 = {}
            end
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'Torso', self:GetArmy(), '/mods/BlackOpsACUs/effects/emitters/maelstrom_aura_01_emit.bp'):ScaleEmitter(1):OffsetEmitter(0, -2, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'Torso', self:GetArmy(), '/mods/BlackOpsACUs/effects/emitters/maelstrom_aura_02_emit.bp'):ScaleEmitter(1):OffsetEmitter(0, -2.75, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'DamagePack_LArm', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_02_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.05, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'DamagePack_LArm', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_03_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.05, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'DamagePack_LArm', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_04_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.05, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'DamagePack_RArm', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_02_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.05, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'DamagePack_RArm', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_03_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.05, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'DamagePack_RArm', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_04_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.05, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'DamagePack_RLeg_B01', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_02_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.1, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'DamagePack_RLeg_B01', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_03_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.1, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'DamagePack_RLeg_B01', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_04_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.1, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'DamagePack_RLeg_B02', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_02_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.15, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'DamagePack_RLeg_B02', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_03_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.15, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'DamagePack_RLeg_B02', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_04_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.15, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'DamagePack_LLeg_B01', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_02_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.1, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'DamagePack_LLeg_B01', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_03_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.1, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'DamagePack_LLeg_B01', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_04_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.1, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'DamagePack_LLeg_B02', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_02_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.15, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'DamagePack_LLeg_B02', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_03_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.15, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'DamagePack_LLeg_B02', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_04_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.15, 0))
            
            if not Buffs['AeonMaelstromHealth1'] then
                BuffBlueprint {
                    Name = 'AeonMaelstromHealth1',
                    DisplayName = 'AeonMaelstromHealth1',
                    BuffType = 'AeonMaelstromHealth',
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
            Buff.ApplyBuff(self, 'AeonMaelstromHealth1')
            
            self:SetWeaponEnabledByLabel('QuantumMaelstrom', true)
        elseif enh == 'MaelstromQuantumRemove' then
            if Buff.HasBuff(self, 'AeonMaelstromHealth1') then
                Buff.RemoveBuff(self, 'AeonMaelstromHealth1')
            end
            
            if self.MaelstromEffects01 then
                for k, v in self.MaelstromEffects01 do
                    v:Destroy()
                end
                self.MaelstromEffects01 = {}
            end
            
            self:SetWeaponEnabledByLabel('QuantumMaelstrom', false)
        elseif enh == 'FieldExpander' then
            if not Buffs['AeonMaelstromHealth2'] then
                BuffBlueprint {
                    Name = 'AeonMaelstromHealth2',
                    DisplayName = 'AeonMaelstromHealth2',
                    BuffType = 'AeonMaelstromHealth',
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
            Buff.ApplyBuff(self, 'AeonMaelstromHealth2')
            
            local wep = self:GetWeaponByLabel('QuantumMaelstrom')
            wep:AddDamageMod(bp.MaelstromDamage)
            
            self:SetWeaponEnabledByLabel('AntiMissile', true)
        elseif enh == 'FieldExpanderRemove' then
            if Buff.HasBuff(self, 'AeonMaelstromHealth1') then
                Buff.RemoveBuff(self, 'AeonMaelstromHealth1')
            end

            if self.MaelstromEffects01 then
                for k, v in self.MaelstromEffects01 do
                    v:Destroy()
                end
                self.MaelstromEffects01 = {}
            end

            self:SetWeaponEnabledByLabel('AntiMissile', false)
            
            local wep = self:GetWeaponByLabel('QuantumMaelstrom')
            wep:AddDamageMod(bp.MaelstromDamage)
        elseif enh == 'QuantumInstability' then
            if not Buffs['AeonMaelstromHealth3'] then
                BuffBlueprint {
                    Name = 'AeonMaelstromHealth3',
                    DisplayName = 'AeonMaelstromHealth3',
                    BuffType = 'AeonMaelstromHealth',
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
            Buff.ApplyBuff(self, 'AeonMaelstromHealth3')

            local wep = self:GetWeaponByLabel('QuantumMaelstrom')
            wep:AddDamageMod(bp.MaelstromDamage)
            wep:ChangeMaxRadius(bp.MaelstromRange)
            wep:ChangeDamageRadius(bp.MaelstromRange)
            self:SetPainterRange(enh, bp.MaelstromRange, false)
        elseif enh == 'QuantumInstabilityRemove' then
            if Buff.HasBuff(self, 'AeonMaelstromHealth3') then
                Buff.RemoveBuff(self, 'AeonMaelstromHealth3')
            end

            if self.MaelstromEffects01 then
                for k, v in self.MaelstromEffects01 do
                    v:Destroy()
                end
                self.MaelstromEffects01 = {}
            end

            local wep = self:GetWeaponByLabel('QuantumMaelstrom')
            wep:AddDamageMod(bp.MaelstromDamage)
            wep:ChangeMaxRadius(wep:GetBlueprint().MaxRadius)
            wep:ChangeDamageRadius(wep:GetBlueprint().DamageRadius)
            self:SetPainterRange(enh, 0, true)
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
    },
}

TypeClass = EAL0001