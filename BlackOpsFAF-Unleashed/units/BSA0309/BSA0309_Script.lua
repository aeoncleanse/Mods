-----------------------------------------------------------------
-- File     :  /cdimage/units/XSA0309/XSA0309_script.lua
-- Author(s):  Greg Kohne, Aaron Lundquist
-- Summary  : Seraphim T2 Transport Script
-- Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local AirTransport = import('/lua/defaultunits.lua').AirTransport
local explosion = import('/lua/defaultexplosions.lua')
local util = import('/lua/utilities.lua')
local SeraphimWeapons = import('/lua/seraphimweapons.lua')
local SAAShleoCannonWeapon = SeraphimWeapons.SAAShleoCannonWeapon
local SDFHeavyPhasicAutoGunWeapon = SeraphimWeapons.SDFHeavyPhasicAutoGunWeapon
local SeraLambdaFieldDestroyer = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsDefaultAntiProjectile.lua').SeraLambdaFieldDestroyer

BSA0309 = Class(AirTransport) {
    AirDestructionEffectBones = {'XSA0309','Left_Attachpoint08','Right_Attachpoint02'},

    Weapons = {
        AutoGun = Class(SDFHeavyPhasicAutoGunWeapon) {},
        AALeft01 = Class(SAAShleoCannonWeapon) {},
        AARight01 = Class(SAAShleoCannonWeapon) {},
        AALeft02 = Class(SAAShleoCannonWeapon) {},
        AARight02 = Class(SAAShleoCannonWeapon) {},
    },

    OnStopBeingBuilt = function(self, builder, layer)
        local bp = self:GetBlueprint().Defense.LambdaField
        local field = SeraLambdaFieldDestroyer {
            Owner = self,
            Radius = bp.Radius,
            AttachBone = bp.AttachBone,
            Probability = bp.Probability
        }
        self.Trash:Add(field)
        self.UnitComplete = true
        AirTransport.OnStopBeingBuilt(self,builder,layer)
    end,

    -- Override air destruction effects so we can do something custom here
    CreateUnitAirDestructionEffects = function(self, scale)
        self:ForkThread(self.AirDestructionEffectsThread, self)
    end,

    AirDestructionEffectsThread = function(self)
        local numExplosions = math.floor(table.getn(self.AirDestructionEffectBones) * 0.5)
        for i = 0, numExplosions do
            explosion.CreateDefaultHitExplosionAtBone(self, self.AirDestructionEffectBones[util.GetRandomInt(1, numExplosions)], 0.5)
            WaitSeconds(util.GetRandomFloat(0.2, 0.9))
        end
    end,
}

TypeClass = BSA0309
