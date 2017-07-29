-- Changed PlatoonTemplate = 'UEFT3EngineerBuilderSorian' to 'T3EngineerBuilderSorian'
-- so, all races can build T3 base Defenses like UEF

BuilderGroup {
    BuilderGroupName = 'SorianT3BaseDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'Sorian T3 Base D Engineer PD - Exp Response',
        PlatoonTemplate = 'T3EngineerBuilderSorian',
        Priority = 1300,
        BuilderConditions = {
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 10, 'DEFENSE TECH3 DIRECTFIRE STRUCTURE'}},
            { SIBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH3 } },
            { SIBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSPRODUCTION * categories.TECH3 } },
            { IBC, 'BrainNotLowPowerMode', {} },
            #{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, categories.DEFENSE * categories.TECH3 * categories.STRUCTURE * (categories.ANTIAIR + categories.DIRECTFIRE) } },
            { SBC, 'T4ThreatExists', {{'Land'}, categories.LAND}},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3GroundDefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'Sorian T3 Base D Engineer PD',
        PlatoonTemplate = 'T3EngineerBuilderSorian',
        Priority = 945,
        BuilderConditions = {
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 15, 'DEFENSE TECH3 DIRECTFIRE STRUCTURE'}},
            { SIBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH3 } },
            { SIBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSPRODUCTION * categories.TECH3 } },
            { IBC, 'BrainNotLowPowerMode', {} },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, categories.DEFENSE * categories.TECH3 * categories.STRUCTURE * (categories.ANTIAIR + categories.DIRECTFIRE) } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3GroundDefense',
                },
                Location = 'LocationType',
            }
        }
    },
}
BuilderGroup {
    BuilderGroupName = 'SorianT3BaseDefenses - Emerg',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'Sorian T3 Base D Engineer PD - Exp Response R',
        PlatoonTemplate = 'T3EngineerBuilderSorian',
        Priority = 1300,
        BuilderConditions = {
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 10, 'DEFENSE TECH3 DIRECTFIRE STRUCTURE'}},
            { SIBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH3 } },
            { SIBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSPRODUCTION * categories.TECH3 } },
            { IBC, 'BrainNotLowPowerMode', {} },
            #{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, categories.DEFENSE * categories.TECH3 * categories.STRUCTURE * (categories.ANTIAIR + categories.DIRECTFIRE) } },
            { SBC, 'T4ThreatExists', {{'Land'}, categories.LAND}},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3GroundDefense',
                },
                Location = 'LocationType',
            }
        }
    },
}
BuilderGroup {
    BuilderGroupName = 'SorianT3LightDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'Sorian T3 Base D Engineer PD - Light',
        PlatoonTemplate = 'T3EngineerBuilderSorian',
        Priority = 875,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 6, 'DEFENSE TECH3 DIRECTFIRE STRUCTURE'}},
            { SIBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH3 } },
            { SIBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.MASSPRODUCTION * categories.TECH3 } },
            { IBC, 'BrainNotLowPowerMode', {} },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3GroundDefense',
                },
                Location = 'LocationType',
            }
        }
    },
}
