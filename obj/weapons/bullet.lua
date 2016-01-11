local bullet=Class("bullet")

function bullet:initialize(parent,x,y,rot)
	self.x=x
	self.y=y
	self.speed=5
	self.rot=rot
	self.parent=parent
end

function bullet:hitTest()
	if self.destroy then return end
	for i,v in ipairs(game.ship) do
		if self.parent.group~=v.group and math.getDistance(self.x,self.y,v.x,v.y)<=self.size then
			self.destroy=true
			local frag=Frag:new(self.x,self.y,self.rot,self:getCanvas())
			table.insert(game.frag, frag)
			v.hp=v.hp-self.attack
			if v.hp<=0 then
				v.destroy=true
				local frag=Frag:new(v.x,v.y,v.rot,v:getCanvas())
				table.insert(game.frag, frag)
			end
		end
	end

end

function bullet:outRangeTest()
	if self.destroy then return end

	if math.getDistance(self.x,self.y,self.parent.x,self.parent.y)>self.range then
		self.destroy=true
		return
	end
end


function bullet:update()
	if self.destroy then return end
	self.x =self.x + math.cos(self.rot)*self.speed
	self.y =self.y + math.sin(self.rot)*self.speed
	--self:outRangeTest()
	--self:hitTest()
end

function bullet:getCanvas()
	self.canvas = love.graphics.newCanvas(6,6)
	love.graphics.setCanvas(self.canvas)
	love.graphics.setColor(255, 0,0)
	love.graphics.circle("fill", 3,3,3)
	love.graphics.setCanvas()
	return self.canvas
end

function bullet:draw()
	if self.destroy then return end
	love.graphics.setColor(255, 0,0)
	love.graphics.circle("fill", self.x, self.y, 3)
end


return bullet