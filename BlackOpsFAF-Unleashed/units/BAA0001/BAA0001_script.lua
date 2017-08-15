-- Tempest Drone

local AirDroneUnit = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsunits.lua').AirDroneUnit
local WeaponsFile = import('/lua/aeonweapons.lua')
local ADFCannonOblivionWeapon = WeaponsFile.ADFCannonOblivionWeapon02
local AANDepthChargeBombWeapon = WeaponsFile.AANDepthChargeBombWeapon
local ADFQuantumAutogunWeapon = WeaponsFile.ADFQuantumAutogunWeapon

BAA0001 = Class(AirDroneUnit) {

    Weapons = {
        MainGun = Class(import('/lua/aeonweapons.lua').ADFCannonOblivionWeapon) {
            FxMuzzleFlash = {
                '/effects/emitters/oblivion_cannon_flash_04_emit.bp',
                '/effects/emitters/oblivion_cannon_flash_05_emit.bp',
                '/effects/emitters/oblivion_cannon_flash_06_emit.bp',
            },
        },
        BlazeGun = Class(ADFQuantumAutogunWeapon) {},
        Depthcharge = Class(AANDepthChargeBombWeapon) {},
    },

    OnStopBeingBuilt = function(self, builder, layer)
        AirDroneUnit.OnStopBeingBuilt(self, builder, layer)
        self.AnimManip = CreateAnimator(self)
        self.Trash:Add(self.AnimManip)
        self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationTakeOff, false):SetRate(1)
        if not self.OpenAnim then
            self.OpenAnim = CreateAnimator(self)
            self.Trash:Add(self.OpenAnim)
        end
    end,

    OnMotionVertEventChange = function(self, new, old)
        AirDroneUnit.OnMotionVertEventChange(self, new, old)
        -- Aborting a landing
        if ((new == 'Top' or new == 'Up') and old == 'Down') then
            self.AnimManip:SetRate(-1)
        elseif (new == 'Down') then
            self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationLand, false):SetRate(1)
        elseif (new == 'Up') then
            self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationTakeOff, false):SetRate(1)
        end
    end,

}

TypeClass = BAA0001
