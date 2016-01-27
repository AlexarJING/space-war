local devour={
	["enter"]=function(self,ship) 
		local dist
		local pos
		local len=300
		for i,v in ipairs(game.rock) do
			local range=math.getDistance(ship.x,ship.y,v.x,v.y)
			local test=range<len and range or nil 
			if v.exploiter  then test= nil end
			if  test then
				if not dist then
					dist=test
					pos=i
				else
					if dist>test then
						dist=test
						pos=i
					end
				end
			end
		end
		if dist then ship.abTarget=game.rock[pos] end
		self.time=5
	end
	,
	["update"]=function(self,ship,dt)
		self.time=self.time-dt
		if self.time<0 then
			return true
		end
	end,
	["leave"]=function(self,ship) 
		ship.abTarget:destroy()
		ship.energy=ship.energy+100*ship.abTarget.size
		if ship.energy>ship.energyMax then ship.energy=ship.energyMax end
		ship.abTarget=nil
	end
}


local recharge={
	["enter"]=function(self,ship) 
		ship.abActive=false
		ship.rechargeRange=300
	end,
	["update"]=function(self,ship,dt)
		if ship.abActive then
			ship.rechargeTarget={}
			for i,v in ipairs(game.ship) do
				if math.getDistance(ship.x,ship.y,v.x,v.y)<ship.rechargeRange and ship~=v then
					if v.energy<v.energyMax and game:pay(ship,0.1,0) then
						table.insert(ship.rechargeTarget,v)
						v.energy=v.energy+0.3
						if v.energy>v.energyMax then
							v.energy=v.energyMax
						end

					end
				end
			end
		else
			ship.rechargeTarget=nil
		end
	end,
	["leave"]=function(self,ship) 
	end
}







return {
	["7"]={
		text="recharge", 
		text2="recharge all allian units nearby when still",
		icon=221,
		cd=3,				
		func=function(obj,x,y,ship) 
			if ship.abActive==nil then
				ship:addBuff(recharge)
			end
			obj.toggle=obj.toggle=="on" and "off" or "on"
			ship.abActive=not ship.abActive		
		end,
	},
	["8"]={
		text="devour", 
		text2="devour a asteroid nearby to charge the energy by the size of the asteroid",
		icon=274,
		cd=300,
		func=function(obj,x,y,ship) 
			ship:addBuff(devour)
		end,
	}
}