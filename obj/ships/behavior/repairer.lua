local ship=res.shipClass.repairer

function ship:reset()
	self.energy=self.energyMax
	self.armor=self.armorMax
	self.quad = res.ships[self.side][self.skin] 
	self.icon = self.quad
	self.r=8*self.size
	self.engineAni={}
	self.state="repaire"
	self.stopFire=true
	for i,v in ipairs(self.engineSys) do
		table.insert(self.engineAni, res.engineFire[v.anim]())
	end
	self.killCallBack=function()
		self.parent.mineral=self.parent.mineral+2
	end
	self:getCanvas()

end

function ship:find()
	local dist
	local pos
	self.targetsInRange={}
	for i,v in ipairs(game.ship) do
		local range=math.getDistance(self.x,self.y,v.x,v.y)
		local test=range<self.visualRange and range or nil 
		if ((self.state=="battle" and v.side~=self.side ) 
			or (self.state=="repaire" and v.side==self.side and v.armor<v.armorMax) )
			and test then
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
		if self.target.armor==self.target.armorMax then self.target=nil ;return false end
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

function ship:switchState(state)
	self.state=state
	self.inFireRange=false
	self.inVisualRange=false
	self.target=nil
	if self.state=="battle" then self.stopFire=false  else self.stopFire=true end
	self:hold()
end


function ship:moveToTarget() --如果当前状态是采矿 那么就去采矿
	if self.state=="battle" or (not self.target) then return end
	
	if self.inVisualRange and not self.dx and not self.inFireRange  then
		self.class.super.moveTo(self,self.target.x,self.target.y)
	end

	if self.inFireRange and self.dx then
		self:hold()
	end
	
end

function ship:moveTo(x,y)
	self.class.super.moveTo(self,x,y)
	--self.state="battle"
	if self.target then 
		self.target=nil
	end
end

function ship:repaire()
	if self.target and self.state=="repaire" and self.inFireRange then
		if game:pay(self,0.2) then
			self.target.armor=self.target.armor+0.5
			if self.target.armor>self.target.armorMax then self.target.armor=self.target.armorMax end
		end
	end
end

function ship:update(dt)
	self.class.super.update(self,dt)
	self:moveToTarget()
	self:repaire()
	self.rot=self.moveRot
end

local count=2

function ship:draw()
	self.class.super.draw(self)
	local a=game:getVisualAlpha(self)
	if self.target and self.state=="repaire" and self.inFireRange then
		for i=5,1,-2 do
			love.graphics.setLineWidth(i)
			love.graphics.setColor(200, 200-i*30, i*30, a)
			love.graphics.line(self.x, self.y, self.target.x, self.target.y)
			love.graphics.circle("fill", self.x, self.y,i)
			love.graphics.circle("line", self.target.x, self.target.y,i)
		end
		
		count=count-1 
		if count<0 then game:newSpark(self.target.x,self.target.y);count=2 end
	end
end

return ship

