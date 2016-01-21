local p={
	["ship"]={
		energyMax=50,
		armorMax=100 ,
		price_m=100,
		price_e=50,
		price_t=3,
		isMum=false	,
		name="bee",
		description="basic unit, build one tone of that",
		skin=2,
		size=2 ,
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
			type="impulse",
			wpn_param={
				speed=10,
				damage=3,
				life=100,
				skin=nil,
				sw=0,
				sh=0},
			}
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