local ship=Class("bee",res.shipClass.base) --这个 要改“”中的名称 跟飞机名字对应就行了
local weapon=Class("be_w",res.weaponClass.impulse)

function weapon:initialize(parent,x,y,rot)
	self.class.super.initialize(self,parent,x,y,rot)
	self.speed=10
	self.damage=3
	self.life=100
	self.skin=nil
	self.sw=0
	self.sh=0
end


function ship:initialize(side,x,y,rot)
	self.class.super.initialize(self,side,x,y,rot)  
	
	self.energyMax=50 
	self.armorMax=100 

	self.name="bee"
	self.price_m=100
	self.price_e=50

	self.skin=2

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

