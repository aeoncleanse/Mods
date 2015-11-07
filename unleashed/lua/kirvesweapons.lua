local WeaponFile = import('/lua/sim/DefaultWeapons.lua')
local KamikazeWeapon = WeaponFile.KamikazeWeapon
local BareBonesWeapon = WeaponFile.BareBonesWeapon
local DefaultProjectileWeapon = WeaponFile.DefaultProjectileWeapon
local DefaultBeamWeapon = WeaponFile.DefaultBeamWeapon
local OriginalEffectTemplate = import('/lua/EffectTemplates.lua')
local EffectTemplate = import('/lua/kirveseffects.lua')

local CollisionBeamFile = import('/lua/kirvesbeams.lua')



TargetingLaser = Class(DefaultBeamWeapon) {
    BeamType = CollisionBeamFile.TargetingCollisionBeam,
    FxMuzzleFlash = {'/effects/emitters/particle_cannon_muzzle_01_emit.bp'},
	
	FxBeamEndPointScale = 0.01,
}

TAAPhalanxWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = EffectTemplate.TPhalanxGunMuzzleFlash,
    FxShellEject  = EffectTemplate.TPhalanxGunShells,

    PlayFxMuzzleSequence = function(self, muzzle)
		DefaultProjectileWeapon.PlayFxMuzzleSequence(self, muzzle)
		for k, v in self.FxShellEject do
            CreateAttachedEmitter(self.unit, 'Shells_Left', self.unit:GetArmy(), v)
            CreateAttachedEmitter(self.unit, 'Shells_Right', self.unit:GetArmy(), v)
        end
    end,
}
TAAPhalanxWeapon2 = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = EffectTemplate.TPhalanxGunMuzzleFlash,
    FxShellEject  = EffectTemplate.TPhalanxGunShells,

    PlayFxMuzzleSequence = function(self, muzzle)
		DefaultProjectileWeapon.PlayFxMuzzleSequence(self, muzzle)
		for k, v in self.FxShellEject do
            CreateAttachedEmitter(self.unit, 'Gattle_Shells_Right_01', self.unit:GetArmy(), v)
            CreateAttachedEmitter(self.unit, 'Gattle_Shells_Right_02', self.unit:GetArmy(), v)
            CreateAttachedEmitter(self.unit, 'Gattle_Shells_Left_01', self.unit:GetArmy(), v)
            CreateAttachedEmitter(self.unit, 'Gattle_Shells_Left_02', self.unit:GetArmy(), v)
        end
    end,
}

SDFUnstablePhasonBeam = Class(DefaultBeamWeapon) {
    BeamType = CollisionBeamFile.UnstablePhasonLaserCollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {}, ####OriginalEffectTemplate.SExperimentalUnstablePhasonLaserMuzzle01,
    FxUpackingChargeEffects = OriginalEffectTemplate.CMicrowaveLaserCharge01,
    FxUpackingChargeEffectScale = 0.2,
}

Dummy = Class(DefaultBeamWeapon) {
    BeamType = CollisionBeamFile.TargetingCollisionBeam,
	
	FxBeamEndPointScale = 0.01,
}