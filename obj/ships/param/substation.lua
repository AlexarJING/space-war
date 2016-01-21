local p={
	["ship"]={
		energyMax=500,
		armorMax=500,
		price_m=500,
		price_e=500,
		price_t=3,
		isMum=true	,
		name="substation",
		description="vice president",
		skin=90,
		size=4 ,
		speedMax=1 ,
		speedAcc=0.3,
		isSP=true,
		visualRange=500,
		fireRange=200,
		},
	["weapon"]={
			{
			posX=5,
			posY=0,
			rot=0,
			cd=10,
			type="impulse",
			wpn_param={
				speed=15,
				damage=5,
				life=100,
				skin=nil,
				sw=0,
				sh=0},
			},
		},
	["engine"]={
			{posX=-11,
			posY=0,
			rot=0,
			anim=4
			}

		}	
}

return p