local p={
	["ship"]={
		energyMax=400,
		armorMax=400 ,
		price_m=500,
		price_e=500,
		price_t=3,
		isMum=false	,
		name="cruiser",
		description="battle cruiser operational!",
		skin=85,
		size=4 ,
		speedMax=5 ,
		speedAcc=0.3,
		isSP=false,
		visualRange=600,
		fireRange=400,
		},
	["weapon"]={
			{
			posX=5,
			posY=0,
			rot=0,
			cd=20,
			type="impulse",
			wpn_param={
				speed=15,
				damage=5,
				life=150,
				skin=nil,
				sw=0,
				sh=0},
			},
			{
			posX=5,
			posY=0,
			rot=0,
			cd=20,
			type="missile",
			wpn_param={
				damage=10,
				life=150,
				speed=0.1,
				speedMax=10,
				visualRange=300,
				AOERange=50,
				AOEDamage=4},
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