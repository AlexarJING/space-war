local p={
	["ship"]={
		energyMax=50,
		armorMax=50 ,
		price_m=100,
		price_e=50,
		price_t=3,
		isMum=false	,
		name="miner",
		description="work work",
		skin=70,
		size=2 ,
		speedMax=3 ,
		speedAcc=0.3,
		isSP=true,
		visualRange=500,
		fireRange=200,
		state="mine",
		testRange=5000
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