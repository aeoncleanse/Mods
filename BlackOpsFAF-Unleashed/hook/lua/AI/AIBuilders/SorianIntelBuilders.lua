
-- SorianEngineerFactoryBuilders are used from all basetemplates. Perfect for hooking
BuilderGroup {
    BuilderGroupName = 'SorianLandScoutFormBuilders',
    BuildersType = 'PlatoonFormBuilder',
    -- Hydrocarbon Power Plant upgrade START -----------------------------------------
    Builder {
        BuilderName = 'Sorian T1 HydroUpgrade',
        PlatoonTemplate = 'T1PowerHydroUpgrade',
        Priority = 200,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.HYDROCARBON * categories.ENERGYPRODUCTION * categories.TECH1 } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.HYDROCARBON * categories.ENERGYPRODUCTION * categories.TECH2 } },
            { SIBC, 'GreaterThanEconIncome', { 2, 10 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0, 0 }},
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'Sorian T2 HydroUpgrade',
        PlatoonTemplate = 'T2PowerHydroUpgrade',
        Priority = 200,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.HYDROCARBON * categories.ENERGYPRODUCTION * categories.TECH1 } },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.HYDROCARBON * categories.ENERGYPRODUCTION * categories.TECH2 } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.HYDROCARBON * categories.ENERGYPRODUCTION * categories.TECH3 } },
            { SIBC, 'GreaterThanEconIncome', { 2.6, 60 } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0, 0 }},
        },
        FormRadius = 10000,
        BuilderType = 'Any',
    },
    -- Hydrocarbon Power Plant upgrade END -------------------------------------------
    Builder {
        BuilderName = 'Sorian T1 Land Scout Form init',
        BuilderConditions = {
            #{ UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.FACTORY * categories.LAND - categories.TECH1 }},
            { SBC, 'LessThanGameTime', { 300 } },
            { SBC, 'NoRushTimeCheck', { 0 }},
        },
        PlatoonTemplate = 'T1LandScoutFormSorian',
        Priority = 10000, #725,
        InstanceCount = 30,
        BuilderData = {
            UseCloak = false,
        },
        LocationType = 'LocationType',
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'Sorian T1 Land Scout Form',
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.FACTORY * categories.AIR * categories.TECH3 }},
            { SBC, 'GreaterThanGameTime', { 300 } },
            { SBC, 'NoRushTimeCheck', { 0 }},
        },
        PlatoonTemplate = 'T1LandScoutFormSorian',
        Priority = 10000, #725,
        InstanceCount = 30,
        BuilderData = {
            UseCloak = true,
        },
        LocationType = 'LocationType',
        BuilderType = 'Any',
    },

}
