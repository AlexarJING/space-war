return {
	["7"]={
		text="probe", 
		text2="send a fixed probe to the place for 60 energy",
		icon=163,
		func=function(obj,x,y,ship) 
			if game:pay(ship,60) then
				res.shipClass.probe(ship.parent,ship.x,ship.y)
			end
		end,
	}
}