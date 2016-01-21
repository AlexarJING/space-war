local p={
	["ship"]={
		energyMax=200,
		armorMax=50 ,
		price_m=250,
		price_e=300,
		price_t=3,
		isMum=false	,
		name="fighter",
		description="one shoot one kill",
		skin=20,
		size=2.5 ,
		speedMax=7 ,
		speedAcc=0.1,
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
			type="laser",
			wpn_param={
				damage=5,
				range=500,
				width=7,
				laserW=7},
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