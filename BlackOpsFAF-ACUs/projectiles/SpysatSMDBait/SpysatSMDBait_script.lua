-------------------
-- Dummy projectile
-------------------

local DummyArtemisCannonProjectile = import('/lua/sim/defaultprojectiles.lua').NullShell

SpysatSMDBait = Class(DummyArtemisCannonProjectile) {
    Parent = nil,

    DoTakeDamage = function(self, instigator, amount, vector, damageType)
        DummyArtemisCannonProjectile.DoTakeDamage(self, instigator, amount, vector, damageType)

        if not self.Parent.Dead then
            self.Parent:Kill()
        end
    end,

    OnCreate = function(self)
        DummyArtemisCannonProjectile.OnCreate(self)

        self:SetCollisionShape('Sphere', 0, 0, 0, 2.0)
        self.VerificationThread = self:ForkThread(self.Verification)
        self.KillThread = self:ForkThread(self.KillSelfThread)
    end,

    KillSelfThread = function(self)
        WaitSeconds(20)

        if not self.Parent.Dead then
            self.Parent:ProjSpawn()
        end
        self:Destroy()
    end,

    SetParent = function(self, parent, projName)
        self.Parent = parent
        self.Proj = projName
    end,

    Verification = function(self)
        while not self:BeenDestroyed() and not self.Parent.Dead do
            local unitLoc = self.Parent:GetPosition('Turret_Barrel_Muzzle')
            local projmod = unitLoc[2] - 1
            local destination = {unitLoc[1], projmod, unitLoc[3]}
            Warp(self, destination)
            WaitSeconds(1)
        end
    end,

    OnLostTarget = function(self)
    end,
}

TypeClass = SpysatSMDBait
