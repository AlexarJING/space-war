local ship=Class("generator",res.shipClass.base) --这个 要改“”中的名称 跟飞机名字对应就行了
local weapon=Class("ge_w",res.weaponClass.tesla)

function weapon:initialize(parent,x,y,rot)
	self.class.super.initialize(self,parent,x,y,rot)
	self.damage=4
	self.lines=4
	self.life=30
end


function ship:initialize(side,x,y,rot)
	self.class.super.initialize(self,side,x,y,rot)  
	
	self.energyMax=150 
	self.armorMax=50

	self.name="generator"
	self.price_m=250
	self.price_e=350

	self.skin=94

	self.size=2.5 


	self.speedMax=3 
	self.speedAcc=0.3 



	self.visualRange=500 
	self.fireRange=200

	self.fireSys={
		{
			posX=3,
			posY=5,
			rot=0,
			wpn=weapon,
			cd=20,
		},
	}


	self.engineSys={
		{posX=-9,
		posY=0,
		rot=0,
		anim=1
		}
	}

	self:reset()
end

return ship

