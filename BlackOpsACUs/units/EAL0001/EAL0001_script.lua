-----------------------------------------------------------------
-- Author(s):  Exavier Macbeth
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
local EXCEMPArrayBeam01 = BOWeapons.EXCEMPArrayBeam01 
local EXQuantumMaelstromWeapon = BOWeapons.EXQuantumMaelstromWeapon
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker

EAL0001 = Class(ACUUnit) {
    DeathThreadDestructionWaitTime = 2,

    Weapons = {
        DeathWeapon = Class(DeathNukeWeapon) {},
        EXTargetPainter = Class(EXCEMPArrayBeam01) {},
        RightDisruptor = Class(ADFDisruptorCannonWeapon) {},
        EXChronoDampener01 = Class(ADFChronoDampener) {},
        EXChronoDampener02 = Class(ADFChronoDampener) {},
        EXTorpedoLauncher01 = Class(AANChronoTorpedoWeapon) {},
        EXTorpedoLauncher02 = Class(AANChronoTorpedoWeapon) {},
        EXTorpedoLauncher03 = Class(AANChronoTorpedoWeapon) {},
        EXMiasmaArtillery01 = Class(AIFArtilleryMiasmaShellWeapon) {},
        EXMiasmaArtillery02 = Class(AIFArtilleryMiasmaShellWeapon) {},
        EXMiasmaArtillery03 = Class(AIFArtilleryMiasmaShellWeapon) {},
        EXPhasonBeam01 = Class(AeonACUPhasonLaser) {},
        EXPhasonBeam02 = Class(AeonACUPhasonLaser) {},
        EXPhasonBeam03 = Class(AeonACUPhasonLaser) {},
        EXQuantumMaelstrom01 = Class(EXQuantumMaelstromWeapon) {},
        EXQuantumMaelstrom02 = Class(EXQuantumMaelstromWeapon) {},
        EXQuantumMaelstrom03 = Class(EXQuantumMaelstromWeapon) {},
        EXAntiTorpedo = Class(AIFQuasarAntiTorpedoWeapon) {},
        EXAntiMissile = Class(AAMWillOWisp) {},
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
        self:SetWeaponEnabledByLabel('EXTargetPainter', false)
        self:SetWeaponEnabledByLabel('EXChronoDampener01', false)
        self:SetWeaponEnabledByLabel('EXChronoDampener02', false)
        self:SetWeaponEnabledByLabel('EXTorpedoLauncher01', false)
        self:SetWeaponEnabledByLabel('EXTorpedoLauncher02', false)
        self:SetWeaponEnabledByLabel('EXTorpedoLauncher03', false)
        self:SetWeaponEnabledByLabel('EXMiasmaArtillery01', false)
        self:SetWeaponEnabledByLabel('EXMiasmaArtillery02', false)
        self:SetWeaponEnabledByLabel('EXMiasmaArtillery02', false)
        self:SetWeaponEnabledByLabel('EXPhasonBeam01', false)
        self:SetWeaponEnabledByLabel('EXPhasonBeam02', false)
        self:SetWeaponEnabledByLabel('EXPhasonBeam03', false)
        self:SetWeaponEnabledByLabel('EXQuantumMaelstrom01', false)
        self:SetWeaponEnabledByLabel('EXQuantumMaelstrom02', false)
        self:SetWeaponEnabledByLabel('EXQuantumMaelstrom03', false)
        self:SetWeaponEnabledByLabel('EXAntiTorpedo', false)
        self:SetWeaponEnabledByLabel('EXAntiMissile', false)        
        
        self.Sync.Abilities = self:GetBlueprint().Abilities
        self.Sync.Abilities.EXScryTarget.Active = false
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
            self.Sync.Abilities.EXScryTarget.Active = false
            self:AddToggleCap('RULEUTC_IntelToggle')
            self:RemoveToggleCap('RULEUTC_IntelToggle')
        end,
        
        EnableRemoteViewingButtons = function(self)
            self.Sync.Abilities = self:GetBlueprint().Abilities
            self.Sync.Abilities.EXScryTarget.Active = true
            self:AddToggleCap('RULEUTC_IntelToggle')
            self:RemoveToggleCap('RULEUTC_IntelToggle')
        end,

        EXRemoteCheck = function(self)
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
                self:ForkThread(self.EXRemoteCheck)
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

    CreateEnhancement = function(self, enh)
        ACUUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if enh =='EXImprovedEngineering' then
            self:RemoveBuildRestriction(categories.AEON * (categories.BUILTBYTIER2COMMANDER))
            if not Buffs['AEONACUT2BuildRate'] then
                BuffBlueprint {
                    Name = 'AEONACUT2BuildRate',
                    DisplayName = 'AEONACUT2BuildRate',
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
            Buff.ApplyBuff(self, 'AEONACUT2BuildRate')
            local bp = self:GetBlueprint().Enhancements[enh]
            local bpEcon = self:GetBlueprint().Economy
            if not bp then return end
            self:SetProductionPerSecondEnergy(bp.ProductionPerSecondEnergy + bpEcon.ProductionPerSecondEnergy or 0)
            self:SetProductionPerSecondMass(bp.ProductionPerSecondMass + bpEcon.ProductionPerSecondMass or 0)
            if not Buffs['EXAeonHealthBoost1'] then
                BuffBlueprint {
                    Name = 'EXAeonHealthBoost1',
                    DisplayName = 'EXAeonHealthBoost1',
                    BuffType = 'EXAeonHealthBoost1',
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
            Buff.ApplyBuff(self, 'EXAeonHealthBoost1')
            self.RBImpEngineering = true
            self.RBAdvEngineering = false
            self.RBExpEngineering = false
            
        elseif enh =='EXImprovedEngineeringRemove' then
            local bp = self:GetBlueprint().Economy.BuildRate
            if Buff.HasBuff(self, 'AEONACUT2BuildRate') then
                Buff.RemoveBuff(self, 'AEONACUT2BuildRate')
            end
            if not bp then return end
            self:RestoreBuildRestrictions()
            self:AddBuildRestriction(categories.AEON * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            local bpEcon = self:GetBlueprint().Economy
            self:SetProductionPerSecondEnergy(bpEcon.ProductionPerSecondEnergy or 0)
            self:SetProductionPerSecondMass(bpEcon.ProductionPerSecondMass or 0)
            if Buff.HasBuff(self, 'EXAeonHealthBoost1') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost1')
            end
            self.RBImpEngineering = false
            self.RBAdvEngineering = false
            self.RBExpEngineering = false
            
        elseif enh =='EXAdvancedEngineering' then
            self:RemoveBuildRestriction(categories.AEON * (categories.BUILTBYTIER3COMMANDER - categories.BUILTBYTIER4COMMANDER))
            if not Buffs['AEONACUT3BuildRate'] then
                BuffBlueprint {
                    Name = 'AEONACUT3BuildRate',
                    DisplayName = 'AEONCUT3BuildRate',
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
            Buff.ApplyBuff(self, 'AEONACUT3BuildRate')
            local bp = self:GetBlueprint().Enhancements[enh]
            local bpEcon = self:GetBlueprint().Economy
            if not bp then return end
            self:SetProductionPerSecondEnergy(bp.ProductionPerSecondEnergy + bpEcon.ProductionPerSecondEnergy or 0)
            self:SetProductionPerSecondMass(bp.ProductionPerSecondMass + bpEcon.ProductionPerSecondMass or 0)
            if not Buffs['EXAeonHealthBoost2'] then
                BuffBlueprint {
                    Name = 'EXAeonHealthBoost2',
                    DisplayName = 'EXAeonHealthBoost2',
                    BuffType = 'EXAeonHealthBoost2',
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
            Buff.ApplyBuff(self, 'EXAeonHealthBoost2')
            self.RBImpEngineering = true
            self.RBAdvEngineering = true
            self.RBExpEngineering = false
            
        elseif enh =='EXAdvancedEngineeringRemove' then
            local bp = self:GetBlueprint().Economy.BuildRate
            if not bp then return end
            self:RestoreBuildRestrictions()
            if Buff.HasBuff(self, 'AEONACUT3BuildRate') then
                Buff.RemoveBuff(self, 'AEONACUT3BuildRate')
            end
            self:AddBuildRestriction(categories.AEON * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            local bpEcon = self:GetBlueprint().Economy
            self:SetProductionPerSecondEnergy(bpEcon.ProductionPerSecondEnergy or 0)
            self:SetProductionPerSecondMass(bpEcon.ProductionPerSecondMass or 0)
            if Buff.HasBuff(self, 'EXAeonHealthBoost1') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost1')
            end
            if Buff.HasBuff(self, 'EXAeonHealthBoost2') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost2')
            end
            self.RBImpEngineering = false
            self.RBAdvEngineering = false
            self.RBExpEngineering = false
            
        elseif enh =='EXExperimentalEngineering' then
            self:RemoveBuildRestriction(categories.AEON * (categories.BUILTBYTIER4COMMANDER))
            local bp = self:GetBlueprint().Enhancements[enh]
            local bpEcon = self:GetBlueprint().Economy
            if not bp then return end
            self:SetProductionPerSecondEnergy(bp.ProductionPerSecondEnergy + bpEcon.ProductionPerSecondEnergy or 0)
            self:SetProductionPerSecondMass(bp.ProductionPerSecondMass + bpEcon.ProductionPerSecondMass or 0)
            if not Buffs['AEONACUT4BuildRate'] then
                BuffBlueprint {
                    Name = 'AEONACUT4BuildRate',
                    DisplayName = 'AEONCUT4BuildRate',
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
            Buff.ApplyBuff(self, 'AEONACUT4BuildRate')
            if not Buffs['EXAeonHealthBoost3'] then
                BuffBlueprint {
                    Name = 'EXAeonHealthBoost3',
                    DisplayName = 'EXAeonHealthBoost3',
                    BuffType = 'EXAeonHealthBoost3',
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
            Buff.ApplyBuff(self, 'EXAeonHealthBoost3')
            self.RBImpEngineering = true
            self.RBAdvEngineering = true
            self.RBExpEngineering = true
            
        elseif enh =='EXExperimentalEngineeringRemove' then
            local bp = self:GetBlueprint().Economy.BuildRate
            if not bp then return end
            self:RestoreBuildRestrictions()
            if Buff.HasBuff(self, 'AEONACUT4BuildRate') then
                Buff.RemoveBuff(self, 'AEONACUT4BuildRate')
            end
            self:AddBuildRestriction(categories.AEON * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            local bpEcon = self:GetBlueprint().Economy
            self:SetProductionPerSecondEnergy(bpEcon.ProductionPerSecondEnergy or 0)
            self:SetProductionPerSecondMass(bpEcon.ProductionPerSecondMass or 0)
            if Buff.HasBuff(self, 'EXAeonHealthBoost1') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost1')
            end
            if Buff.HasBuff(self, 'EXAeonHealthBoost2') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost2')
            end
            if Buff.HasBuff(self, 'EXAeonHealthBoost3') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost3')
            end
            self.RBImpEngineering = false
            self.RBAdvEngineering = false
            self.RBExpEngineering = false
            
        elseif enh =='EXCombatEngineering' then
            self:RemoveBuildRestriction(categories.AEON * (categories.BUILTBYTIER2COMMANDER))
            if not Buffs['AEONACUT2BuildRate'] then
                BuffBlueprint {
                    Name = 'AEONACUT2BuildRate',
                    DisplayName = 'AEONACUT2BuildRate',
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
            Buff.ApplyBuff(self, 'AEONACUT2BuildRate')
            if not Buffs['EXAeonHealthBoost4'] then
                BuffBlueprint {
                    Name = 'EXAeonHealthBoost4',
                    DisplayName = 'EXAeonHealthBoost4',
                    BuffType = 'EXAeonHealthBoost4',
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
            Buff.ApplyBuff(self, 'EXAeonHealthBoost4')
            self.wcChrono01 = true
            self.wcChrono02 = false
            
            
            self.RBComEngineering = true
            self.RBAssEngineering = false
            self.RBApoEngineering = false
            
        elseif enh =='EXCombatEngineeringRemove' then
            local bp = self:GetBlueprint().Economy.BuildRate
            if Buff.HasBuff(self, 'AEONACUT2BuildRate') then
                Buff.RemoveBuff(self, 'AEONACUT2BuildRate')
            end
            if not bp then return end
            self:RestoreBuildRestrictions()
            self:AddBuildRestriction(categories.AEON * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            if Buff.HasBuff(self, 'EXAeonHealthBoost4') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost4')
            end
            self.wcChrono01 = false
            self.wcChrono02 = false
            
            
            self.RBComEngineering = false
            self.RBAssEngineering = false
            self.RBApoEngineering = false
            
        elseif enh =='EXAssaultEngineering' then
            self:RemoveBuildRestriction(categories.AEON * (categories.BUILTBYTIER3COMMANDER - categories.BUILTBYTIER4COMMANDER))
            if not Buffs['AEONACUT3BuildRate'] then
                BuffBlueprint {
                    Name = 'AEONACUT3BuildRate',
                    DisplayName = 'AEONCUT3BuildRate',
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
            Buff.ApplyBuff(self, 'AEONACUT3BuildRate')
            if not Buffs['EXAeonHealthBoost5'] then
                BuffBlueprint {
                    Name = 'EXAeonHealthBoost5',
                    DisplayName = 'EXAeonHealthBoost5',
                    BuffType = 'EXAeonHealthBoost5',
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
            Buff.ApplyBuff(self, 'EXAeonHealthBoost5')  
            self.wcChrono01 = false
            self.wcChrono02 = true
            
            
            self.RBComEngineering = true
            self.RBAssEngineering = true
            self.RBApoEngineering = false
            
        elseif enh =='EXAssaultEngineeringRemove' then
            local bp = self:GetBlueprint().Economy.BuildRate
            if not bp then return end
            self:RestoreBuildRestrictions()
            if Buff.HasBuff(self, 'AEONACUT3BuildRate') then
                Buff.RemoveBuff(self, 'AEONACUT3BuildRate')
            end
            self:AddBuildRestriction(categories.AEON * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))   
            if Buff.HasBuff(self, 'EXAeonHealthBoost4') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost4')
            end
            if Buff.HasBuff(self, 'EXAeonHealthBoost5') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost5')
            end
            self.wcChrono01 = false
            self.wcChrono02 = false
            
            
            self.RBComEngineering = false
            self.RBAssEngineering = false
            self.RBApoEngineering = false
            
        elseif enh =='EXApocolypticEngineering' then
            self:RemoveBuildRestriction(categories.AEON * (categories.BUILTBYTIER4COMMANDER))
            if not Buffs['AEONACUT4BuildRate'] then
                BuffBlueprint {
                    Name = 'AEONACUT4BuildRate',
                    DisplayName = 'AEONCUT4BuildRate',
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
            Buff.ApplyBuff(self, 'AEONACUT4BuildRate')
            if not Buffs['EXAeonHealthBoost6'] then
                BuffBlueprint {
                    Name = 'EXAeonHealthBoost6',
                    DisplayName = 'EXAeonHealthBoost6',
                    BuffType = 'EXAeonHealthBoost6',
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
            Buff.ApplyBuff(self, 'EXAeonHealthBoost6')
            self.RBComEngineering = true
            self.RBAssEngineering = true
            self.RBApoEngineering = true
            
        elseif enh =='EXApocolypticEngineeringRemove' then
            local bp = self:GetBlueprint().Economy.BuildRate
            if not bp then return end
            self:RestoreBuildRestrictions()
            if Buff.HasBuff(self, 'AEONACUT4BuildRate') then
                Buff.RemoveBuff(self, 'AEONACUT4BuildRate')
            end
            self:AddBuildRestriction(categories.AEON * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
            if Buff.HasBuff(self, 'EXAeonHealthBoost4') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost4')
            end
            if Buff.HasBuff(self, 'EXAeonHealthBoost5') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost5')
            end
            if Buff.HasBuff(self, 'EXAeonHealthBoost6') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost6')
            end
            self.wcChrono01 = false
            self.wcChrono02 = false
            
            
            self.RBComEngineering = false
            self.RBAssEngineering = false
            self.RBApoEngineering = false
            
        elseif enh =='EXDisruptorrBooster' then
            
            self:ForkThread(self.DefaultGunBuffThread)
        elseif enh =='EXDisruptorrBoosterRemove' then
            local wepTargetPainter = self:GetWeaponByLabel('EXTargetPainter')
            wepTargetPainter:ChangeMaxRadius(22)
            
        elseif enh =='EXDisruptorrEnhancer' then
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            wepDisruptor:ChangeMaxRadius(35)
            local wepTargetPainter = self:GetWeaponByLabel('EXTargetPainter')
            wepTargetPainter:ChangeMaxRadius(35)
            self.DisruptorRange = true
            
            self:ForkThread(self.DefaultGunBuffThread02)
        elseif enh =='EXDisruptorrEnhancerRemove' then
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[2].MaxRadius
            wepDisruptor:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            local wepTargetPainter = self:GetWeaponByLabel('EXTargetPainter')
            wepTargetPainter:ChangeMaxRadius(22)
            self.DisruptorRange = false
            
        elseif enh =='EXTorpedoLauncher' then
            if not Buffs['EXAeonHealthBoost7'] then
                BuffBlueprint {
                    Name = 'EXAeonHealthBoost7',
                    DisplayName = 'EXAeonHealthBoost7',
                    BuffType = 'EXAeonHealthBoost7',
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
            Buff.ApplyBuff(self, 'EXAeonHealthBoost7')
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            wepDisruptor:ChangeMaxRadius(35)
            local wepTargetPainter = self:GetWeaponByLabel('EXTargetPainter')
            wepTargetPainter:ChangeMaxRadius(35)
            self.wcTorp01 = true
            self.wcTorp02 = false
            self.wcTorp03 = false
            
            
            
        elseif enh =='EXTorpedoLauncherRemove' then
            if Buff.HasBuff(self, 'EXAeonHealthBoost7') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost7')
            end
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[2].MaxRadius
            wepDisruptor:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            local wepTargetPainter = self:GetWeaponByLabel('EXTargetPainter')
            wepTargetPainter:ChangeMaxRadius(22)
            self.wcTorp01 = false
            self.wcTorp02 = false
            self.wcTorp03 = false
            
            
            
        elseif enh =='EXTorpedoRapidLoader' then
            if not Buffs['EXAeonHealthBoost8'] then
                BuffBlueprint {
                    Name = 'EXAeonHealthBoost8',
                    DisplayName = 'EXAeonHealthBoost8',
                    BuffType = 'EXAeonHealthBoost8',
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
            Buff.ApplyBuff(self, 'EXAeonHealthBoost8')
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            wepDisruptor:AddDamageMod(100)
            self.wcTorp01 = false
            self.wcTorp02 = true
            self.wcTorp03 = false
            
            
            
            self:ForkThread(self.DefaultGunBuffThread)
            self:ForkThread(self.DefaultGunBuffThread02)
        elseif enh =='EXTorpedoRapidLoaderRemove' then
            if Buff.HasBuff(self, 'EXAeonHealthBoost7') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost7')
            end
            if Buff.HasBuff(self, 'EXAeonHealthBoost8') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost8')
            end
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[2].MaxRadius
            wepDisruptor:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            wepDisruptor:AddDamageMod(-100)
            local wepTargetPainter = self:GetWeaponByLabel('EXTargetPainter')
            wepTargetPainter:ChangeMaxRadius(22)
            self.wcTorp01 = false
            self.wcTorp02 = false
            self.wcTorp03 = false
            
            
            
        elseif enh =='EXTorpedoClusterLauncher' then
            if not Buffs['EXAeonHealthBoost9'] then
                BuffBlueprint {
                    Name = 'EXAeonHealthBoost9',
                    DisplayName = 'EXAeonHealthBoost9',
                    BuffType = 'EXAeonHealthBoost9',
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
            Buff.ApplyBuff(self, 'EXAeonHealthBoost9')
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            wepDisruptor:AddDamageMod(200)
            self.wcTorp01 = false
            self.wcTorp02 = false
            self.wcTorp03 = true
            
            
            
        elseif enh =='EXTorpedoClusterLauncherRemove' then
            if Buff.HasBuff(self, 'EXAeonHealthBoost7') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost7')
            end
            if Buff.HasBuff(self, 'EXAeonHealthBoost8') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost8')
            end
            if Buff.HasBuff(self, 'EXAeonHealthBoost9') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost9')
            end
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[2].MaxRadius
            wepDisruptor:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            wepDisruptor:AddDamageMod(-300)
            local wepTargetPainter = self:GetWeaponByLabel('EXTargetPainter')
            wepTargetPainter:ChangeMaxRadius(22)
            self.wcTorp01 = false
            self.wcTorp02 = false
            self.wcTorp03 = false
            
            
            
        elseif enh =='EXArtilleryMiasma' then
            if not Buffs['EXAeonHealthBoost10'] then
                BuffBlueprint {
                    Name = 'EXAeonHealthBoost10',
                    DisplayName = 'EXAeonHealthBoost10',
                    BuffType = 'EXAeonHealthBoost10',
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
            Buff.ApplyBuff(self, 'EXAeonHealthBoost10')
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            wepDisruptor:ChangeMaxRadius(35)
            local wepTargetPainter = self:GetWeaponByLabel('EXTargetPainter')
            wepTargetPainter:ChangeMaxRadius(100)
            self.wcArtillery01 = true
            self.wcArtillery02 = false
            self.wcArtillery03 = false
            self.ccArtillery = true
            
            
            self:ForkThread(self.ArtyShieldCheck)
            
        elseif enh =='EXArtilleryMiasmaRemove' then
            if Buff.HasBuff(self, 'EXAeonHealthBoost10') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost10')
            end
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[2].MaxRadius
            wepDisruptor:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            local wepTargetPainter = self:GetWeaponByLabel('EXTargetPainter')
            wepTargetPainter:ChangeMaxRadius(22)
            self.wcArtillery01 = false
            self.wcArtillery02 = false
            self.wcArtillery03 = false
            self.ccArtillery = false
            
            
            self:ForkThread(self.ArtyShieldCheck)
            
        elseif enh =='EXAdvancedShells' then
            if not Buffs['EXAeonHealthBoost11'] then
                BuffBlueprint {
                    Name = 'EXAeonHealthBoost11',
                    DisplayName = 'EXAeonHealthBoost11',
                    BuffType = 'EXAeonHealthBoost11',
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
            Buff.ApplyBuff(self, 'EXAeonHealthBoost11')
            self.wcArtillery01 = false
            self.wcArtillery02 = true
            self.wcArtillery03 = false
            self.ccArtillery = true
            
            
            self:ForkThread(self.ArtyShieldCheck)
            
            self:ForkThread(self.DefaultGunBuffThread)
            self:ForkThread(self.DefaultGunBuffThread02)
        elseif enh =='EXAdvancedShellsRemove' then    
            self:RemoveToggleCap('RULEUTC_WeaponToggle')
            if Buff.HasBuff(self, 'EXAeonHealthBoost10') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost10')
            end
            if Buff.HasBuff(self, 'EXAeonHealthBoost11') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost11')
            end
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[2].MaxRadius
            wepDisruptor:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            local wepTargetPainter = self:GetWeaponByLabel('EXTargetPainter')
            wepTargetPainter:ChangeMaxRadius(22)
            self.wcArtillery01 = false
            self.wcArtillery02 = false
            self.wcArtillery03 = false
            self.ccArtillery = false
            
            
            self:ForkThread(self.ArtyShieldCheck)
            
        elseif enh =='EXImprovedReloader' then
            if not Buffs['EXAeonHealthBoost12'] then
                BuffBlueprint {
                    Name = 'EXAeonHealthBoost12',
                    DisplayName = 'EXAeonHealthBoost12',
                    BuffType = 'EXAeonHealthBoost12',
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
            Buff.ApplyBuff(self, 'EXAeonHealthBoost12')
            self.wcArtillery01 = false
            self.wcArtillery02 = false
            self.wcArtillery03 = true
            self.ccArtillery = true
            
            
            self:ForkThread(self.ArtyShieldCheck)
            
        elseif enh =='EXImprovedReloaderRemove' then    
            self:RemoveToggleCap('RULEUTC_WeaponToggle')
            if Buff.HasBuff(self, 'EXAeonHealthBoost10') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost10')
            end
            if Buff.HasBuff(self, 'EXAeonHealthBoost11') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost11')
            end
            if Buff.HasBuff(self, 'EXAeonHealthBoost12') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost12')
            end
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[2].MaxRadius
            wepDisruptor:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            local wepTargetPainter = self:GetWeaponByLabel('EXTargetPainter')
            wepTargetPainter:ChangeMaxRadius(22)
            self.wcArtillery01 = false
            self.wcArtillery02 = false
            self.wcArtillery03 = false
            self.ccArtillery = false
            
            
            self:ForkThread(self.ArtyShieldCheck)
            
        elseif enh =='EXBeamPhason' then
            if not Buffs['EXAeonHealthBoost13'] then
                BuffBlueprint {
                    Name = 'EXAeonHealthBoost13',
                    DisplayName = 'EXAeonHealthBoost13',
                    BuffType = 'EXAeonHealthBoost13',
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
            Buff.ApplyBuff(self, 'EXAeonHealthBoost13')
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            wepDisruptor:ChangeMaxRadius(35)
            local wepTargetPainter = self:GetWeaponByLabel('EXTargetPainter')
            wepTargetPainter:ChangeMaxRadius(35)
            self.wcBeam01 = true
            self.wcBeam02 = false
            self.wcBeam03 = false
            
            
            
        elseif enh =='EXBeamPhasonRemove' then
            if Buff.HasBuff(self, 'EXAeonHealthBoost13') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost13')
            end
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[2].MaxRadius
            wepDisruptor:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            local wepTargetPainter = self:GetWeaponByLabel('EXTargetPainter')
            wepTargetPainter:ChangeMaxRadius(22)
            self.wcBeam01 = false
            self.wcBeam02 = false
            self.wcBeam03 = false
            
            
            
        elseif enh =='EXImprovedCoolingSystem' then
            if not Buffs['EXAeonHealthBoost14'] then
                BuffBlueprint {
                    Name = 'EXAeonHealthBoost14',
                    DisplayName = 'EXAeonHealthBoost14',
                    BuffType = 'EXAeonHealthBoost14',
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
            Buff.ApplyBuff(self, 'EXAeonHealthBoost14')
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            wepDisruptor:ChangeMaxRadius(40)
            self.wcBeam01 = false
            self.wcBeam02 = true
            self.wcBeam03 = false
            
                
            
            self:ForkThread(self.DefaultGunBuffThread)
            self:ForkThread(self.DefaultGunBuffThread02)
        elseif enh =='EXImprovedCoolingSystemRemove' then
            if Buff.HasBuff(self, 'EXAeonHealthBoost13') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost13')
            end
            if Buff.HasBuff(self, 'EXAeonHealthBoost14') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost14')
            end
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[2].MaxRadius
            wepDisruptor:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            local wepTargetPainter = self:GetWeaponByLabel('EXTargetPainter')
            wepTargetPainter:ChangeMaxRadius(22)
            self.wcBeam01 = false
            self.wcBeam02 = false
            self.wcBeam03 = false
            
            
            
        elseif enh =='EXPowerBooster' then
            if not Buffs['EXAeonHealthBoost15'] then
                BuffBlueprint {
                    Name = 'EXAeonHealthBoost15',
                    DisplayName = 'EXAeonHealthBoost15',
                    BuffType = 'EXAeonHealthBoost15',
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
            Buff.ApplyBuff(self, 'EXAeonHealthBoost15')
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            wepDisruptor:ChangeMaxRadius(40)
            self.wcBeam01 = false
            self.wcBeam02 = false
            self.wcBeam03 = true
            
            
            
        elseif enh =='EXPowerBoosterRemove' then
            if Buff.HasBuff(self, 'EXAeonHealthBoost13') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost13')
            end
            if Buff.HasBuff(self, 'EXAeonHealthBoost14') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost14')
            end
            if Buff.HasBuff(self, 'EXAeonHealthBoost15') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost15')
            end
            local wepDisruptor = self:GetWeaponByLabel('RightDisruptor')
            local bpDisruptZephyrRadius = self:GetBlueprint().Weapon[2].MaxRadius
            wepDisruptor:ChangeMaxRadius(bpDisruptZephyrRadius or 22)
            local wepTargetPainter = self:GetWeaponByLabel('EXTargetPainter')
            wepTargetPainter:ChangeMaxRadius(22)
            self.wcBeam01 = false
            self.wcBeam02 = false
            self.wcBeam03 = false
            
            
            
        elseif enh == 'EXShieldBattery' then
            self:AddToggleCap('RULEUTC_ShieldToggle')
            self:CreateShield(bp)
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            self.ccShield = true
            self:ForkThread(self.ArtyShieldCheck)
            
        elseif enh == 'EXShieldBatteryRemove' then
            self:DestroyShield()
            RemoveUnitEnhancement(self, 'EXShieldBatteryRemove')
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
            self.ccShield = false
            self:ForkThread(self.ArtyShieldCheck)
            
        elseif enh == 'EXActiveShielding' then
            self:DestroyShield()
            ForkThread(function()
                WaitTicks(1)
                self:CreateShield(bp)
            end)
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            self.ccShield = true
            self:ForkThread(self.ArtyShieldCheck)
            
        elseif enh == 'EXActiveShieldingRemove' then
            self:DestroyShield()
            RemoveUnitEnhancement(self, 'EXActiveShieldingRemove')
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
            self.ccShield = false
            self:ForkThread(self.ArtyShieldCheck)
            
        elseif enh == 'EXImprovedShieldBattery' then
            self:DestroyShield()
            ForkThread(function()
                WaitTicks(1)
                self:CreateShield(bp)
            end)
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            self:SetWeaponEnabledByLabel('EXAntiMissile', true)
            self.ccShield = true
            self:ForkThread(self.ArtyShieldCheck)
            
        elseif enh == 'EXImprovedShieldBatteryRemove' then
            self:DestroyShield()
            RemoveUnitEnhancement(self, 'EXImprovedShieldBatteryRemove')
            self:SetMaintenanceConsumptionInactive()
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
            self:SetWeaponEnabledByLabel('EXAntiMissile', false)
            self.ccShield = false
            self:ForkThread(self.ArtyShieldCheck)
            
        elseif enh == 'EXElectronicsEnhancment' then
            self:SetIntelRadius('Vision', bp.NewVisionRadius or 50)
            self:SetIntelRadius('Omni', bp.NewOmniRadius or 50)
            if not Buffs['EXAeonHealthBoost16'] then
                BuffBlueprint {
                    Name = 'EXAeonHealthBoost16',
                    DisplayName = 'EXAeonHealthBoost16',
                    BuffType = 'EXAeonHealthBoost16',
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
            Buff.ApplyBuff(self, 'EXAeonHealthBoost16')
            self:SetWeaponEnabledByLabel('EXAntiMissile', true)
            self.RBIntTier1 = true
            self.RBIntTier2 = false
            self.RBIntTier3 = false
            
        elseif enh == 'EXElectronicsEnhancmentRemove' then
            local bpIntel = self:GetBlueprint().Intel
            self:SetIntelRadius('Vision', bpIntel.VisionRadius or 26)
            self:SetIntelRadius('Omni', bpIntel.OmniRadius or 26)
            if Buff.HasBuff(self, 'EXAeonHealthBoost16') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost16')
            end
            self:SetWeaponEnabledByLabel('EXAntiMissile', false)
            self.RBIntTier1 = false
            self.RBIntTier2 = false
            self.RBIntTier3 = false
            
        elseif enh == 'EXElectronicCountermeasures' then
            if not Buffs['EXAeonHealthBoost17'] then
                BuffBlueprint {
                    Name = 'EXAeonHealthBoost17',
                    DisplayName = 'EXAeonHealthBoost17',
                    BuffType = 'EXAeonHealthBoost17',
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
            Buff.ApplyBuff(self, 'EXAeonHealthBoost17')
            self.RBIntTier1 = true
            self.RBIntTier2 = true
            self.RBIntTier3 = false
            
            self:ForkThread(self.EnableRemoteViewingButtons)
        elseif enh == 'EXElectronicCountermeasuresRemove' then
            local bpIntel = self:GetBlueprint().Intel
            self:SetIntelRadius('Vision', bpIntel.VisionRadius or 26)
            self:SetIntelRadius('Omni', bpIntel.OmniRadius or 26)
            if Buff.HasBuff(self, 'EXAeonHealthBoost16') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost16')
            end
            if Buff.HasBuff(self, 'EXAeonHealthBoost17') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost17')
            end
            self:SetWeaponEnabledByLabel('EXAntiMissile', false)
            self.RBIntTier1 = false
            self.RBIntTier2 = false
            self.RBIntTier3 = false
            
            self:ForkThread(self.DisableRemoteViewingButtons)
        elseif enh == 'EXCloakingSubsystems' then
            self:AddCommandCap('RULEUCC_Teleport')
            if not Buffs['EXAeonHealthBoost18'] then
                BuffBlueprint {
                    Name = 'EXAeonHealthBoost18',
                    DisplayName = 'EXAeonHealthBoost18',
                    BuffType = 'EXAeonHealthBoost18',
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
            Buff.ApplyBuff(self, 'EXAeonHealthBoost18')
            self.RBIntTier1 = true
            self.RBIntTier2 = true
            self.RBIntTier3 = true
            
        elseif enh == 'EXCloakingSubsystemsRemove' then
            self:RemoveCommandCap('RULEUCC_Teleport')
            local bpIntel = self:GetBlueprint().Intel
            self:SetIntelRadius('Vision', bpIntel.VisionRadius or 26)
            self:SetIntelRadius('Omni', bpIntel.OmniRadius or 26)
            if Buff.HasBuff(self, 'EXAeonHealthBoost16') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost16')
            end
            if Buff.HasBuff(self, 'EXAeonHealthBoost17') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost17')
            end
            if Buff.HasBuff(self, 'EXAeonHealthBoost18') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost18')
            end
            self.RBIntTier1 = false
            self.RBIntTier2 = false
            self.RBIntTier3 = false
            self:SetWeaponEnabledByLabel('EXAntiMissile', false)
            
            self:ForkThread(self.DisableRemoteViewingButtons)
        elseif enh =='EXMaelstromQuantum' then
                if self.MaelstromEffects01 then
                    for k, v in self.MaelstromEffects01 do
                        v:Destroy()
                    end
                    self.MaelstromEffects01 = {}
                end
                table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'Torso', self:GetArmy(), '/mods/BlackOpsACUs/effects/emitters/exmaelstrom_aura_01_emit.bp'):ScaleEmitter(1):OffsetEmitter(0, -2, 0))
                table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'Torso', self:GetArmy(), '/mods/BlackOpsACUs/effects/emitters/exmaelstrom_aura_02_emit.bp'):ScaleEmitter(1):OffsetEmitter(0, -2.75, 0))
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
            if not Buffs['EXAeonHealthBoost19'] then
                BuffBlueprint {
                    Name = 'EXAeonHealthBoost19',
                    DisplayName = 'EXAeonHealthBoost19',
                    BuffType = 'EXAeonHealthBoost19',
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
            Buff.ApplyBuff(self, 'EXAeonHealthBoost19')
            self.wcMaelstrom01 = true
            self.wcMaelstrom02 = false
            self.wcMaelstrom03 = false
            
            
            self.RBComTier1 = true
            self.RBComTier2 = false
            self.RBComTier3 = false
            
        elseif enh =='EXMaelstromQuantumRemove' then
            if Buff.HasBuff(self, 'EXAeonHealthBoost19') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost19')
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
            
        elseif enh =='EXFieldExpander' then
            if not Buffs['EXAeonHealthBoost20'] then
                BuffBlueprint {
                    Name = 'EXAeonHealthBoost20',
                    DisplayName = 'EXAeonHealthBoost20',
                    BuffType = 'EXAeonHealthBoost20',
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
            Buff.ApplyBuff(self, 'EXAeonHealthBoost20')
            self:SetWeaponEnabledByLabel('EXAntiMissile', true)
            self.wcMaelstrom01 = false
            self.wcMaelstrom02 = true
            self.wcMaelstrom03 = false
            self:SetWeaponEnabledByLabel('EXAntiMissile', true)
            
                
            self.RBComTier1 = true
            self.RBComTier2 = true
            self.RBComTier3 = false
            
        elseif enh =='EXQuantumInstability' then
            if not Buffs['EXAeonHealthBoost21'] then
                BuffBlueprint {
                    Name = 'EXAeonHealthBoost21',
                    DisplayName = 'EXAeonHealthBoost21',
                    BuffType = 'EXAeonHealthBoost21',
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
            Buff.ApplyBuff(self, 'EXAeonHealthBoost21')
            self:SetWeaponEnabledByLabel('EXAntiMissile', false)
            self.wcMaelstrom01 = false
            self.wcMaelstrom02 = false
            self.wcMaelstrom03 = true
            
                  
            self.RBComTier1 = true
            self.RBComTier2 = true
            self.RBComTier3 = true
            
        elseif enh == 'EXFieldExpanderRemove' then
            if Buff.HasBuff(self, 'EXAeonHealthBoost19') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost19')
            end
            if Buff.HasBuff(self, 'EXAeonHealthBoost20') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost20')
            end
            if Buff.HasBuff(self, 'EXAeonHealthBoost21') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost21')
            end
            self:SetWeaponEnabledByLabel('EXAntiMissile', false)
            self.wcMaelstrom01 = false
            self.wcMaelstrom02 = false
            self.wcMaelstrom03 = false
            self:SetWeaponEnabledByLabel('EXAntiMissile', false)
            
            
                if self.MaelstromEffects01 then
                    for k, v in self.MaelstromEffects01 do
                        v:Destroy()
                    end
                    self.MaelstromEffects01 = {}
                end
            self.RBComTier1 = false
            self.RBComTier2 = false
            self.RBComTier3 = false
            
        elseif enh == 'EXQuantumInstabilityRemove' then
            if Buff.HasBuff(self, 'EXAeonHealthBoost19') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost19')
            end
            if Buff.HasBuff(self, 'EXAeonHealthBoost20') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost20')
            end
            if Buff.HasBuff(self, 'EXAeonHealthBoost21') then
                Buff.RemoveBuff(self, 'EXAeonHealthBoost21')
            end
            self:SetWeaponEnabledByLabel('EXAntiMissile', false)
            self.wcMaelstrom01 = false
            self.wcMaelstrom02 = false
            self.wcMaelstrom03 = false
            self:SetWeaponEnabledByLabel('EXAntiMissile', false)
            
            
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
            self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Enhancements['EXCloakingSubsystems'].MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            if not self.IntelEffectsBag then
                self.IntelEffectsBag = {}
                self.CreateTerrainTypeEffects(self, self.IntelEffects.Cloak, 'FXIdle',  self:GetCurrentLayer(), nil, self.IntelEffectsBag)
            end            
        elseif self.StealthEnh and self:IsIntelEnabled('RadarStealth') and self:IsIntelEnabled('SonarStealth') then
            self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Enhancements['EXElectronicCountermeasures'].MaintenanceConsumptionPerSecondEnergy or 0)
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