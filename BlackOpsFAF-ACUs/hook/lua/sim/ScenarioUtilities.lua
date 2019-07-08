OldCreateArmyUnit = CreateArmyUnit

function CreateArmyUnit(strArmy, strUnit)
    local map = {
        ual0001 = 'eal0001',
        uel0001 = 'eel0001',
        url0001 = 'erl0001',
        usl0001 = 'esl0001'
    }
    OldCreateArmyUnit(strArmy, map[strUnit])
end