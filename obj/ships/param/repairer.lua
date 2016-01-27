local p={
	["ship"]={
		energyMax=200,
		armorMax=200 ,
		price_m=350,
		price_e=200,
		price_t=3,
		isMum=false	,
		name="repairer",
		description="i have no hammer",
		skin=39,
		size=2.5 ,
		speedMax=5 ,
		speedAcc=0.3,
		isSP=true,
		visualRange=500,
		fireRange=200,
		testRange=2000
		},
	["weapon"]={
			{
			posX=5,
			posY=0,
			rot=0,
			cd=20,
			type="impulse",
			wpn_param={
				speed=10,
				damage=3,
				life=200,
				skin=nil,
				sw=0,
				sh=0},
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