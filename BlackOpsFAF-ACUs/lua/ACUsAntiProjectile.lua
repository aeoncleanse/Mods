local Entity = import('/lua/sim/Entity.lua').Entity
local BlackOpsEffectTemplate = import('/mods/BlackOpsFAF-ACUs/lua/ACUsEffectTemplates.lua')

SeraLambdaFieldDestroyer = Class(Entity) {
    EndPointEffects = {'/effects/emitters/particle_cannon_end_01_emit.bp',},
    LambdaEffects = BlackOpsEffectTemplate.LambdaDestroyer,

    OnCreate = function(self, spec)
        Entity.OnCreate(self, spec)
        self.Owner = spec.Owner
        self.Probability = spec.Probability
        self:SetCollisionShape('Sphere', 0, 0, 0, spec.Radius)
        self:SetDrawScale(spec.Radius)
        self.AttachBone = spec.AttachBone
        self:AttachTo(spec.Owner, spec.AttachBone)
        ChangeState(self, self.WaitingState)
        self.LambdaEffectsBag = {}
    end,

    OnDestroy = function(self)
        Entity.OnDestroy(self)
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

            if not IsEnemy(self:GetArmy(), other:GetArmy()) then return false end -- Don't affect non-enemies

            if other.LambdaDetect[self] then return false end

            local rand = math.random(0, 100)
            if rand >= 0 and rand <= self.Probability then
                -- Create Lambda FX
                for _, v in self.LambdaEffects do
                    table.insert(self.LambdaEffectsBag, CreateEmitterOnEntity(other, self:GetArmy(), v):ScaleEmitter(0.2))
                end

                other:Destroy()

                -- Clean up FX
                for _, v in self.LambdaEffectsBag do
                    v:Destroy()
                end
                self.LambdaEffectsBag = {}
            end

            if not other.LambdaDetect then
                other.LambdaDetect = {}
            end
            other.LambdaDetect[self] = true

            return false
        end,
    },
}
