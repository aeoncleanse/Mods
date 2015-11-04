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