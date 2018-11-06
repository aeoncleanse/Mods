-- Cybran Anti Air Projectile

local CybranHailfire02Projectile = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsProjectiles.lua').CybranHailfire02Projectile
local EffectTemplate = import('/lua/EffectTemplates.lua')
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat

CAANanoDart02 = Class(CybranHailfire02Projectile) {
   OnCreate = function(self)
        CybranHailfire02Projectile.OnCreate(self)
        for k, v in self.FxTrails do
            CreateEmitterOnEntity(self,self:GetArmy(),v)
        end
        self.MoveThread = self:ForkThread(self.MovementThread)
   end,

    MovementThread = function(self)
        self.WaitTime = 0.1
        WaitSeconds(0.1)
        while not self:BeenDestroyed() do
            self:SetTurnRateByDist()
            WaitSeconds(self.WaitTime)
        end
    end,

    SetTurnRateByDist = function(self)
        local dist = VDist3(self:GetPosition(), self:GetCurrentTargetPosition())
        if dist > 0 and dist <= 15 then
            WaitSeconds(0.1)
            local FxFragEffect = EffectTemplate.SThunderStormCannonProjectileSplitFx
            local ChildProjectileBP = '/mods/BlackOpsFAF-Unleashed/projectiles/CybranHailfire01child/CybranHailfire01child_proj.bp'

            -- Split effects
            for k, v in FxFragEffect do
                CreateEmitterAtEntity(self, self:GetArmy(), v)
            end

            local vx, vy, vz = self:GetVelocity()
            local velocity = 20

            -- Create several other projectiles in a dispersal pattern
            local numProjectiles = 5

            local angle = (2*math.pi) / numProjectiles
            local angleInitial = RandomFloat(0, angle)

            -- Randomization of the spread
            local angleVariation = angle * 3 -- Adjusts angle variance spread
            local spreadMul = 1.75 -- Adjusts the width of the dispersal

            local xVec = 0
            local yVec = vy
            local zVec = 0

            -- Launch projectiles at semi-random angles away from split location
            for i = 0, (numProjectiles -1) do
                xVec = vx + (math.sin(angleInitial + (i*angle) + RandomFloat(-angleVariation, angleVariation))) * spreadMul
                zVec = vz + (math.cos(angleInitial + (i*angle) + RandomFloat(-angleVariation, angleVariation))) * spreadMul
                local proj = self:CreateChildProjectile(ChildProjectileBP)
                proj:SetVelocity(xVec,yVec,zVec)
                proj:SetVelocity(velocity)
                proj:PassDamageData(self.ChildDamageData)
            end

            self:Destroy()
        end
    end,

    PassDamageData = function(self, damageData)
        CybranHailfire02Projectile.PassDamageData(self,damageData)
        local launcherbp = self:GetLauncher():GetBlueprint()
        self.ChildDamageData = table.copy(self.DamageData)
        self.ChildDamageData.DamageAmount = launcherbp.SplitDamage.DamageAmount or 0
        self.ChildDamageData.DamageRadius = launcherbp.SplitDamage.DamageRadius or 1
    end,
}

TypeClass = CAANanoDart02
