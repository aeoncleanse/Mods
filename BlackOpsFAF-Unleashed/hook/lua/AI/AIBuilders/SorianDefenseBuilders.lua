
-- T3GroundDefense
-- Changed PlatoonTemplate = 'UEFT3EngineerBuilderSorian' to 'T3EngineerBuilderSorian'
-- so, all races can build T3 base Defenses like UEF
BuilderGroup {
    BuilderGroupName = 'SorianT3BaseDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'Sorian T3 Base D Engineer AA',
        PlatoonTemplate = 'T3EngineerBuilderSorian',
        Priority = 945,
        BuilderConditions = {
            {UCBC, 'UnitsLessAtLocation', {'LocationType', 40, 'DEFENSE TECH3 ANTIAIR STRUCTURE'}},
            {SIBC, 'HaveGreaterThanUnitsWithCategory', {0, categories.ENERGYPRODUCTION * categories.TECH3} },
            {SIBC, 'HaveGreaterThanUnitsWithCategory', {0, categories.MASSPRODUCTION * categories.TECH3} },
            {IBC, 'BrainNotLowPowerMode', {}},
            {SIBC, 'GreaterThanEconEfficiencyOverTime', {0.9, 1.2}},
            {UCBC, 'LocationEngineersBuildingLess', {'LocationType', 1, categories.DEFENSE * categories.TECH3 * categories.STRUCTURE * (categories.ANTIAIR + categories.DIRECTFIRE)} },
            {UCBC, 'UnitCapCheckLess', {.8} },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3AADefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'Sorian T3 Base D Engineer AA - Response',
        PlatoonTemplate = 'T3EngineerBuilderSorian',
        Priority = 948,
        BuilderConditions = {
            {UCBC, 'UnitsLessAtLocation', {'LocationType', 15, 'DEFENSE TECH3 ANTIAIR STRUCTURE'}},
            {TBC, 'EnemyThreatGreaterThanValueAtBase', {'LocationType', 1, 'Air'} },
            {IBC, 'BrainNotLowPowerMode', {}},
            {SIBC, 'GreaterThanEconEfficiencyOverTime', {0.9, 1.2}},
            {UCBC, 'LocationEngineersBuildingLess', {'LocationType', 1, categories.DEFENSE * categories.TECH3 * categories.STRUCTURE * (categories.ANTIAIR + categories.DIRECTFIRE)} },
            {UCBC, 'UnitCapCheckLess', {.8} },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3AADefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'Sorian T3 Base D Engineer AA - Exp Response',
        PlatoonTemplate = 'T3EngineerBuilderSorian',
        Priority = 1300,
        BuilderConditions = {
            {UCBC, 'UnitsLessAtLocation', {'LocationType', 30, 'DEFENSE TECH3 ANTIAIR STRUCTURE'}},
            {SIBC, 'HaveGreaterThanUnitsWithCategory', {0, categories.ENERGYPRODUCTION * categories.TECH3} },
            {IBC, 'BrainNotLowPowerMode', {}},
            --{SIBC, 'GreaterThanEconEfficiencyOverTime', {0.9, 1.2}},
            {UCBC, 'UnitCapCheckLess', {.8} },
            --{UCBC, 'HaveUnitsWithCategoryAndAlliance', {true, 0, 'EXPERIMENTAL AIR', 'Enemy'}},
            {SBC, 'T4ThreatExists', {{'Air'}, categories.AIR}},
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3AADefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'Sorian T2TMLEngineer - Exp Response',
        PlatoonTemplate = 'T3EngineerBuilderSorian',
        Priority = 1300,
        BuilderConditions = {
            {UCBC, 'UnitsLessAtLocation', {'LocationType', 8, categories.TACTICALMISSILEPLATFORM * categories.STRUCTURE}},
            {SIBC, 'HaveGreaterThanUnitsWithCategory', {0, categories.ENERGYPRODUCTION * categories.TECH2} },
            --{SIBC, 'GreaterThanEconEfficiencyOverTime', {0.9, 1.2}},
            {IBC, 'BrainNotLowPowerMode', {}},
            --{UCBC, 'HaveUnitsWithCategoryAndAlliance', {true, 0, 'EXPERIMENTAL LAND', 'Enemy'}},
            {SBC, 'T4ThreatExists', {{'Land'}, categories.LAND}},
            --{UCBC, 'CheckUnitRange', {'LocationType', 'T2StrategicMissile', categories.STRUCTURE + (categories.LAND * (categories.TECH2 + categories.TECH3))} },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T2StrategicMissile',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'Sorian T3 Base D Engineer PD - Exp Response',
        PlatoonTemplate = 'T3EngineerBuilderSorian',
        Priority = 1300,
        BuilderConditions = {
            {UCBC, 'UnitsLessAtLocation', {'LocationType', 10, 'DEFENSE TECH3 DIRECTFIRE STRUCTURE'}},
            {SIBC, 'HaveGreaterThanUnitsWithCategory', {0, categories.ENERGYPRODUCTION * categories.TECH3} },
            {SIBC, 'HaveGreaterThanUnitsWithCategory', {0, categories.MASSPRODUCTION * categories.TECH3} },
            {IBC, 'BrainNotLowPowerMode', {}},
            --{SIBC, 'GreaterThanEconEfficiencyOverTime', {0.9, 1.2}},
            {UCBC, 'LocationEngineersBuildingLess', {'LocationType', 1, categories.DEFENSE * categories.TECH3 * categories.STRUCTURE * (categories.ANTIAIR + categories.DIRECTFIRE)} },
            {SBC, 'T4ThreatExists', {{'Land'}, categories.LAND}},
            {UCBC, 'UnitCapCheckLess', {.8} },
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
            {UCBC, 'UnitsLessAtLocation', {'LocationType', 15, 'DEFENSE TECH3 DIRECTFIRE STRUCTURE'}},
            {SIBC, 'HaveGreaterThanUnitsWithCategory', {0, categories.ENERGYPRODUCTION * categories.TECH3} },
            {SIBC, 'HaveGreaterThanUnitsWithCategory', {0, categories.MASSPRODUCTION * categories.TECH3} },
            {IBC, 'BrainNotLowPowerMode', {}},
            {SIBC, 'GreaterThanEconEfficiencyOverTime', {0.9, 1.2}},
            {UCBC, 'LocationEngineersBuildingLess', {'LocationType', 1, categories.DEFENSE * categories.TECH3 * categories.STRUCTURE * (categories.ANTIAIR + categories.DIRECTFIRE)} },
            {UCBC, 'UnitCapCheckLess', {.8} },
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
        BuilderName = 'Sorian T3 Base D AA Engineer - Response R',
        PlatoonTemplate = 'T3EngineerBuilderSorian',
        Priority = 925,
        BuilderConditions = {
            {UCBC, 'UnitsLessAtLocation', {'LocationType', 10, 'DEFENSE TECH3 ANTIAIR STRUCTURE'}},
            {TBC, 'EnemyThreatGreaterThanValueAtBase', {'LocationType', 1, 'Air'} },
            {IBC, 'BrainNotLowPowerMode', {}},
            {SIBC, 'GreaterThanEconEfficiencyOverTime', {0.9, 1.2}},
            {UCBC, 'LocationEngineersBuildingLess', {'LocationType', 1, categories.DEFENSE * categories.TECH3 * categories.STRUCTURE - categories.SHIELD - categories.ANTIMISSILE} },
            {UCBC, 'UnitCapCheckLess', {.8} },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3AADefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'Sorian T3 Base D Engineer AA - Exp Response R',
        PlatoonTemplate = 'T3EngineerBuilderSorian',
        Priority = 1300,
        BuilderConditions = {
            {UCBC, 'UnitsLessAtLocation', {'LocationType', 30, 'DEFENSE TECH3 ANTIAIR STRUCTURE'}},
            {SIBC, 'HaveGreaterThanUnitsWithCategory', {0, categories.ENERGYPRODUCTION * categories.TECH3} },
            {IBC, 'BrainNotLowPowerMode', {}},
            --{SIBC, 'GreaterThanEconEfficiencyOverTime', {0.9, 1.2}},
            {UCBC, 'UnitCapCheckLess', {.8} },
            --{UCBC, 'HaveUnitsWithCategoryAndAlliance', {true, 0, 'EXPERIMENTAL AIR', 'Enemy'}},
            {SBC, 'T4ThreatExists', {{'Air'}, categories.AIR}},
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3AADefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'Sorian T2TMLEngineer - Exp Response R',
        PlatoonTemplate = 'T3EngineerBuilderSorian',
        Priority = 1300,
        BuilderConditions = {
            {UCBC, 'UnitsLessAtLocation', {'LocationType', 8, categories.TACTICALMISSILEPLATFORM * categories.STRUCTURE}},
            {SIBC, 'HaveGreaterThanUnitsWithCategory', {0, categories.ENERGYPRODUCTION * categories.TECH2} },
            --{SIBC, 'GreaterThanEconEfficiencyOverTime', {0.9, 1.2}},
            {IBC, 'BrainNotLowPowerMode', {}},
            --{UCBC, 'HaveUnitsWithCategoryAndAlliance', {true, 0, 'EXPERIMENTAL LAND', 'Enemy'}},
            {SBC, 'T4ThreatExists', {{'Land'}, categories.LAND}},
            --{UCBC, 'CheckUnitRange', {'LocationType', 'T2StrategicMissile', categories.STRUCTURE + (categories.LAND * (categories.TECH2 + categories.TECH3))} },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T2StrategicMissile',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'Sorian T3 Base D Engineer PD - Exp Response R',
        PlatoonTemplate = 'T3EngineerBuilderSorian',
        Priority = 1300,
        BuilderConditions = {
            {UCBC, 'UnitsLessAtLocation', {'LocationType', 10, 'DEFENSE TECH3 DIRECTFIRE STRUCTURE'}},
            {SIBC, 'HaveGreaterThanUnitsWithCategory', {0, categories.ENERGYPRODUCTION * categories.TECH3} },
            {SIBC, 'HaveGreaterThanUnitsWithCategory', {0, categories.MASSPRODUCTION * categories.TECH3} },
            {IBC, 'BrainNotLowPowerMode', {}},
            --{SIBC, 'GreaterThanEconEfficiencyOverTime', {0.9, 1.2}},
            {UCBC, 'LocationEngineersBuildingLess', {'LocationType', 1, categories.DEFENSE * categories.TECH3 * categories.STRUCTURE * (categories.ANTIAIR + categories.DIRECTFIRE)} },
            {SBC, 'T4ThreatExists', {{'Land'}, categories.LAND}},
            {UCBC, 'UnitCapCheckLess', {.8} },
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
        BuilderName = 'Sorian T3 Base D Engineer AA - Light',
        PlatoonTemplate = 'T3EngineerBuilderSorian',
        Priority = 925,
        BuilderConditions = {
            {UCBC, 'UnitsLessAtLocation', {'LocationType', 6, 'DEFENSE TECH3 ANTIAIR STRUCTURE'}},
            {SIBC, 'HaveGreaterThanUnitsWithCategory', {0, categories.ENERGYPRODUCTION * categories.TECH3} },
            {IBC, 'BrainNotLowPowerMode', {}},
            {SIBC, 'GreaterThanEconEfficiencyOverTime', {0.9, 1.2}},
            {UCBC, 'UnitCapCheckLess', {.8} },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3AADefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'Sorian T3 Base D Engineer PD - Light',
        PlatoonTemplate = 'T3EngineerBuilderSorian',
        Priority = 875,
        BuilderConditions = {
            {UCBC, 'HaveLessThanUnitsWithCategory', {6, 'DEFENSE TECH3 DIRECTFIRE STRUCTURE'}},
            {SIBC, 'HaveGreaterThanUnitsWithCategory', {0, categories.ENERGYPRODUCTION * categories.TECH3} },
            {SIBC, 'HaveGreaterThanUnitsWithCategory', {0, categories.MASSPRODUCTION * categories.TECH3} },
            {IBC, 'BrainNotLowPowerMode', {}},
            {SIBC, 'GreaterThanEconEfficiencyOverTime', {0.9, 1.2}},
            {UCBC, 'UnitCapCheckLess', {.8} },
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
BuilderGroup {
    BuilderGroupName = 'SorianT3DefensivePoints Turtle',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'Sorian T3 Turtle Defensive Point Engineer UEF',
        PlatoonTemplate = 'T3EngineerBuilderSorian',
        Priority = 950,
        InstanceCount = 1,
        BuilderConditions = {
            {SIBC, 'GreaterThanEconEfficiencyOverTime', {0.9, 1.2}},
            {SIBC, 'HaveGreaterThanUnitsWithCategory', {0, categories.ENERGYPRODUCTION * categories.TECH3} },
            {SIBC, 'DefensivePointNeedsStructure', {'LocationType', 2000, 'DEFENSE TECH3 STRUCTURE', 20, 2, 0, 1, 1, 'AntiSurface'} },
            {IBC, 'BrainNotLowPowerMode', {}},
            {UCBC, 'LocationEngineersBuildingLess', {'LocationType', 2, 'DEFENSE STRUCTURE'} },
            {UCBC, 'UnitCapCheckLess', {.75} },
            {SBC, 'NoRushTimeCheck', {0}},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            NumAssistees = 2,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 2000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 5,
                ThreatRings = 1,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 2,
                MarkerUnitCategory = 'DEFENSE TECH3 STRUCTURE',
                BuildStructures = {
                    'T3GroundDefense',
                    'T3AADefense',
                    'T2MissileDefense',
                    'T2ShieldDefense',
                    'T2StrategicMissile',
                    'T2Artillery',
                    'T2EngineerSupport',
                    'T3GroundDefense',
                    'T3AADefense',
                    'T2ShieldDefense',
                }
            }
        }
    },
    Builder {
        BuilderName = 'Sorian T3 Turtle Defensive Point Engineer Cybran',
        PlatoonTemplate = 'CybranT3EngineerBuilderSorian',
        Priority = 950,
        InstanceCount = 1,
        BuilderConditions = {
            {SIBC, 'GreaterThanEconEfficiencyOverTime', {0.9, 1.2}},
            {SIBC, 'HaveGreaterThanUnitsWithCategory', {0, categories.ENERGYPRODUCTION * categories.TECH3} },
            {SIBC, 'DefensivePointNeedsStructure', {'LocationType', 2000, 'DEFENSE TECH3 STRUCTURE', 20, 2, 0, 1, 1, 'AntiSurface'} },
            {IBC, 'BrainNotLowPowerMode', {}},
            {UCBC, 'LocationEngineersBuildingLess', {'LocationType', 2, 'DEFENSE STRUCTURE'} },
            {UCBC, 'UnitCapCheckLess', {.75} },
            {SBC, 'NoRushTimeCheck', {0}},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            NumAssistees = 2,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 2000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 5,
                ThreatRings = 1,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 2,
                MarkerUnitCategory = 'DEFENSE TECH3 STRUCTURE',
                BuildStructures = {
                    'T2GroundDefense',
                    'T3AADefense',
                    'T2MissileDefense',
                    'T2ShieldDefense',
                    'T2StrategicMissile',
                    'T2Artillery',
                    'T2EngineerSupport',
                    'T2GroundDefense',
                    'T3AADefense',
                    'T2ShieldDefense',
                }
            }
        }
    },
    Builder {
        BuilderName = 'Sorian T3 Turtle Defensive Point Engineer',
        PlatoonTemplate = 'T3EngineerBuilderSorian',
        Priority = 950,
        InstanceCount = 1,
        BuilderConditions = {
            {SIBC, 'GreaterThanEconEfficiencyOverTime', {0.9, 1.2}},
            {SIBC, 'HaveGreaterThanUnitsWithCategory', {0, categories.ENERGYPRODUCTION * categories.TECH3} },
            {SIBC, 'DefensivePointNeedsStructure', {'LocationType', 2000, 'DEFENSE TECH3 STRUCTURE', 20, 2, 0, 1, 1, 'AntiSurface'} },
            {IBC, 'BrainNotLowPowerMode', {}},
            {UCBC, 'LocationEngineersBuildingLess', {'LocationType', 2, 'DEFENSE STRUCTURE'} },
            {UCBC, 'UnitCapCheckLess', {.75} },
            {MIBC, 'FactionIndex', {2, 4}},
            {SBC, 'NoRushTimeCheck', {0}},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            NumAssistees = 2,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 2000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 5,
                ThreatRings = 1,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 2,
                MarkerUnitCategory = 'DEFENSE TECH3 STRUCTURE',
                BuildStructures = {
                    'T2GroundDefense',
                    'T3AADefense',
                    'T2MissileDefense',
                    'T2ShieldDefense',
                    'T2StrategicMissile',
                    'T2Artillery',
                    'T2GroundDefense',
                    'T3AADefense',
                    'T2ShieldDefense',
                }
            }
        }
    },
}
BuilderGroup {
    BuilderGroupName = 'SorianT3DefensivePoints',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'Sorian T3 Defensive Point Engineer UEF',
        PlatoonTemplate = 'T3EngineerBuilderSorian',
        Priority = 900,
        InstanceCount = 1,
        BuilderConditions = {
            {SIBC, 'GreaterThanEconEfficiencyOverTime', {0.9, 1.2}},
            {SIBC, 'HaveGreaterThanUnitsWithCategory', {0, categories.ENERGYPRODUCTION * categories.TECH3} },
            {SIBC, 'DefensivePointNeedsStructure', {'LocationType', 2000, 'DEFENSE TECH3 STRUCTURE', 20, 2, 0, 1, 1, 'AntiSurface'} },
            {IBC, 'BrainNotLowPowerMode', {}},
            {UCBC, 'LocationEngineersBuildingLess', {'LocationType', 2, 'DEFENSE STRUCTURE'} },
            {UCBC, 'UnitCapCheckLess', {.75} },
            {SBC, 'NoRushTimeCheck', {0}},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            NumAssistees = 2,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 2000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 5,
                ThreatRings = 1,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 2,
                MarkerUnitCategory = 'DEFENSE TECH3 STRUCTURE',
                BuildStructures = {
                    'T3GroundDefense',
                    'T3AADefense',
                    'T2MissileDefense',
                    'T2ShieldDefense',
                    'T2StrategicMissile',
                    'T2Artillery',
                    'T2EngineerSupport',
                    'T2ShieldDefense',
                }
            }
        }
    },
    Builder {
        BuilderName = 'Sorian T3 Defensive Point Engineer Cybran',
        PlatoonTemplate = 'CybranT3EngineerBuilderSorian',
        Priority = 900,
        InstanceCount = 1,
        BuilderConditions = {
            {SIBC, 'GreaterThanEconEfficiencyOverTime', {0.9, 1.2}},
            {SIBC, 'HaveGreaterThanUnitsWithCategory', {0, categories.ENERGYPRODUCTION * categories.TECH3} },
            {SIBC, 'DefensivePointNeedsStructure', {'LocationType', 2000, 'DEFENSE TECH3 STRUCTURE', 20, 2, 0, 1, 1, 'AntiSurface'} },
            {IBC, 'BrainNotLowPowerMode', {}},
            {UCBC, 'LocationEngineersBuildingLess', {'LocationType', 2, 'DEFENSE STRUCTURE'} },
            {UCBC, 'UnitCapCheckLess', {.75} },
            {SBC, 'NoRushTimeCheck', {0}},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            NumAssistees = 2,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 2000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 5,
                ThreatRings = 1,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 2,
                MarkerUnitCategory = 'DEFENSE TECH3 STRUCTURE',
                BuildStructures = {
                    'T2GroundDefense',
                    'T3AADefense',
                    'T2MissileDefense',
                    'T2ShieldDefense',
                    'T2StrategicMissile',
                    'T2Artillery',
                    'T2EngineerSupport',
                    'T2ShieldDefense',
                }
            }
        }
    },
    Builder {
        BuilderName = 'Sorian T3 Defensive Point Engineer',
        PlatoonTemplate = 'T3EngineerBuilderSorian',
        Priority = 900,
        InstanceCount = 1,
        BuilderConditions = {
            {SIBC, 'GreaterThanEconEfficiencyOverTime', {0.9, 1.2}},
            {SIBC, 'HaveGreaterThanUnitsWithCategory', {0, categories.ENERGYPRODUCTION * categories.TECH3} },
            {SIBC, 'DefensivePointNeedsStructure', {'LocationType', 2000, 'DEFENSE TECH3 STRUCTURE', 20, 2, 0, 1, 1, 'AntiSurface'} },
            {IBC, 'BrainNotLowPowerMode', {}},
            {UCBC, 'LocationEngineersBuildingLess', {'LocationType', 2, 'DEFENSE STRUCTURE'} },
            {UCBC, 'UnitCapCheckLess', {.75} },
            {MIBC, 'FactionIndex', {2, 4}},
            {SBC, 'NoRushTimeCheck', {0}},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = true,
            NumAssistees = 2,
            Construction = {
                BuildClose = false,
                NearMarkerType = 'Defensive Point',
                MarkerRadius = 20,
                LocationRadius = 2000,
                LocationType = 'LocationType',
                ThreatMin = -10000,
                ThreatMax = 5,
                ThreatRings = 1,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 2,
                MarkerUnitCategory = 'DEFENSE TECH3 STRUCTURE',
                BuildStructures = {
                    'T2GroundDefense',
                    'T3AADefense',
                    'T2MissileDefense',
                    'T2ShieldDefense',
                    'T2StrategicMissile',
                    'T2Artillery',
                    'T2ShieldDefense',
                }
            }
        }
    },
}

-- T3ShieldDefense
-- Removed FactionIndex 1,2,4
-- so, all races can build T3 Shields directly
BuilderGroup {
    BuilderGroupName = 'SorianT3Shields',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'Sorian T3 Shield D Engineer Factory Adj',
        PlatoonTemplate = 'T3EngineerBuilderSorian',
        Priority = 950,
        BuilderConditions = {
            {UCBC, 'HaveGreaterThanUnitsWithCategory', {5, categories.ENGINEER * categories.TECH3}},
            {SIBC, 'HaveGreaterThanUnitsWithCategory', {0, categories.ENERGYPRODUCTION * categories.TECH3} },
            {UCBC, 'UnitsLessAtLocation', {'LocationType', 10, categories.SHIELD * categories.TECH3 * categories.STRUCTURE}},
            {UCBC, 'LocationEngineersBuildingLess', {'LocationType', 1, 'SHIELD STRUCTURE TECH3'} },
            {SIBC, 'GreaterThanEconEfficiencyOverTime', {0.9, 1.2}},
            {IBC, 'BrainNotLowPowerMode', {}},
            {UCBC, 'UnitCapCheckLess', {.8} },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
            Construction = {
                AdjacencyCategory = 'FACTORY, STRUCTURE EXPERIMENTAL, ENERGYPRODUCTION TECH3, ENERGYPRODUCTION TECH2',
                AdjacencyDistance = 100,
                BuildClose = false,
                BuildStructures = {
                    'T3ShieldDefense',
                },
                Location = 'LocationType',
            }
        }
    },
}
BuilderGroup {
    BuilderGroupName = 'SorianT3ACUShields',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'Sorian T3 Shield D Engineer Near ACU',
        PlatoonTemplate = 'T3EngineerBuilderSorian',
        Priority = 890,
        BuilderConditions = {
            {UCBC, 'HaveGreaterThanUnitsWithCategory', {8, categories.ENGINEER * categories.TECH3}},
            {SIBC, 'HaveGreaterThanUnitsWithCategory', {0, categories.ENERGYPRODUCTION * categories.TECH3} },
            {UCBC, 'UnitsLessAtLocation', {'LocationType', 3, categories.SHIELD * categories.STRUCTURE}},
            {SIBC, 'GreaterThanEconEfficiencyOverTime', {0.9, 1.2}},
            {IBC, 'BrainNotLowPowerMode', {}},
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
            Construction = {
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
BuilderGroup {
    BuilderGroupName = 'SorianT3ShieldsExpansion',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'Sorian T3 Shield D Engineer Near Factory Expansion',
        PlatoonTemplate = 'T3EngineerBuilderSorian',
        Priority = 940,
        BuilderConditions = {
            --{UCBC, 'HaveLessThanUnitsWithCategory', {2, categories.SHIELD * categories.TECH2 * categories.STRUCTURE}},
            {UCBC, 'HaveGreaterThanUnitsWithCategory', {5, categories.ENGINEER * categories.TECH3}},
            {UCBC, 'UnitsLessAtLocation', {'LocationType', 3, categories.SHIELD * categories.TECH3 * categories.STRUCTURE}},
            {SIBC, 'HaveGreaterThanUnitsWithCategory', {0, categories.ENERGYPRODUCTION * categories.TECH3}},
            {IBC, 'BrainNotLowPowerMode', {}},
            {SIBC, 'GreaterThanEconEfficiency', {0.9, 1.2} },
            {UCBC, 'LocationEngineersBuildingLess', {'LocationType', 1, 'SHIELD STRUCTURE TECH2'} },
            {UCBC, 'UnitCapCheckLess', {.8} },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
            Construction = {
                AdjacencyCategory = 'FACTORY, ENERGYPRODUCTION EXPERIMENTAL, ENERGYPRODUCTION TECH3, ENERGYPRODUCTION TECH2',
                AdjacencyDistance = 100,
                BuildClose = false,
                BuildStructures = {
                    'T3ShieldDefense',
                },
                Location = 'LocationType',
            }
        }
    },
}
