---------------------------------
-- Billy Tactical Nuke Projectile
---------------------------------

local TIFMissileNuke = import('/lua/terranprojectiles.lua').TIFMissileNuke

Billy = Class(TIFMissileNuke) {
    BeamName = '/effects/emitters/missile_exhaust_fire_beam_06_emit.bp',
    InitialEffects = {'/effects/emitters/nuke_munition_launch_trail_02_emit.bp'},
    LaunchEffects = {
        '/effects/emitters/nuke_munition_launch_trail_03_emit.bp',
        '/effects/emitters/nuke_munition_launch_trail_05_emit.bp',
    },
    ThrustEffects = {'/effects/emitters/nuke_munition_launch_trail_04_emit.bp'},

    OnCreate = function(self)
        TIFMissileNuke.OnCreate(self)

        self.effectEntityPath = '/effects/Entities/UEFNukeEffectController01/UEFNukeEffectController01_proj.bp'
        self:LauncherCallbacks()
    end,

    -- Tactical nuke has different flight path
    MovementThread = function(self)
        local army = self:GetArmy()
        self.CreateEffects(self, self.InitialEffects, army, 1)
        self:SetTurnRate(8)
        WaitTicks(3)

        self.CreateEffects(self, self.LaunchEffects, army, 1)
        self.CreateEffects(self, self.ThrustEffects, army, 1)
        while not self:BeenDestroyed() do
            self:SetTurnRateByDist()
            WaitTicks(1)
        end
    end,

    SetTurnRateByDist = function(self)
        local dist = self:GetDistanceToTarget()
        if dist > 50 then
            -- Freeze the turn rate as to prevent steep angles at long distance targets
            WaitTicks(20)
            self:SetTurnRate(20)
        elseif dist > 128 and dist <= 213 then
            -- Increase check intervals
            self:SetTurnRate(30)
            WaitTicks(15)
            self:SetTurnRate(30)
        elseif dist > 43 and dist <= 107 then
            -- Further increase check intervals
            WaitTicks(3)
            self:SetTurnRate(75)
        elseif dist > 0 and dist <= 43 then
            -- Further increase check intervals
            self:SetTurnRate(200)
            KillThread(self.MoveThread)
        end
    end,

    OnEnterWater = function(self)
        TIFMissileNuke.OnEnterWater(self)

        self:SetDestroyOnWater(true)
    end,
}

TypeClass = Billy
