local ship=res.shipClass.generator
local rad=0
function ship:draw()
	self.class.super.draw(self)
	local a=game:getVisualAlpha(self)
	rad=rad+Pi/60
	if self.rechargeTarget then  
		for i,target in ipairs(self.rechargeTarget) do
			for i=5,1,-2 do
				love.graphics.setLineWidth(i)
				love.graphics.setColor(255-i*50, 255, 255-i*50, a)
				love.graphics.line(self.x, self.y, target.x, target.y)
				love.graphics.circle("fill", self.x, self.y,i)
				love.graphics.circle("line", target.x, target.y,i)
				love.graphics.setLineWidth(1)
				love.graphics.circle("line", target.x, target.y,target.r*math.sin(rad+i))
			end
		end
	end

	if self.abTarget then
		for i=1,5 do
			local rnd = love.math.random()
			love.graphics.setLineWidth(2)
			love.graphics.setColor(255*rnd, 255*rnd,255,a)
			love.graphics.drawLightning(self.x-self.r/2+love.math.random()*self.r,
				self.y-self.r/2+love.math.random()*self.r,
				self.abTarget.x-self.abTarget.r/2+love.math.random()*self.abTarget.r,
				self.abTarget.y-self.abTarget.r/2+love.math.random()*self.abTarget.r,50,15)
		end
	end

end

return ship