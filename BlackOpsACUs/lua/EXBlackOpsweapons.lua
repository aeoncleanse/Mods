-----------------------------------------------------------------
-- File     :  /cdimage/lua/modules/BlackOpsweapons.lua
-- Author(s):  Lt_hawkeye
-- Summary  :  
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local WeaponFile = import('/lua/sim/defaultweapons.lua')
local CollisionBeams = import('/lua/defaultcollisionbeams.lua')
local CollisionBeamFile = import('/lua/defaultcollisionbeams.lua')
local KamikazeWeapon = WeaponFile.KamikazeWeapon
local BareBonesWeapon = WeaponFile.BareBonesWeapon
local DefaultProjectileWeapon = WeaponFile.DefaultProjectileWeapon
local DefaultBeamWeapon = WeaponFile.DefaultBeamWeapon
local GinsuCollisionBeam = CollisionBeams.GinsuCollisionBeam
local EffectTemplate = import('/lua/EffectTemplates.lua')
local QuantumBeamGeneratorCollisionBeam = CollisionBeamFile.QuantumBeamGeneratorCollisionBeam
local PhasonLaserCollisionBeam = CollisionBeamFile.PhasonLaserCollisionBeam
local MicrowaveLaserCollisionBeam01 = CollisionBeamFile.MicrowaveLaserCollisionBeam01
local EXCollisionBeamFile = import('/mods/BlackOpsUnleashed/lua/BlackOpsdefaultcollisionbeams.lua')
local CWeapons = import('/lua/cybranweapons.lua')
local CCannonMolecularWeapon = CWeapons.CCannonMolecularWeapon
local Weapon = import('/lua/sim/Weapon.lua').Weapon

local EXQuantumMaelstromWeapon = Class(Weapon) {
    OnFire = function(self)
        local blueprint = self:GetBlueprint()
        DamageArea(self.unit, self.unit:GetPosition(), blueprint.DamageRadius,
            blueprint.Damage, blueprint.DamageType, blueprint.DamageFriendly)
    end,
}

HawkNapalmWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = EffectTemplate.TGaussCannonFlash,
}

HawkGaussCannonWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = EffectTemplate.TGaussCannonFlash,
}

UEFACUAntiMatterWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = import('/mods/BlackOpsUnleashed/lua/BlackOpsEffectTemplates.lua').ACUAntiMatterMuzzle,
}

PDLaserGrid = Class(DefaultBeamWeapon) {
    BeamType = EXCollisionBeamFile.PDLaserCollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},

    FxUpackingChargeEffects = {}, -- '/effects/emitters/quantum_generator_charge_01_emit.bp'},
    FxUpackingChargeEffectScale = 1,

    PlayFxWeaponUnpackSequence = function(self)
        local army = self.unit:GetArmy()
        local bp = self:GetBlueprint()
        for k, v in self.FxUpackingChargeEffects do
            for ek, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale):ScaleEmitter(0.05)
            end
        end
        DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
    end,
}

EXCEMPArrayBeam01 = Class(DefaultBeamWeapon) {
    BeamType = EXCollisionBeamFile.EXCEMPArrayBeam01CollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    
    OnWeaponFired = function(self)
        EXCEMPArrayBeam01.OnWeaponFired(self)
        
        self.mypos = self.unit:GetPosition()
        self.targetpos = self:GetCurrentTargetPos()
        if self.targetpos then
            self.targetdistance = VDist3(self.mypos,self.targetpos)
            if self.unit.wcArtillery01 then
                if (self.targetdistance >= 25) then
                    self.unit:SetWeaponEnabledByLabel('RightDisruptor', false)
                    self.unit:SetWeaponEnabledByLabel('EXMiasmaArtillery01', true)
                    self.unit:SetWeaponEnabledByLabel('EXMiasmaArtillery02', false)
                    self.unit:SetWeaponEnabledByLabel('EXMiasmaArtillery03', false)
                else
                    self.unit:SetWeaponEnabledByLabel('RightDisruptor', true)
                    self.unit:SetWeaponEnabledByLabel('EXMiasmaArtillery01', false)
                    self.unit:SetWeaponEnabledByLabel('EXMiasmaArtillery02', false)
                    self.unit:SetWeaponEnabledByLabel('EXMiasmaArtillery03', false)
                end
            elseif self.unit.wcArtillery02 then
                if (self.targetdistance >= 25) then
                    self.unit:SetWeaponEnabledByLabel('RightDisruptor', false)
                    self.unit:SetWeaponEnabledByLabel('EXMiasmaArtillery01', false)
                    self.unit:SetWeaponEnabledByLabel('EXMiasmaArtillery02', true)
                    self.unit:SetWeaponEnabledByLabel('EXMiasmaArtillery03', false)
                else
                    self.unit:SetWeaponEnabledByLabel('RightDisruptor', true)
                    self.unit:SetWeaponEnabledByLabel('EXMiasmaArtillery01', false)
                    self.unit:SetWeaponEnabledByLabel('EXMiasmaArtillery02', false)
                    self.unit:SetWeaponEnabledByLabel('EXMiasmaArtillery03', false)
                end
            elseif self.unit.wcArtillery03 then
                if (self.targetdistance >= 25) then
                    self.unit:SetWeaponEnabledByLabel('RightDisruptor', false)
                    self.unit:SetWeaponEnabledByLabel('EXMiasmaArtillery01', false)
                    self.unit:SetWeaponEnabledByLabel('EXMiasmaArtillery02', false)
                    self.unit:SetWeaponEnabledByLabel('EXMiasmaArtillery03', true)
                else
                    self.unit:SetWeaponEnabledByLabel('RightDisruptor', true)
                    self.unit:SetWeaponEnabledByLabel('EXMiasmaArtillery01', false)
                    self.unit:SetWeaponEnabledByLabel('EXMiasmaArtillery02', false)
                    self.unit:SetWeaponEnabledByLabel('EXMiasmaArtillery03', false)
                end
            elseif self.unit.wcBeam01 then
                self.unit:SetWeaponEnabledByLabel('RightDisruptor', false)
                self.unit:SetWeaponEnabledByLabel('EXPhasonBeam01', true)
                self.unit:SetWeaponEnabledByLabel('EXPhasonBeam02', false)
                self.unit:SetWeaponEnabledByLabel('EXPhasonBeam03', false)
            elseif self.unit.wcBeam02 then
                self.unit:SetWeaponEnabledByLabel('RightDisruptor', false)
                self.unit:SetWeaponEnabledByLabel('EXPhasonBeam01', false)
                self.unit:SetWeaponEnabledByLabel('EXPhasonBeam02', true)
                self.unit:SetWeaponEnabledByLabel('EXPhasonBeam03', false)
            elseif self.unit.wcBeam03 then
                self.unit:SetWeaponEnabledByLabel('RightDisruptor', false)
                self.unit:SetWeaponEnabledByLabel('EXPhasonBeam01', false)
                self.unit:SetWeaponEnabledByLabel('EXPhasonBeam02', false)
                self.unit:SetWeaponEnabledByLabel('EXPhasonBeam03', true)
            elseif not self.unit.wcArtillery01 and not self.unit.wcArtillery02 and not self.unit.wcArtillery03 and not self.unit.wcBeam01 and not self.unit.wcBeam02 and not self.unit.wcBeam03 then
                self.unit:SetWeaponEnabledByLabel('RightDisruptor', true)
                self.unit:SetWeaponEnabledByLabel('EXMiasmaArtillery01', false)
                self.unit:SetWeaponEnabledByLabel('EXMiasmaArtillery02', false)
                self.unit:SetWeaponEnabledByLabel('EXMiasmaArtillery03', false)
                self.unit:SetWeaponEnabledByLabel('EXPhasonBeam01', false)
                self.unit:SetWeaponEnabledByLabel('EXPhasonBeam02', false)
                self.unit:SetWeaponEnabledByLabel('EXPhasonBeam03', false)
            end
        end
    end,
}

