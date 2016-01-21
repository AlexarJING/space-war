local p={
	["ship"]={
		energyMax=0,
		armorMax=500 ,
		price_m=300,
		price_e=300,
		price_t=3,
		isMum=false	,
		name="defender",
		description="full of armor!",
		skin=49,
		size=3 ,
		speedMax=3 ,
		speedAcc=0.3,
		isSP=false,
		visualRange=500,
		fireRange=200,
		},
	["weapon"]={
			{
			posX=5,
			posY=0,
			rot=0,
			cd=20,
			type="impulse",
			wpn_param={
				speed=10,
				damage=6,
				life=80,
				skin=nil,
				sw=0,
				sh=0},
			},
		},
	["engine"]={
			{posX=-11,
			posY=0,
			rot=0,
			anim=3
			}

		}	
}

return p