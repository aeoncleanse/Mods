local oldACUUnit = ACUUnit

ACUUnit = Class(oldACUUnit) {
    BuildDisable = function(self)
        while self:IsUnitState('Building') or self:IsUnitState('Enhancing') or self:IsUnitState('Upgrading') or
                self:IsUnitState('Repairing') or self:IsUnitState('Reclaiming') do
            WaitSeconds(0.5)
        end

        for k, v in self.WeaponEnabled do
            if v then
                self:SetWeaponEnabledByLabel(k, true, true)
            end
        end
    end,
    
    -- Store weapon status on upgrade. Ignore default and OC, which are dealt with elsewhere
    SetWeaponEnabledByLabel = function(self, label, enable, lockOut)
        oldACUUnit.SetWeaponEnabledByLabel(self, label, enable)
        
        if label ~= self.rightGunLabel and label ~= 'OverCharge' and label ~= 'AutoOverCharge' and not lockOut then
            self.WeaponEnabled[label] = enable
        end
    end,

    OnStartBuild = function(self, unitBeingBuilt, order)
        oldACUUnit.OnStartBuild(self, unitBeingBuilt, order)

        -- Disable any active upgrade weapons
        local fork = false
        for k, v in self.WeaponEnabled do
            if v then
                self:SetWeaponEnabledByLabel(k, false, true)
                fork = true
            end
        end

        if fork then
            self:ForkThread(self.BuildDisable)
        end
    end,
    
    updateBuildRestrictions = function(self)
        local faction = nil
        local type = nil
        local techlevel = nil

        --Defines the unit's faction
        if EntityCategoryContains(categories.AEON, self) then
            faction = categories.AEON
        elseif EntityCategoryContains(categories.UEF, self) then
            faction = categories.UEF
        elseif EntityCategoryContains(categories.CYBRAN, self) then
            faction = categories.CYBRAN
        elseif EntityCategoryContains(categories.SERAPHIM, self) then
            faction = categories.SERAPHIM
        end

        --Defines the unit's layer type
        if EntityCategoryContains(categories.LAND, self) then
            type = categories.LAND
        elseif EntityCategoryContains(categories.AIR, self) then
            type = categories.AIR
        elseif EntityCategoryContains(categories.NAVAL, self) then
            type = categories.NAVAL
        end

        local aiBrain = self:GetAIBrain()

        --Sanity check.
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