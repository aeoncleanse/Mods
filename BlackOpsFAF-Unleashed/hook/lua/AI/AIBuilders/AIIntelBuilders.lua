

-- LandScoutFormBuilders are used from all basetemplates. Perfect for hooking
BuilderGroup {
    BuilderGroupName = 'LandScoutFormBuilders',
    BuildersType = 'PlatoonFormBuilder',
    -- Hydrocarbon Power Plant upgrade START -----------------------------------------
    Builder {
        BuilderName = 'T1 HydroUpgrade',
        PlatoonTemplate = 'T1PowerHydroUpgrade',
        Priority = 200,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.HYDROCARBON * categories.ENERGYPRODUCTION * categories.TECH1 } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.HYDROCARBON * categories.ENERGYPRODUCTION * categories.TECH2 } },
            { EBC, 'GreaterThanEconIncome', { 2, 10 } },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0, 0 }},
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'T2 HydroUpgrade',
        PlatoonTemplate = 'T2PowerHydroUpgrade',
        Priority = 200,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.HYDROCARBON * categories.ENERGYPRODUCTION * categories.TECH1 } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.HYDROCARBON * categories.ENERGYPRODUCTION * categories.TECH2 } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.HYDROCARBON * categories.ENERGYPRODUCTION * categories.TECH3 } },
            { EBC, 'GreaterThanEconIncome', { 2.6, 60 } },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0, 0 }},
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
    -- Hydrocarbon Power Plant upgrade END -------------------------------------------
    Builder {
        BuilderName = 'T1 Land Scout Form',
        BuilderConditions = {
            #{ UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.FACTORY * categories.LAND - categories.TECH1 }},
        },
        PlatoonTemplate = 'T1LandScoutForm',
        Priority = 725,
        InstanceCount = 3,
        LocationType = 'LocationType',
        BuilderType = 'Any',
    },
}