
local SHoverLandUnit = import('/lua/seraphimunits.lua').SHoverLandUnit
local BaseTransport = import('/lua/defaultunits.lua').BaseTransport
local AirDroneCarrier = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsunits.lua').AirDroneCarrier
local WeaponsFile = import ('/lua/seraphimweapons.lua')
local WeaponsFile2 = import ('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsWeapons.lua')
local YenzothaExperimentalLaser = WeaponsFile2.YenzothaExperimentalLaser
local SAAOlarisCannonWeapon = WeaponsFile.SAAOlarisCannonWeapon
local EffectUtil = import('/lua/EffectUtilities.lua')
local explosion = import('/lua/defaultexplosions.lua')

BSL0401 = Class(BaseTransport, SHoverLandUnit, AirDroneCarrier) {
    SpawnEffects = {
        '/effects/emitters/seraphim_othuy_spawn_01_emit.bp',
        '/effects/emitters/seraphim_othuy_spawn_02_emit.bp',
        '/effects/emitters/seraphim_othuy_spawn_03_emit.bp',
        '/effects/emitters/seraphim_othuy_spawn_04_emit.bp',
    },

    ChargeEffects01 = {
        '/effects/emitters/seraphim_expirimental_laser_muzzle_01_emit.bp',
        '/effects/emitters/seraphim_expirimental_laser_muzzle_02_emit.bp',
        '/effects/emitters/seraphim_expirimental_laser_muzzle_03_emit.bp',
        '/effects/emitters/seraphim_expirimental_laser_muzzle_04_emit.bp',
    },

    Weapons = {
        EyeWeapon01 = Class(YenzothaExperimentalLaser) {
            OnWeaponFired = function(self)
                YenzothaExperimentalLaser.OnWeaponFired(self)
                if self.unit.ChargeEffects01Bag then
                    for k, v in self.unit.ChargeEffects01Bag do
                        v:Destroy()
                    end
                    self.unit.ChargeEffects01Bag = {}
                end
                if self.unit.BeamChargeEffects1 then
                    for k, v in self.unit.BeamChargeEffects1 do
                        v:Destroy()
                    end
                    self.unit.BeamChargeEffects1 = {}
                end
                table.insert(self.unit.BeamChargeEffects1, AttachBeamEntityToEntity(self.unit, 'Focus_Beam01_Emitter01', self.unit, 'Focus_Beam01_Emitter02', self.unit:GetArmy(), '/mods/BlackOpsFAF-Unleashed/effects/emitters/seraphim_expirimental_laser_charge_beam_emit.bp'))
                for k, v in self.unit.ChargeEffects01 do
                    table.insert(self.unit.ChargeEffects01Bag, CreateAttachedEmitter(self.unit, 'Focus_Beam01_Emitter01', self.unit:GetArmy(), v):ScaleEmitter(0.5))
                end
                table.insert(self.unit.BeamChargeEffects1, AttachBeamEntityToEntity(self.unit, 'Focus_Beam01_Emitter02', self.unit, 'Focus_Beam01_Emitter03', self.unit:GetArmy(), '/mods/BlackOpsFAF-Unleashed/effects/emitters/seraphim_expirimental_laser_charge_beam_emit.bp'))
                for k, v in self.unit.ChargeEffects01 do
                    table.insert(self.unit.ChargeEffects01Bag, CreateAttachedEmitter(self.unit, 'Focus_Beam01_Emitter02', self.unit:GetArmy(), v):ScaleEmitter(0.5))
                end
                table.insert(self.unit.BeamChargeEffects1, AttachBeamEntityToEntity(self.unit, 'Focus_Beam01_Emitter03', self.unit, 'Beam_Point_Focus01', self.unit:GetArmy(), '/mods/BlackOpsFAF-Unleashed/effects/emitters/seraphim_expirimental_laser_charge_beam_emit.bp'))
                for k, v in self.unit.ChargeEffects01 do
                    table.insert(self.unit.ChargeEffects01Bag, CreateAttachedEmitter(self.unit, 'Focus_Beam01_Emitter03', self.unit:GetArmy(), v):ScaleEmitter(0.5))
                    table.insert(self.unit.ChargeEffects01Bag, CreateAttachedEmitter(self.unit, 'Beam_Point_Focus01', self.unit:GetArmy(), v):ScaleEmitter(0.5))
                end
            end,

            PlayFxWeaponPackSequence = function(self)
                if self.unit.BeamChargeEffects1 then
                    for k, v in self.unit.BeamChargeEffects1 do
                        v:Destroy()
                    end
                    self.unit.BeamChargeEffects1 = {}
                end
                if self.unit.ChargeEffects01Bag then
                    for k, v in self.unit.ChargeEffects01Bag do
                        v:Destroy()
                    end
                    self.unit.ChargeEffects01Bag = {}
                end
                YenzothaExperimentalLaser.PlayFxWeaponPackSequence(self)
            end,
        },

        EyeWeapon02 = Class(YenzothaExperimentalLaser) {
            OnWeaponFired = function(self)
                YenzothaExperimentalLaser.OnWeaponFired(self)
                if self.unit.ChargeEffects02Bag then
                    for k, v in self.unit.ChargeEffects02Bag do
                        v:Destroy()
                    end
                    self.unit.ChargeEffects02Bag = {}
                end
                if self.unit.BeamChargeEffects2 then
                    for k, v in self.unit.BeamChargeEffects2 do
                        v:Destroy()
                    end
                    self.unit.BeamChargeEffects2 = {}
                end
                table.insert(self.unit.BeamChargeEffects2, AttachBeamEntityToEntity(self.unit, 'Focus_Beam02_Emitter01', self.unit, 'Focus_Beam02_Emitter02', self.unit:GetArmy(), '/mods/BlackOpsFAF-Unleashed/effects/emitters/seraphim_expirimental_laser_charge_beam_emit.bp'))
                for k, v in self.unit.ChargeEffects01 do
                    table.insert(self.unit.ChargeEffects02Bag, CreateAttachedEmitter(self.unit, 'Focus_Beam02_Emitter01', self.unit:GetArmy(), v):ScaleEmitter(0.5))
                end
                table.insert(self.unit.BeamChargeEffects2, AttachBeamEntityToEntity(self.unit, 'Focus_Beam02_Emitter02', self.unit, 'Focus_Beam02_Emitter03', self.unit:GetArmy(), '/mods/BlackOpsFAF-Unleashed/effects/emitters/seraphim_expirimental_laser_charge_beam_emit.bp'))
                for k, v in self.unit.ChargeEffects01 do
                    table.insert(self.unit.ChargeEffects02Bag, CreateAttachedEmitter(self.unit, 'Focus_Beam02_Emitter02', self.unit:GetArmy(), v):ScaleEmitter(0.5))
                end
                table.insert(self.unit.BeamChargeEffects2, AttachBeamEntityToEntity(self.unit, 'Focus_Beam02_Emitter03', self.unit, 'Beam_Point_Focus02', self.unit:GetArmy(), '/mods/BlackOpsFAF-Unleashed/effects/emitters/seraphim_expirimental_laser_charge_beam_emit.bp'))
                for k, v in self.unit.ChargeEffects01 do
                    table.insert(self.unit.ChargeEffects02Bag, CreateAttachedEmitter(self.unit, 'Focus_Beam02_Emitter03', self.unit:GetArmy(), v):ScaleEmitter(0.5))
                    table.insert(self.unit.ChargeEffects02Bag, CreateAttachedEmitter(self.unit, 'Beam_Point_Focus02', self.unit:GetArmy(), v):ScaleEmitter(0.5))
                end
            end,

            PlayFxWeaponPackSequence = function(self)
                if self.unit.BeamChargeEffects2 then
                    for k, v in self.unit.BeamChargeEffects2 do
                        v:Destroy()
                    end
                    self.unit.BeamChargeEffects2 = {}
                end
                if self.unit.ChargeEffects02Bag then
                    for k, v in self.unit.ChargeEffects02Bag do
                        v:Destroy()
                    end
                    self.unit.ChargeEffects02Bag = {}
                end
                YenzothaExperimentalLaser.PlayFxWeaponPackSequence(self)
            end,
        },

        EyeWeapon03 = Class(YenzothaExperimentalLaser) {
            OnWeaponFired = function(self)
                YenzothaExperimentalLaser.OnWeaponFired(self)
                if self.unit.ChargeEffects03Bag then
                    for k, v in self.unit.ChargeEffects03Bag do
                        v:Destroy()
                    end
                    self.unit.ChargeEffects03Bag = {}
                end
                if self.unit.BeamChargeEffects3 then
                    for k, v in self.unit.BeamChargeEffects3 do
                        v:Destroy()
                    end
                    self.unit.BeamChargeEffects3 = {}
                end
                table.insert(self.unit.BeamChargeEffects3, AttachBeamEntityToEntity(self.unit, 'Focus_Beam03_Emitter01', self.unit, 'Focus_Beam03_Emitter02', self.unit:GetArmy(), '/mods/BlackOpsFAF-Unleashed/effects/emitters/seraphim_expirimental_laser_charge_beam_emit.bp'))
                for k, v in self.unit.ChargeEffects01 do
                    table.insert(self.unit.ChargeEffects03Bag, CreateAttachedEmitter(self.unit, 'Focus_Beam03_Emitter01', self.unit:GetArmy(), v):ScaleEmitter(0.5))
                end
                table.insert(self.unit.BeamChargeEffects3, AttachBeamEntityToEntity(self.unit, 'Focus_Beam03_Emitter02', self.unit, 'Focus_Beam03_Emitter03', self.unit:GetArmy(), '/mods/BlackOpsFAF-Unleashed/effects/emitters/seraphim_expirimental_laser_charge_beam_emit.bp'))
                for k, v in self.unit.ChargeEffects01 do
                    table.insert(self.unit.ChargeEffects03Bag, CreateAttachedEmitter(self.unit, 'Focus_Beam03_Emitter02', self.unit:GetArmy(), v):ScaleEmitter(0.5))
                end
                table.insert(self.unit.BeamChargeEffects3, AttachBeamEntityToEntity(self.unit, 'Focus_Beam03_Emitter03', self.unit, 'Beam_Point_Focus03', self.unit:GetArmy(), '/mods/BlackOpsFAF-Unleashed/effects/emitters/seraphim_expirimental_laser_charge_beam_emit.bp'))
                for k, v in self.unit.ChargeEffects01 do
                    table.insert(self.unit.ChargeEffects03Bag, CreateAttachedEmitter(self.unit, 'Focus_Beam03_Emitter03', self.unit:GetArmy(), v):ScaleEmitter(0.5))
                    table.insert(self.unit.ChargeEffects03Bag, CreateAttachedEmitter(self.unit, 'Beam_Point_Focus03', self.unit:GetArmy(), v):ScaleEmitter(0.5))
                end
            end,

            PlayFxWeaponPackSequence = function(self)
                if self.unit.BeamChargeEffects3 then
                    for k, v in self.unit.BeamChargeEffects3 do
                        v:Destroy()
                    end
                    self.unit.BeamChargeEffects3 = {}
                end
                if self.unit.ChargeEffects03Bag then
                    for k, v in self.unit.ChargeEffects03Bag do
                        v:Destroy()
                    end
                    self.unit.ChargeEffects03Bag = {}
                end
                YenzothaExperimentalLaser.PlayFxWeaponPackSequence(self)
            end,
        },
        LeftAA = Class(SAAOlarisCannonWeapon) {},
        RightAA = Class(SAAOlarisCannonWeapon) {},
    },

    StartBeingBuiltEffects = function(self, builder, layer)
        SHoverLandUnit.StartBeingBuiltEffects(self, builder, layer)
        self:ForkThread(EffectUtil.CreateSeraphimExperimentalBuildBaseThread, builder, self.OnBeingBuiltEffectsBag)
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        SHoverLandUnit.OnStopBeingBuilt(self,builder,layer)
        self.BeamChargeEffects1 = {}
        self.ChargeEffects01Bag = {}
        self.BeamChargeEffects2 = {}
        self.ChargeEffects02Bag = {}
        self.BeamChargeEffects3 = {}
        self.ChargeEffects03Bag = {}
        AirDroneCarrier.InitDrones(self)
    end,

    -- Places the Goliath's first drone-targetable attacker into a global
    OnDamage = function(self, instigator, amount, vector, damagetype)
        SHoverLandUnit.OnDamage(self, instigator, amount, vector, damagetype)
        AirDroneCarrier.SetAttacker(self, instigator)
    end,

    -- Drone control buttons
    OnScriptBitSet = function(self, bit)
        -- Drone assist toggle, on
        if bit == 1 then
            self.DroneAssist = false
        -- Drone recall button
        elseif bit == 7 then
            self:RecallDrones()
            -- Pop button back up, as it's not actually a toggle
            self:SetScriptBit('RULEUTC_SpecialToggle', false)
        else
            SHoverLandUnit.OnScriptBitSet(self, bit)
        end
    end,
    OnScriptBitClear = function(self, bit)
        -- Drone assist toggle, off
        if bit == 1 then
            self.DroneAssist = true
        -- Recall button reset, do nothing
        elseif bit == 7 then
            return
        else
            SHoverLandUnit.OnScriptBitClear(self, bit)
        end
    end,

    -- Handles drone docking
    OnTransportAttach = function(self, attachBone, unit)
        self.DroneData[unit.Name].Docked = attachBone
        unit:SetDoNotTarget(true)
        BaseTransport.OnTransportAttach(self, attachBone, unit)
    end,

    -- Handles drone undocking, also called when docked drones die
    OnTransportDetach = function(self, attachBone, unit)
        self.DroneData[unit.Name].Docked = false
        unit:SetDoNotTarget(false)
        if unit.Name == self.BuildingDrone then
            self:CleanupDroneMaintenance(self.BuildingDrone)
        end
        BaseTransport.OnTransportDetach(self, attachBone, unit)
    end,

    -- Cleans up threads and drones on death
    OnKilled = function(self, instigator, damageType, overkillRatio)
        -- Kill our heartbeat thread
        KillThread(self.HeartBeatThread)
        -- Clean up any in-progress construction
        ChangeState(self, self.DeadState)
        -- Immediately kill existing drones
        self:KillAllDrones()
        SHoverLandUnit.OnKilled(self, instigator, damageType, overkillRatio)
    end,

    -- Set on unit death, ends production and consumption immediately
    DeadState = State {
        Main = function(self)
            if self.gettingBuilt == false then
                self:CleanupDroneMaintenance(nil, true)
            end
        end,
    },






    DeathThread = function(self, overkillRatio , instigator)
        local bigExplosionBones = {'BSL0401', 'Beam_Muzzle01'}
        local explosionBones = {'Focus_Beam02_Emitter03', 'Left_AA_Barrel',
                                'Focus_Beam01_Emitter01', 'Right_AA_Turret', 'Beam_Point_Focus03'}

        explosion.CreateDefaultHitExplosionAtBone(self, bigExplosionBones[Random(1,3)], 4.0)
        explosion.CreateDebrisProjectiles(self, explosion.GetAverageBoundingXYZRadius(self), {self:GetUnitSizes()})
        WaitSeconds(0.2)

        local RandBoneIter = RandomIter(explosionBones)
        for i = 1, Random(4,6) do
            local bone = RandBoneIter()
            explosion.CreateDefaultHitExplosionAtBone(self, bone, 1.0)
            WaitTicks(Random(0.1,1))
        end

        local bp = self:GetBlueprint()
        for i, numWeapons in bp.Weapon do
            if(bp.Weapon[i].Label == 'CollossusDeath') then
                DamageArea(self, self:GetPosition(), bp.Weapon[i].DamageRadius, bp.Weapon[i].Damage, bp.Weapon[i].DamageType, bp.Weapon[i].DamageFriendly)
                break
            end
        end
        WaitSeconds(0.5)
        explosion.CreateDefaultHitExplosionAtBone(self, 'BSL0401', 5.0)

        if self.DeathAnimManip then
            WaitFor(self.DeathAnimManip)
        end


        self:DestroyAllDamageEffects()
        self:CreateWreckage(overkillRatio)

        -- CURRENTLY DISABLED UNTIL DESTRUCTION
        -- Create destruction debris out of the mesh, currently these projectiles look like crap,
        -- since projectile rotation and terrain collision doesn't work that great. These are left in
        -- hopes that this will look better in the future.. =)
        if(self.ShowUnitDestructionDebris and overkillRatio) then
            if overkillRatio <= 1 then
                self.CreateUnitDestructionDebris(self, true, true, false)
            elseif overkillRatio <= 2 then
                self.CreateUnitDestructionDebris(self, true, true, false)
            elseif overkillRatio <= 3 then
                self.CreateUnitDestructionDebris(self, true, true, true)
            else
                self.CreateUnitDestructionDebris(self, true, true, true)
            end
        end

        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,

    OnDestroy = function(self)
        SHoverLandUnit.OnDestroy(self)

        -- Don't make the energy being if not built
        if self:GetFractionComplete() ~= 1 then return end

        -- Spawn the Energy Being
        local position = self:GetPosition()
        local spiritUnit = CreateUnitHPR('XSL0402', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)

        -- Create effects for spawning of energy being
        for k, v in self.SpawnEffects do
            CreateAttachedEmitter(spiritUnit, -1, self:GetArmy(), v)
        end
    end,
}

TypeClass = BSL0401
