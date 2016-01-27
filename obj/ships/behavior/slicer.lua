local ship=res.shipClass.slicer
function ship:moveTo()

end


function ship:update(dt)
	self.class.super.update(self,dt)
	self.energy=self.energy-1/60
	
	self.moveRot=self.moveRot+Pi/60
	self.rot=self.moveRot
	self:fire()
	if self.energy<0 then
		self:destroy()
	end
end