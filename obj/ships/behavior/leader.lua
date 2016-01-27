local ship=res.shipClass.leader
function ship:reset()
	self.energy=self.energyMax/2
	self.armor=self.armorMax/2
	self.quad = res.ships[self.side][self.skin] 
	self.icon = self.quad
	self.r=8*self.size
	self.sub={}
	self.engineAni={}
	for i,v in ipairs(self.engineSys) do
		table.insert(self.engineAni, res.engineFire[v.anim]())
	end
	self:getCanvas()
end


function ship:draw()
	self.class.super.draw(self)
	if self.isCharging then
		local a=game:getVisualAlpha(self)
		for i=1,5 do	
		local rnd = love.math.random()
		love.graphics.setLineWidth(2)
		love.graphics.setColor(255*rnd, 255*rnd,255,a)
		local tx,ty=math.axisRot(self.size*5,0, love.math.random()*2*Pi)
		love.graphics.drawLightning(self.x,self.y,self.x+tx,self.y+ty,20,8)
		end
	end
end

return ship