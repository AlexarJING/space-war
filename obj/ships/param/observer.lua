local p={
	["ship"]={
		energyMax=100,
		armorMax=50 ,
		price_m=150,
		price_e=100,
		price_t=3,
		isMum=false	,
		name="observer",
		description="i carry my eyes in my pack",
		skin=66,
		size=2.5 ,
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
			type="tesla",
			wpn_param={
				damage=2,
				lines=2,
				life=30},
			},
		},
	["engine"]={
			{posX=-11,
			posY=0,
			rot=0,
			anim=1
			}

		}	
}

return p