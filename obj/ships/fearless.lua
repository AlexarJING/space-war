local ship=Class("fearless",res.shipClass.base) --这个 要改“”中的名称 跟飞机名字对应就行了


function ship:initialize(side,x,y,rot)
	self.class.super.initialize(self,side,x,y,rot)  
	
	self.energyMax=200 
	self.armorMax=1

	self.name="fearless"
	self.price_m=100
	self.price_e=200

	self.skin=46

	self.size=2.5 


	self.speedMax=6
	self.speedAcc=0.1 



	self.visualRange=500 
	self.fireRange=500

	self.fireSys={
	}


	self.engineSys={
		{posX=-9,
		posY=0,
		rot=0,
		anim=4
		}
	}

	self:reset()
end

return ship

