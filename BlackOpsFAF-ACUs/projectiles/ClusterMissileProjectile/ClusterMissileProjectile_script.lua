-----------------------------
-- Cluster missile projectile
-----------------------------

local EffectTemplate = import('/lua/EffectTemplates.lua')
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local ClusterMissileProjectileClass = import('/mods/BlackOpsFAF-ACUs/lua/ACUsProjectiles.lua').ClusterMissileProjectileClass

ClusterMissileProjectile = Class(ClusterMissileProjectileClass) {
    OnCreate = function(self)
        ClusterMissileProjectileClass.OnCreate(self)

        self:SetCollisionShape('Sphere', 0, 0, 0, 2)
        self.MoveThread = self:ForkThread(self.MovementThread)
    end,

    MovementThread = function(self)
        self.WaitTime = 0.1
        self:SetTurnRate(8)
        WaitSeconds(0.1)

        while not self:BeenDestroyed() do
            self:SetTurnRateByDist()
            WaitSeconds(self.WaitTime)
        end
    end,

    SetTurnRateByDist = function(self)
        local dist = VDist3(self:GetPosition(), self:GetCurrentTargetPosition())
        if dist > 50 then
            -- Freeze the turn rate as to prevent steep angles at long distance targets
            self:SetTurnRate(15)
            WaitSeconds(0.5)
            self:SetTurnRate(90)
            WaitSeconds(0.1)
            self:SetTurnRate(50)
        elseif dist > 35 and dist <= 50 then
            -- Increase check intervals
            self:SetTurnRate(15)
            WaitSeconds(0.1)
            self:SetTurnRate(90)
            WaitSeconds(0.1)
            self:SetTurnRate(15)
        elseif dist > 25 and dist <= 35 then
            self:SetTurnRate(15)
            WaitSeconds(0.1)
            self:SetTurnRate(90)
            WaitSeconds(0.1)
            self:SetTurnRate(15)
        elseif dist > 8 and dist <= 25 then
            self:SetTurnRate(45)
            WaitSeconds(0.1)
            self:SetTurnRate(100)
        elseif dist > 0 and dist <= 8 then
            -- Further increase check intervals
            self:SetTurnRate(360)
            WaitSeconds(0.1)

            local FxFragEffect = EffectTemplate.SThunderStormCannonProjectileSplitFx
            local ChildProjectileBP = '/mods/BlackOpsFAF-ACUs/projectiles/SmallYieldNukeProjectile/SmallYieldNukeProjectile_proj.bp'

            -- Split effects
            for _, v in FxFragEffect do
                CreateEmitterAtEntity(self, self:GetArmy(), v)
            end

            local vx, vy, vz = self:GetVelocity()
            local velocity = 20

            -- One initial projectile following same directional path as the original
            -- Create several other projectiles in a dispersal pattern
            local numProjectiles = 3

            local angle = (2 * math.pi) / numProjectiles
            local angleInitial = RandomFloat(0, angle)

            -- Randomization of the spread
            local angleVariation = angle * 3 -- Adjusts angle variance spread
            local spreadMul = 1.25 -- Adjusts the width of the dispersal

            local xVec
            local yVec = vy
            local zVec

            -- Launch projectiles at semi-random angles away from split location
            for i = 0, (numProjectiles -1) do
                xVec = vx + (math.sin(angleInitial + (i*angle) + RandomFloat(-angleVariation, angleVariation))) * spreadMul
                zVec = vz + (math.cos(angleInitial + (i*angle) + RandomFloat(-angleVariation, angleVariation))) * spreadMul
                local proj = self:CreateChildProjectile(ChildProjectileBP)
                proj:SetVelocity(xVec, yVec, zVec)
                proj:SetVelocity(velocity)
                proj:PassDamageData(self.DamageData)
            end

            self:Destroy()
        end
    end,

    OnEnterWater = function(self)
        ClusterMissileProjectileClass.OnEnterWater(self)

        self:SetDestroyOnWater(true)
    end,
}

TypeClass = ClusterMissileProjectile
