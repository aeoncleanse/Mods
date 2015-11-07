#
# Cybran Anti Air Missile
#
local DumbRocketProjectile = import('/lua/BlackOpsprojectiles.lua').DumbRocketProjectile
local EffectTemplate = import('/lua/EffectTemplates.lua')
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker
DumbRocket01 = Class(DumbRocketProjectile) {
    }

TypeClass = DumbRocket01
