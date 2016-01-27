local ship=res.shipClass.raider

function ship:reset()
	self.energy=self.energyMax
	self.armor=self.armorMax
	self.quad = res.ships[self.side][self.skin] 
	self.icon = self.quad
	self.r=8*self.size
	self.engineAni={}
	for i,v in ipairs(self.engineSys) do
		table.insert(self.engineAni, res.engineFire[v.anim]())
	end
	self.killCallBack=function()
		self.parent.mineral=self.parent.mineral+2
	end
	self:getCanvas()
end