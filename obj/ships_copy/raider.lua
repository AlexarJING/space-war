local ship=Class("raider",res.shipClass.base) --这个 要改“”中的名称 跟飞机名字对应就行了
local weapon=Class("ra_w",res.weaponClass.missile)

function weapon:initialize(parent,x,y,rot)
	self.class.super.initialize(self,parent,x,y,rot)
	self.damage=5
	self.life=150
	self.speed=0.1
	self.speedMax=10
	self.visualRange=300
	self.AOERange=self.size*10
	self.AOEDamage=0
end


function ship:initialize(side,x,y,rot)
	self.class.super.initialize(self,side,x,y,rot)  
	
	self.energyMax=30 
	self.armorMax=30 

	self.name="raider"
	self.price_m=100
	self.price_e=50

	self.skin=45

	self.size=2 


	self.speedMax=6 
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

