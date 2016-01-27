local p={
	["ship"]={
		energyMax=150,
		armorMax=50 ,
		price_m=250,
		price_e=350,
		price_t=3,
		isMum=false	,
		name="generator",
		description="matirial is energy",
		skin=53,
		size=3 ,
		speedMax=3 ,
		speedAcc=1,
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
			type="tesla",
			wpn_param={
				damage=4,
				lines=4,
				life=30},
			},
		},
	["engine"]={
			{posX=-11,
			posY=0,
			rot=0,
			anim=2
			}

		}	
}

return p