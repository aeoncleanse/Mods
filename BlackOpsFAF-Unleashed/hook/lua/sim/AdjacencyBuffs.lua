--****************************************************************************
--**
--**  File     :  /lua/sim/AdjacencyBuffs.lua
--**
--**  Copyright © 2008 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

local AdjBuffFuncs = import('/lua/sim/AdjacencyBuffFunctions.lua')

local adj = {          -- SIZE4     SIZE8   SIZE12    SIZE16   SIZE20

    T3MassEnergyStorage={
        EnergyProduction=   {0.125, 0.0625, 0.041667, 0.03125, 0.025},
        MassProduction=     {0.125, 0.0625, 0.041667, 0.03125, 0.025},
    },
}

for a, buffs in adj do
    _G[a .. 'AdjacencyBuffs'] = {}
    for t, sizes in buffs do
        for i, add in sizes do
            local size = i * 4
            local display_name = a .. t
            local name = display_name .. 'Size' .. size

            BuffBlueprint {
                Name = name,
                DisplayName = display_name,
                BuffType = string.upper(t) .. 'BONUS',
                Stacks = 'ALWAYS',
                Duration = -1,
                EntityCategory = 'STRUCTURE SIZE' .. size,
                BuffCheckFunction = AdjBuffFuncs[t .. 'BuffCheck'],
                OnBuffAffect = AdjBuffFuncs.DefaultBuffAffect,
                OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
                Affects = {[t]={Add=add}},
            }

            table.insert(_G[a .. 'AdjacencyBuffs'], name)
        end
    end
end
