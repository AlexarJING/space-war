local p={
	["ship"]={
		energyMax=300,
		armorMax=200 ,
		price_m=400,
		price_e=600,
		price_t=3,
		isMum=false	,
		name="annihilator",
		description="it's about the black hole",
		skin=34,
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
			type="missile",
			wpn_param={
				damage=8,
				life=30,
				lines=4}
			}
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