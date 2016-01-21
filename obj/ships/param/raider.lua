local p={
	["ship"]={
		energyMax=30,
		armorMax=30 ,
		price_m=100,
		price_e=50,
		price_t=3,
		isMum=false	,
		name="raider",
		description="one shoot one kill",
		skin=45,
		size=2 ,
		speedMax=6 ,
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
				AOERange=30,
				AOEDamage=0},
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