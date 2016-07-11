local multsTable = import('/lua/sim/BuffDefinitions.lua').MultsTable
local typeTable = import('/lua/sim/BuffDefinitions.lua').TypeTable

local oldUnit = Unit
Unit = Class(oldUnit) {
    OnCreate = function(self)
        self.Instigators = {}
        self.totalDamageTaken = 0
        self.techLevel = self:FindTechLevel()
        oldUnit.OnCreate(self)
    end,
    
    DoTakeDamage = function(self, instigator, amount, vector, damageType)
        -- Keep track of instigators, but only if it is a unit
        if instigator and IsUnit(instigator) then
            self.Instigators[instigator] = (self.Instigators[instigator] or 0) + amount
            self.totalDamageTaken = self.totalDamageTaken + amount
        end
        oldUnit.DoTakeDamage(self, instigator, amount, vector, damageType)
    end,
    
    OnKilled = function(self, instigator, type, overkillRatio)
        self.Dead = true
        if instigator and self.totalDamageTaken ~= 0 then
            self:VeterancyDispersal()
        end
        oldUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
    
    -- This section contains functions used by the new veterancy system
    -------------------------------------------------------------------
    
    -- Tell any living instigators that they need to gain some veterancy
    VeterancyDispersal = function(unitKilled)
        local bp = unitKilled:GetBlueprint()
        local mass = bp.Economy.BuildCostMass
        
        -- Allow units to count for more or less than their real mass if needed.
        mass = mass * (bp.Veteran.ImportanceMult or 1)
        
        for k, damageDealt in unitKilled.Instigators do
            -- k should be a unit's entity ID
            if k and not k.Dead and k.Sync.VeteranLevel ~= 5 then
                -- Find the proportion of yourself that each instigator killed
                local massKilled = math.floor(mass * (damageDealt / unitKilled.totalDamageTaken))
                k:OnKilledUnit(unitKilled, massKilled)
            end
        end
    end,
    
    OnKilledUnit = function(self, unitKilled, massKilled)
        if not massKilled then return end -- Make sure engine calls aren't passed with massKilled == 0
        
        if unitKilled.Sync.VeteranLevel then
            massKilled = massKilled * (1 + (0.25 * math.max((unitKilled.Sync.VeteranLevel - self.Sync.VeteranLevel), 0)))
        end
        
        if not IsAlly(self:GetArmy(), unitKilled:GetArmy()) then
            self:CalculateVeterancyLevel(massKilled) -- Bails if we've not gone up
        end
    end,
    
    CalculateVeterancyLevel = function(self, massKilled, defaultMult)
        local bp = self:GetBlueprint()

        -- Total up the mass the unit has killed overall, and store it
        self.Sync.totalMassKilled = math.floor(self.Sync.totalMassKilled + massKilled)
        
        -- Calculate veterancy level. By default killing your own mass grants a level
        local newVetLevel = math.min(math.floor(self.Sync.totalMassKilled / self.Sync.myValue), 5)

        -- Bail if our veterancy hasn't increased
        if newVetLevel == self.Sync.VeteranLevel then
            return
        end
        
        -- Update our recorded veterancy level
        self.Sync.VeteranLevel = newVetLevel

        self:BuffVeterancy()
    end,
    
    BuffVeterancy = function(self)

        -- Create buffs
        local regenBuff = self:NewCreateVeterancyBuff(self.techLevel, 'VETERANCYREGEN', 'REPLACE', -1, 'Regen', 'Add')
        local healthBuff = self:NewCreateVeterancyBuff(self.techLevel, 'VETERANCYMAXHEALTH', 'REPLACE', -1, 'MaxHealth', 'Mult')
        
        -- Apply buffs
        Buff.ApplyBuff(self, regenBuff)
        Buff.ApplyBuff(self, healthBuff)
    end,
    
    NewCreateVeterancyBuff = function(self, techLevel, buffType, stacks, buffDuration, effectType, mathType)
        -- Generate a buffName based on the unit's tech level. This way, once we generate it once,
        -- We can just apply it for any future unit which fits.
        -- Example: TECH1VETERANCYREGEN1
        local vetLevel = self.Sync.VeteranLevel
        
        local buffName = false
        local subSection = false
        if buffType == 'VETERANCYREGEN' then
            subSection = typeTable[self:GetUnitId()] -- Will be 1 through 6
            buffName = techLevel .. subSection .. buffType .. vetLevel
        else
            buffName = techLevel .. buffType .. vetLevel
        end
        
        -- Bail out if it already exists
        if Buffs[buffName] then
            return buffName
        end
        
        -- Each buffType should only ever be allowed to add OR mult, not both.
        local val = 1
        if buffType == 'VETERANCYMAXHEALTH' then
            val = 1 + ((multsTable[buffType][techLevel] - 1) * vetLevel)
        else
            if subSection == 1 or subSection == 3 then -- Combat or Ship
                val = multsTable[buffType][techLevel][subSection][vetLevel]
            elseif subSection == 2 or subSection == 4 then -- Raider or Sub
                val = multsTable[buffType][techLevel][subSection] * vetLevel
            elseif subSection == 5 then -- Experimental or sACU
                val = multsTable[buffType][techLevel][vetLevel]
            else -- ACU
                val = multsTable[buffType][techLevel] * vetLevel
            end
        end

        -- This creates a buff into the global bufftable
        -- First, we need to create the Affects section
        local affects = {}
        affects[effectType] = {
            DoNotFill = effectType == 'MaxHealth',
            Add = 0,
            Mult = 0,
        }
        affects[effectType][mathType] = val
        
        -- Then fill in the main, global table
        BuffBlueprint {
            Name = buffName,
            DisplayName = buffName,
            BuffType = buffType,
            Stacks = stacks,
            Duration = buffDuration,
            Affects = affects,
        }
        
        -- Return the buffname so the buff can be applied to the unit
        return buffName
    end,
    
    FindTechLevel = function(self)
        for k, cat in pairs({'TECH1', 'TECH2', 'TECH3', 'EXPERIMENTAL', 'COMMAND', 'SUBCOMMANDER'}) do
            if EntityCategoryContains(ParseEntityCategory(cat), self) then return cat end
        end
    end,
    
    OnStopBeingBuilt = function(self, builder, layer)        
        -- Set up Veterancy tracking here. Avoids needing to check completion later.
        -- Do all this here so we only have to do for things which get completed        
        -- Don't need to track damage for things which cannot attack!
        if typeTable[self:GetUnitId()] then
            local bp = self:GetBlueprint()
            self.Sync.totalMassKilled = 0
            self.Sync.VeteranLevel = 0
            
            -- Allow units to require more or less mass to level up. Decimal multipliers mean
            -- faster leveling, >1 mean slower. Doing this here means doing it once instead of every kill.
            local defaultMult = 1.25
            self.Sync.myValue = math.floor(bp.Economy.BuildCostMass * (bp.Veteran.RequirementMult or defaultMult))
        end
        oldUnit.OnStopBeingBuilt(self, builder, layer)
    end,
}