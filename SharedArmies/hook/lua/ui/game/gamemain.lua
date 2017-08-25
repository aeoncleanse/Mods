local oldCreateUI = CreateUI

function CreateUI(isReplay)
    WARN('CreateUI hook called in gamemain')
    oldCreateUI(isReplay)
    LOG('oldCreateUI done')
    
    SimCallback({Func = 'SetArmyShares', Args = {}})
end
