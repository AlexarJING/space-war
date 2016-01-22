local impulse=Class("impulse")
function impulse:initialize(parent,x,y,rot)
	self.x=x
	self.y=y
	self.rot=rot
	self.parent=parent
	self.life=100
	self.skin=nil
	self.sw=0
	self.sh=0
	self.multiply=5
end

function impulse:collision(t)
	if math.getDistance(self.x,self.y,t.x,t.y)<=t.size*8 then
		return true
	end
end

function impulse:hitTest()
	for i,v in ipairs(game.ship) do
		if v.side~=self.parent.side and self:collision(v) then
			self.destroy=true --进入爆炸
			self.dead=true --爆炸完成，删除资源
			for i=1,5 do
				game:newSpark(self.x,self.y)
			end
			v:getDamage(self.parent,"physic",self.damage*self.multiply)
		end		
	end

end


function impulse:update()
	if self.destroy then 
		return 
	end
	self:hitTest()
	self.ox=self.x
	self.oy=self.y
	self.x =self.x + math.cos(self.rot)*self.speed
	self.y =self.y + math.sin(self.rot)*self.speed
	self.life=self.life-1
	if self.life<0 then
		self.dead=true
		self.destroy=true
	end
end



function impulse:draw()
	if self.destroy then return end
	local a=game:getVisualAlpha(self)
	love.graphics.setLineWidth(self.parent.size+1)
	love.graphics.setColor(255, 0,0,a)
	love.graphics.line(self.x,self.y,self.ox,self.oy)
	love.graphics.setLineWidth(self.parent.size)
	love.graphics.setColor(255, 255,0,a)
	love.graphics.line(self.x,self.y,self.ox,self.oy)
	
	if self.skin then
		love.graphics.setColor(255, 255,255,a)
		love.graphics.draw(self.skin, self.x, self.y, self.rot, self.parent.size, self.parent.size, self.sw/2, self.sh/2)
	end

end


return impulse