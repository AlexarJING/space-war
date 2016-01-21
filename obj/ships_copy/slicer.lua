local ship=Class("slicer",res.shipClass.base) --这个 要改“”中的名称 跟飞机名字对应就行了
local weapon=Class("sl_w",res.weaponClass.laser)

function weapon:initialize(parent,x,y,rot)
	self.class.super.initialize(self,parent,x,y,rot)
	self.damage=4
	self.range=100
	self.width=5
	self.laserW=self.width
end


function ship:initialize(side,x,y,rot)
	self.class.super.initialize(self,side,x,y,rot)  
	
	self.energyMax=100 
	self.armorMax=1 

	self.name="slicer"
	self.price_m=0
	self.price_e=0

	self.skin=58

	self.size=2 


	self.speedMax=0 
	self.speedAcc=0 



	self.visualRange=500 
	self.fireRange=100

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
	}

	self:reset()
end

return ship

