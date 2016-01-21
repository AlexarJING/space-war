local ship=Class("cruiser",res.shipClass.base) --这个 要改“”中的名称 跟飞机名字对应就行了
local weapon=Class("cr_w",res.weaponClass.impulse)

function weapon:initialize(parent,x,y,rot)
	self.class.super.initialize(self,parent,x,y,rot)
	self.speed=15
	self.damage=5
	self.life=150
	self.skin=nil
	self.sw=0
	self.sh=0
end

local weapon2=Class("cr_w2",res.weaponClass.missle)

function weapon:initialize(parent,x,y,rot)
	self.class.super.initialize(self,parent,x,y,rot)
	self.damage=10
	self.life=150
	self.speed=0.1
	self.speedMax=10
	self.visualRange=300
	self.AOERange=self.size*10
	self.AOEDamage=4
end


function ship:initialize(side,x,y,rot)
	self.class.super.initialize(self,side,x,y,rot)  
	
	self.energyMax=400 
	self.armorMax=400 

	self.name="cruiser"
	self.price_m=500
	self.price_e=500

	self.skin=85

	self.size=4 


	self.speedMax=5 
	self.speedAcc=0.3 



	self.visualRange=600 
	self.fireRange=400

	self.fireSys={
		{
			posX=3,
			posY=5,
			rot=0,
			wpn=weapon,
			cd=20,
		},
		{
			posX=3,
			posY=5,
			rot=0,
			wpn=weapon2,
			cd=100,
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

