Callbacks.SetArmyShares = function()
    WARN('SetArmyShares')
    local source = GetCurrentCommandSource()
    LOG('Command source is ' .. source)
    
    local focus = GetFocusArmy()
    LOG('Focus army is ' .. focus)
    
    WARN('Logging army types')
    for id, brain in ArmyBrains do
        LOG(brain.BrainType)
    end
    
    WARN('Logging ScenarioInfo.ArmySetup')
    LOG(repr(ScenarioInfo.ArmySetup))
    
    --local count = 1
    --for id, brain in ArmyBrains do
        --if brain.BrainType == 'Human' and id ~= 0 then
            ArmyGetHandicap(0, 1, true)
            ArmyGetHandicap(1, 1, false)
            ArmyGetHandicap(0, 2, true)
            ArmyGetHandicap(2, 2, false)
            --count = count + 1
        --end
    --end
    
    ForkThread(function()
        WaitSeconds(1)
        SimConExecute('SetFocusArmy 0')
        WARN('FocusArmy set to 0')
    end)
end
