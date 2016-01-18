local ship=Class("destroyer",res.shipClass.base) --这个 要改“”中的名称 跟飞机名字对应就行了
local weapon=Class("de_w",res.weaponClass.missile)

function weapon:initialize(parent,x,y,rot)
	self.class.super.initialize(self,parent,x,y,rot)
	self.damage=5
	self.life=150
	self.speed=0.1
	self.speedMax=10
	self.visualRange=300
	self.AOERange=self.size*10
	self.AOEDamage=3
end


function ship:initialize(side,x,y,rot)
	self.class.super.initialize(self,side,x,y,rot)  
	
	self.energyMax=50 
	self.armorMax=300 

	self.name="destroyer"
	self.price_m=250
	self.price_e=150

	self.skin=82

	self.size=2.5 


	self.speedMax=2.5 
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

