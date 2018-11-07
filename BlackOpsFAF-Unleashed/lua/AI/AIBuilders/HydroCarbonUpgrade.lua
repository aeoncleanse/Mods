
local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'

BuilderGroup {
    BuilderGroupName = 'BO-HydroCarbonUpgrade',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'BO1 HydroUpgrade',
        PlatoonTemplate = 'T1PowerHydroUpgrade',
        Priority = 200,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.HYDROCARBON * categories.ENERGYPRODUCTION * categories.TECH1 } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.HYDROCARBON * categories.ENERGYPRODUCTION * categories.TECH2 } },
            { EBC, 'GreaterThanEconIncome', { 2, 10 } },
            { EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'BO2 HydroUpgrade',
        PlatoonTemplate = 'T2PowerHydroUpgrade',
        Priority = 200,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.HYDROCARBON * categories.ENERGYPRODUCTION * categories.TECH1 } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.HYDROCARBON * categories.ENERGYPRODUCTION * categories.TECH2 } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.HYDROCARBON * categories.ENERGYPRODUCTION * categories.TECH3 } },
            { EBC, 'GreaterThanEconIncome', { 2.6, 60 } },
            { EBC, 'GreaterThanEconTrend', { 0.0, 0.0 } },
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
}