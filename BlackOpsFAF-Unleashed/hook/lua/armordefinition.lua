newStructure = {   
    -- Armor Type Name
    'Structure',

    -- Armor Definition
    'Normal 1.0',
    'Overcharge 0.066666',
    'Deathnuke 0.032',
    'Fire 2.5',
}

function hookInsert(newTable)
    for key, armorTable in armordefinition do
        for index, str in armorTable do
            if newTable[1] == str then
                armordefinition[key] = newTable
                break
            end
        end
    end
end

do

hookInsert(newStructure)

end
