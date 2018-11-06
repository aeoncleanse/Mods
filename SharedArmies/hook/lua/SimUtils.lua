
function ForceTransferUnit(unit, ToArmyIndex) -- This is a rough copy of TransferUnitsOwnership but it's different so be careful using it
    local toBrain = GetArmyBrain(ToArmyIndex)
    local fromBrain = GetArmyBrain(unit:GetArmy())

    local bp = unit:GetBlueprint()
    local unitId = unit:GetUnitId()

    -- B E F O R E
    local numNukes = unit:GetNukeSiloAmmoCount()  -- looks like one of these 2 works for SMDs also
    local numTacMsl = unit:GetTacticalSiloAmmoCount()
    local xp = unit.xp
    local unitHealth = unit:GetHealth()
    local shieldIsOn = false
    local ShieldHealth = 0
    local hasFuel = false
    local fuelRatio = 0
    local enh = {} -- enhancements

    local position = unit:GetPosition()
    local orientation = unit:GetOrientation()
    local name = "Name transfer doesn't work."

    if unit.MyShield then
        shieldIsOn = unit:ShieldIsOn()
        ShieldHealth = unit.MyShield:GetHealth()
    end
    if bp.Physics.FuelUseTime and bp.Physics.FuelUseTime > 0 then   -- going through the BP to check for fuel
        fuelRatio = unit:GetFuelRatio()                             -- usage is more reliable then unit.HasFuel
        hasFuel = true                                              -- cause some buildings say they use fuel
    end
    local posblEnh = bp.Enhancements
    if posblEnh then
        for k, v in posblEnh do
            if unit:HasEnhancement(k) then
               table.insert(enh, k)
            end
        end
    end

    unit.IsBeingTransferred = true

    -- changing owner
    local oldUnit = unit
    unit:Destroy()

    unit = CreateUnit(unitId, ToArmyIndex, position[1], position[2], position[3], orientation[1], orientation[2], orientation[3], orientation[4])
    if not unit then
        return nil
    end

    -- A F T E R
    if name then
        unit:SetCustomName(name)
    end

    if xp and xp > 0 then
        unit:AddXP(xp)
    end
    if enh and table.getn(enh) > 0 then
        for k, v in enh do
            unit:CreateEnhancement(v)
        end
    end
    if unitHealth > unit:GetMaxHealth() then
        unitHealth = unit:GetMaxHealth()
    end
    unit:SetHealth(unit,unitHealth)
    if hasFuel then
        unit:SetFuelRatio(fuelRatio)
    end
    if numNukes and numNukes > 0 then
        unit:GiveNukeSiloAmmo((numNukes - unit:GetNukeSiloAmmoCount()))
    end
    if numTacMsl and numTacMsl > 0 then
        unit:GiveTacticalSiloAmmo((numTacMsl - unit:GetTacticalSiloAmmoCount()))
    end
    if unit.MyShield then
        unit.MyShield:SetHealth(unit, ShieldHealth)
        if shieldIsOn then
            unit:EnableShield()
        else
            unit:DisableShield()
        end
    end
    if EntityCategoryContains(categories.ENGINEERSTATION, unit) then
        unit:SetPaused(true)
    end

    unit.IsBeingTransferred = false

    oldUnit:OnGiven(unit)

    if EntityCategoryContains(categories.RESEARCH, unit) then
        for _,aiBrain in {fromBrain, toBrain} do
            local buildRestrictionVictims = aiBrain:GetListOfUnits(categories.FACTORY + categories.ENGINEER, false)
            for _, victim in buildRestrictionVictims do
                victim:updateBuildRestrictions()
            end
        end
    end

    return unit
end

function TransferEverything(toArmy, fromArmy)
    local fromBrain = GetArmyBrain(fromArmy)
    local toBrain = GetArmyBrain(toArmy)
    if fromBrain:IsDefeated() or toBrain:IsDefeated() then
        return false
    end

    -- Take resources before transferring storage
    local massTaken = fromBrain:TakeResource('Mass', fromBrain:GetEconomyStored('Mass'))
    local energyTaken = fromBrain:TakeResource('Energy', fromBrain:GetEconomyStored('Energy'))

    LOG("Transferring "..GetArmyUnitCap(fromArmy).." unit cap.")
    SetArmyUnitCap(toArmy, GetArmyUnitCap(toArmy) + GetArmyUnitCap(fromArmy))

    -- Change who any transferred units will return to if their owner is defeated
    if sharedUnits[fromArmy] and table.getn(sharedUnits[fromArmy]) > 0 then
        if not sharedUnits[toArmy] then
            sharedUnits[toArmy] = {}
        end

        for _, unit in sharedUnits[fromArmy] do
            if unit.oldowner == fromArmy then
                unit.oldowner = toArmy
                table.insert(sharedUnits[toArmy], unit)
            end
        end
    end

    -- Transfer all units that can be transferred right now
    local oldUnits = fromBrain:GetListOfUnits(categories.ALLUNITS - categories.COMMAND, false)
    LOG("Transferring "..table.getn(oldUnits).." units.")
    local newUnits = TransferUnitsOwnership(oldUnits, toArmy)
    LOG("Successfully transferred "..table.getn(newUnits or {}).." units.")
    if newUnits then
        for _, unit in newUnits do
            if unit.oldowner == fromArmy then
                unit.oldowner = nil
            end
        end
    end
    sharedUnits[fromArmy] = {}

    -- Some units may not be transferred, most likely because they're in the process of being captured
    -- We'll find those and set up a callback to transfer them immediately if the capture attempt fails
    for _, unit in oldUnits do
        if unit.CaptureProgress > 0 then

            unit:AddUnitCallback(function(self, captor)
                if self:GetArmy() == fromArmy then
                    local newUnit = TransferUnitsOwnership(self, toArmy)
                    if newUnit then
                        for _, unit in newUnit do
                            if unit.oldowner == fromArmy then
                                unit.oldowner = nil
                            end
                        end
                    end
                end
            end, 'OnFailedBeingCaptured')

        end
    end

    -- ACUs can't be transferred normally so we have to do things manually
    local commandUnits = fromBrain:GetListOfUnits(categories.COMMAND, false)
    for _, unit in commandUnits do
        unit:Destroy()
        --ForceTransferUnit(unit, toArmy)
    end

    SetArmyUnitCap(fromArmy, 0)

    -- Give toArmy the resources now that they have all of fromArmy's storage
    --LOG("Transferring "..massTaken.." mass and "..energyTaken.." energy.")
    --toBrain:GiveResource('Mass', massTaken)
    --toBrain:GiveResource('Energy', energyTaken)

    return true
end
