BuffBlueprint {
    Name = 'T1PowerRateOfFireBonusSize4',
    DisplayName = 'T1PowerRateOfFireBonus',
    BuffType = 'RATEOFFIREADJACENCY',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4 ARTILLERY',
    BuffCheckFunction = AdjBuffFuncs.RateOfFireBuffCheck,
    OnBuffAffect = AdjBuffFuncs.RateOfFireBuffAffect,
    OnBuffRemove = AdjBuffFuncs.RateOfFireBuffRemove,
    Affects = {
        RateOfFire = {
            Add = -0.075,
            Mult = 1.0,
        },
    },
}
BuffBlueprint {
    Name = 'T2PowerRateOfFireBonusSize4',
    DisplayName = 'T2PowerRateOfFireBonus',
    BuffType = 'RATEOFFIREADJACENCY',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4 ARTILLERY',
    BuffCheckFunction = AdjBuffFuncs.RateOfFireBuffCheck,
    OnBuffAffect = AdjBuffFuncs.RateOfFireBuffAffect,
    OnBuffRemove = AdjBuffFuncs.RateOfFireBuffRemove,
    Affects = {
        RateOfFire = {
            Add = -0.15,
            Mult = 1.0,
        },
    },
}
BuffBlueprint {
    Name = 'T3PowerRateOfFireBonusSize4',
    DisplayName = 'T3PowerRateOfFireBonus',
    BuffType = 'RATEOFFIREADJACENCY',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4 ARTILLERY',
    BuffCheckFunction = AdjBuffFuncs.RateOfFireBuffCheck,
    OnBuffAffect = AdjBuffFuncs.RateOfFireBuffAffect,
    OnBuffRemove = AdjBuffFuncs.RateOfFireBuffRemove,
    Affects = {
        RateOfFire = {
            Add = -0.2,
            Mult = 1.0,
        },
    },
}
BuffBlueprint {
    Name = 'T3PowerEnergyMaintenanceBonusSize12',
    DisplayName = 'T3PowerEnergyMaintenanceBonus',
    BuffType = 'ENERGYMAINTENANCEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.EnergyMaintenanceBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyMaintenanceBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyMaintenanceBuffRemove,
    Affects = {
        EnergyMaintenance = {
            Add = -0.225,
            Mult = 1.0,
        },
    },
}