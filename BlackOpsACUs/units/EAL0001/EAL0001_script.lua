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
local BOWeapons = import('/mods/BlackOpsACUs/lua/BlackOpsweapons.lua')
local AeonACUPhasonLaser = BOWeapons.AeonACUPhasonLaser 
local AIFQuasarAntiTorpedoWeapon = AWeapons.AIFQuasarAntiTorpedoWeapon
local CEMPArrayBeam01 = BOWeapons.CEMPArrayBeam01 
local QuantumMaelstromWeapon = BOWeapons.QuantumMaelstromWeapon
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker

EAL0001 = Class(ACUUnit) {
    DeathThreadDestructionWaitTime = 2,

    Weapons = {
        DeathWeapon = Class(DeathNukeWeapon) {},
        TargetPainter = Class(CEMPArrayBeam01) {},
        RightDisruptor = Class(ADFDisruptorCannonWeapon) {},
        ChronoDampener = Class(ADFChronoDampener) {},
        TorpedoLauncher01 = Class(AANChronoTorpedoWeapon) {},
        TorpedoLauncher02 = Class(AANChronoTorpedoWeapon) {},
        TorpedoLauncher03 = Class(AANChronoTorpedoWeapon) {},
        MiasmaArtillery01 = Class(AIFArtilleryMiasmaShellWeapon) {},
        MiasmaArtillery02 = Class(AIFArtilleryMiasmaShellWeapon) {},
        MiasmaArtillery03 = Class(AIFArtilleryMiasmaShellWeapon) {},
        PhasonBeam01 = Class(AeonACUPhasonLaser) {},
        PhasonBeam02 = Class(AeonACUPhasonLaser) {},
        PhasonBeam03 = Class(AeonACUPhasonLaser) {},
        QuantumMaelstrom01 = Class(QuantumMaelstromWeapon) {},
        QuantumMaelstrom02 = Class(QuantumMaelstromWeapon) {},
        QuantumMaelstrom03 = Class(QuantumMaelstromWeapon) {},
        AntiTorpedo = Class(AIFQuasarAntiTorpedoWeapon) {},
        AntiMissile = Class(AAMWillOWisp) {},
        OverCharge = Class(ADFOverchargeWeapon) {},
        AutoOverCharge = Class(ADFOverchargeWeapon) {},
    },

    __init = function(self)
        ACUUnit.__init(self, 'RightDisruptor')
    end,
    
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
        self:AddBuildRestriction(categories.CYBRAN * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            self.RemoteViewingData = {}
            self.RemoteViewingData.RemoteViewingFunctions = {}
            self.RemoteViewingData.DisableCounter = 0
            self.RemoteViewingData.IntelButton = true
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        ACUUnit.OnStopBeingBuilt(self, builder, layer)
        self:DisableUnitIntel('Enhancement', 'RadarStealth')
        self:DisableUnitIntel('Enhancement', 'SonarStealth')
        self:DisableUnitIntel('Enhancement', 'Cloak')
        self:DisableUnitIntel('Enhancement', 'CloakField')

        -- Disable Upgrade Weapons
        self:SetWeaponEnabledByLabel('TargetPainter', false)
        self:SetWeaponEnabledByLabel('ChronoDampener', false)
        self:SetWeaponEnabledByLabel('TorpedoLauncher01', false)
        self:SetWeaponEnabledByLabel('TorpedoLauncher02', false)
        self:SetWeaponEnabledByLabel('TorpedoLauncher03', false)
        self:SetWeaponEnabledByLabel('MiasmaArtillery01', false)
        self:SetWeaponEnabledByLabel('MiasmaArtillery02', false)
        self:SetWeaponEnabledByLabel('MiasmaArtillery02', false)
        self:SetWeaponEnabledByLabel('PhasonBeam01', false)
        self:SetWeaponEnabledByLabel('PhasonBeam02', false)
        self:SetWeaponEnabledByLabel('PhasonBeam03', false)
        self:SetWeaponEnabledByLabel('QuantumMaelstrom01', false)
        self:SetWeaponEnabledByLabel('QuantumMaelstrom02', false)
        self:SetWeaponEnabledByLabel('QuantumMaelstrom03', false)
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
            if self.RBIntTier2 and self.ScryActive then
                self:DisableRemoteViewingButtons()
                WaitSeconds(10)
                if self.RBIntTier2 then
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
    TogglePrimaryGun = function(self, RoF, radius)
        local wep = self:GetWeaponByLabel('RightDisruptor')
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

    CreateEnhancement = function(self, enh)
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
                    DisplayName = 'AEONCUT3BuildCombat',
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

            local gun = self:GetWeaponByLabel('ChronoDampener')
            gun:ChangeMaxRadius(bp.ChronoMaxRadius)
        elseif enh == 'AssaultEngineeringRemove' then
            if Buff.HasBuff(self, 'AEONACUT3BuildCombat') then
                Buff.RemoveBuff(self, 'AEONACUT3BuildCombat')
            end

            self:AddBuildRestriction(categories.AEON * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))   
            local gun = self:GetWeaponByLabel('ChronoDampener')
            gun:ChangeMaxRadius(gun:GetBlueprint().MaxRadius)
        elseif enh == 'ApocolypticEngineering' then
            self:RemoveBuildRestriction(categories.AEON * (categories.BUILTBYTIER4COMMANDER))
            self:updateBuildRestrictions()

            if not Buffs['AEONACUT4BuildCombat'] then
                BuffBlueprint {
                    Name = 'AEONACUT4BuildCombat',
                    DisplayName = 'AEONCUT4BuildCombat',
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
        elseif enh == 'ApocolypticEngineeringRemove' then
            if Buff.HasBuff(self, 'AEONACUT4BuildCombat') then
                Buff.RemoveBuff(self, 'AEONACUT4BuildCombat')
            end

            self:AddBuildRestriction(categories.AEON * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))

        -- Disruptor Amplifier
            
        elseif enh == 'DisruptorrBooster' then
            
            self:ForkThread(self.DefaultGunBuffThread)
        elseif enh == 'DisruptorrBoosterRemove' then
            local wepTargetPainter = self:GetWeaponByLabel('TargetPainter')
            wepTargetPainter:ChangeMaxRadius(22)
            
        elseif enh == 'DisruptorrEnhancer' then
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            wepDisruptor:ChangeMaxRadius(35)
            local wepTargetPainter = self:GetWeaponByLabel('TargetPainter')
            wepTargetPainter:ChangeMaxRadius(35)
            self.DisruptorRange = true
            
            self:ForkThread(self.DefaultGunBuffThread02)
        elseif enh == 'DisruptorrEnhancerRemove' then
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[2].MaxRadius
            wepDisruptor:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            local wepTargetPainter = self:GetWeaponByLabel('TargetPainter')
            wepTargetPainter:ChangeMaxRadius(22)
            self.DisruptorRange = false
            
        elseif enh == 'TorpedoLauncher' then
            if not Buffs['AeonHealthBoost7'] then
                BuffBlueprint {
                    Name = 'AeonHealthBoost7',
                    DisplayName = 'AeonHealthBoost7',
                    BuffType = 'AeonHealthBoost7',
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
            Buff.ApplyBuff(self, 'AeonHealthBoost7')
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            wepDisruptor:ChangeMaxRadius(35)
            local wepTargetPainter = self:GetWeaponByLabel('TargetPainter')
            wepTargetPainter:ChangeMaxRadius(35)
            self.wcTorp01 = true
            self.wcTorp02 = false
            self.wcTorp03 = false
            
            
            
        elseif enh == 'TorpedoLauncherRemove' then
            if Buff.HasBuff(self, 'AeonHealthBoost7') then
                Buff.RemoveBuff(self, 'AeonHealthBoost7')
            end
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[2].MaxRadius
            wepDisruptor:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            local wepTargetPainter = self:GetWeaponByLabel('TargetPainter')
            wepTargetPainter:ChangeMaxRadius(22)
            self.wcTorp01 = false
            self.wcTorp02 = false
            self.wcTorp03 = false
            
            
            
        elseif enh == 'TorpedoRapidLoader' then
            if not Buffs['AeonHealthBoost8'] then
                BuffBlueprint {
                    Name = 'AeonHealthBoost8',
                    DisplayName = 'AeonHealthBoost8',
                    BuffType = 'AeonHealthBoost8',
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
            Buff.ApplyBuff(self, 'AeonHealthBoost8')
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            wepDisruptor:AddDamageMod(100)
            self.wcTorp01 = false
            self.wcTorp02 = true
            self.wcTorp03 = false
            
            
            
            self:ForkThread(self.DefaultGunBuffThread)
            self:ForkThread(self.DefaultGunBuffThread02)
        elseif enh == 'TorpedoRapidLoaderRemove' then
            if Buff.HasBuff(self, 'AeonHealthBoost7') then
                Buff.RemoveBuff(self, 'AeonHealthBoost7')
            end
            if Buff.HasBuff(self, 'AeonHealthBoost8') then
                Buff.RemoveBuff(self, 'AeonHealthBoost8')
            end
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[2].MaxRadius
            wepDisruptor:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            wepDisruptor:AddDamageMod(-100)
            local wepTargetPainter = self:GetWeaponByLabel('TargetPainter')
            wepTargetPainter:ChangeMaxRadius(22)
            self.wcTorp01 = false
            self.wcTorp02 = false
            self.wcTorp03 = false
            
            
            
        elseif enh == 'TorpedoClusterLauncher' then
            if not Buffs['AeonHealthBoost9'] then
                BuffBlueprint {
                    Name = 'AeonHealthBoost9',
                    DisplayName = 'AeonHealthBoost9',
                    BuffType = 'AeonHealthBoost9',
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
            Buff.ApplyBuff(self, 'AeonHealthBoost9')
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            wepDisruptor:AddDamageMod(200)
            self.wcTorp01 = false
            self.wcTorp02 = false
            self.wcTorp03 = true
            
            
            
        elseif enh == 'TorpedoClusterLauncherRemove' then
            if Buff.HasBuff(self, 'AeonHealthBoost7') then
                Buff.RemoveBuff(self, 'AeonHealthBoost7')
            end
            if Buff.HasBuff(self, 'AeonHealthBoost8') then
                Buff.RemoveBuff(self, 'AeonHealthBoost8')
            end
            if Buff.HasBuff(self, 'AeonHealthBoost9') then
                Buff.RemoveBuff(self, 'AeonHealthBoost9')
            end
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[2].MaxRadius
            wepDisruptor:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            wepDisruptor:AddDamageMod(-300)
            local wepTargetPainter = self:GetWeaponByLabel('TargetPainter')
            wepTargetPainter:ChangeMaxRadius(22)
            self.wcTorp01 = false
            self.wcTorp02 = false
            self.wcTorp03 = false
            
            
            
        elseif enh == 'ArtilleryMiasma' then
            if not Buffs['AeonHealthBoost10'] then
                BuffBlueprint {
                    Name = 'AeonHealthBoost10',
                    DisplayName = 'AeonHealthBoost10',
                    BuffType = 'AeonHealthBoost10',
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
            Buff.ApplyBuff(self, 'AeonHealthBoost10')
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            wepDisruptor:ChangeMaxRadius(35)
            local wepTargetPainter = self:GetWeaponByLabel('TargetPainter')
            wepTargetPainter:ChangeMaxRadius(100)
            self.wcArtillery01 = true
            self.wcArtillery02 = false
            self.wcArtillery03 = false
            self.ccArtillery = true
            
            
            self:ForkThread(self.ArtyShieldCheck)
            
        elseif enh == 'ArtilleryMiasmaRemove' then
            if Buff.HasBuff(self, 'AeonHealthBoost10') then
                Buff.RemoveBuff(self, 'AeonHealthBoost10')
            end
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[2].MaxRadius
            wepDisruptor:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            local wepTargetPainter = self:GetWeaponByLabel('TargetPainter')
            wepTargetPainter:ChangeMaxRadius(22)
            self.wcArtillery01 = false
            self.wcArtillery02 = false
            self.wcArtillery03 = false
            self.ccArtillery = false
            
            
            self:ForkThread(self.ArtyShieldCheck)
            
        elseif enh == 'AdvancedShells' then
            if not Buffs['AeonHealthBoost11'] then
                BuffBlueprint {
                    Name = 'AeonHealthBoost11',
                    DisplayName = 'AeonHealthBoost11',
                    BuffType = 'AeonHealthBoost11',
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
            Buff.ApplyBuff(self, 'AeonHealthBoost11')
            self.wcArtillery01 = false
            self.wcArtillery02 = true
            self.wcArtillery03 = false
            self.ccArtillery = true
            
            
            self:ForkThread(self.ArtyShieldCheck)
            
            self:ForkThread(self.DefaultGunBuffThread)
            self:ForkThread(self.DefaultGunBuffThread02)
        elseif enh == 'AdvancedShellsRemove' then    
            self:RemoveToggleCap('RULEUTC_WeaponToggle')
            if Buff.HasBuff(self, 'AeonHealthBoost10') then
                Buff.RemoveBuff(self, 'AeonHealthBoost10')
            end
            if Buff.HasBuff(self, 'AeonHealthBoost11') then
                Buff.RemoveBuff(self, 'AeonHealthBoost11')
            end
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[2].MaxRadius
            wepDisruptor:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            local wepTargetPainter = self:GetWeaponByLabel('TargetPainter')
            wepTargetPainter:ChangeMaxRadius(22)
            self.wcArtillery01 = false
            self.wcArtillery02 = false
            self.wcArtillery03 = false
            self.ccArtillery = false
            
            
            self:ForkThread(self.ArtyShieldCheck)
            
        elseif enh == 'ImprovedReloader' then
            if not Buffs['AeonHealthBoost12'] then
                BuffBlueprint {
                    Name = 'AeonHealthBoost12',
                    DisplayName = 'AeonHealthBoost12',
                    BuffType = 'AeonHealthBoost12',
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
            Buff.ApplyBuff(self, 'AeonHealthBoost12')
            self.wcArtillery01 = false
            self.wcArtillery02 = false
            self.wcArtillery03 = true
            self.ccArtillery = true
            
            
            self:ForkThread(self.ArtyShieldCheck)
            
        elseif enh == 'ImprovedReloaderRemove' then    
            self:RemoveToggleCap('RULEUTC_WeaponToggle')
            if Buff.HasBuff(self, 'AeonHealthBoost10') then
                Buff.RemoveBuff(self, 'AeonHealthBoost10')
            end
            if Buff.HasBuff(self, 'AeonHealthBoost11') then
                Buff.RemoveBuff(self, 'AeonHealthBoost11')
            end
            if Buff.HasBuff(self, 'AeonHealthBoost12') then
                Buff.RemoveBuff(self, 'AeonHealthBoost12')
            end
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[2].MaxRadius
            wepDisruptor:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            local wepTargetPainter = self:GetWeaponByLabel('TargetPainter')
            wepTargetPainter:ChangeMaxRadius(22)
            self.wcArtillery01 = false
            self.wcArtillery02 = false
            self.wcArtillery03 = false
            self.ccArtillery = false
            
            
            self:ForkThread(self.ArtyShieldCheck)
            
        elseif enh == 'BeamPhason' then
            if not Buffs['AeonHealthBoost13'] then
                BuffBlueprint {
                    Name = 'AeonHealthBoost13',
                    DisplayName = 'AeonHealthBoost13',
                    BuffType = 'AeonHealthBoost13',
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
            Buff.ApplyBuff(self, 'AeonHealthBoost13')
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            wepDisruptor:ChangeMaxRadius(35)
            local wepTargetPainter = self:GetWeaponByLabel('TargetPainter')
            wepTargetPainter:ChangeMaxRadius(35)
            self.wcBeam01 = true
            self.wcBeam02 = false
            self.wcBeam03 = false
            
            
            
        elseif enh == 'BeamPhasonRemove' then
            if Buff.HasBuff(self, 'AeonHealthBoost13') then
                Buff.RemoveBuff(self, 'AeonHealthBoost13')
            end
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[2].MaxRadius
            wepDisruptor:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            local wepTargetPainter = self:GetWeaponByLabel('TargetPainter')
            wepTargetPainter:ChangeMaxRadius(22)
            self.wcBeam01 = false
            self.wcBeam02 = false
            self.wcBeam03 = false
            
            
            
        elseif enh == 'ImprovedCoolingSystem' then
            if not Buffs['AeonHealthBoost14'] then
                BuffBlueprint {
                    Name = 'AeonHealthBoost14',
                    DisplayName = 'AeonHealthBoost14',
                    BuffType = 'AeonHealthBoost14',
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
            Buff.ApplyBuff(self, 'AeonHealthBoost14')
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            wepDisruptor:ChangeMaxRadius(40)
            self.wcBeam01 = false
            self.wcBeam02 = true
            self.wcBeam03 = false
            
                
            
            self:ForkThread(self.DefaultGunBuffThread)
            self:ForkThread(self.DefaultGunBuffThread02)
        elseif enh == 'ImprovedCoolingSystemRemove' then
            if Buff.HasBuff(self, 'AeonHealthBoost13') then
                Buff.RemoveBuff(self, 'AeonHealthBoost13')
            end
            if Buff.HasBuff(self, 'AeonHealthBoost14') then
                Buff.RemoveBuff(self, 'AeonHealthBoost14')
            end
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[2].MaxRadius
            wepDisruptor:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            local wepTargetPainter = self:GetWeaponByLabel('TargetPainter')
            wepTargetPainter:ChangeMaxRadius(22)
            self.wcBeam01 = false
            self.wcBeam02 = false
            self.wcBeam03 = false
            
            
            
        elseif enh == 'PowerBooster' then
            if not Buffs['AeonHealthBoost15'] then
                BuffBlueprint {
                    Name = 'AeonHealthBoost15',
                    DisplayName = 'AeonHealthBoost15',
                    BuffType = 'AeonHealthBoost15',
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
            Buff.ApplyBuff(self, 'AeonHealthBoost15')
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            wepDisruptor:ChangeMaxRadius(40)
            self.wcBeam01 = false
            self.wcBeam02 = false
            self.wcBeam03 = true
            
            
            
        elseif enh == 'PowerBoosterRemove' then
            if Buff.HasBuff(self, 'AeonHealthBoost13') then
                Buff.RemoveBuff(self, 'AeonHealthBoost13')
            end
            if Buff.HasBuff(self, 'AeonHealthBoost14') then
                Buff.RemoveBuff(self, 'AeonHealthBoost14')
            end
            if Buff.HasBuff(self, 'AeonHealthBoost15') then
                Buff.RemoveBuff(self, 'AeonHealthBoost15')
            end
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[2].MaxRadius
            wepDisruptor:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            local wepTargetPainter = self:GetWeaponByLabel('TargetPainter')
            wepTargetPainter:ChangeMaxRadius(22)
            self.wcBeam01 = false
            self.wcBeam02 = false
            self.wcBeam03 = false
            
            
            
        elseif enh == 'ShieldBattery' then
            self:AddToggleCap('RULEUTC_ShieldToggle')
            self:CreateShield(bp)
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            self.ccShield = true
            self:ForkThread(self.ArtyShieldCheck)
            
        elseif enh == 'ShieldBatteryRemove' then
            self:DestroyShield()
            RemoveUnitEnhancement(self, 'ShieldBatteryRemove')
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
            self.ccShield = false
            self:ForkThread(self.ArtyShieldCheck)
            
        elseif enh == 'ActiveShielding' then
            self:DestroyShield()
            ForkThread(function()
                WaitTicks(1)
                self:CreateShield(bp)
            end)
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            self.ccShield = true
            self:ForkThread(self.ArtyShieldCheck)
            
        elseif enh == 'ActiveShieldingRemove' then
            self:DestroyShield()
            RemoveUnitEnhancement(self, 'ActiveShieldingRemove')
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
            self.ccShield = false
            self:ForkThread(self.ArtyShieldCheck)
            
        elseif enh == 'ImprovedShieldBattery' then
            self:DestroyShield()
            ForkThread(function()
                WaitTicks(1)
                self:CreateShield(bp)
            end)
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            self:SetWeaponEnabledByLabel('AntiMissile', true)
            self.ccShield = true
            self:ForkThread(self.ArtyShieldCheck)
            
        elseif enh == 'ImprovedShieldBatteryRemove' then
            self:DestroyShield()
            RemoveUnitEnhancement(self, 'ImprovedShieldBatteryRemove')
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
            self:SetWeaponEnabledByLabel('AntiMissile', false)
            self.ccShield = false
            self:ForkThread(self.ArtyShieldCheck)
            
        elseif enh == 'ElectronicsEnhancment' then
            self:SetIntelRadius('Vision', bp.NewVisionRadius or 50)
            self:SetIntelRadius('Omni', bp.NewOmniRadius or 50)
            if not Buffs['AeonHealthBoost16'] then
                BuffBlueprint {
                    Name = 'AeonHealthBoost16',
                    DisplayName = 'AeonHealthBoost16',
                    BuffType = 'AeonHealthBoost16',
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
            Buff.ApplyBuff(self, 'AeonHealthBoost16')
            self:SetWeaponEnabledByLabel('AntiMissile', true)
            self.RBIntTier1 = true
            self.RBIntTier2 = false
            self.RBIntTier3 = false
            
        elseif enh == 'ElectronicsEnhancmentRemove' then
            local bpIntel = self:GetBlueprint().Intel
            self:SetIntelRadius('Vision', bpIntel.VisionRadius or 26)
            self:SetIntelRadius('Omni', bpIntel.OmniRadius or 26)
            if Buff.HasBuff(self, 'AeonHealthBoost16') then
                Buff.RemoveBuff(self, 'AeonHealthBoost16')
            end
            self:SetWeaponEnabledByLabel('AntiMissile', false)
            self.RBIntTier1 = false
            self.RBIntTier2 = false
            self.RBIntTier3 = false
            
        elseif enh == 'ElectronicCountermeasures' then
            if not Buffs['AeonHealthBoost17'] then
                BuffBlueprint {
                    Name = 'AeonHealthBoost17',
                    DisplayName = 'AeonHealthBoost17',
                    BuffType = 'AeonHealthBoost17',
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
            Buff.ApplyBuff(self, 'AeonHealthBoost17')
            self.RBIntTier1 = true
            self.RBIntTier2 = true
            self.RBIntTier3 = false
            
            self:ForkThread(self.EnableRemoteViewingButtons)
        elseif enh == 'ElectronicCountermeasuresRemove' then
            local bpIntel = self:GetBlueprint().Intel
            self:SetIntelRadius('Vision', bpIntel.VisionRadius or 26)
            self:SetIntelRadius('Omni', bpIntel.OmniRadius or 26)
            if Buff.HasBuff(self, 'AeonHealthBoost16') then
                Buff.RemoveBuff(self, 'AeonHealthBoost16')
            end
            if Buff.HasBuff(self, 'AeonHealthBoost17') then
                Buff.RemoveBuff(self, 'AeonHealthBoost17')
            end
            self:SetWeaponEnabledByLabel('AntiMissile', false)
            self.RBIntTier1 = false
            self.RBIntTier2 = false
            self.RBIntTier3 = false
            
            self:ForkThread(self.DisableRemoteViewingButtons)
        elseif enh == 'CloakingSubsystems' then
            self:AddCommandCap('RULEUCC_Teleport')
            if not Buffs['AeonHealthBoost18'] then
                BuffBlueprint {
                    Name = 'AeonHealthBoost18',
                    DisplayName = 'AeonHealthBoost18',
                    BuffType = 'AeonHealthBoost18',
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
            Buff.ApplyBuff(self, 'AeonHealthBoost18')
            self.RBIntTier1 = true
            self.RBIntTier2 = true
            self.RBIntTier3 = true
            
        elseif enh == 'CloakingSubsystemsRemove' then
            self:RemoveCommandCap('RULEUCC_Teleport')
            local bpIntel = self:GetBlueprint().Intel
            self:SetIntelRadius('Vision', bpIntel.VisionRadius or 26)
            self:SetIntelRadius('Omni', bpIntel.OmniRadius or 26)
            if Buff.HasBuff(self, 'AeonHealthBoost16') then
                Buff.RemoveBuff(self, 'AeonHealthBoost16')
            end
            if Buff.HasBuff(self, 'AeonHealthBoost17') then
                Buff.RemoveBuff(self, 'AeonHealthBoost17')
            end
            if Buff.HasBuff(self, 'AeonHealthBoost18') then
                Buff.RemoveBuff(self, 'AeonHealthBoost18')
            end
            self.RBIntTier1 = false
            self.RBIntTier2 = false
            self.RBIntTier3 = false
            self:SetWeaponEnabledByLabel('AntiMissile', false)
            
            self:ForkThread(self.DisableRemoteViewingButtons)
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
            if not Buffs['AeonHealthBoost19'] then
                BuffBlueprint {
                    Name = 'AeonHealthBoost19',
                    DisplayName = 'AeonHealthBoost19',
                    BuffType = 'AeonHealthBoost19',
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
            Buff.ApplyBuff(self, 'AeonHealthBoost19')
            self.wcMaelstrom01 = true
            self.wcMaelstrom02 = false
            self.wcMaelstrom03 = false
            
            
            self.RBComTier1 = true
            self.RBComTier2 = false
            self.RBComTier3 = false
            
        elseif enh == 'MaelstromQuantumRemove' then
            if Buff.HasBuff(self, 'AeonHealthBoost19') then
                Buff.RemoveBuff(self, 'AeonHealthBoost19')
            end
            self.wcMaelstrom01 = false
            self.wcMaelstrom02 = false
            self.wcMaelstrom03 = false
            
            
                if self.MaelstromEffects01 then
                    for k, v in self.MaelstromEffects01 do
                        v:Destroy()
                    end
                    self.MaelstromEffects01 = {}
                end
            self.RBComTier1 = false
            self.RBComTier2 = false
            self.RBComTier3 = false
            
        elseif enh == 'Fieldpander' then
            if not Buffs['AeonHealthBoost20'] then
                BuffBlueprint {
                    Name = 'AeonHealthBoost20',
                    DisplayName = 'AeonHealthBoost20',
                    BuffType = 'AeonHealthBoost20',
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
            Buff.ApplyBuff(self, 'AeonHealthBoost20')
            self:SetWeaponEnabledByLabel('AntiMissile', true)
            self.wcMaelstrom01 = false
            self.wcMaelstrom02 = true
            self.wcMaelstrom03 = false
            self:SetWeaponEnabledByLabel('AntiMissile', true)
            
                
            self.RBComTier1 = true
            self.RBComTier2 = true
            self.RBComTier3 = false
            
        elseif enh == 'QuantumInstability' then
            if not Buffs['AeonHealthBoost21'] then
                BuffBlueprint {
                    Name = 'AeonHealthBoost21',
                    DisplayName = 'AeonHealthBoost21',
                    BuffType = 'AeonHealthBoost21',
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
            Buff.ApplyBuff(self, 'AeonHealthBoost21')
            self:SetWeaponEnabledByLabel('AntiMissile', false)
            self.wcMaelstrom01 = false
            self.wcMaelstrom02 = false
            self.wcMaelstrom03 = true
            
                  
            self.RBComTier1 = true
            self.RBComTier2 = true
            self.RBComTier3 = true
            
        elseif enh == 'FieldpanderRemove' then
            if Buff.HasBuff(self, 'AeonHealthBoost19') then
                Buff.RemoveBuff(self, 'AeonHealthBoost19')
            end
            if Buff.HasBuff(self, 'AeonHealthBoost20') then
                Buff.RemoveBuff(self, 'AeonHealthBoost20')
            end
            if Buff.HasBuff(self, 'AeonHealthBoost21') then
                Buff.RemoveBuff(self, 'AeonHealthBoost21')
            end
            self:SetWeaponEnabledByLabel('AntiMissile', false)
            self.wcMaelstrom01 = false
            self.wcMaelstrom02 = false
            self.wcMaelstrom03 = false
            self:SetWeaponEnabledByLabel('AntiMissile', false)
            
            
                if self.MaelstromEffects01 then
                    for k, v in self.MaelstromEffects01 do
                        v:Destroy()
                    end
                    self.MaelstromEffects01 = {}
                end
            self.RBComTier1 = false
            self.RBComTier2 = false
            self.RBComTier3 = false
            
        elseif enh == 'QuantumInstabilityRemove' then
            if Buff.HasBuff(self, 'AeonHealthBoost19') then
                Buff.RemoveBuff(self, 'AeonHealthBoost19')
            end
            if Buff.HasBuff(self, 'AeonHealthBoost20') then
                Buff.RemoveBuff(self, 'AeonHealthBoost20')
            end
            if Buff.HasBuff(self, 'AeonHealthBoost21') then
                Buff.RemoveBuff(self, 'AeonHealthBoost21')
            end
            self:SetWeaponEnabledByLabel('AntiMissile', false)
            self.wcMaelstrom01 = false
            self.wcMaelstrom02 = false
            self.wcMaelstrom03 = false
            self:SetWeaponEnabledByLabel('AntiMissile', false)
            
            
                if self.MaelstromEffects01 then
                    for k, v in self.MaelstromEffects01 do
                        v:Destroy()
                    end
                    self.MaelstromEffects01 = {}
                end
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

TypeClass = EAL0001