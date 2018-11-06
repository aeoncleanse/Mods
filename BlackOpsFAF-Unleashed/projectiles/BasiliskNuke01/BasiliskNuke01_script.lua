--------------------------------------------------------------------------------------------------------------
-- File     :  \data\effects\Entities\CybranNukeEffectController0101\CybranNukeEffectController0101_script.lua
-- Author(s):  Greg Kohne
-- Summary  :  Ohwalli Bomb effect controller script, non-damaging
-- Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
--------------------------------------------------------------------------------------------------------------

local NullShell = import('/lua/sim/defaultprojectiles.lua').NullShell
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local Util = import('/lua/utilities.lua')
local BasiliskNukeEffect04 = '/mods/BlackOpsFAF-Unleashed/projectiles/MGQAIPlasmaArty01/MGQAIPlasmaArty01_proj.bp'
local BasiliskNukeEffect05 = '/mods/BlackOpsFAF-Unleashed/effects/Entities/BasiliskNukeEffect05/BasiliskNukeEffect05_proj.bp'

BasiliskNukeEffectController01 = Class(NullShell) {
    -- Create inner explosion plasma
    CreateEffectInnerPlasma = function(self)
        local vx, vy, vz = self:GetVelocity()
        local num_projectiles = 20
        local horizontal_angle = (2*math.pi) / num_projectiles
        local angleInitial = RandomFloat(0, horizontal_angle)
        local xVec, zVec
        local offsetMultiple = 5
        local px, pz

        for i = 0, (num_projectiles -1) do
            xVec = (math.sin(angleInitial + (i*horizontal_angle)))
            zVec = (math.cos(angleInitial + (i*horizontal_angle)))
            px = 0
            pz = 0

            local proj = self:CreateProjectile(BasiliskNukeEffect05, px, -4, pz, xVec, 0, zVec)
            proj:SetLifetime(2.0)
            proj:SetVelocity(12.0)
            proj:SetAcceleration(-0.9)
        end
    end,

    EffectThread = function(self)
        self:ForkThread(self.CreateEffectInnerPlasma)
        local army = self:GetArmy()
        local position = self:GetPosition()

        WaitSeconds(1)
        CreateLightParticle(self, -1, self:GetArmy(), 50, 100, 'beam_white_01', 'ramp_blue_16')
        self:ShakeCamera(75, 3, 0, 10)

        -- Knockdown force rings
        DamageRing(self, position, 0.1, 22, 1, 'Force', true)
        WaitSeconds(0.8)
        DamageRing(self, position, 0.1, 22, 1, 'Force', true)

        -- Create initial fireball dome effect
        local FireballDomeYOffset = -15
        self:CreateProjectile('/mods/BlackOpsFAF-Unleashed/effects/entities/BasiliskNukeEffect01/BasiliskNukeEffect01_proj.bp',0,FireballDomeYOffset,0,0,0,1)

        WaitSeconds(1.1)

        -- Create fireball plumes to accentuate the explosive detonation
        local num_projectiles = 1
        local horizontal_angle = (2*math.pi) / num_projectiles
        local angleInitial = RandomFloat(0, horizontal_angle)
        local xVec, yVec, zVec
        local angleVariation = 0.1
        local px, pz
        local py = -5

        for i = 0, (num_projectiles -1) do
            xVec = math.sin(angleInitial + (i*horizontal_angle) + RandomFloat(-angleVariation, angleVariation))
            yVec = RandomFloat(0.5, 1.7) + 1.2
            zVec = math.cos(angleInitial + (i*horizontal_angle) + RandomFloat(-angleVariation, angleVariation))
            px = RandomFloat(0.5, 1.0) * xVec
            pz = RandomFloat(0.5, 1.0) * zVec

            local proj = self:CreateProjectile(BasiliskNukeEffect04, px, py, pz, xVec, yVec, zVec)
            proj:SetVelocity(RandomFloat(10, 20))
            proj:SetBallisticAcceleration(-9.8)
        end

        WaitSeconds(0.1)

        -- Create fireball plumes to accentuate the explosive detonation
        local num_projectiles = 2
        local horizontal_angle = (2*math.pi) / num_projectiles
        local angleInitial = RandomFloat(0, horizontal_angle)
        local xVec, yVec, zVec
        local angleVariation = 0.3
        local px, pz
        local py = -5

        for i = 0, (num_projectiles -1) do
            xVec = math.sin(angleInitial + (i*horizontal_angle) + RandomFloat(-angleVariation, angleVariation))
            yVec = RandomFloat(0.5, 1.7) + 1.2
            zVec = math.cos(angleInitial + (i*horizontal_angle) + RandomFloat(-angleVariation, angleVariation))
            px = RandomFloat(0.5, 1.0) * xVec
            pz = RandomFloat(0.5, 1.0) * zVec

            local proj = self:CreateProjectile(BasiliskNukeEffect04, px, py, pz, xVec, yVec, zVec)
            proj:SetVelocity(RandomFloat(10, 20))
            proj:SetBallisticAcceleration(-9.8)
        end
        WaitSeconds(.5)

        -- Create fireball plumes to accentuate the explosive detonation
        local num_projectiles = 2
        local horizontal_angle = (2*math.pi) / num_projectiles
        local angleInitial = RandomFloat(0, horizontal_angle)
        local xVec, yVec, zVec
        local angleVariation = 0.5
        local px, pz
        local py = -5

        for i = 0, (num_projectiles -1) do
            xVec = math.sin(angleInitial + (i*horizontal_angle) + RandomFloat(-angleVariation, angleVariation))
            yVec = RandomFloat(0.5, 1.7) + 1.2
            zVec = math.cos(angleInitial + (i*horizontal_angle) + RandomFloat(-angleVariation, angleVariation))
            px = RandomFloat(0.5, 1.0) * xVec
            pz = RandomFloat(0.5, 1.0) * zVec

            local proj = self:CreateProjectile(BasiliskNukeEffect04, px, py, pz, xVec, yVec, zVec)
            proj:SetVelocity(RandomFloat(10, 20))
            proj:SetBallisticAcceleration(-9.8)
        end

        WaitSeconds(0.2)

        -- Create fireball plumes to accentuate the explosive detonation
        local num_projectiles = 1
        local horizontal_angle = (2*math.pi) / num_projectiles
        local angleInitial = RandomFloat(0, horizontal_angle)
        local xVec, yVec, zVec
        local angleVariation = 0.7
        local px, pz
        local py = -5

        for i = 0, (num_projectiles -1) do
            xVec = math.sin(angleInitial + (i*horizontal_angle) + RandomFloat(-angleVariation, angleVariation))
            yVec = RandomFloat(0.5, 1.7) + 1.2
            zVec = math.cos(angleInitial + (i*horizontal_angle) + RandomFloat(-angleVariation, angleVariation))
            px = RandomFloat(0.5, 1.0) * xVec
            pz = RandomFloat(0.5, 1.0) * zVec

            local proj = self:CreateProjectile(BasiliskNukeEffect04, px, py, pz, xVec, yVec, zVec)
            proj:SetVelocity(RandomFloat(10, 20))
            proj:SetBallisticAcceleration(-9.8)
        end

        WaitSeconds(0.5)

        -- Create fireball plumes to accentuate the explosive detonation
        local num_projectiles = 1
        local horizontal_angle = (2*math.pi) / num_projectiles
        local angleInitial = RandomFloat(0, horizontal_angle)
        local xVec, yVec, zVec
        local angleVariation = 0.2
        local px, pz
        local py = -5

        for i = 0, (num_projectiles -1) do
            xVec = math.sin(angleInitial + (i*horizontal_angle) + RandomFloat(-angleVariation, angleVariation))
            yVec = RandomFloat(0.5, 1.7) + 1.2
            zVec = math.cos(angleInitial + (i*horizontal_angle) + RandomFloat(-angleVariation, angleVariation))
            px = RandomFloat(0.5, 1.0) * xVec
            pz = RandomFloat(0.5, 1.0) * zVec

            local proj = self:CreateProjectile(BasiliskNukeEffect04, px, py, pz, xVec, yVec, zVec)
            proj:SetVelocity(RandomFloat(10, 20))
            proj:SetBallisticAcceleration(-9.8)
        end

        WaitSeconds(0.5)

        local army = self:GetArmy()
        CreateDecal(self:GetPosition(), RandomFloat(0,2*math.pi), 'nuke_scorch_001_albedo', '', 'Albedo', 30, 30, 500, 0, army)

        self:ForkThread(self.CreateHeadConvectionSpinners)
    end,

    CreateHeadConvectionSpinners = function(self)
        local sides = 8
        local angle = (2*math.pi) / sides
        local HeightOffset = -10
        local velocity = 1
        local OffsetMod = 10
        local projectiles = {}

        for i = 0, (sides-1) do
            local x = math.sin(i*angle) * OffsetMod
            local z = math.cos(i*angle) * OffsetMod
            local proj = self:CreateProjectile('/mods/BlackOpsFAF-Unleashed/effects/entities/BasiliskNukeEffect03/BasiliskNukeEffect03_proj.bp', x, HeightOffset, z, x, 0, z)
                :SetVelocity(velocity)
            table.insert(projectiles, proj)
        end

        WaitSeconds(1)
        for i = 0, (sides-1) do
            local x = math.sin(i*angle)
            local z = math.cos(i*angle)
            local proj = projectiles[i+1]
            proj:SetVelocityAlign(false)
            proj:SetOrientation(OrientFromDir(Util.Cross(Vector(x,0,z), Vector(0,1,0))),true)
            proj:SetVelocity(0,3,0)
          proj:SetBallisticAcceleration(-0.05)
        end
    end,
}

TypeClass = BasiliskNukeEffectController01
