local p={
	["ship"]={
		energyMax=100,
		armorMax=100 ,
		price_m=400,
		price_e=450,
		price_t=3,
		isMum=false	,
		name="surveillant",
		description="i got really good sight",
		skin=75,
		size=3 ,
		speedMax=5 ,
		speedAcc=0.3,
		isSP=false,
		visualRange=1000,
		fireRange=800,
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
				range=1000,
				width=10,
				laserW=10},
			}
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