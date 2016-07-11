-- Merging in as mod

--Function to affect the unit.  Everytime you want to affect a new part of unit, add it in here.
--afterRemove is a bool that defines if this buff is affecting after the removal of a buff.
--We reaffect the unit to make sure that buff type is recalculated accurately without the buff that was on the unit.
--However, this doesn't work for stunned units because it's a fire-and-forget type buff, not a fire-and-keep-track-of type buff.
function BuffAffectUnit(unit, buffName, instigator, afterRemove)

    local buffDef = Buffs[buffName]

    local buffAffects = buffDef.Affects

    if buffDef.OnBuffAffect and not afterRemove then
        buffDef:OnBuffAffect(unit, instigator)
    end

    for atype, vals in buffAffects do

        if atype == 'Health' then
            --Note: With health we don't actually look at the unit's table because it's an instant happening.  We don't want to overcalculate something as pliable as health.

            local health = unit:GetHealth()
            local val = ((buffAffects.Health.Add or 0) + health) * (buffAffects.Health.Mult or 1)
            local healthadj = val - health

            if healthadj < 0 then
                -- fixme: DoTakeDamage shouldn't be called directly
                local data = {
                    Instigator = instigator,
                    Amount = -1 * healthadj,
                    Type = buffDef.DamageType or 'Spell',
                    Vector = VDiff(instigator:GetPosition(), unit:GetPosition()),
                }
                unit:DoTakeDamage(data)
            else
                unit:AdjustHealth(instigator, healthadj)
            end

        elseif atype == 'MaxHealth' then
            local unitbphealth = unit:GetBlueprint().Defense.MaxHealth or 1
            local val = BuffCalculate(unit, buffName, 'MaxHealth', unitbphealth)
            local oldmax = unit:GetMaxHealth()

            unit:SetMaxHealth(val)

            if not vals.DoNotFill then
                if val > oldmax then
                    unit:AdjustHealth(unit, val - oldmax)
                else
                    unit:SetHealth(unit, math.min(unit:GetHealth(), unit:GetMaxHealth()))
                end
            end
        elseif atype == 'Regen' then
            -- Adjusted to use a special case of adding mults and calculating the final value
            -- in BuffCalculate to fix bugs where adds and mults would clash or cancel
            local bpRegen = unit:GetBlueprint().Defense.RegenRate or 0
            local val = BuffCalculate(unit, nil, 'Regen', bpRegen)
            
            unit:SetRegen(val)
        elseif atype == 'Damage' then
            for i = 1, unit:GetWeaponCount() do
                local wep = unit:GetWeapon(i)
                if wep.Label ~= 'DeathWeapon' and wep.Label ~= 'DeathImpact' then
                    local wepbp = wep:GetBlueprint()
                    local wepdam = wepbp.Damage
                    local val = BuffCalculate(unit, buffName, 'Damage', wepdam)

                    if val >= ( math.abs(val) + 0.5 ) then
                        val = math.ceil(val)
                    else
                        val = math.floor(val)
                    end

                    wep:ChangeDamage(val)
                end
            end
        elseif atype == 'DamageRadius' then
            for i = 1, unit:GetWeaponCount() do

                local wep = unit:GetWeapon(i)
                local wepbp = wep:GetBlueprint()
                local weprad = wepbp.DamageRadius
                local val = BuffCalculate(unit, buffName, 'DamageRadius', weprad)

                wep:SetDamageRadius(val)
            end
        elseif atype == 'MaxRadius' then
            for i = 1, unit:GetWeaponCount() do

                local wep = unit:GetWeapon(i)
                local wepbp = wep:GetBlueprint()
                local weprad = wepbp.MaxRadius
                local val = BuffCalculate(unit, buffName, 'MaxRadius', weprad)

                wep:ChangeMaxRadius(val)
            end
        elseif atype == 'MoveMult' then
            local val = BuffCalculate(unit, buffName, 'MoveMult', 1)
            unit:SetSpeedMult(val)
            unit:SetAccMult(val)
            unit:SetTurnMult(val)
        elseif atype == 'Stun' and not afterRemove then
            unit:SetStunned(buffDef.Duration or 1, instigator)
            if unit.Anims then
                for k, manip in unit.Anims do
                    manip:SetRate(0)
                end
            end
        elseif atype == 'WeaponsEnable' then
            for i = 1, unit:GetWeaponCount() do
                local wep = unit:GetWeapon(i)
                local val, bool = BuffCalculate(unit, buffName, 'WeaponsEnable', 0, true)
                wep:SetWeaponEnabled(bool)
            end
        elseif atype == 'VisionRadius' then
            local val = BuffCalculate(unit, buffName, 'VisionRadius', unit:GetBlueprint().Intel.VisionRadius or 0)
            unit:SetIntelRadius('Vision', val)

        elseif atype == 'RadarRadius' then
            local val = BuffCalculate(unit, buffName, 'RadarRadius', unit:GetBlueprint().Intel.RadarRadius or 0)
            if not unit:IsIntelEnabled('Radar') then
                unit:InitIntel(unit:GetArmy(),'Radar', val)
                unit:EnableIntel('Radar')
            else
                unit:SetIntelRadius('Radar', val)
                unit:EnableIntel('Radar')
            end

            if val <= 0 then
                unit:DisableIntel('Radar')
            end
        elseif atype == 'OmniRadius' then
            local val = BuffCalculate(unit, buffName, 'OmniRadius', unit:GetBlueprint().Intel.RadarRadius or 0)
            if not unit:IsIntelEnabled('Omni') then
                unit:InitIntel(unit:GetArmy(),'Omni', val)
                unit:EnableIntel('Omni')
            else
                unit:SetIntelRadius('Omni', val)
                unit:EnableIntel('Omni')
            end

            if val <= 0 then
                unit:DisableIntel('Omni')
            end
        elseif atype == 'BuildRate' then
            local val = BuffCalculate(unit, buffName, 'BuildRate', unit:GetBlueprint().Economy.BuildRate or 1)
            unit:SetBuildRate( val )
        -------- ADJACENCY BELOW --------
        elseif atype == 'EnergyActive' then
            local val = BuffCalculate(unit, buffName, 'EnergyActive', 1)
            unit.EnergyBuildAdjMod = val
            unit:UpdateConsumptionValues()
        elseif atype == 'MassActive' then
            local val = BuffCalculate(unit, buffName, 'MassActive', 1)
            unit.MassBuildAdjMod = val
            unit:UpdateConsumptionValues()
        elseif atype == 'EnergyMaintenance' then
            local val = BuffCalculate(unit, buffName, 'EnergyMaintenance', 1)
            unit.EnergyMaintAdjMod = val
            unit:UpdateConsumptionValues()
        elseif atype == 'MassMaintenance' then
            local val = BuffCalculate(unit, buffName, 'MassMaintenance', 1)
            unit.MassMaintAdjMod = val
            unit:UpdateConsumptionValues()
        elseif atype == 'EnergyProduction' then
            local val = BuffCalculate(unit, buffName, 'EnergyProduction', 1)
            unit.EnergyProdAdjMod = val
            unit:UpdateProductionValues()
        elseif atype == 'MassProduction' then
            local val = BuffCalculate(unit, buffName, 'MassProduction', 1)
            unit.MassProdAdjMod = val
            unit:UpdateProductionValues()
        elseif atype == 'EnergyWeapon' then
            local val = BuffCalculate(unit, buffName, 'EnergyWeapon', 1)
            for i = 1, unit:GetWeaponCount() do
                local wep = unit:GetWeapon(i)
                if wep:WeaponUsesEnergy() then
                    wep.AdjEnergyMod = val
                end
            end
        elseif atype == 'RateOfFire' then
            local val = BuffCalculate(unit, buffName, 'RateOfFire', 1)

            for i = 1, unit:GetWeaponCount() do
                local wep = unit:GetWeapon(i)
                local bp = wep:GetBlueprint()
                -- Set new rate of fire based on blueprint rate of fire
                wep:ChangeRateOfFire(bp.RateOfFire / val)
                wep.AdjRoFMod = val
            end
        elseif atype ~= 'Stun' then
            WARN("*WARNING: Tried to apply a buff with an unknown affect type of " .. atype .. " for buff " .. buffName)
        end
    end
