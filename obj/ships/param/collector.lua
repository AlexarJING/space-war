local p={
	["ship"]={
		energyMax=150,
		armorMax=150 ,
		price_m=100,
		price_e=50,
		price_t=3,
		isMum=false	,
		name="collector",
		description="matirial teleporter inside!",
		skin=73,
		size=2 ,
		speedMax=3 ,
		speedAcc=0.3,
		isSP=true,
		visualRange=500,
		fireRange=200,
		testRange=5000
		},
	["weapon"]={
			{
			posX=5,
			posY=0,
			rot=0,
			cd=20,
			type="laser",
			wpn_param={
				damage=3,
				range=500,
				width=15,
				laserW=15},
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