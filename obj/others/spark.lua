local spark=Class("spark")

function spark:initialize(x,y)
	self.x,self.y=x,y
	self.ox,self.oy=x,y
	self.speedX=-5+love.math.random()*10
	self.speedY=-5+love.math.random()*10
	self.life=0.2
	table.insert(game.spark, self)
end

function spark:update(dt)
	dt=dt or 1/60
	if self.destroy then 
		return 
	end
	self.life=self.life-dt
	if self.life<0 then 
		self.destroy=true 
		self.dead=true
	end	
	self.ox,self.oy=self.x,self.y
	self.x=self.x+self.speedX
	self.y=self.y+self.speedY
end



function spark:draw()
	if self.destroy then return end
	local a=game:getVisualAlpha(self)
	love.graphics.setColor(255,255,0,a)
	love.graphics.setLineWidth(2)
	love.graphics.line(self.x,self.y, self.ox,self.oy )
end

return spark