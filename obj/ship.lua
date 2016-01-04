local ship=Class("base")


function ship:initialize(parent,x,y,rot,mod)
	
	if not mod then 
		table.insert(game.ship, self) 
	end
	if type(parent)=="string" then
		self.side=parent
	else
		self.parent=parent
		self.side=self.parent.side
		table.insert(self.parent.child,self)
	end
	
	self.x=x
	self.y=y
	self.rot=rot or -Pi/2
	self.moveRot=0
	self.speed=0
	self.quad = res.ships.green[80]
	self.level=1
	self.size=3
	self.r=8*self.size
	
	self.speedRush=12
	self.speedMax=8
	self.speedAcc=0.1
	self.groupIndex=1

	self.isAiCtrl=false
	self.isSelected=false
	self.visualRange=3
	self.disable=false
	self.lockTarget=nil

	self.fireSys={
		{posX=5*self.size,posY=-3*self.size,rot=0,type="impulse",level=1,cd=100,heat=0},
		{posX=5*self.size,posY= 4*self.size,rot=Pi,type="impulse",level=1,cd=100,heat=0}
	}

	self.engineSys={
		{posX=-9*self.size,posY=-3*self.size,anim=res.engineFire[1]()},
		{posX=-9*self.size,posY=-1*self.size,anim=res.engineFire[1]()},
		{posX=-9*self.size,posY= 2*self.size,anim=res.engineFire[1]()},
		{posX=-9*self.size,posY= 4*self.size,anim=res.engineFire[1]()}
	}

	self.abilities={}
	self:getCanvas()

	self.destroyCallback=function() end
	self.hitCallBack=function() end
end

function ship:reset()
	self.hp=self.hpMax
	self.shield=self.shieldMax
	self.armor=self.armorMax
	self.quad = res.ships[self.side][self.skin] 
	self.icon = self.quad
	self.r=8*self.size
end

function ship:moveTo(x,y)

	self.moveRot= math.getRot(x,y,self.x,self.y)+math.pi/2
	if game.ctrlMode=="turn" then self.rot=self.moveRot end
	self.speed=self.speed==0  and 0.1 or self.speed
	self.dx,self.dy=x,y
	self.disable=false
end


function ship:moveFor(x,y)
	self.moveRot= math.getRot(x,y,self.x,self.y)+math.pi/2
	if game.ctrlMode=="turn" then self.rot=self.moveRot end
	self.speed=self.speed==0  and 0.1 or self.speed
	self.speed=self.speed==0  and 0.1 or self.speed	
end

function ship:stop()
	self.speed=0
	self.dx=nil
	self.dy=nil
	self.disable=true
end

function ship:hold()
	self.speed=0
	self.dx=nil
	self.dy=nil
end


function ship:fire()
	if not self.fireSys then
		return
	end
	for i,v in ipairs(self.fireSys) do
		v.heat=v.heat-1
		if v.heat<0 then
			v.heat=v.cd
			local offx,offy=math.axisRot(v.posX,v.posY,self.rot)
			game:newBullet(self,v.type,self.x+offx,self.y+offy,self.rot+v.rot,v.level,v.speed,v.type)
		end
	end
end

function ship:castAbility(index)
	
	if index then
		local ab=self.abilities[index]
		if not ab then return end
		if ab.arg then ab.arg.caster=ab.caster end
		self.abilities[index].func(_,_,_,ab.arg)
	else
		if not self.passive then
			self.passive={}
			for i,v in ipairs(self.abilities) do
				if v.isPassive==true then
					table.insert(self.passive, v)
				end
			end
			return
		else
			for i,v in ipairs(self.passive) do
				v.func(v.parent)
			end
		end
	end	
end


function ship:getDamage(from,damageType,damage)
	if damageType=="physic" then --物理
		if self.armor>=damage then
			self.armor=self.armor-damage
		else
			self.hp=self.hp-damage+self.armor
			self.armor=0
		end
	elseif damageType=="energy" then --能量
		if self.shield>=damage then
			self.shield=self.shield-damage
		else
			self.hp=self.hp-damage+self.shield
			self.shield=0
		end
	end
	if self.hp<=0 then
		self:destroy()
	end

	from.hitCallBack(from,self)
end

function ship:destroy()
	local frag=Frag:new(self.x,self.y,self.rot,self.canvas)
	table.insert(game.frag, frag)
	self.dead=true
	self.target=nil
	if self.parent then
		table.removeItem(self.parent.child,self)
	end
	if self.group then
		table.removeItem(self.group, self)
	end
	self.destroyCallback(self)
end




function ship:getCanvas()
	local size=self.r
	self.canvas = love.graphics.newCanvas(size*2,size*2)
	love.graphics.setCanvas(self.canvas)
	love.graphics.draw(sheet, self.quad , 0, 0, 0, size/8,size/8)
	love.graphics.setCanvas()
	return self.canvas
