-- script for projectile Missile

local GargEMPWarheadProjectile = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsProjectiles.lua').GargEMPWarheadProjectile

GargEMPWarhead01 = Class(GargEMPWarheadProjectile) {
    FxSplashScale = 0.5,
    FxTrails = {},

    LaunchSound = 'Nuke_Launch',
    ExplodeSound = 'Nuke_Impact',
    AmbientSound = 'Nuke_Flight',
    InitialEffects = {'/effects/emitters/nuke_munition_launch_trail_02_emit.bp',},
    LaunchEffects = {'/effects/emitters/nuke_munition_launch_trail_03_emit.bp',},
    ThrustEffects = {'/effects/emitters/nuke_munition_launch_trail_04_emit.bp',},

    OnCreate = function(self)
        GargEMPWarheadProjectile.OnCreate(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 2.0)
        self.effectEntityPath = '/mods/BlackOpsFAF-Unleashed/projectiles/GargEMPWarhead02/GargEMPWarhead02_proj.bp'
    end,
}

TypeClass = GargEMPWarhead01
