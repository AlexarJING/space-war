local p={
	["ship"]={
		energyMax=100,
		armorMax=1 ,
		price_m=0,
		price_e=0,
		price_t=0,
		isMum=false	,
		name="slicer",
		description="not in one piece",
		skin=58,
		size=3 ,
		speedMax=0 ,
		speedAcc=0,
		isSP=true,
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
					damage=4,
					range=100,
					width=5,
					laserW=5},
			},
		},
	["engine"]={
		}	
}

return p