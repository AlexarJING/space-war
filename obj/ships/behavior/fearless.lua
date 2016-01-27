local ship=res.shipClass.fearless

function ship:draw()
	self.class.super.draw(self)
	if self.isCharging then
		local a=game:getVisualAlpha(self)
		for i=1,1 do	
			love.graphics.setLineWidth(2)
			love.graphics.setColor(255, 255*love.math.random(),255*love.math.random(),a)
			local tx,ty=math.axisRot(self.size*5,0, love.math.random()*2*Pi)
			love.graphics.drawLightning(self.x,self.y,self.x+tx,self.y+ty,50,8)
		end
	end
end

return ship