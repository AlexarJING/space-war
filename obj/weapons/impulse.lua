local impulse=Class("impulse")
local bullet={
	"fire"=={
		speed=5,
		img=23,
		animation=123,
	}
}

function impulse:initialize(parent,level,x,y,rot,speed,type)
	self.x=x
	self.y=y
	self.speed=speed
	self.rot=rot
	self.parent=parent
	self.level=level
	self.type=1
	self.life=100
	self.type=type
	self.img=1
	self.offside=0
	self.offRange=0
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
			v:getDamage(self.parent,"physic",self.level)
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
	self.offside=self.offside+0.3
	self.x =self.x + math.cos(self.rot)*self.speed+2*self.offRange*math.cos(self.offside)
	self.y =self.y + math.sin(self.rot)*self.speed+self.offRange*math.sin(self.offside)
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
	love.graphics.setColor(255, 0,0,a)
	--love.graphics.circle("fill", self.x,self.y,5)
end


return impulse