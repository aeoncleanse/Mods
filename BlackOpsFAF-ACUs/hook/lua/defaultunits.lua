local oldACUUnit = ACUUnit

ACUUnit = Class(oldACUUnit) {
    -- Hooked functions
    OnStopBeingBuilt = function(self, builder, layer)
        oldACUUnit.OnStopBeingBuilt(self, builder, layer)

        self:SetupWeapons()

        self:ForkThread(self.GiveInitialResources)
    end,

    OnStartBuild = function(self, unitBeingBuilt, order)
        oldACUUnit.OnStartBuild(self, unitBeingBuilt, order)
        self.UnitBuildOrder = order
    end,

    OnTransportDetach = function(self, attachBone, unit)
        oldACUUnit.OnTransportDetach(self, attachBone, unit)

        self:StopSiloBuild()
    end,

    updateBuildRestrictions = function(self)
        local aiBrain = self:GetAIBrain()

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
        for _, researchType in ipairs({categories.LAND, categories.AIR, categories.NAVAL}) do
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

    -- New Functions
    SetProduction = function(self, bp)
        local energy = bp.ProductionPerSecondEnergy or 0
        local mass = bp.ProductionPerSecondMass or 0

        local bpEcon = self:GetBlueprint().Economy

        self:SetProductionPerSecondEnergy(energy + bpEcon.ProductionPerSecondEnergy or 0)
        self:SetProductionPerSecondMass(mass + bpEcon.ProductionPerSecondMass or 0)
    end,

    -- Target painter. 0 damage as primary weapon, controls targeting
    -- for the variety of changing ranges on the ACU with upgrades.
    SetPainterRange = function(self, enh, newRange)
        self.PainterRange[enh] = newRange

        local range = self.MainGun:GetBlueprint().MaxRadius
        for _, new in self.PainterRange do
            range = math.max(range, new)
        end

        self.TargetPainter:ChangeMaxRadius(range)
    end,

    -- Resets range to blueprint when radius is nil
    -- Called with negative damage when removing an enhancement
    TogglePrimaryGun = function(self, damage, radius)
        local wep = self.MainGun
        local oc = self.OverCharge
        local aoc = self.AutoOverCharge

        local wepRadius = radius or wep:GetBlueprint().MaxRadius
        local ocRadius = radius or oc:GetBlueprint().MaxRadius
        local aocRadius = radius or aoc:GetBlueprint().MaxRadius

        -- Change Damage
        wep:AddDamageMod(damage)

        -- Change Radius
        wep:ChangeMaxRadius(wepRadius)
        oc:ChangeMaxRadius(ocRadius)
        aoc:ChangeMaxRadius(aocRadius)

        -- Show or hide bones if needed
        if self.RightGunBone then
            -- As radius is only passed when turning on, use the bool
            if radius then
                self:ShowBones({self.RightGunBone}, true)
            else
                self:HideBones({self.RightGunBone}, true)
            end
        end

        self:SetPainterRange(self.RightGunUpgrade, radius)
    end,

    SetupWeapons = function(self)
        local exclude = {
            DeathWeapon = true,
            TargetPainter = true,
            OverCharge = true,
            AutoOverCharge = true
        }
        exclude[self.RightGunLabel] = true

        for name, v in self.Weapons do
            local wep = self:GetWeaponByLabel(name)

            if name == self.RightGunLabel then
                self.MainGun = wep
            else
                self[name] = wep
            end

            if not exclude[name] then
                self[name]:SetWeaponEnabled(false)
            end
        end
    end,
}
