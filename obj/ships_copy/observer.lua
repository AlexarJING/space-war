local ship=Class("observer",res.shipClass.base) --这个 要改“”中的名称 跟飞机名字对应就行了
local weapon=Class("ob_w",res.weaponClass.tesla)

function weapon:initialize(parent,x,y,rot)
	self.class.super.initialize(self,parent,x,y,rot)
	self.damage=2
	self.lines=2
	self.life=30
end


function ship:initialize(side,x,y,rot)
	self.class.super.initialize(self,side,x,y,rot)  
	
	self.energyMax=100
	self.armorMax=50

	self.name="observer"
	self.price_m=150
	self.price_e=100

	self.skin=61

	self.size=2 


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

