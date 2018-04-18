
-- SorianEngineerFactoryBuilders are used from all basetemplates. Perfect for hooking
BuilderGroup {
    BuilderGroupName = 'SorianLandScoutFormBuilders',
    BuildersType = 'PlatoonFormBuilder',
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
