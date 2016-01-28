local indicator=Class("indicator")


function indicator:initialize(x,y,r,step)
	self.x=x
	self.y=y
	self.r=r
	self.rMax=r
	self.count=step or 0
	table.insert(game.indicator, self)
end

function indicator:destroy()
	self.dead=true
end

function indicator:update(dt)

	self.r=self.r-self.rMax/10
	if self.r<0 then self.r=self.rMax end
end

function indicator:draw()
	love.graphics.setColor(0,255,0)
	love.graphics.setLineWidth(2)
	love.graphics.circle("line", self.x,self.y,self.r)
end

return indicator