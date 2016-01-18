local ship=Class("probe",res.shipClass.base) --这个 要改“”中的名称 跟飞机名字对应就行了


function ship:initialize(side,x,y,rot)
	self.class.super.initialize(self,side,x,y,rot)  
	
	self.energyMax=50 
	self.armorMax=1 

	self.name="probe"
	self.price_m=0
	self.price_e=0

	self.skin=61

	self.size=1 


	self.speedMax=0 
	self.speedAcc=0 



	self.visualRange=500 
	self.fireRange=0

	self.fireSys={
	}


	self.engineSys={
	}

	self:reset()
end

return ship

