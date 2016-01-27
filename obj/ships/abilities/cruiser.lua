local powerUp={
	["enter"]=function(self,ship) 
		self.cd1=ship.fireSys[1].cd; 
		self.cd2=ship.fireSys[2].cd
		self.time=10
	end,
	["update"]=function(self,ship,dt)
		self.time=self.time-dt
		if self.time<0 then
			return true
		end
	end,
	["leave"]=function(self,ship) 
		ship.fireSys[1].cd=self.cd1
		ship.fireSys[2].cd=self.cd2
	end
}

return {
	["7"]={
		text="overwhelm", 
		text2="all cd of weapons are 50% off for 10 seconds",
		icon=161, 
		cd=30,
		func=function(obj,x,y,ship) 
			if game:pay(ship,200) then
				ship:addBuff(powerUp)
			end
		end,
	}
}
