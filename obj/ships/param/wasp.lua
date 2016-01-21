local p={
	["ship"]={
		energyMax=100,
		armorMax=150 ,
		price_m=200,
		price_e=100,
		price_t=3,
		isMum=false	,
		name="wasp",
		description="larger and stronger then bees",
		skin=5,
		size=3 ,
		speedMax=5 ,
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
				life=150,
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