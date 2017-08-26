local oldBeginSession = BeginSession

function BeginSession()
    WARN('Hooked BeginSession called')
    oldBeginSession()
    LOG('Old BeginSession done')
    import('/mods/SharedArmies/modules/ArmySharing.lua').CombineTeams()
end