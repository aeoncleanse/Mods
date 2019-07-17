-----------------------------------------------------------------
-- File     :  /cdimage/lua/BlackOpsweapons.lua
-- Author(s):  Lt_hawkeye
-- Summary  :
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local EffectTemplate = import('/lua/EffectTemplates.lua')
local CollisionBeamFile = import('/mods/BlackOpsFAF-ACUs/lua/ACUsDefaultCollisionBeams.lua')
local CCannonMolecularWeapon = import('/lua/cybranweapons.lua').CCannonMolecularWeapon
local Weapon = import('/lua/sim/Weapon.lua').Weapon

local WeaponFile = import('/lua/sim/defaultweapons.lua')
local DefaultProjectileWeapon = WeaponFile.DefaultProjectileWeapon
local DefaultBeamWeapon = WeaponFile.DefaultBeamWeapon

local SWeapons = import('/lua/seraphimweapons.lua')
local SIFLaanseTacticalMissileLauncher = SWeapons.SIFLaanseTacticalMissileLauncher
local SDFSinnuntheWeapon = SWeapons.SDFSinnuntheWeapon

-- Aeon
QuantumMaelstromWeapon = Class(Weapon) {
    OnCreate = function(self)
        local bp = self:GetBlueprint()
        self.CurrentDamage = bp.Damage
        self.CurrentDamageRadius = bp.DamageRadius

        Weapon.OnCreate(self)
    end,

    OnFire = function(self)
        local blueprint = self:GetBlueprint()
        DamageArea(self.unit, self.unit:GetPosition(), self.CurrentDamageRadius,
            self.CurrentDamage, blueprint.DamageType, blueprint.DamageFriendly)
    end,
}

PhasonLaser = Class(DefaultBeamWeapon) {
    BeamType = CollisionBeamFile.PhasonLaser,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = EffectTemplate.CMicrowaveLaserCharge01,
    FxUpackingChargeEffectScale = 0.33,

    PlayFxWeaponUnpackSequence = function(self)
        if not self.ContBeamOn then
            local army = self.unit:GetArmy()
            local bp = self:GetBlueprint()
            for _, v in self.FxUpackingChargeEffects do
                for ek, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                    CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale)
                end
            end

            DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
        end
    end,
}


-- UEF
AntiMatterWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = import('/mods/BlackOpsFAF-ACUs/lua/ACUsEffectTemplates.lua').AntiMatterMuzzle,
}

NapalmWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = EffectTemplate.TGaussCannonFlash,
}

HeavyPlasmaGatlingWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = import('/mods/BlackOpsFAF-ACUs/lua/ACUsEffectTemplates.lua').HeavyPlasmaGatlingMuzzleFlash,
    FxMuzzleFlashScale = 0.35,

    OnCreate = function(self)
        DefaultProjectileWeapon.OnCreate(self)

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

        DefaultProjectileWeapon.PlayFxRackSalvoChargeSequence(self)
    end,

    PlayFxRackSalvoReloadSequence = function(self)
        if self.unit.SpinManip then
            self.unit.SpinManip:SetTargetSpeed(0)
        end
        self.ExhaustEffects = EffectUtil.CreateBoneEffects(self.unit, 'Exhaust', self.unit:GetArmy(), EffectTemplate.WeaponSteam01)

        DefaultProjectileWeapon.PlayFxRackSalvoChargeSequence(self)
    end,

    IdleState = State(DefaultProjectileWeapon.IdleState) {
        Main = function(self)
            if self.unit.SpinManip then
                self.unit.SpinManip:SetTargetSpeed(0)
            end
        end,
    },
}

PDLaserGrid = Class(DefaultBeamWeapon) {
    BeamType = CollisionBeamFile.PDLaser,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = {},
    FxUpackingChargeEffectScale = 1,
    PlayOnlyOneSoundCue = true,

    PlayFxWeaponUnpackSequence = function(self)
        if not self.ContBeamOn then
            local army = self.unit:GetArmy()
            local bp = self:GetBlueprint()
            for _, v in self.FxUpackingChargeEffects do
                for ek, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                    CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale)
                end
            end

            DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
        end
    end,
}

