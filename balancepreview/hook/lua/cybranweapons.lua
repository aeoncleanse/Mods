CMobileKamikazeBombWeapon = Class(KamikazeWeapon){
	FxDeath = EffectTemplate.CMobileKamikazeBombExplosion,

    OnFire = function(self)
		local army = self.unit:GetArmy()
        for k, v in self.FxDeath do
            CreateEmitterAtBone(self.unit,-2,army,v):ScaleEmitter(1.3)
        end
		KamikazeWeapon.OnFire(self)
    end,
}