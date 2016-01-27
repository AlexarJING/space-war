local drawPower={
	["enter"]=function(self,ship) 
		ship.abActive=false
		ship.drawPowerCd=1
		ship.drawPowerTimer=-1
		ship.drawPowerRange=300
	end,
	["update"]=function(self,ship,dt)
		if ship.abActive then
			ship.drawPowerTimer=ship.drawPowerTimer-dt
			if ship.drawPowerTimer<0 then
				ship.drawPowerTimer=ship.drawPowerCd
				ship.drawPowerTarget={}
				for i,v in ipairs(game.ship) do
					if math.getDistance(ship.x,ship.y,v.x,v.y)<300 and ship~=v then
						if game:pay(v,2,0) then
							table.insert(ship.drawPowerTarget,v)
							ship.energy=ship.energy+2
							if ship.energy>ship.energyMax then
								ship.energy=ship.energyMax
							end
						end
					end
				end
			end
		end
	end,
	["leave"]=function(self,ship) 
	end
}



local abilities={
	["7"]={
		text="vortex of power",
		description="draw all then units energy nearby by 2 per second when active" ,
		icon=282, 
		isActive=true,
		func=function(obj,x,y,ship) 
			if ship.abActive==nil then
				ship:addBuff(drawPower)

			end
			obj.toggle=obj.toggle=="on" and "off" or "on"
			ship.abActive=not ship.abActive
			
		end,
	},
	["8"]={
		text="black hole",
		description="cast a uncontrolable blackhole which moves slowly",
		icon=155, 
		func=function(obj,x,y,ship) 
			if game:pay(ship,ship.energyMax,0) then
				table.insert(game.bullet, res.weaponClass.proton(ship,ship.x,ship.y,ship.rot))
			end
		end,
	},
}

return abilities 