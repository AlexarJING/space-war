local p={
	["ship"]={
		energyMax=1000,
		armorMax=1000 ,
		price_m=1000,
		price_e=1000,
		price_t=3,
		isMum=true	,
		name="leader" ,
		description="Leader is a important unit.",
		skin=95,
		size=10 ,
		speedMax=0.5 ,
		speedAcc=0.3,
		isSP=true,
		visualRange=800,
		fireRange=500,
		},
	["weapon"]={
			{
			posX=5,
			posY=0,
			rot=0,
			level=20,
			cd=80,
			speed=8,
			type="missile",
			wpn_param={
				damage=10,
				life=150,
				speed=0.1,
				speedMax=10,
				visualRange=300,
				AOERange=50,
				AOEDamage=0}
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