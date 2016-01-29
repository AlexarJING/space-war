local ship=Class("base")


function ship:initialize(parent,x,y,rot,mod)
	self.child={}
	if not mod then 
		table.insert(game.ship, self) 
	end
	if type(parent)=="string" then
		self.side=parent
		self.parent=self
	else
		self.parent=parent
		self.side=self.parent.side	
	end

	table.insert(self.parent.child,self)

	self.x=x
	self.y=y
	self.rot=rot or -Pi/2
	self.moveRot=0
	self.speed=0
	self.quad = res.ships.green[80]
	self.level=1
	self.size=3

	
	self.speedMax=8
	self.speedAcc=0.1
	self.groupIndex=1

	self.isMum=false
	self.isAiCtrl=false
	self.isSelected=false
	self.visualRange=3
	self.disable=false
	self.lockTarget=nil

	self.deployment=self
	self.ctrlCount=0
	self.queue={}
	self.engineAni={}
	self.fireSys={}
	self.abilities={}
	self.buff={}

	self.mineral=0
	self.generateRate=0.01

	self.strategy="nearest" --or "focus"

	self.destroyCallback=function() end
	self.hitCallBack=function() end
	self.killCallBack=function() end
end
local keys={"name","isMum","energyMax","armorMax","skin","size","speedMax","speedAcc","visualRange","fireRange","fireSys","engineSys"}
function ship:setParam(param)
	for i,v in ipairs(keys) do
		self[v]=param[v]
	end
end

function ship:getParam()
	local param={}
	for i,v in ipairs(keys) do
		param[v]=self[v]
	end
	return param
end



function ship:reset()
	self.energy=self.energyMax
	self.armor=self.armorMax
	self.quad = res.ships[self.side][self.skin] 
	self.icon = self.quad
	self.r=8*self.size
	self.engineAni={}
	for i,v in ipairs(self.engineSys) do
		table.insert(self.engineAni, res.engineFire[v.anim]())
	end
	for i,weapon in pairs(self.fireParam) do
		self.fireSys[i]={}
		for k,param in pairs(weapon) do
			self.fireSys[i][k]=param
		end
	end
	self:getCanvas()
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
	if self.stopFire then return end
	if not self.fireSys then
		return
	end
	for i,v in ipairs(self.fireSys) do
		if v.heat<0 and not v.dx then
			v.heat=v.cd
			local offx,offy=math.axisRot(v.posX,v.posY,self.rot)
			--game:newBullet(self,v.type,self.x+offx,self.y+offy,self.rot+v.rot,v.level,v.speed,v.type)
			table.insert(game.bullet, v.wpn(self,self.x+offx,self.y+offy,self.rot+v.rot))
		end
	end
end
 
function ship:castAbility(index)
	
	if index then
		local ab=self.abilities[index]
		if not ab then return end
		if ab.arg then ab.arg.caster=ab.caster else ab.arg=self end
		self.abilities[index].func(_,_,_,ab.arg)
	end	
end

function ship:addBuff(arg)
	table.insert(self.buff, arg)
	arg:enter(self)
end



function ship:updateBuff(dt)
	for i=#self.buff,1,-1 do
		if self.buff[i]:update(self,dt) then  
			self.buff[i]:leave(self,dt)
			table.remove(self.buff,i)
		end
	end
end


function ship:delay()



end

function ship:addToQueue(cmd)
	if #self.queue==8 then return end
	if not cmd then return end
	local new={}
	for k,v in pairs(cmd) do
		new[k]=v
	end
	new.time=0
	table.insert(self.queue, new)

end


function ship:queueUpdate(dt)
	local cmd=self.queue[1]
	if not cmd then return end
	cmd.time=cmd.time+dt
	if cmd.time>cmd.during then
		if cmd.arg then
			cmd.func(self,unpack(cmd.arg))
		else
			cmd.func(self)
		end
		table.remove(self.queue, 1)
	end	
end

