--****************************************************************************
--**
--**  File     :  /cdimage/units/XSA0309/XSA0309_script.lua
--**  Author(s):  Greg Kohne, Aaron Lundquist
--**
--**  Summary  : Seraphim T2 Transport Script
--**
--**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

local SAirUnit = import('/lua/seraphimunits.lua').SAirUnit
local explosion = import('/lua/defaultexplosions.lua')
local util = import('/lua/utilities.lua')
local SeraphimWeapons = import('/lua/seraphimweapons.lua')
local SAAShleoCannonWeapon = SeraphimWeapons.SAAShleoCannonWeapon
local SDFHeavyPhasicAutoGunWeapon = SeraphimWeapons.SDFHeavyPhasicAutoGunWeapon
local SeraLambdaFieldRedirector = import('/lua/BlackOpsdefaultantiprojectile.lua').SeraLambdaFieldRedirector
local SeraLambdaFieldDestroyer = import('/lua/BlackOpsdefaultantiprojectile.lua').SeraLambdaFieldDestroyer



BSA0309 = Class(SAirUnit) {

    AirDestructionEffectBones = { 'XSA0309','Left_Attachpoint08','Right_Attachpoint02'},

    Weapons = {
        AutoGun = Class(SDFHeavyPhasicAutoGunWeapon) {},
        AALeft01 = Class(SAAShleoCannonWeapon) {},
        AARight01 = Class(SAAShleoCannonWeapon) {},
        AALeft02 = Class(SAAShleoCannonWeapon) {},
        AARight02 = Class(SAAShleoCannonWeapon) {},
    },
    OnStopBeingBuilt = function(self, builder, layer)
        local bp = self:GetBlueprint().Defense.SeraLambdaFieldRedirector01
        local bp2 = self:GetBlueprint().Defense.SeraLambdaFieldRedirector02
        local bp3 = self:GetBlueprint().Defense.SeraLambdaFieldDestroyer01
        local SeraLambdaFieldRedirector01 = SeraLambdaFieldRedirector {
            Owner = self,
            Radius = bp.Radius,
            AttachBone = bp.AttachBone,
            RedirectRateOfFire = bp.RedirectRateOfFire
        }
        local SeraLambdaFieldRedirector02 = SeraLambdaFieldRedirector {
            Owner = self,
            Radius = bp2.Radius,
            AttachBone = bp2.AttachBone,
            RedirectRateOfFire = bp2.RedirectRateOfFire
        }
        local SeraLambdaFieldDestroyer01 = SeraLambdaFieldDestroyer {
            Owner = self,
            Radius = bp3.Radius,
            AttachBone = bp3.AttachBone,
            RedirectRateOfFire = bp3.RedirectRateOfFire
        }
        self.Trash:Add(SeraLambdaFieldRedirector01)
        self.Trash:Add(SeraLambdaFieldRedirector02)
        self.Trash:Add(SeraLambdaFieldDestroyer01)
        self.UnitComplete = true
        SAirUnit.OnStopBeingBuilt(self,builder,layer)
    end,
    -- Override air destruction effects so we can do something custom here
    CreateUnitAirDestructionEffects = function( self, scale )
        self:ForkThread(self.AirDestructionEffectsThread, self )
    end,

    AirDestructionEffectsThread = function( self )
        local numExplosions = math.floor( table.getn( self.AirDestructionEffectBones ) * 0.5 )
        for i = 0, numExplosions do
            explosion.CreateDefaultHitExplosionAtBone( self, self.AirDestructionEffectBones[util.GetRandomInt( 1, numExplosions )], 0.5 )
            WaitSeconds( util.GetRandomFloat( 0.2, 0.9 ))
        end
    end,
}

TypeClass = BSA0309