
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
    local oldUnits = fromBrain:GetListOfUnits(categories.ALLUNITS, false)
    LOG("Transferring "..table.getn(oldUnits).." units.")
    local newUnits = TransferUnitsOwnership(oldUnits, toArmy)
    LOG("Successfully transferred "..table.getn(newUnits).." units.")
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

    SetArmyUnitCap(fromArmy, 0)

    -- Give toArmy the resources now that they have all of fromArmy's storage
    LOG("Transferring "..massTaken.." mass and "..energyTaken.." energy.")
    toBrain:GiveResource('Mass', massTaken)
    toBrain:GiveResource('Energy', energyTaken)

    return true
end
