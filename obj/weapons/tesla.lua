local tesla=Class("tesla")

function tesla:initialize(parent,x,y,rot)

	self.px=parent.x
	self.py=parent.y
	self.ox=x
	self.oy=y
	self.x=x
	self.y=y
	self.lines=2
	self.life=30
	self.parent=parent
end



function tesla:update()
	
	self.target=self.parent.target
	if not self.target or not self.parent.inFireRange then 
		self.dead=true
		return 
	end
	if self.dead then return end
	self.x=self.ox+self.parent.x-self.px
	self.y=self.oy+self.parent.y-self.py
	self.life=self.life-1
	if self.life<0 then 
		self.dead=true 
		self.dead=true
	end
	if not self.target then
		return
	else
		self.tx=self.target.x+(0.5-love.math.random())*self.target.r/2
		self.ty=self.target.y+(0.5-love.math.random())*self.target.r/2
	end

	if self.target then
		game:newSpark(self.tx,self.ty)
		self.target:getDamage(self.parent,"energy",self.damage)
	end
end


function tesla:draw()
	if self.dead then return end
	if not self.target then return end
	local a=game:getVisualAlpha(self)
	for i=1,self.lines do
		local rnd = love.math.random()
		love.graphics.setLineWidth(self.parent.size*rnd)
		love.graphics.setColor(255*rnd, 255*rnd,255,a)
		love.graphics.drawLightning(self.x,self.y,self.tx,self.ty,20,5)
	end

end


return tesla