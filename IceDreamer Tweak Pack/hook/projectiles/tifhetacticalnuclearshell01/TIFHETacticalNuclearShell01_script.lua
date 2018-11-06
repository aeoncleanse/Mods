--
-- UEF Anti-Matter Shells
--
do
local TArtilleryAntiMatterProjectile = import('/lua/terranprojectiles.lua').TArtilleryAntiMatterProjectile
TIFAntiMatterShells01 = Class(TArtilleryAntiMatterProjectile) {
    FxLandHitScale = 1.4,
}

TypeClass = TIFAntiMatterShells01
end