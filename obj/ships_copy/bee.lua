local ship=Class("bee",res.shipClass.base)
res.loadParam(ship,"bee")
res.loadAbilities(ship,"bee")


function ship:initialize(sideOrParent,x,y,rot)
	self.class.super.initialize(self,sideOrParent,x,y,rot)  --x,y 不用管
	for k,v in pairs(ship.static) do
		self[k]=v
	end
	self:reset()
end

return ship