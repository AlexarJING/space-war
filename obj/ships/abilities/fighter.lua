return {
	["7"]={
		text="slicer", 
		text2="send a fixed slicer to the place only once",
		icon=285,
		func=function(obj,x,y,ship) 
			obj.enabled=false
			res.shipClass.slicer(ship.parent,ship.x,ship.y)
		end,
	}
}