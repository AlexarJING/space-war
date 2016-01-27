local ship=res.shipClass.annihilator


function ship:reset()
	self.energy=0
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


function ship:draw()
	self.class.super.draw(self)
	if not self.drawPowerTarget then return end

	local a=game:getVisualAlpha(self)
	if self.drawPowerVisTime then
		self.drawPowerVisTime=self.drawPowerVisTime-1
	else
		self.drawPowerVisTime=10
	end

	if self.drawPowerVisTime<0 then self.drawPowerTarget=nil;self.drawPowerVisTime=nil; return end
	
	for i,target in ipairs(self.drawPowerTarget) do
		local rnd = love.math.random()
		love.graphics.setLineWidth(1)
		love.graphics.setColor(255*rnd, 255*rnd,255,a)
		love.graphics.drawLightning(self.x,self.y,target.x,target.y,15,15)
	end


end

return ship