local ship=res.shipClass.substation
function ship:reset()
	table.insert(self.parent.sub,self)
	self.energy=self.energyMax
	self.armor=self.armorMax
	self.quad = res.ships[self.side][self.skin] 
	self.icon = self.quad
	self.r=8*self.size
	self.engineAni={}
	for i,v in ipairs(self.engineSys) do
		table.insert(self.engineAni, res.engineFire[v.anim]())
	end
	self:getCanvas()
end

return ship