--
-- Cybran Anti Air Missile
--
local DumbRocketProjectile = import('/mods/BlackOpsUnleashed/lua/BlackOpsprojectiles.lua').DumbRocketProjectile
local EffectTemplate = import('/lua/EffectTemplates.lua')
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker
DumbRocket02 = Class(DumbRocketProjectile) {}

TypeClass = DumbRocket02