EXCEMPArrayBeam02 = Class(DefaultBeamWeapon) {
    BeamType = EXCollisionBeamFile.EXCEMPArrayBeam02CollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
}

EMPWeapon = Class(CCannonMolecularWeapon) {
    OnWeaponFired = function(self)
        CCannonMolecularWeapon.OnWeaponFired(self)
        self.targetaquired = self:GetCurrentTargetPos()
        if self.targetaquired then
            if self.unit.EMPArrayEffects01 then
                for k, v in self.unit.EMPArrayEffects01 do
                    v:Destroy()
                end
                self.unit.EMPArrayEffects01 = {}
            end
            table.insert(self.unit.EMPArrayEffects01, AttachBeamEntityToEntity(self.unit, 'EMP_Array_Beam_01', self.unit, 'EMP_Array_Muzzle_01', self.unit:GetArmy(), '/mods/BlackOpsACUs/effects/emitters/excemparraybeam02_emit.bp'))
            table.insert(self.unit.EMPArrayEffects01, AttachBeamEntityToEntity(self.unit, 'EMP_Array_Beam_02', self.unit, 'EMP_Array_Muzzle_02', self.unit:GetArmy(), '/mods/BlackOpsACUs/effects/emitters/excemparraybeam02_emit.bp'))
            table.insert(self.unit.EMPArrayEffects01, AttachBeamEntityToEntity(self.unit, 'EMP_Array_Beam_03', self.unit, 'EMP_Array_Muzzle_03', self.unit:GetArmy(), '/mods/BlackOpsACUs/effects/emitters/excemparraybeam02_emit.bp'))
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
            for k, v in self.unit.EMPArrayEffects01 do
                v:Destroy()
            end
            self.unit.EMPArrayEffects01 = {}
        end
    end,
}

PDLaserGrid2 = Class(DefaultBeamWeapon) {
    BeamType = EXCollisionBeamFile.PDLaser2CollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = {},
    FxUpackingChargeEffectScale = 1,

    PlayFxWeaponUnpackSequence = function(self)
        if not self.ContBeamOn then
            local army = self.unit:GetArmy()
            local bp = self:GetBlueprint()
            for k, v in self.FxUpackingChargeEffects do
                for ek, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                    CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale)
                end
            end
            DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
        end
    end,
}

UEFACUHeavyPlasmaGatlingCannonWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = import('/mods/BlackOpsACUs/lua/EXBlackOpsEffectTemplates.lua').UEFACUHeavyPlasmaGatlingCannonMuzzleFlash,
    FxMuzzleFlashScale = 0.35,
}

AeonACUPhasonLaser = Class(DefaultBeamWeapon) {
    BeamType = EXCollisionBeamFile.AeonACUPhasonLaserCollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = EffectTemplate.CMicrowaveLaserCharge01,
    FxUpackingChargeEffectScale = 0.33,

    PlayFxWeaponUnpackSequence = function(self)
        if not self.ContBeamOn then
            local army = self.unit:GetArmy()
            local bp = self:GetBlueprint()
            for k, v in self.FxUpackingChargeEffects do
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
}
