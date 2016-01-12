local rock=Class("rock")

function rock:initialize(x,y,size)
	self.x=x
	self.y=y
	self.speed=love.math.random()*0.01
	self.rot=love.math.random()*2*Pi
	self.anim=res.asteroid()
	self.anim.currentFrame = love.math.random(1,64)
	self.anim.delay=love.math.random()*0.5+0.05
	self.size = size or love.math.random(2,3)
	self.r=self.size*16
	self.angle =  love.math.random()*2*Pi
	self.hp=200*self.size
	self.freeze=false
	self.exploiter=nil
	table.insert(game.rock, self)
end

function rock:getCanvas()
	self.canvas = love.graphics.newCanvas(self.r*2, self.r*2)
	love.graphics.setCanvas(self.canvas)
	love.graphics.setColor(color.white)
	love.graphics.draw(sheet3,self.anim.frame, 0, 0, self.angle, self.size, self.size, 16, 16)
	love.graphics.setCanvas()
	return self.canvas
end

function rock:destroy()
	self.dead=true
	self.freeze=true
	--table.removeItem(game.rock,self)
	self:getCanvas()
	local frag=res.otherClass.frag:new(self.x,self.y,self.angle,self.canvas)
	table.insert(game.frag, frag)
end

function rock:getDamage(from,damageType,damage)
	if self.dead  then return end
	self.hp=self.hp-damage
	if self.hp>0 and self.hp%100==0 then  --每100点伤害则带回一个小石头
		from.mine=self.class(self.x,self.y,1)
		from.mine.freeze=true
	end
	if self.hp<=0 then
		self:destroy()
	end
	from.hitCallBack(from,self)
end

function rock:update(dt)
	if self.exploiter and self.exploiter.dead then self.exploiter=nil end
	if self.dead  or self.freeze then return end
	self.x =self.x + math.cos(self.rot)*self.speed
	self.y =self.y + math.sin(self.rot)*self.speed
	self.anim:update(dt)
end

function rock:draw()
	if self.dead then return end
	self.alpha=game:getVisualAlpha(self)
	love.graphics.setColor(255,255,255,self.alpha)
	self.anim:draw(self.x, self.y, self.angle, self.size, self.size, 16, 16)
end


return rock
