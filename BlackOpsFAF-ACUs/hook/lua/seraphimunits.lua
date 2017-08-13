local SeraLambdaField = import('/mods/BlackOpsFAF-ACUs/lua/ACUsAntiProjectile.lua').SeraLambdaFieldDestroyer

LambdaUnit = Class(SStructureUnit) {
    ShieldEffects = {
        '/effects/emitters/seraphim_shield_generator_t3_03_emit.bp',
        '/effects/emitters/seraphim_shield_generator_t2_03_emit.bp',
    },

    OnCreate = function(self, builder, layer)
        SStructureUnit.OnCreate(self, builder, layer)
        self.ShieldEffectsBag = {}

        for _, v in self.ShieldEffects do
            table.insert(self.ShieldEffectsBag, CreateAttachedEmitter(self, 0, self:GetArmy(), v):ScaleEmitter(0.0625))
            table.insert(self.ShieldEffectsBag, CreateAttachedEmitter(self, 0, self:GetArmy(), v):ScaleEmitter(0.0625):OffsetEmitter(0, -0.5, 0))
            table.insert(self.ShieldEffectsBag, CreateAttachedEmitter(self, 0, self:GetArmy(), v):ScaleEmitter(0.0625):OffsetEmitter(0, 0.5, 0))
        end

        local bp = self:GetBlueprint().Defense.LambdaField
        local field = SeraLambdaField {
            Owner = self,
            Radius = bp.Radius,
            AttachBone = bp.AttachBone,
            Probability = bp.Probability
        }

        self.Trash:Add(field)
    end,

    SetParent = function(self, parent, droneName)
        self.Parent = parent
        self.Drone = droneName
    end,

    -- Make this unit invulnerable
    OnDamage = function()
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        SStructureUnit.OnKilled(self, instigator, type, overkillRatio)

        if self.ShieldEffectsBag then
            for _, v in self.ShieldEffectsBag or {} do
                v:Destroy()
            end
        end
    end,

    DeathThread = function(self)
        self:Destroy()
    end,
}
