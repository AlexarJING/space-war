local function getDamage(self,from,damageType,damage)
	if damage>20 then damage=20 end
	if damageType=="physic" then --物理
		if self.energy>=damage then
			self.energy=self.energy-damage
		else
			self.armor=self.armor-(damage-self.energy)*0.5
			self.energy=0
		end
	elseif damageType=="energy" then --能量
		if self.energy>=damage*0.5 then
			self.energy=self.energy-damage*0.5
		else
			self.armor=self.armor-(damage*0.5-self.energy)*2
			self.energy=0
		end
	elseif damageType=="real" then
		if self.energy>=damage then
			self.energy=self.energy-damage
		else
			self.armor=self.armor-(damage-self.energy)
			self.energy=0
		end
	end
	if self.armor<=0 then
		game.event:check("onKill",from,self)
		self:destroy()
	end
	game.event:check("onGotHit",from,self)
	from.hitCallBack(from,self)
end

local df={
	["enter"]=function(self,ship) 
		self.func=ship.getDamage
		ship.getDamage=getDamage
		self.time=20
	end,
	["update"]=function(self,ship,dt)
		self.time=self.time-dt
		if self.time<0 then
			return true
		end
	end,
	["leave"]=function(self,ship) 
		ship.getDamage=self.func
	end
}





return {
	["7"]={
		text="crystal lattice shell",
		description="damage per attack is no more then 20 for 10 seconds" ,
		icon=286, 
		isActive=false,
		cd=60,
		func=function(obj,x,y,ship) 
			ship:addBuff(df)
		end,
	}
}