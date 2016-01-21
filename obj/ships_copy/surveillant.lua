local ship=Class("suiveillant",res.shipClass.base) --这个 要改“”中的名称 跟飞机名字对应就行了
local weapon=Class("su_w",res.weaponClass.laser)

function weapon:initialize(parent,x,y,rot)
	self.class.super.initialize(self,parent,x,y,rot)
	self.damage=5
	self.range=1000
	self.width=self.parent.size*5
	self.laserW=self.width
	self.target=nil
end


function ship:initialize(side,x,y,rot)
	self.class.super.initialize(self,side,x,y,rot)  
	
	self.energyMax=100 
	self.armorMax=100 

	self.name="suiveillant"
	self.price_m=400
	self.price_e=500 	

	self.skin=75

	self.size=3 


	self.speedMax=5 
	self.speedAcc=0.3 



	self.visualRange=1000 
	self.fireRange=800

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

