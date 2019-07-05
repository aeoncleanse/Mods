local Entity = import('/lua/sim/Entity.lua').Entity
local LambdaDestroyerEffects = import('/mods/BlackOpsFAF-ACUs/lua/ACUsEffectTemplates.lua').LambdaDestroyer

LambdaField = Class(Entity) {
    ActiveEffects = LambdaDestroyerEffects,
    PassiveEffects = {
        '/effects/emitters/seraphim_shield_generator_t2_03_emit.bp',
        '/effects/emitters/seraphim_shield_generator_t3_03_emit.bp',
    },

    OnCreate = function(self, spec)
        Entity.OnCreate(self, spec)

        -- Set up our properties using data passed in
        self:SetCollisionShape('Sphere', 0, 0, 0, spec.Radius)
        self.Probability = spec.Probability
        self:SetDrawScale(spec.Radius)
        self:AttachTo(spec.Owner, spec.AttachBone)

        -- Gotta have some bags of holding for our fancy effects!
        self.ActiveEffectsBag = {}
        self.PassiveEffectsBag = {}

        -- Set up some visuals to show people we have defenses in place
        for _, effect in self.PassiveEffects do
            table.insert(self.PassiveEffectsBag, CreateAttachedEmitter(spec.Owner, spec.AttachBone, self:GetArmy(), effect):ScaleEmitter(0.0625))
            table.insert(self.PassiveEffectsBag, CreateAttachedEmitter(spec.Owner, spec.AttachBone, self:GetArmy(), effect):ScaleEmitter(0.0625):OffsetEmitter(0, -0.5, 0))
            table.insert(self.PassiveEffectsBag, CreateAttachedEmitter(spec.Owner, spec.AttachBone, self:GetArmy(), effect):ScaleEmitter(0.0625):OffsetEmitter(0, 0.5, 0))
        end

        ChangeState(self, self.WaitingState)
    end,

    OnDestroy = function(self)
        Entity.OnDestroy(self)

        -- Remember to clean up our effects
        for _, effect in self.PassiveEffectsBag do
            effect:Destroy()
        end

        ChangeState(self, self.DeadState)
    end,

    DeadState = State {
        Main = function(self)
        end,
    },

    -- Return true to process this collision, false to ignore it.
    WaitingState = State{
        OnCollisionCheck = function(self, other)
            if not EntityCategoryContains(categories.PROJECTILE, other) or EntityCategoryContains(categories.STRATEGIC, other) or EntityCategoryContains(categories.ANTINAVY, other) then
                return false
            end

            -- Don't affect friendlies
            if not IsEnemy(self:GetArmy(), other:GetArmy()) then return false end

            -- Don't trigger on projectiles already affected by another Lambda field
            if other.LambdaDetect then return false end

            local rand = math.random(0, 100)
            if rand <= self.Probability then
                -- Create Lambda FX
                for _, v in self.ActiveEffects do
                    table.insert(self.ActiveEffectsBag, CreateEmitterOnEntity(other, self:GetArmy(), v):ScaleEmitter(0.2))
                end

                other:Destroy()

                -- Clean up FX
                for _, v in self.ActiveEffectsBag do
                    v:Destroy()
                end
                self.ActiveEffectsBag = {}
            end

            other.LambdaDetect = true

            return false
        end,
    },
}
