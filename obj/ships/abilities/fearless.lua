local charge={
	["enter"]=function(self,ship) 
		self.charge=3;
		ship.isCharging=true
	end,
	["update"]=function(self,ship,dt)
		self.charge=self.charge-dt
		if self.charge<0 then
			ship.isCharging=false
			return true
		end
	end,
	["leave"]=function(self,ship) 
		ship:destroy()
		local frag=res.otherClass.frag(ship.x,ship.y,0,_,200)
		table.insert(game.frag, frag)
		for i,v in ipairs(game.ship) do
			if  math.getDistance(ship.x,ship.y,v.x,v.y)<200 then
				v:getDamage(ship,"energy",ship.energy/5)
			end
		end
	end
}



return {
	["7"]={
		text="nova", 
		text2="use all the energy of the ship to make a big bang",
		icon=156,
		cd=3,
		func=function(obj,x,y,ship) 
			ship:addBuff(charge)
		end,
	}
}