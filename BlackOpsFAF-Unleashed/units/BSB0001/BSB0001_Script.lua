-----------------------------------------------------------------
-- File     :  /cdimage/units/XSB0001/XSB0001_script.lua
-- Author(s):  John Comes, David Tomandl
-- Summary  :  UEF Wall Piece Script
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local SShieldLandUnit = import('/lua/seraphimunits.lua').SShieldLandUnit
local SeraLambdaFieldDestroyer = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsDefaultAntiProjectile.lua').SeraLambdaFieldDestroyer

BSB0001 = Class(SShieldLandUnit) {
    -- Sets up parent call backs between drone and parent
    Parent = nil,

    SetParent = function(self, parent, droneName)
        self.Parent = parent
        self.Drone = droneName
    end,

    ShieldEffects = {
        '/effects/emitters/seraphim_shield_generator_t3_03_emit.bp',
        '/effects/emitters/seraphim_shield_generator_t2_03_emit.bp',
    },

    OnCreate = function(self, builder, layer)
        SShieldLandUnit.OnCreate(self, builder, layer)
        self.ShieldEffectsBag = {}
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
            self.ShieldEffectsBag = {}
        end

        for k, v in self.ShieldEffects do
            table.insert(self.ShieldEffectsBag, CreateAttachedEmitter(self, 0, self:GetArmy(), v):ScaleEmitter(1))
        end

        local bp = self:GetBlueprint().Defense.LambdaField
        local field = SeraLambdaFieldDestroyer {
            Owner = self,
            Radius = bp.Radius,
            AttachBone = bp.AttachBone,
            Probability = bp.Probability
        }

        self.Trash:Add(field)
        self.UnitComplete = true
    end,

    -- Make this unit invulnerable
    OnDamage = function()
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        if self.ShieldEffctsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
        end
        SShieldLandUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

    DeathThread = function(self)
        self:Destroy()
    end,
}

TypeClass = BSB0001
