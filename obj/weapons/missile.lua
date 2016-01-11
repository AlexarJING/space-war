local missile=Class("missile")



function missile:initialize(parent,level,x,y,rot)
	self.x=x
	self.y=y
	self.rot=rot
	self.parent=parent
	self.level=level
	self.life=150
	self.target=nil
	self.quad = res.missile
	self.size=self.parent.size/2
	self.engineFire = {
		posX=-9*self.size,
		posY= 0*self.size,
		rot =0,
		anim=res.engineFire[4]()
	}
	self.speed=0.1
	self.speedMax=8
	self.speedAcc=0.2
	self.side=self.parent.side
	self.visualRange=500
	self.explosionRange=self.size*10
end


function missile:moveTo(x,y)
	local t=math.getRot(x,y,self.x,self.y)+math.pi/2
	t=math.unitAngle(t)
	local dr=Pi/30
	local oRot=math.unitAngle(self.rot)
	local nRot=math.unitAngle(self.rot+dr)


	if math.getLoopDist(oRot,t)>math.getLoopDist(nRot,t) then
		self.rot=self.rot+dr
	else
		self.rot=self.rot-dr
	end
end


function missile:collision(target)
	if math.getDistance(self.x,self.y,target.x,target.y)<=(self.size+target.size)*6 then
		return true
	end
end

function missile:explosion()
	for i,v in ipairs(game.ship) do
		if v.side~=self.side and math.getDistance(self.x,self.y,v.x,v.y)<self.explosionRange then
			v:getDamage(self.parent,"energy",self.level*3)
		end
	end
end



function missile:hitTest()
	for i,v in ipairs(game.ship) do
		if v.side~=self.side and self:collision(v) then
			self.destroy=true
			self.dead=true
			table.insert(game.frag, Frag:new(self.x,self.y,self.rot,_,self.size*10))
			v:getDamage(self.parent,"energy",self.level*10)
			self:explosion()
		end		
	end

end

function missile:findTarget()
	if self.target and self.target.dead then self.target=nil end
	if not self.target then
		local dist
		local pos
		for i,v in ipairs(game.ship) do
			local range=math.getDistance(self.x,self.y,v.x,v.y)
			local test=range<self.visualRange and range or nil 
			if v.side~=self.side and test then
				if not dist then
					dist=test
					pos=i
				else
					if dist>test then
						dist=test
						pos=i
					end
				end
			end
		end
		if pos then
			self.target=game.ship[pos]
		end
	end
end


function missile:update(dt)
	
	if not self.destroy then 
		self:findTarget()
		self:hitTest()
		if self.speed~=0 then
			self.speed=self.speed+self.speedAcc
			if self.speed>self.speedMax then
				self.speed=self.speedMax
			end
		end
		if not self.target then
			self.rot=self.rot +Pi/50
		else
			self:moveTo(self.target.x,self.target.y)
		end

		self.x = self.x + math.cos(self.rot)*self.speed
		self.y = self.y + math.sin(self.rot)*self.speed
		
		self.life=self.life-1
		if self .life<0 then 
			self.destroy=true 
			self.dead=true
		end
		self.engineFire.anim:update(dt)
	end
	
end


function missile:draw()
	if not self.destroy then
		love.graphics.setColor(255,255,255,game:getVisualAlpha(self))
		love.graphics.draw(sheet, self.quad , self.x, self.y, self.rot, self.size,self.size/2,8,8)
		local offx,offy=math.axisRot(self.engineFire.posX,self.engineFire.posY,self.rot)
		love.graphics.draw(sheet,self.engineFire.anim.frame, self.x+offx, self.y+offy, self.rot+self.engineFire.rot, self.size, self.size, 0, 4)
	end
end


return missile