function ship:getDamage(from,damageType,damage)
	if damageType=="physic" then --物理
		if self.energy>=damage then
			self.energy=self.energy-damage
		else
			self.armor=self.armor-(damage-self.energy)*0.5
			self.energy=0
		end
	elseif damageType=="energy" then --能量
		if self.energy>=damage*0.5 then
			self.energy=self.energy-damage*0.5
		else
			self.armor=self.armor-(damage*0.5-self.energy)*2
			self.energy=0
		end
	elseif damageType=="real" then
		if self.energy>=damage then
			self.energy=self.energy-damage
		else
			self.armor=self.armor-(damage-self.energy)
			self.energy=0
		end
	end
	if self.armor<=0 then
		game.event:check("onKill",from,self)
		from.killCallBack(from,self)
		self:destroy()
	end
	game.event:check("onGotHit",from,self)
	from.hitCallBack(from,self)
end

function ship:destroy()
	res.otherClass.frag:new(self.x,self.y,self.rot,self.canvas)
	self.dead=true
	self.target=nil
	if self.parent then
		table.removeItem(self.parent.child,self)
	end
	if self.group then
		table.removeItem(self.group, self)
	end
	game.event:check("onDestroy",self)
	self.destroyCallback(self)
end




function ship:getCanvas()
	local size=self.r
	
	self.canvas = love.graphics.newCanvas(size*2,size*2)
	love.graphics.setCanvas(self.canvas)
	love.graphics.setColor(255,255,255)
	love.graphics.draw(sheet, self.quad , 0, 0, 0, size/8,size/8)
	love.graphics.setCanvas()
	return self.canvas
end

function ship:collision()
	for i,v in ipairs(game.ship) do
		if v.side~=self.side and game:collision(self.x,self.y,v.x,v.y,(self.size+v.size)*8) then
			local damage
			if v.energy+v.armor<self.energy+self.armor then
				damage=v.energy+v.armor
			else
				damage=self.energy+self.armor
			end
			self:getDamage(v,"real",damage)
			v:getDamage(self,"real",damage)
			v:hold()
			self:hold()
		end
	end

end

function ship:weaponCD()
	if not self.fireSys then
		return
	end
	for i,v in ipairs(self.fireSys) do
		v.heat=v.heat or 0
		v.heat=v.heat-1
	end

end



function ship:update(dt)
	if self.dead then return end
	self:updateBuff(dt)
	self.energy=self.energy+self.generateRate
	if self.energy>self.energyMax then self.energy=self.energyMax end

	self:collision()
	
	if self.lockTarget then 
		if self.lockTarget.dead then self.lockTarget=nil end
		self.target=self.lockTarget
	else
		self.inVisualRange=self:findTarget() 
	end --如果有强制目标则不找目标

	self:weaponCD()
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
		self.engineAni[i]:update(dt)
		if self.dx then
			self.engineAni[i].maxFrame=4
		else
			self.engineAni[i].maxFrame=2
		end
	end

	if self.queue and #self.queue~=0 then
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
	love.graphics.draw(sheet, self.quad , self.x, self.y, self.rot, self.size*1.2,self.size*1.2,8,8)
	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(255,255,255,c[4])
	love.graphics.draw(sheet, self.quad , self.x, self.y, self.rot, self.size,self.size,8,8)

	for i,v in ipairs(self.engineSys) do
		local offx,offy=math.axisRot(v.posX*self.size,v.posY*self.size,self.rot)
		self.engineAni[i]:draw(self.x+offx, self.y+offy, self.rot+v.rot, self.size, self.size, 0, 4)
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


function ship:find()
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
		return true
	else
		return false
	end

end

function ship:check()
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


function ship:findTarget()
	if self.target and self.target.dead then 
		self.target=nil 
		self.rot=self.moveRot
		self.inFireRange=nil
		self.inVisualRange=nil
	end
	
	if self.strategy=="nearest" then
		self:find()
		return self:check()
	elseif self.strategy=="focus" then
		if not self:check() then return self:find() else return true end
	end

end


return ship