end

--Calculates the buff from all the buffs of the same time the unit has.
function BuffCalculate(unit, buffName, affectType, initialVal, initialBool)
    local adds = 0
    local mults = 1.0
    local multsTotal = 0 -- Used only for regen buffs
    local bool = initialBool or false

    if not unit.Buffs.Affects[affectType] then return initialVal, bool end

    for k, v in unit.Buffs.Affects[affectType] do
        if v.Add and v.Add ~= 0 then
            adds = adds + (v.Add * v.Count)
        end

        if v.Mult then
            if affectType == 'Regen' then
                -- Regen mults use MaxHp as base, so should always be <1
                
                -- If >1 it's probably deliberate, but silly, so let's bail. If it's THAT deliberate
                -- they will remove this
                if v.Mult > 1 then WARN('Regen mult too high, should be <1, for unit ' .. unit:GetUnitId() .. ' and buff ' .. buffName) return end
            
                -- GPG default for mult is 1. To avoid changing loads of scripts for now, let's do this
                if v.Mult ~= 1 then
                    local maxHealth = unit:GetBlueprint().Defense.MaxHealth
                    for i=1,v.Count do
                        multsTotal = multsTotal + math.min((v.Mult * maxHealth), v.Ceil or 999999)
                    end
                end
            else
                for i=1,v.Count do
                    mults = mults * v.Mult
                end
            end
        end

        if not v.Bool then
            bool = false
        else
            bool = true
        end
    end
    
    -- Adds are calculated first, then the mults.  May want to expand that later.
    local returnVal = false
    returnVal = (initialVal + adds + multsTotal) * mults

    return returnVal, bool
end
