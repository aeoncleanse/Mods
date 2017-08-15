-----------------------------------------------------------------
-- File     :  /cdimage/lua/BlackOpsweapons.lua
-- Author(s):  Lt_hawkeye
-- Summary  :
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local WeaponFile = import('/lua/sim/defaultweapons.lua')
local DefaultProjectileWeapon = WeaponFile.DefaultProjectileWeapon
local DefaultBeamWeapon = WeaponFile.DefaultBeamWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local CollisionBeamFile = import('/mods/BlackOpsFAF-ACUs/lua/ACUsDefaultCollisionBeams.lua')
local CCannonMolecularWeapon = import('/lua/cybranweapons.lua').CCannonMolecularWeapon
local Weapon = import('/lua/sim/Weapon.lua').Weapon
local SWeapons = import('/lua/seraphimweapons.lua')
local SIFLaanseTacticalMissileLauncher = SWeapons.SIFLaanseTacticalMissileLauncher
local SDFSinnuntheWeapon = SWeapons.SDFSinnuntheWeapon

SeraACUMissile = Class(SIFLaanseTacticalMissileLauncher) {
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

QuantumMaelstromWeapon = Class(Weapon) {
    OnFire = function(self)
        local blueprint = self:GetBlueprint()
        DamageArea(self.unit, self.unit:GetPosition(), self.CurrentDamageRadius,
            self.CurrentDamage, blueprint.DamageType, blueprint.DamageFriendly)
    end,
}

HawkGaussCannonWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = EffectTemplate.TGaussCannonFlash,
}

UEFACUAntiMatterWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = import('/mods/BlackOpsFAF-ACUs/lua/ACUsEffectTemplates.lua').ACUAntiMatterMuzzle,
}

PDLaserGrid = Class(DefaultBeamWeapon) {
    BeamType = CollisionBeamFile.PDLaserCollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = {},
    FxUpackingChargeEffectScale = 1,

    PlayFxWeaponUnpackSequence = function(self)
        local army = self.unit:GetArmy()
        local bp = self:GetBlueprint()
        for _, v in self.FxUpackingChargeEffects do
            for ek, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale):ScaleEmitter(0.05)
            end
        end
        DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
    end,
}

CEMPArrayBeam01 = Class(DefaultBeamWeapon) {
    BeamType = CollisionBeamFile.CEMPArrayBeam01CollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
}

CEMPArrayBeam02 = Class(DefaultBeamWeapon) {
    BeamType = CollisionBeamFile.CEMPArrayBeam02CollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
}

EMPWeapon = Class(CCannonMolecularWeapon) {
    OnWeaponFired = function(self)
        CCannonMolecularWeapon.OnWeaponFired(self)
        self.targetaquired = self:GetCurrentTargetPos()
        if self.targetaquired then
            if self.unit.EMPArrayEffects01 then
                for _, v in self.unit.EMPArrayEffects01 do
                    v:Destroy()
                end
                self.unit.EMPArrayEffects01 = {}
            end
            table.insert(self.unit.EMPArrayEffects01, AttachBeamEntityToEntity(self.unit, 'EMP_Array_Beam_01', self.unit, 'EMP_Array_Muzzle_01', self.unit:GetArmy(), '/mods/BlackOpsFAF-ACUs/effects/emitters/cemparraybeam02_emit.bp'))
            table.insert(self.unit.EMPArrayEffects01, AttachBeamEntityToEntity(self.unit, 'EMP_Array_Beam_02', self.unit, 'EMP_Array_Muzzle_02', self.unit:GetArmy(), '/mods/BlackOpsFAF-ACUs/effects/emitters/cemparraybeam02_emit.bp'))
            table.insert(self.unit.EMPArrayEffects01, AttachBeamEntityToEntity(self.unit, 'EMP_Array_Beam_03', self.unit, 'EMP_Array_Muzzle_03', self.unit:GetArmy(), '/mods/BlackOpsFAF-ACUs/effects/emitters/cemparraybeam02_emit.bp'))
            table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Beam_01', self.unit:GetArmy(), '/effects/emitters/microwave_laser_flash_01_emit.bp'):ScaleEmitter(0.05))
            table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Beam_01', self.unit:GetArmy(), '/effects/emitters/microwave_laser_muzzle_01_emit.bp'):ScaleEmitter(0.05))
            table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Beam_02', self.unit:GetArmy(), '/effects/emitters/microwave_laser_flash_01_emit.bp'):ScaleEmitter(0.05))
            table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Beam_02', self.unit:GetArmy(), '/effects/emitters/microwave_laser_muzzle_01_emit.bp'):ScaleEmitter(0.05))
            table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Beam_03', self.unit:GetArmy(), '/effects/emitters/microwave_laser_flash_01_emit.bp'):ScaleEmitter(0.05))
            table.insert(self.unit.EMPArrayEffects01, CreateAttachedEmitter(self.unit, 'EMP_Array_Beam_03', self.unit:GetArmy(), '/effects/emitters/microwave_laser_muzzle_01_emit.bp'):ScaleEmitter(0.05))
            self:ForkThread(self.ArrayEffectsCleanup)
        end
    end,

    ArrayEffectsCleanup = function(self)
        WaitTicks(20)
        if self.unit.EMPArrayEffects01 then
            for _, v in self.unit.EMPArrayEffects01 do
                v:Destroy()
            end
            self.unit.EMPArrayEffects01 = {}
        end
    end,
}

PDLaserGrid2 = Class(DefaultBeamWeapon) {
    BeamType = CollisionBeamFile.PDLaser2CollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = {},
    FxUpackingChargeEffectScale = 1,

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

UEFACUHeavyPlasmaGatlingCannonWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = import('/mods/BlackOpsFAF-ACUs/lua/ACUsEffectTemplates.lua').UEFACUHeavyPlasmaGatlingCannonMuzzleFlash,
    FxMuzzleFlashScale = 0.35,
}

AeonACUPhasonLaser = Class(DefaultBeamWeapon) {
    BeamType = CollisionBeamFile.AeonACUPhasonLaserCollisionBeam,
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

SeraACURapidWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = EffectTemplate.SDFAireauWeaponMuzzleFlash,
    FxMuzzleFlashScale = 0.33,
}

SeraACUBigBallWeapon = Class(DefaultProjectileWeapon) {
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
