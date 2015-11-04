local oldAIBrain = AIBrain
AIBrain = Class(oldAIBrain) {
    CalculateScore = function(self)
        local commanderKills = self:GetArmyStat("Enemies_Commanders_Destroyed",0).Value
        local massSpent = self:GetArmyStat("Economy_TotalConsumed_Mass",0.0).Value
        local massProduced = self:GetArmyStat("Economy_TotalProduced_Mass",0.0).Value -- not currently being used
        local energySpent = self:GetArmyStat("Economy_TotalConsumed_Energy",0.0).Value
        local energyProduced = self:GetArmyStat("Economy_TotalProduced_Energy",0.0).Value -- not currently being used
        local massValueDestroyed = self:GetArmyStat("Enemies_MassValue_Destroyed",0.0).Value
        local massValueLost = self:GetArmyStat("Units_MassValue_Lost",0.0).Value
        local energyValueDestroyed = self:GetArmyStat("Enemies_EnergyValue_Destroyed",0.0).Value
        local energyValueLost = self:GetArmyStat("Units_EnergyValue_Lost",0.0).Value

        -- helper variables to make equation more clear
        local excessMassProduced = massProduced - massSpent -- not currently being used
        local excessEnergyProduced = energyProduced - energySpent -- not currently being used
        local energyValueCoefficient = 20
        local commanderKillBonus = commanderKills + 1 -- not currently being used

        -- score components calculated
        local resourceProduction = ((massSpent) + (energySpent / energyValueCoefficient)) / 2
        local battleResults = (((massValueDestroyed - massValueLost- (commanderKills * 1000)) + ((energyValueDestroyed - energyValueLost - (commanderKills * 5000000)) / energyValueCoefficient)) / 2)
        if battleResults < 0 then
            battleResults = 0
        end

        -- score calculated
        local score = math.floor(resourceProduction + battleResults + (commanderKills * 5000))

        return score
    end,
}
