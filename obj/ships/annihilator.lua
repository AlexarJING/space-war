local ship=Class("annihilator",res.shipClass.base) --这个 要改“”中的名称 跟飞机名字对应就行了
local weapon=Class("an_w",res.weaponClass.tesla)

function weapon:initialize(parent,x,y,rot)
	self.class.super.initialize(self,parent,x,y,rot)
	self.damage=8
	self.lines=4
	self.life=30
end


function ship:initialize(side,x,y,rot)
	self.class.super.initialize(self,side,x,y,rot)  
	self.energyMax=300
	self.armorMax=200 

	self.name="annihilator"
	self.price_m=400
	self.price_e=600

	self.skin=34

	self.size=3 


	self.speedMax=5 
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

