local oldACUUnit = ACUUnit
ACUUnit = Class(oldACUUnit) {

    -- Called when this unit kills another. Chiefly responsible for the veterancy system for now.
    OnKilledUnit = function(self, unitKilled, massKilled)
        if not massKilled then return end -- Make sure engine calls aren't passed with massKilled == 0
        
        if not IsAlly(self:GetArmy(), unitKilled:GetArmy()) then
        
            -- Adjust mass based on unit killed for ACU
            local techIndex = function()
                for k, tech in pairs({'TECH1', 'TECH2', 'TECH3', 'EXPERIMENTAL', 'COMMAND'}) do
                    if tech == unitKilled.techLevel then return k end
                end
            end
            massKilled = massKilled / techIndex()

            self:CalculateVeterancyLevel(massKilled) -- Bails if we've not gone up
        end
    end,
}
    
local oldAirUnit = AirUnit
AirUnit = Class(oldAirUnit) {
    --- Called when the unit is killed, but before it falls out of the sky and blows up.
    OnKilled = function(self, instigator, type, overkillRatio)
        local bp = self:GetBlueprint()

        -- A completed, flying plane expects an OnImpact event due to air crash.
        -- An incomplete unit in the factory still reports as being in layer "Air", so needs this
        -- stupid check.
        if self:GetCurrentLayer() == 'Air' and self:GetFractionComplete() == 1  then
            self.Dead = true
            self.CreateUnitAirDestructionEffects(self, 1.0)
            self:DestroyTopSpeedEffects()
            self:DestroyBeamExhaust()
            self.OverKillRatio = overkillRatio
            self:PlayUnitSound('Killed')
            self:DoUnitCallbacks('OnKilled')
            self:DisableShield()
            
            if instigator and IsUnit(instigator) then
                instigator:OnKilledUnit(self)
            end
            
            if instigator and self.totalDamageTaken ~= 0 then
                self:VeterancyDispersal()
            end
        else
            self.DeathBounce = 1
            MobileUnit.OnKilled(self, instigator, type, overkillRatio)
        end
    end,
}