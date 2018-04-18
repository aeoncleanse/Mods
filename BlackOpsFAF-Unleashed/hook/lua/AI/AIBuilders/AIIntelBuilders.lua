

-- LandScoutFormBuilders are used from all basetemplates. Perfect for hooking
BuilderGroup {
    BuilderGroupName = 'LandScoutFormBuilders',
    BuildersType = 'PlatoonFormBuilder',
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