end

function ship:collision()
	for i,v in ipairs(game.ship) do
		if v.side~=self.side and game:collision(self.x,self.y,v.x,v.y,(self.size+v.size)*8) then
			local damage
			if v.hp+v.armor<self.hp+self.armor then
				damage=v.hp+v.armor
			else
				damage=self.hp+self.armor
			end
			self:getDamage(v,"physic",damage)
			v:getDamage(self,"physic",damage)
		end
	end

end




function ship:update(dt)
	if self.dead then return end

	self:collision()
	
	if self.lockTarget then 
		if self.lockTarget.dead then self.lockTarget=nil end
		self.target=self.lockTarget
	else
		self.inVisualRange=self:findTarget() 
	end --如果有强制目标则不找目标

	if self.inVisualRange and not self.disable then --如果设置无效则 不再开火
		self.rot=math.getRot(self.target.x,self.target.y,self.x,self.y)+math.pi/2
		self.inFireRange=math.getDistance(self.x,self.y,self.target.x,self.target.y)<self.fireRange
		if  self.inFireRange then
			self:fire()
		end
	else
		self.rot=self.moveRot
		self.inFireRange=false
	end

	if self.speed~=0 then  --acc
		self.speed=self.speed+self.speedAcc
		if self.speed>self.speedMax then
			self.speed=self.speedMax
		end
	end
	

	self.x = self.x + math.cos(self.moveRot)*self.speed --move
	self.y = self.y + math.sin(self.moveRot)*self.speed
	
	
	if self.dx then --到达目的地后停止
		if math.getDistance(self.x+ math.cos(self.moveRot)*self.speed , 
			self.y+ math.sin(self.moveRot)*self.speed,self.dx,self.dy)
			>= math.getDistance(self.x, self.y,self.dx,self.dy) then
			-- if the dist reaches the min point then stop
			self.speed=0
			self.dx=nil
			self.dy=nil
		end
	else
		self.speed=0
	end
	
	for i,v in ipairs(self.engineSys) do
		v.anim:update(dt)
		if self.dx then
			v.anim.maxFrame=4
		else
			v.anim.maxFrame=2
		end
	end

	if self.queue then
		self:queueUpdate(dt)
	end
end






function ship:draw()
	
	if self.dead then return end
	---设置alpha
	self.alpha=game:getVisualAlpha(self)
	local c={unpack(color[self.side])};c[4]=self.alpha
	love.graphics.setBlendMode("additive")
	love.graphics.setColor(c)
	love.graphics.draw(sheet, self.quad , self.x, self.y, self.rot, self.size*1.1,self.size*1.1,8,8)
	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(255,255,255,c[4])
	love.graphics.draw(sheet, self.quad , self.x, self.y, self.rot, self.size,self.size,8,8)

	for i,v in ipairs(self.engineSys) do
		local offx,offy=math.axisRot(v.posX*self.size,v.posY*self.size,self.rot)
		love.graphics.draw(sheet,v.anim.frame, self.x+offx, self.y+offy, self.rot+v.rot, self.size, self.size, 0, 4)
	end
	
	if game.debug and self.group==game.ctrlGroup then
	  	love.graphics.setColor(0,255,0)
	  	love.graphics.circle("line", self.x, self.y, self.size)
	  	if self.dx then love.graphics.line(self.x,self.y,self.dx,self.dy) end
		love.graphics.line(self.x, self.y, self.x+math.sin(-self.rot+math.pi/2)*50, self.y+math.cos(-self.rot+math.pi/2)*50) 
	end

	if self.deployment and self.isSelected and self.side==game.userSide then
		love.graphics.setColor(0,255,0)
		x2,y2=self.deployment[1] or self.deployment.x ,self.deployment[2] or self.deployment.y
		love.graphics.line(self.x,self.y,x2,y2)
	end


end




function ship:mouseTest()
	if math.getDistance(game.bx,game.by,self.x,self.y)<=self.r then
		return true
	end
end


function ship:findTarget()
	if self.target and self.target.dead then 
		self.target=nil 
		self.rot=self.moveRot
		self.inFireRange=nil
		self.inVisualRange=nil
	end
	
	local dist
	local pos
	self.targetsInRange={}
	for i,v in ipairs(game.ship) do
		local range=math.getDistance(self.x,self.y,v.x,v.y)
		local test=range<self.visualRange and range or nil 
		if v.side~=self.side and test then
			table.insert(self.targetsInRange,v)
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
	if dist then
		self.target=game.ship[pos]
	end
	
	if self.target then
		local range=math.getDistance(self.x,self.y,self.target.x,self.target.y)
		if range>self.visualRange then
			self.target=nil
			return false
		else
			return true
		end
	else
		return false
	end

end


return ship