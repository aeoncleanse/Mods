local oldACUUnit = ACUUnit

ACUUnit = Class(oldACUUnit) {    
    updateBuildRestrictions = function(self)
        local aiBrain = self:GetAIBrain()

        -- Sanity check.
        if not self.FactionCategory then
            return
        end

        self:AddBuildRestriction(categories.SUPPORTFACTORY)
        
        local upgradeNames = {
            'ImprovedEngineering',
            'CombatEngineering',
            'AdvancedEngineering',
            'ExperimentalEngineering',
            'AssaultEngineering',
            'ApocalypticEngineering'
        }

        -- Check for the existence of HQs
        for i, researchType in ipairs({categories.LAND, categories.AIR, categories.NAVAL}) do
            -- If there is a research station of the appropriate type, enable support factory construction
            for id, unit in aiBrain:GetListOfUnits(categories.RESEARCH * categories.TECH2 * self.FactionCategory * researchType, false, true) do
                if not unit.Dead and not unit:IsBeingBuilt() then
                    for key, title in upgradeNames do
                        if self:HasEnhancement(title) then
                            self:RemoveBuildRestriction(categories.TECH2 * categories.SUPPORTFACTORY * self.FactionCategory * researchType)
                            break
                        end
                    end
                    break
                end
            end
            for id, unit in aiBrain:GetListOfUnits(categories.RESEARCH * categories.TECH3 * self.FactionCategory * researchType, false, true) do
                if not unit.Dead and not unit:IsBeingBuilt() then
                    -- Special case for the commander, since its engineering upgrades are implemented using build restrictions
                    for key, title in upgradeNames do
                        if key <= 2 and self:HasEnhancement(title) then
                            self:RemoveBuildRestriction(categories.TECH2 * categories.SUPPORTFACTORY * self.FactionCategory * researchType)
                        elseif key > 2 and self:HasEnhancement(title) then
                            self:RemoveBuildRestriction(categories.TECH2 * categories.SUPPORTFACTORY * self.FactionCategory * researchType)
                            self:RemoveBuildRestriction(categories.TECH3 * categories.SUPPORTFACTORY * self.FactionCategory * researchType)
                            break
                        end
                    end
                    break
                end
            end
        end
    end,
}
