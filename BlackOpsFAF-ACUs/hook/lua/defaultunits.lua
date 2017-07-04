local oldACUUnit = ACUUnit

ACUUnit = Class(oldACUUnit) {    
    updateBuildRestrictions = function(self)
        local faction = nil
        local type = nil
        local techlevel = nil

        -- Defines the unit's faction
        if EntityCategoryContains(categories.AEON, self) then
            faction = categories.AEON
        elseif EntityCategoryContains(categories.UEF, self) then
            faction = categories.UEF
        elseif EntityCategoryContains(categories.CYBRAN, self) then
            faction = categories.CYBRAN
        elseif EntityCategoryContains(categories.SERAPHIM, self) then
            faction = categories.SERAPHIM
        end

        -- Defines the unit's layer type
        if EntityCategoryContains(categories.LAND, self) then
            type = categories.LAND
        elseif EntityCategoryContains(categories.AIR, self) then
            type = categories.AIR
        elseif EntityCategoryContains(categories.NAVAL, self) then
            type = categories.NAVAL
        end

        local aiBrain = self:GetAIBrain()

        -- Sanity check.
        if not faction then
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
        for i,researchType in ipairs({categories.LAND, categories.AIR, categories.NAVAL}) do
            -- If there is a research station of the appropriate type, enable support factory construction
            for id, unit in aiBrain:GetListOfUnits(categories.RESEARCH * categories.TECH2 * faction * researchType, false, true) do
                if not unit.Dead and not unit:IsBeingBuilt() then
                    for key, title in upgradeNames do
                        if self:HasEnhancement(title) then
                            self:RemoveBuildRestriction(categories.TECH2 * categories.SUPPORTFACTORY * faction * researchType)
                            break
                        end
                    end
                    break
                end
            end
            for id, unit in aiBrain:GetListOfUnits(categories.RESEARCH * categories.TECH3 * faction * researchType, false, true) do
                if not unit.Dead and not unit:IsBeingBuilt() then
                    -- Special case for the commander, since its engineering upgrades are implemented using build restrictions
                    for key, title in upgradeNames do
                        if key <= 2 and self:HasEnhancement(title) then
                            self:RemoveBuildRestriction(categories.TECH2 * categories.SUPPORTFACTORY * faction * researchType)
                        elseif key > 2 and self:HasEnhancement(title) then
                            self:RemoveBuildRestriction(categories.TECH2 * categories.SUPPORTFACTORY * faction * researchType)
                            self:RemoveBuildRestriction(categories.TECH3 * categories.SUPPORTFACTORY * faction * researchType)
                            break
                        end
                    end
                    break
                end
            end
        end
    end,
}