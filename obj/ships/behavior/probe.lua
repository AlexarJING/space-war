local ship=res.shipClass.probe

function ship:update(dt)
	self.class.super.update(self,dt)
	self.energy=self.energy-1/60
	if self.energy<0 then
		self:destroy()
	end
end