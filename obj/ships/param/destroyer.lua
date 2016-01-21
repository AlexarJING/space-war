local p={
	["ship"]={
		energyMax=50,
		armorMax=300 ,
		price_m=250,
		price_e=150,
		price_t=3,
		isMum=false	,
		name="destroyer",
		description="boom boom boom",
		skin=82,
		size=3 ,
		speedMax=2.5 ,
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
			type="missile",
			wpn_param={
				damage=5,
				life=150,
				speed=0.1,
				speedMax=10,
				visualRange=300,
				AOERange=50,
				AOEDamage=3},
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