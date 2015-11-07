do

local Game = import('/lua/game.lua')

local CBFP_DefaultBeamWeapon = DefaultBeamWeapon
DefaultBeamWeapon = Class(CBFP_DefaultBeamWeapon) {
    BeamLifetimeThread = function(self, beam, lifeTime) 
        WaitSeconds(lifeTime)
        WaitTicks(1) # added by brute51 fix for beam weapon DPS bug [101]
        self:PlayFxBeamEnd(beam) 
    end, 
}


end