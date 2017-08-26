local oldCreateUI = CreateUI

function CreateUI(isReplay)
    WARN('CreateUI hook called in gamemain')
    LOG("First Command sources run:")
    local armiesTable = GetArmiesTable().armiesTable
    for id, army in armiesTable do
        LOG(id .. " -> " .. repr(army.authorizedCommandSources))
    end
    oldCreateUI(isReplay)
    LOG('oldCreateUI done')
    
    SimCallback({Func = 'SetArmyShares', Args = {}})
    
    ForkThread(function()
        WaitSeconds(1)
        LOG("Second Command sources run:")
        local armiesTable = GetArmiesTable().armiesTable
        for id, army in armiesTable do
            LOG(id .. " -> " .. repr(army.authorizedCommandSources))
        end
    end)
end
