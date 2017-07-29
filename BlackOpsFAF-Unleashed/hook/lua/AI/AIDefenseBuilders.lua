BuilderGroup {
    BuilderGroupName = 'T3Shields',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'T3 Shield D Engineer Factory Adj',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 950,
        BuilderConditions = {
            {UCBC, 'HaveGreaterThanUnitsWithCategory', {4, categories.ENGINEER * categories.TECH3}},
            {UCBC, 'UnitsLessAtLocation', {'LocationType', 8, categories.SHIELD * categories.STRUCTURE}},
            {EBC, 'GreaterThanEconEfficiencyOverTime', {0.8, 1.1}},
            {IBC, 'BrainNotLowPowerMode', {}},
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
            Construction = {
                AdjacencyCategory = 'ENERGYPRODUCTION EXPERIMENTAL, ENERGYPRODUCTION TECH3, FACTORY TECH3, FACTORY TECH2, ENERGYPRODUCTION TECH2, FACTORY',
                AdjacencyDistance = 60,
                BuildClose = false,
                AvoidCategory = 'SHIELD',
                maxUnits = 1,
                maxRadius = 10,
                BuildStructures = {
                    'T3ShieldDefense',
                },
                Location = 'LocationType',
            }
        }
    },
}
