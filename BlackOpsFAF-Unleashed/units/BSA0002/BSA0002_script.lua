-- Seraphim T3 Air Staging Platform Repair Drone script
-- By the Blackops team, revisions by Mithy
local SConstructionUnit = import('/lua/seraphimunits.lua').SConstructionUnit
local EffectUtil = import('/lua/EffectUtilities.lua')

BSA0002 = Class(SConstructionUnit) {
    Parent = nil,
    ExhaustLaunch01 = '/effects/emitters/seraphim_inaino_launch_01_emit.bp',
    ExhaustLaunch02 = '/effects/emitters/seraphim_inaino_launch_02_emit.bp',
    ExhaustLaunch03 = '/effects/emitters/seraphim_inaino_launch_03_emit.bp',
    ExhaustLaunch04 = '/effects/emitters/seraphim_inaino_launch_04_emit.bp',
    ExhaustLaunch05 = '/effects/emitters/seraphim_inaino_launch_05_emit.bp',
    BeamLaunch = '/effects/emitters/missile_exhaust_fire_beam_01_emit.bp',

    SetParent = function(self, parent, droneName)
        self.Parent = parent
        self.Drone = droneName
        self.LaunchExhaustEffectsBag = {}
        self:ForkThread(self.LaunchEffects)
        self.HeartBeatThread = self:ForkThread(self.DistanceHeartbeat)
    end,

    OnStopbuild = function(self, unitBeingBuilt)
        self:ForkThread(self.Patrolplatform)
        SConstructionUnit.OnStopBuild(self, unitBeingBuilt)
    end,

    OnMotionHorzEventChange = function(self, new, old)
        if new == 'Stopped' then
            self:ForkThread(self.Patrolplatform)
        end
        SConstructionUnit.OnMotionHorzEventChange(self, new, old)
    end,

    DistanceHeartbeat = function(self)
        self.CapTable = {
            'RULEUCC_Guard',
            'RULEUCC_Move',
            'RULEUCC_Patrol',
            'RULEUCC_Stop',
        }
        self.MoveToParent = false
        while self and not self.Dead do
            local dronePos = self:GetPosition()
            local parentPos = self.Parent:GetPosition()
            local parentDist = VDist2(dronePos[1], dronePos[3], parentPos[1], parentPos[3])
            if parentDist >= 80 and self.MoveToParent == false then
                self.MoveToParent = true
                -- Increase return speed
                self:SetSpeedMult(2.0)
                self:SetAccMult(2.0)
                IssueClearCommands({self})
                IssueMove({self}, parentPos)
                -- Disable command caps
                for k, cap in self.CapTable do
                    self:RemoveCommandCap(cap)
                end
            elseif parentDist <= 70 and self.MoveToParent == true then
                self.MoveToParent = false
                -- Restore speed
                self:SetSpeedMult(1.0)
                self:SetAccMult(1.0)
                -- Re-enable command caps
                self:RestoreCommandCaps()
                -- This will auto-queue a patrol
                IssueStop({self})
            else
                -- If we're idle and our movement check somehow failed, re-queue patrol
                if self:IsIdleState() then
                    self:ForkThread(self.Patrolplatform)
                end
            end
            WaitSeconds(1)
        end
    end,

    Patrolplatform = function(self, override)
        if override or (not self.Dead and not self.Parent.Dead and self:IsIdleState()) then
            local location = self.Parent:GetPosition()
            IssueClearCommands({self})
            local patroltable = {
                {location[1]+15, location[2], location[3]-6},
                {location[1]+15, location[2], location[3]+6},
                {location[1]+6, location[2], location[3]+15},
                {location[1]-6, location[2], location[3]+15},
                {location[1]-15, location[2], location[3]+6},
                {location[1]-15, location[2], location[3]-6},
                {location[1]-6, location[2], location[3]-15},
                {location[1]+6, location[2], location[3]-15},
            }
            local ppoint = math.random(1, 8)
            local pointsleft = 8
            while pointsleft > 0 do
                IssuePatrol({self}, patroltable[ppoint])
                if ppoint < 8 then
                    ppoint = ppoint + 1
                else
                    ppoint = 1
                end
                pointsleft = pointsleft - 1
            end
       end
    end,

    OnDamage = function(self, instigator, amount, vector, damagetype)
        if self.Dead == false then
            -- Base script for this script function was developed by Gilbot_x
            -- sets the damage resistance of the rebuilder bot to 30%
            -- local rebuilerBot_DLS = 0.3
            -- amount = math.ceil(amount*rebuilerBot_DLS)
        end
        if not self.Dead and instigator and IsUnit(instigator) and not instigator.Dead and not self.EvadeThread then
            self.EvadeThread = self:ForkThread(function()
                self:SetSpeedMult(2.0)
                self:SetAccMult(2.0)
                IssueClearCommands({self})
                IssueMove({self}, self.Parent:GetPosition())
                WaitSeconds(2)
                self:SetSpeedMult(1.0)
                self:SetAccMult(1.0)
                self.EvadeThread = nil
            end)
        end
        SConstructionUnit.OnDamage(self, instigator, amount, vector, damagetype)
    end,

    OnKilled = function(self, instigator, type, overkillRatio)

        -- Clears the current RebuilderBot commands if any
        IssueClearCommands({self})

        -- Notifies parent of RebuilderBot death and clears the dead unit from the parents table
        if not self.Parent.Dead then
            table.removeByValue(self.Parent.RepairDroneTable, self)
            self.Parent:NotifyOfRepairDroneDeath()
        end
        -- Final command to finish off the drones death event
        SConstructionUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

    LaunchEffects = function(self)
        -- Are we dead?
        if not self.Dead then
            -- Force patrol order
            self:ForkThread(self.Patrolplatform, true)
            -- Attaches effects to drone during launch
            table.insert(self.LaunchExhaustEffectsBag, CreateAttachedEmitter(self, 'XSA0002', self:GetArmy(), self.ExhaustLaunch01))
            table.insert(self.LaunchExhaustEffectsBag, CreateAttachedEmitter(self, 'XSA0002', self:GetArmy(), self.ExhaustLaunch02))
            table.insert(self.LaunchExhaustEffectsBag, CreateAttachedEmitter(self, 'XSA0002', self:GetArmy(), self.ExhaustLaunch03))
            table.insert(self.LaunchExhaustEffectsBag, CreateAttachedEmitter(self, 'XSA0002', self:GetArmy(), self.ExhaustLaunch04))
            table.insert(self.LaunchExhaustEffectsBag, CreateAttachedEmitter(self, 'XSA0002', self:GetArmy(), self.ExhaustLaunch05))
            WaitSeconds(2.5)
            EffectUtil.CleanupEffectBag(self,'LaunchExhaustEffectsBag')
        end
    end,
}

TypeClass = BSA0002
