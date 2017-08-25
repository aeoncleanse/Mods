function CreateArmyUnit(strArmy,strUnit)
    local tblUnit = FindUnit(strUnit,Scenario.Armies[strArmy].Units)
    local brain = GetArmyBrain(strArmy)
    local IDs = {'ual0001', 'uel0001', 'url0001', 'xsl0001'}
    local armyIndex = brain:GetArmyIndex()

    if not brain.IgnoreArmyCaps then
        SetIgnoreArmyUnitCap(armyIndex, true)
    end

    if nil ~= tblUnit then
        if brain.BrainType == 'Human' then
            for _, v in IDs do
                if string.sub(tblUnit.type, 1, 7) == v then
                    tblUnit.type = 'e' .. string.sub(v, 2)
                end
            end
        end

        local unit = CreateUnitHPR(
            tblUnit.type,
            strArmy,
            tblUnit.Position[1], tblUnit.Position[2], tblUnit.Position[3],
            tblUnit.Orientation[1], tblUnit.Orientation[2], tblUnit.Orientation[3]
        )

        if unit:GetBlueprint().Physics.FlattenSkirt then
            unit:CreateTarmac(true, true, true, false, false)
        end

        local platoon
        if tblUnit.platoon ~= nil and tblUnit.platoon ~= '' then
            local i = 3
            while i <= table.getn(Scenario.Platoons[tblUnit.platoon]) do
                if tblUnit.Type == currTemplate[i][1] then
                    platoon = brain:MakePlatoon('None', 'None')
                    brain:AssignUnitsToPlatoon(platoon, {unit}, currTemplate[i][4], currTemplate[i][5])
                    break
                end
                i = i + 1
            end
        end

        if ScenarioInfo.UnitNames[armyIndex] then
            ScenarioInfo.UnitNames[armyIndex][strUnit] = unit
        end
        unit.UnitName = strUnit

        if not brain.IgnoreArmyCaps then
            SetIgnoreArmyUnitCap(armyIndex, false)
        end

        return unit, platoon, tblUnit.platoon
    end

    if not brain.IgnoreArmyCaps then
        SetIgnoreArmyUnitCap(armyIndex, false)
    end

    return nil
end