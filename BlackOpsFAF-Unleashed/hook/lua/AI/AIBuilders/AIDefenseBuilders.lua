
-- T3GroundDefense
-- Changed PlatoonTemplate = 'UEFT3EngineerBuilder' to 'T3EngineerBuilder'
-- so, all races can build T3 base Defenses like UEF
BuilderGroup {
    BuilderGroupName = 'T3BaseDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'T3 Base D Engineer AA',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 900,
        BuilderConditions = {
            {UCBC, 'UnitsLessAtLocation', {'LocationType', 10, 'DEFENSE TECH3 ANTIAIR STRUCTURE'}},
            {UCBC, 'HaveGreaterThanUnitsWithCategory', {0, categories.ENERGYPRODUCTION * categories.TECH3} },
            {IBC, 'BrainNotLowPowerMode', {}},
            {EBC, 'GreaterThanEconEfficiencyOverTime', {0.8, 1.1}}, --DUNCAN - was 0.9, 1.2
            {UCBC, 'LocationEngineersBuildingLess', {'LocationType', 1, 'DEFENSE TECH3 ANTIAIR STRUCTURE'} },
            {UCBC, 'UnitCapCheckLess', {.9} },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 0, --DUNCAN - was 2
            Construction = {
                BuildClose = true,
                AvoidCategory = 'TECH3 ANTIAIR STRUCTURE',
                maxUnits = 1,
                maxRadius = 10,
                AdjacencyCategory = 'SHIELD STUCTURE, FACTORY TECH3, FACTORY TECH2, FACTORY',
                BuildStructures = {
                    'T3AADefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'T3 Base D Engineer PD',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 900,
        BuilderConditions = {
            {UCBC, 'HaveGreaterThanUnitsWithCategory', {0, categories.ENERGYPRODUCTION * categories.TECH3} },
            {UCBC, 'UnitsLessAtLocation', {'LocationType', 2, 'DEFENSE TECH3 DIRECTFIRE'}},
            {IBC, 'BrainNotLowPowerMode', {}},
            {EBC, 'GreaterThanEconEfficiencyOverTime', {0.9, 1.2}},
            {UCBC, 'LocationEngineersBuildingLess', {'LocationType', 1, 'DEFENSE'} },
            {UCBC, 'UnitCapCheckLess', {.9} },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 0,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T3GroundDefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'T3TMLEngineer',
        PlatoonTemplate = 'T2EngineerBuilder',
        Priority = 900,
        BuilderConditions = {
            {UCBC, 'UnitsLessAtLocation', {'LocationType', 2, categories.TACTICALMISSILEPLATFORM}},
            {EBC, 'GreaterThanEconEfficiency', {0.9, 1.2}},
            {IBC, 'BrainNotLowPowerMode', {}},
            --{UCBC, 'CheckUnitRange', {'LocationType', 'T2StrategicMissile', categories.STRUCTURE + (categories.LAND * (categories.TECH2 + categories.TECH3))} },
            {UCBC, 'HaveGreaterThanUnitsWithCategory', {0, categories.ENERGYPRODUCTION * categories.TECH3} },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T2StrategicMissile',
                },
                Location = 'LocationType',
            }
        }
    },
}
BuilderGroup {
    BuilderGroupName = 'T3DefensivePoints',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'T3 Defensive Point Engineer',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 850,
        InstanceCount = 1,
        BuilderConditions = {
            {EBC, 'GreaterThanEconEfficiencyOverTime', {0.9, 1.2}},
            {UCBC, 'DefensivePointNeedsStructure', {'LocationType', 150, 'DEFENSE TECH3 DIRECTFIRE', 20, 2, 0, 1, 2, 'AntiSurface'} },
            {IBC, 'BrainNotLowPowerMode', {}},
            {UCBC, 'LocationEngineersBuildingLess', {'LocationType', 2, 'DEFENSE'} },
            {UCBC, 'UnitCapCheckLess', {.75} },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 150,
                LocationType = 'LocationType',
                ThreatMin = 0,
                ThreatMax = 1,
                ThreatRings = 2,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 2,
                MarkerUnitCategory = 'DEFENSE TECH3 DIRECTFIRE',
                BuildStructures = {
                    'T3GroundDefense',
                }
            }
        }
    },
}
BuilderGroup {
    BuilderGroupName = 'T3DefensivePoints High Pri',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'T3 Defensive Point Engineer High Pri',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 930,
        InstanceCount = 1,
        BuilderConditions = {
            {EBC, 'GreaterThanEconEfficiencyOverTime', {0.9, 1.2}},
            {UCBC, 'DefensivePointNeedsStructure', {'LocationType', 150, 'DEFENSE TECH3 DIRECTFIRE', 20, 2, 0, 1, 2, 'AntiSurface'} },
            {IBC, 'BrainNotLowPowerMode', {}},
            {UCBC, 'LocationEngineersBuildingLess', {'LocationType', 2, 'DEFENSE'} },
            {UCBC, 'UnitCapCheckLess', {.8} },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 150,
                LocationType = 'LocationType',
                ThreatMin = 0,
                ThreatMax = 1,
                ThreatRings = 2,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 2,
                MarkerUnitCategory = 'DEFENSE TECH3 DIRECTFIRE',
                BuildStructures = {
                    'T3GroundDefense',
                }
            }
        }
    },
}
BuilderGroup {
    BuilderGroupName = 'T3LightDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'T3 Base D Engineer AA - Light',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 925,
        BuilderConditions = {
            {UCBC, 'UnitsLessAtLocation', {'LocationType', 2, 'DEFENSE TECH3 ANTIAIR'}},
            {IBC, 'BrainNotLowPowerMode', {}},
            {EBC, 'GreaterThanEconEfficiencyOverTime', {0.9, 1.2}},
            {UCBC, 'UnitCapCheckLess', {.8} },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T3AADefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'T3 Base D Engineer PD - Light',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 875,
        BuilderConditions = {
            {UCBC, 'HaveLessThanUnitsWithCategory', {2, 'DEFENSE TECH3 DIRECTFIRE'}},
            {IBC, 'BrainNotLowPowerMode', {}},
            {EBC, 'GreaterThanEconEfficiencyOverTime', {0.9, 1.2}},
            {UCBC, 'UnitCapCheckLess', {.8} },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T3GroundDefense',
                },
                Location = 'LocationType',
            }
        }
    },
}

-- T3ShieldDefense
-- Removed FactionIndex 1,2,4
-- so, all races can build T3 Shields directly
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
BuilderGroup {
    BuilderGroupName = 'T3ACUShields',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'T3 Shield D Engineer Near ACU',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 890,
        BuilderConditions = {
            {UCBC, 'HaveGreaterThanUnitsWithCategory', {7, categories.ENGINEER * categories.TECH3}},
            {UCBC, 'UnitsLessAtLocation', {'LocationType', 5, categories.SHIELD * categories.STRUCTURE}},
            {EBC, 'GreaterThanEconEfficiencyOverTime', {0.9, 1.2}},
            {IBC, 'BrainNotLowPowerMode', {}},
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
            Construction = {
                AvoidCategory = 'SHIELD',
                maxUnits = 1,
                maxRadius = 10,
                NearUnitCategory = 'COMMAND',
                NearUnitRadius = 32000,
                BuildClose = false,
                BuildStructures = {
                    'T3ShieldDefense',
                },
                Location = 'LocationType',
            }
        }
    },
}


