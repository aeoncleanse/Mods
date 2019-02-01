-----------------------------------------------------------------
-- File     :  /lua/defaultantimissile.lua
-- Author(s):  Gordon Duclos
-- Summary  :  Default definitions collision beams
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local Entity = import('/lua/sim/Entity.lua').Entity
local BlackOpsEffectTemplate = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsEffectTemplates.lua')

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
                for k, v in self.LambdaEffects do
                    table.insert(self.LambdaEffectsBag, CreateEmitterOnEntity(other, self:GetArmy(), v):ScaleEmitter(0.2))
                end

                other:Destroy()

                -- Clean up FX
                for k, v in self.LambdaEffectsBag do
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

TorpRedirectField = Class(Entity) {

    RedirectBeams = {'/mods/BlackOpsFAF-Unleashed/effects/emitters/Torp_beam_02_emit.bp'},
    EndPointEffects = {'/effects/emitters/particle_cannon_end_01_emit.bp',},

    OnCreate = function(self, spec)
        Entity.OnCreate(self, spec)
        self.Owner = spec.Owner
        self.Radius = spec.Radius
        self.RedirectRateOfFire = spec.RedirectRateOfFire or 1
        self:SetCollisionShape('Sphere', 0, 0, 0, self.Radius)
        self:SetDrawScale(self.Radius)
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
            if EntityCategoryContains(categories.TORPEDO, other) and not EntityCategoryContains(categories.STRATEGIC, other)
                    and other ~= self.EnemyProj and IsEnemy(self:GetArmy(), other:GetArmy()) then
                self.Enemy = other:GetLauncher()
                self.EnemyProj = other
                self.EXFiring = false
                if self.Enemy and (not other.lastRedirector or other.lastRedirector ~= self:GetArmy()) then
                    other.lastRedirector = self:GetArmy()
                    local targetspeed = other:GetCurrentSpeed()
                    other:SetVelocity(targetspeed * 3)
                    other:SetNewTarget(self.Enemy)
                    other:TrackTarget(true)
                    other:SetTurnRate(720)
                    self.EXFiring = true
                end
                if self.EXFiring then
                    ChangeState(self, self.RedirectingState)
                end
            end
            return false
        end,
    },

    RedirectingState = State{
        Main = function(self)
            if not self or self:BeenDestroyed()
            or not self.EnemyProj or self.EnemyProj:BeenDestroyed()
            or not self.Owner or self.Owner.Dead then
                return
            end

            local beams = {}
            for k, v in self.RedirectBeams do
                table.insert(beams, AttachBeamEntityToEntity(self.EnemyProj, -1, self.Owner, self.AttachBone, self:GetArmy(), v))
            end
            if self.Enemy then
                -- Set collision to friends active so that when the missile reaches its source it can deal damage.
                self.EnemyProj.DamageData.CollideFriendly = true
                self.EnemyProj.DamageData.DamageFriendly = true
                self.EnemyProj.DamageData.DamageSelf = true
            end
            if self.Enemy and not self.Enemy:BeenDestroyed() then
                WaitTicks(self.RedirectRateOfFire)
                if not self.EnemyProj:BeenDestroyed() then
                     self.EnemyProj:TrackTarget(false)
                end
            else
                WaitTicks(self.RedirectRateOfFire)
                local vectordam = {}
                vectordam.x = 0
                vectordam.y = 1
                vectordam.z = 0
                self.EnemyProj:DoTakeDamage(self.Owner, 30, vectordam,'Fire')
            end
            for k, v in beams do
                v:Destroy()
            end
            ChangeState(self, self.WaitingState)
        end,

        OnCollisionCheck = function(self, other)
            return false
        end,
    },
}
