-------------------------------------------------------------------------------------
-- File     :  /data/projectiles/SDFSinnuntheWeapon01/SDFSinnuntheWeapon01_script.lua
-- Author(s):  Matt Vainio
-- Summary  :  Sinn-Uthe Projectile script, XSL0401
-- Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
-------------------------------------------------------------------------------------

local SDFSinnuntheWeaponProjectile = import('/lua/seraphimprojectiles.lua').SDFSinnuntheWeaponProjectile
local utilities = import('/lua/utilities.lua')

SDFSinnuntheWeapon01 = Class(SDFSinnuntheWeaponProjectile) {
    AttackBeams = {'/effects/emitters/seraphim_othuy_beam_01_emit.bp'},
    SpawnEffects = {
        '/effects/emitters/seraphim_othuy_spawn_01_emit.bp',
        '/effects/emitters/seraphim_othuy_spawn_02_emit.bp',
        '/effects/emitters/seraphim_othuy_spawn_03_emit.bp',
        '/effects/emitters/seraphim_othuy_spawn_04_emit.bp',
    },

    OnCreate = function(self)
        SDFSinnuntheWeaponProjectile.OnCreate(self)
        local army =  self:GetArmy()
    end,

    OnImpact = function(self, targetType, targetEntity)
        SDFSinnuntheWeaponProjectile.OnImpact(self, targetType, targetEntity)
        local position = self:GetPosition()
        local spiritUnit = CreateUnitHPR('BSL0404', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)

        -- Create effects for spawning of energy being
        for k, v in self.SpawnEffects do
            CreateAttachedEmitter(spiritUnit, -1, self:GetArmy(), v):ScaleEmitter(0.5)
        end
    end,

    targetThread = function(self)
        local beams = {}
        while true do
            local instigator = self:GetLauncher()
            local targets = {}
            targets = utilities.GetEnemyUnitsInSphere(self, self:GetPosition(), self.DamageData.DamageRadius)
            if targets then
                for k, v in targets do
                    DamageArea(instigator,self:GetPosition(),self.DamageData.DamageRadius,self.DamageData.DamageAmount,self.DamageData.DamageType,self.DamageData.DamageFriendly)
                    local target = v
                    for k, v in self.AttackBeams do
                        local beam = AttachBeamEntityToEntity(target, -1, self, -2, self:GetArmy(), v)
                        table.insert(beams, beam)
                        self.Trash:Add(beam)
                    end
                end
            end
            WaitTicks(1)
            for k, v in beams do
                v:Destroy()
            end
        end
    end,
}

TypeClass = SDFSinnuntheWeapon01
