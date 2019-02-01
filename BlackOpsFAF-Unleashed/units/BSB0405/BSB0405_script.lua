-----------------------------------------------------------------
-- File     :  /data/units/XSB0405/XSB0405_script.lua
-- Author(s):  Jessica St. Croix, Greg Kohne
-- Summary  :  Seraphim T3 Power Generator Script
-- Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local SShieldStructureUnit = import('/lua/seraphimunits.lua').SShieldStructureUnit
local WeaponsFile = import ('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsWeapons.lua')
local LambdaWeapon = WeaponsFile.LambdaWeapon
local SSeraphimSubCommanderGateway01 = import('/lua/EffectTemplates.lua').SeraphimSubCommanderGateway01
local SSeraphimSubCommanderGateway02 = import('/lua/EffectTemplates.lua').SeraphimSubCommanderGateway02
local explosion = import('/lua/defaultexplosions.lua')

BSB0405 = Class(SShieldStructureUnit) {
    SpawnEffects = {
        '/effects/emitters/seraphim_othuy_spawn_01_emit.bp',
        '/effects/emitters/seraphim_othuy_spawn_02_emit.bp',
        '/effects/emitters/seraphim_othuy_spawn_03_emit.bp',
        '/effects/emitters/seraphim_othuy_spawn_04_emit.bp',
    },

    LambdaEffects = {
        '/effects/emitters/seraphim_t3power_ambient_01_emit.bp',
        '/effects/emitters/seraphim_t3power_ambient_02_emit.bp',
        '/effects/emitters/seraphim_t3power_ambient_04_emit.bp',
    },

    Weapons = {
        Eye01 = Class(LambdaWeapon) {},
        Eye02 = Class(LambdaWeapon) {},
    },

    OnStopBeingBuilt = function(self, builder, layer)
        for k, v in SSeraphimSubCommanderGateway01 do
            CreateAttachedEmitter(self, 'Spinner', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Light04', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Light05', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Light06', self:GetArmy(), v)
        end

        for k, v in SSeraphimSubCommanderGateway02 do
            CreateAttachedEmitter(self, 'Light01', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Light02', self:GetArmy(), v)
            CreateAttachedEmitter(self, 'Light03', self:GetArmy(), v)
        end

        SShieldStructureUnit.OnStopBeingBuilt(self, builder, layer)
        self.Rotator1 = CreateRotator(self, 'Spinner', 'y', nil, 10, 5, 0)
        self.Trash:Add(self.Rotator1)
        self.lambdaEmitterTable = {}
        self.LambdaEffectsBag = {}
        self:SetScriptBit('RULEUTC_ShieldToggle', true)
        self:ForkThread(self.ResourceThread)
    end,

    OnScriptBitSet = function(self, bit)
        SShieldStructureUnit.OnScriptBitSet(self, bit)
        local army =  self:GetArmy()
        if bit == 0 then
        self:SetMaintenanceConsumptionActive()
        self:ForkThread(self.LambdaEmitter)
        end

        if self.Rotator1 then
            self.Rotator1:SetTargetSpeed(40)
        end

        if self.LambdaEffectsBag then
            for k, v in self.LambdaEffectsBag do
                v:Destroy()
            end
            self.LambdaEffectsBag = {}
        end
        for k, v in self.LambdaEffects do
            table.insert(self.LambdaEffectsBag, CreateAttachedEmitter(self, 0, self:GetArmy(), v):ScaleEmitter(1.5))
        end
    end,

    OnScriptBitClear = function(self, bit)
        SShieldStructureUnit.OnScriptBitClear(self, bit)
        if bit == 0 then
        self.Rotator1:SetTargetSpeed(0)
        self:ForkThread(self.KillLambdaEmitter)
        self:SetMaintenanceConsumptionInactive()
        end
        if self.LambdaEffectsBag then
            for k, v in self.LambdaEffectsBag do
                v:Destroy()
            end
            self.LambdaEffectsBag = {}
        end
    end,

    LambdaEmitter = function(self)
        if not self.Dead then
            WaitSeconds(0.5)
            -- Are we dead yet, if not spawn lambdaEmitter
            if not self.Dead then

                -- Gets the platforms current orientation
                local platOrient = self:GetOrientation()

                -- Gets the current position of the platform in the game world
                local location = self:GetPosition('Spinner')

                -- Creates our lambdaEmitter over the platform with a ranomly generated Orientation
                local lambdaEmitter = CreateUnit('bsb0001', self:GetArmy(), location[1], location[2], location[3], platOrient[1], platOrient[2], platOrient[3], platOrient[4], 'Land')

                -- Adds the newly created lambdaEmitter to the parent platforms lambdaEmitter table
                table.insert (self.lambdaEmitterTable, lambdaEmitter)

                -- Sets the platform unit as the lambdaEmitter parent
                lambdaEmitter:SetParent(self, 'bsb0405')
                lambdaEmitter:SetCreator(self)
                self.Trash:Add(lambdaEmitter)
            end
        end
    end,

    DeathThread = function(self, overkillRatio , instigator)
        if self.Rotator1 then
            self.Rotator1:SetTargetSpeed(40)
        end

        local bigExplosionBones = {'Spinner', 'Eye01', 'Eye02'}
        local explosionBones = {'XSB0405', 'Light01',
                                'Light02', 'Light03',
                                'Light04', 'Light05', 'Light06',
        }

        explosion.CreateDefaultHitExplosionAtBone(self, bigExplosionBones[Random(1,3)], 4.0)
        explosion.CreateDebrisProjectiles(self, explosion.GetAverageBoundingXYZRadius(self), {self:GetUnitSizes()})
        WaitSeconds(2)

        local RandBoneIter = RandomIter(explosionBones)
        for i = 1, Random(4,6) do
            local bone = RandBoneIter()
            explosion.CreateDefaultHitExplosionAtBone(self, bone, 1.0)
            WaitTicks(Random(1,3))
        end

        local bp = self:GetBlueprint()
        for i, numWeapons in bp.Weapon do
            if(bp.Weapon[i].Label == 'CollossusDeath') then
                DamageArea(self, self:GetPosition(), bp.Weapon[i].DamageRadius, bp.Weapon[i].Damage, bp.Weapon[i].DamageType, bp.Weapon[i].DamageFriendly)
                break
            end
        end
        WaitSeconds(3.5)
        explosion.CreateDefaultHitExplosionAtBone(self, 'Spinner', 5.0)

        if self.DeathAnimManip then
            WaitFor(self.DeathAnimManip)
        end

        self:DestroyAllDamageEffects()
        self:CreateWreckage(overkillRatio)

        -- CURRENTLY DISABLED UNTIL DESTRUCTION
        -- Create destruction debris out of the mesh, currently these projectiles look like crap,
        -- since projectile rotation and terrain collision doesn't work that great. These are left in
        -- hopes that this will look better in the future.. =)
        if(self.ShowUnitDestructionDebris and overkillRatio) then
            if overkillRatio <= 1 then
                self.CreateUnitDestructionDebris(self, true, true, false)
            elseif overkillRatio <= 2 then
                self.CreateUnitDestructionDebris(self, true, true, false)
            elseif overkillRatio <= 3 then
                self.CreateUnitDestructionDebris(self, true, true, true)
            else
                self.CreateUnitDestructionDebris(self, true, true, true)
            end
        end

        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,

    OnDamage = function(self, instigator, amount, vector, damagetype)
        if self.Dead == false then
            -- Base script for this script function was developed by Gilbot_x
            -- sets the damage resistance of the rebuilder bot to 30%
            local lambdaEmitter_DLS = 0.3
            amount = math.ceil(amount*lambdaEmitter_DLS)
        end
        SShieldStructureUnit.OnDamage(self, instigator, amount, vector, damagetype)
    end,

    KillLambdaEmitter = function(self, instigator, type, overkillRatio)
        -- Small bit of table manipulation to sort thru all of the avalible rebulder bots and remove them after the platform is dead
        if table.getn({self.lambdaEmitterTable}) > 0 then
            for k, v in self.lambdaEmitterTable do
                IssueClearCommands({self.lambdaEmitterTable[k]})
                IssueKillSelf({self.lambdaEmitterTable[k]})
            end
        end
    end,

    ResourceThread = function(self)
        if not self.Dead then
            local energy = self:GetAIBrain():GetEconomyStored('Energy')

            -- Check to see if the player has enough mass / energy
            if  energy <= 10 then
                self:SetScriptBit('RULEUTC_ShieldToggle', false)
                self:ForkThread(self.ResourceThread2)
            else
                -- If the above conditions are not met we check again
                self:ForkThread(self.EconomyWaitUnit)
            end
        end
    end,

    EconomyWaitUnit = function(self)
        if not self.Dead then
        WaitSeconds(2)
            if not self.Dead then
                self:ForkThread(self.ResourceThread)
            end
        end
    end,

    ResourceThread2 = function(self)
        if not self.Dead then
            local energy = self:GetAIBrain():GetEconomyStored('Energy')

            -- Check to see if the player has enough mass / energy
            if  energy > 3000 then
                self:SetScriptBit('RULEUTC_ShieldToggle', true)
                self:ForkThread(self.ResourceThread)
            else
                -- If the above conditions are not met we kill this unit
                self:ForkThread(self.EconomyWaitUnit2)
            end
        end
    end,

    EconomyWaitUnit2 = function(self)
        if not self.Dead then
        WaitSeconds(2)
            if not self.Dead then
                self:ForkThread(self.ResourceThread2)
            end
        end
    end,
}

TypeClass = BSB0405
