-----------------------------------------------------------------------------------
-- File     :  /effects/Entities/Cluster01Effect02/Cluster01Effect05_script.lua
-- Author(s):  Gordon Duclos
-- Summary  :  Nuclear explosion script
-- Copyright © 2005, 2006 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------------------------

local NullShell = import('/lua/sim/defaultprojectiles.lua').NullShell
local EffectTemplate = import('/lua/EffectTemplates.lua')

Cluster01Effect05 = Class(NullShell) {
    OnCreate = function(self)
        NullShell.OnCreate(self)
        self:ForkThread(self.EffectThread)
    end,

    EffectThread = function(self)
        local army = self:GetArmy()

        for _, v in EffectTemplate.TNukeBaseEffects02 do
            CreateEmitterOnEntity(self, army, v):ScaleEmitter(0.03125)
        end
    end,
}

TypeClass = Cluster01Effect05