-- Cybran
EMPWeapon = Class(CCannonMolecularWeapon) {
    OnWeaponFired = function(self)
        CCannonMolecularWeapon.OnWeaponFired(self)

        self.targetaquired = self:GetCurrentTargetPos()
        if self.targetaquired then
            if self.unit.EMPArrayEffects then
                for _, v in self.unit.EMPArrayEffects do
                    v:Destroy()
                end
                self.unit.EMPArrayEffects = {}
            end

            local army = self.unit:GetArmy()
            table.insert(self.unit.EMPArrayEffects, AttachBeamEntityToEntity(self.unit, 'EMP_Array_Beam_01', self.unit, 'EMP_Array_Muzzle_01', army, '/mods/BlackOpsFAF-ACUs/effects/emitters/cemparraybeam02_emit.bp'))
            table.insert(self.unit.EMPArrayEffects, AttachBeamEntityToEntity(self.unit, 'EMP_Array_Beam_02', self.unit, 'EMP_Array_Muzzle_02', army, '/mods/BlackOpsFAF-ACUs/effects/emitters/cemparraybeam02_emit.bp'))
            table.insert(self.unit.EMPArrayEffects, AttachBeamEntityToEntity(self.unit, 'EMP_Array_Beam_03', self.unit, 'EMP_Array_Muzzle_03', army, '/mods/BlackOpsFAF-ACUs/effects/emitters/cemparraybeam02_emit.bp'))
            table.insert(self.unit.EMPArrayEffects, CreateAttachedEmitter(self.unit, 'EMP_Array_Beam_01', army, '/effects/emitters/microwave_laser_flash_01_emit.bp'):ScaleEmitter(0.05))
            table.insert(self.unit.EMPArrayEffects, CreateAttachedEmitter(self.unit, 'EMP_Array_Beam_01', army, '/effects/emitters/microwave_laser_muzzle_01_emit.bp'):ScaleEmitter(0.05))
            table.insert(self.unit.EMPArrayEffects, CreateAttachedEmitter(self.unit, 'EMP_Array_Beam_02', army, '/effects/emitters/microwave_laser_flash_01_emit.bp'):ScaleEmitter(0.05))
            table.insert(self.unit.EMPArrayEffects, CreateAttachedEmitter(self.unit, 'EMP_Array_Beam_02', army, '/effects/emitters/microwave_laser_muzzle_01_emit.bp'):ScaleEmitter(0.05))
            table.insert(self.unit.EMPArrayEffects, CreateAttachedEmitter(self.unit, 'EMP_Array_Beam_03', army, '/effects/emitters/microwave_laser_flash_01_emit.bp'):ScaleEmitter(0.05))
            table.insert(self.unit.EMPArrayEffects, CreateAttachedEmitter(self.unit, 'EMP_Array_Beam_03', army, '/effects/emitters/microwave_laser_muzzle_01_emit.bp'):ScaleEmitter(0.05))
            self:ForkThread(self.ArrayEffectsCleanup)
        end
    end,

    ArrayEffectsCleanup = function(self)
        WaitTicks(20)
        if self.unit.EMPArrayEffects then
            for _, v in self.unit.EMPArrayEffects do
                v:Destroy()
            end
            self.unit.EMPArrayEffects = {}
        end
    end,
}

CEMPArrayBeam = Class(DefaultBeamWeapon) {
    BeamType = CollisionBeamFile.CEMPArrayBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
}

CEMPArrayBeam02 = Class(DefaultBeamWeapon) {
    BeamType = CollisionBeamFile.CEMPArrayBeam02,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
}

-- Seraphim
QuantumStormWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = EffectTemplate.SDFSinnutheWeaponMuzzleFlash,
    FxChargeMuzzleFlash = EffectTemplate.SDFSinnutheWeaponChargeMuzzleFlash,
    FxChargeMuzzleFlashScale = 0.33,
    FxMuzzleFlashScale = 0.33,

    PlayFxMuzzleChargeSequence = function(self, muzzle)
        -- CreateRotator(unit, bone, axis, [goal], [speed], [accel], [goalspeed])
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
}

RapidCannonWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = EffectTemplate.SDFAireauWeaponMuzzleFlash,
    FxMuzzleFlashScale = 0.33,
}

LaanseMissile = Class(SIFLaanseTacticalMissileLauncher) {
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
}
