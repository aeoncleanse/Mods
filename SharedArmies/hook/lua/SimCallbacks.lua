Callbacks.SetArmyShares = function()
    local focusarmy = GetFocusArmy()
    WARN('focusarmy is: ' .. focusarmy)
    if focusarmy ~= 0 and ArmyBrains[focusarmy].BrainType == 'Human' then
        local source = GetCurrentCommandSource()
        if not source then WARN('No Command Source Found') return end
        WARN('Letting army ' .. source .. ' control army 0')
        ArmyGetHandicap(0, source, true)
        ArmyGetHandicap(focusarmy, source, false)
        
        ForkThread(function()
            WaitSeconds(1)
            SimConExecute('SetFocusArmy 0')
            WARN('FocusArmy set to 0')
        end)
    end
end
