local laser=Class("laser")

function laser:initialize(parent,x,y,rot)
	self.px=parent.x
	self.py=parent.y
	self.ox=x
	self.oy=y
	self.range=500
	self.width=parent.size*5
	self.rot=rot
	self.parent=parent
	self.target=parent.target
	self.laserW=self.width
	self.multiply=1
	self.limit=false
end

function laser:hitTest()
    local tab
    if self.parent.state=="mine" then 
    	tab=game.rock
    else
    	tab=game.ship
    end
    local test=math.raycast(self,tab)
    for i,v in ipairs(test) do
    	if v[1].side~=self.parent.side and math.getDistance(self.x,self.y,v[1].x,v[1].y)<=self.range then
    		game:newSpark(v[2],v[3])
    		v[1]:getDamage(self.parent,"energy",self.damage*self.multiply)
    	end
    end

end


function laser:update()
	self.x=self.ox+self.parent.x-self.px
	self.y=self.oy+self.parent.y-self.py

	if self.limit and self.parent.target then
		self.range=math.getDistance(self.x,self.y,self.parent.target.x,self.parent.target.y)
	end
	if self.destroy then return end
	
	self.laserW=self.laserW-self.width/10
	if self.laserW<1 then 
		self.destroy=true 
		self.dead=true
	end
	self:hitTest()
end





function laser:draw()
	if self.destroy then return end
	local a=game:getVisualAlpha(self)
	for i=self.laserW,1,-5 do
		love.graphics.setLineWidth(i)
		local c= 255-i*15<0 and 0 or 255-i*15
		love.graphics.setColor(c, c, 255,a)
		love.graphics.circle("fill", self.x, self.y, i)
		love.graphics.line(self.x, self.y, self.x+math.cos(self.rot)*self.range, self.y+math.sin(self.rot)*self.range) 
		love.graphics.circle("fill", self.x+math.cos(self.rot)*self.range, self.y+math.sin(self.rot)*self.range, i/2)
	end
end


return laser
