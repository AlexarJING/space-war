local charge={
	["enter"]=function(self,ship) 
		self.dtspeed=ship.speedMax; 
		ship.speedMax=2*ship.speedMax;
		self.dtspeed=ship.speedMax-self.dtspeed 
		self.time=3
	end,
	["update"]=function(self,ship,dt)
		self.time=self.time-dt
		if self.time<0 then
			return true
		end
	end,
	["leave"]=function(self,ship) 
		ship.speedMax=ship.speedMax-self.dtspeed
	end
}

return {
	["7"]={
		text="charge", 
		text2="ship's max speed is doubled in 5 seconds",
		icon=190, 
		cd=30,
		func=function(obj,x,y,ship) 
			ship:addBuff(charge)
		end,
	}
}