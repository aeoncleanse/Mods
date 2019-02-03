local oldACUUnit = ACUUnit

ACUUnit = Class(oldACUUnit) {
    -- Hooked functions
    OnCreate = function(self)
        oldACUUnit.OnCreate(self)

        self:SetCapturable(false)
        self:SetupBuildBones()
        self:DoWarpInEffects(false)

        -- Restrict things that enhancements will enable later
        self:AddBuildRestriction(categories[self.factionCategory] * (categories.BUILTBYTIER2COMMANDER + categories.BUILTBYTIER3COMMANDER + categories.BUILTBYTIER4COMMANDER))
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        oldACUUnit.OnStopBeingBuilt(self, builder, layer)

        local exclude = {
            DeathWeapon = true,
            TargetPainter = true,
            OverCharge = true,
            AutoOverCharge = true,
        }

        for k, v in self.Weapons do
            if k ~= self.RightGunLabel and not exclude[k] then
                self:SetWeaponEnabledByLabel(k, false)
            end
        end

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
    DoWarpInEffects = function(self, fake)
        local bp = self:GetBlueprint()

        for _, v in bp.Display.WarpInEffect.HideBones do
            self:HideBone(v, true)
        end

        if fake then
            unit:SetMesh(self.FakeWarpMesh, true)
            unit:ShowBone(0, true)
        end
    end,

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

        local range = self:GetWeaponByLabel(self.RightGunLabel):GetBlueprint().MaxRadius
        for _, new in self.PainterRange do
            range = math.max(range, new)
        end

        local wep = self:GetWeaponByLabel('TargetPainter')
        wep:ChangeMaxRadius(range)
    end,

    TogglePrimaryGun = function(self, damage, radius)
        local wep = self:GetWeaponByLabel(self.RightGunLabel)
        local oc = self:GetWeaponByLabel('OverCharge')
        local aoc = self:GetWeaponByLabel('AutoOverCharge')

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
                self:ShowBone(self.RightGunBone, true)
            else
                self:HideBone(self.RightGunBone, true)
            end
        end

        self:SetPainterRange(self.RightGunUpgrade, radius)
    end,
}
