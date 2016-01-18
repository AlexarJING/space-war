local ship=Class("collector",res.shipClass.base)

local weapon=Class("co_w",res.weaponClass.laser)

function weapon:initialize(parent,x,y,rot)
	self.class.super.initialize(self,x,y,rot)
	self.damage=3
	self.range=500
	self.width=self.parent.size*5
	self.laserW=self.width
	self.target=nil
end




function ship:initialize(side,x,y,rot)

	self.class.super.initialize(self,side,x,y,rot)  
	self.energyMax=150
	self.armorMax=150
	self.price_m=100
	self.price_e=50

	self.name="collector" 
	self.skin=73 
	self.size=2 

	self.speedMax=3 
	self.speedAcc=0.3 

	self.state="mine"
	self.isSP=true 
	self.visualRange=500 
	self.fireRange=50
	self.testRange=5000


	self.fireSys={
		{
			posX=3,
			posY=5,
			rot=0,
			wpn=weapon,
			cd=20,
			heat=0,
			speed=12,
		},
	}


	self.engineSys={
		{posX=-9,
		posY=0,
		rot=0,
		anim=2
		}
	}

	
	self.abilities={
		["7"]={
			caster=self, --自身
			pos=7, --在右侧控制框的位置6~9
			text="exploit", --技能名称
			icon=147, ---技能图标
			func=function(obj,x,y,arg) --技能函数
				local ship=arg.caster
				local state=ship.state=="mine"  and "battle" or "mine"
				ship:switchState(state)
			end,
			arg={}, --函数参数
			type="active"

		}}

	self:reset()
end
function ship:findTarget ()
	
	if self.target and self.target.dead  then 
		self.target=nil 
		self.rot=self.moveRot
		return false
	end
	if self.mine then return end
	if self.state=="battle" and self.target then
		if math.getDistance(self.x,self.y,target.x,target.y)<self.visualRange then
			return
		else
			self.target=nil
		end

	end
	local dist
	local pos
	local tar= self.state=="battle" and game.ship or game.rock
	local len= self.state=="battle" and self.visualRange or self.testRange
	for i,v in ipairs(tar) do
		local range=math.getDistance(self.x,self.y,v.x,v.y)
		local test=range<len and range or nil 
		if self.state=="battle" then --战斗中只找不同队伍的
			if v.side==self.side then
				test=nil
			end
		else --采集中只找没有主的
			if v.exploiter and v.exploiter~=self then
				test= nil
			end
		end
		if  test then
			
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
		if self.state=="mine" then
			if tar[pos]~= self.target then
				tar[pos].exploiter=nil
			end
			self.target=tar[pos]
			self.fireRange=self.r+self.target.r
			self.target.exploiter=self
		else
			self.target=tar[pos]
		end

		
	end
	
	if self.target then
		local range=math.getDistance(self.x,self.y,self.target.x,self.target.y)
		if range>len then
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
	if self.mine then 
		self.exploiter=nil
		self.mine.freeze=false 
	end
	self.target=nil
	if self.mine then self.mine:destroy() end
	self.mine=nil
	self.inFireRange=false
	self.inVisualRange=false
	self:hold()
end


function ship:moveToTarget() --如果当前状态是采矿 那么就去采矿
	if self.state=="battle" or (not self.target) then return end
	if self.mine then --如果得到了矿 则回基地
		local dist=math.getDistance(self.x,self.y,self.parent.x,self.parent.y)
		if dist<self.r+self.parent.r then
			self.mine.dead=true
			self.mine=nil
			self.parent.mineral=self.parent.mineral+3
			return
		else
			self.class.super.moveTo(self,self.parent.x,self.parent.y)
		end
	else --如果未得到 则飞向矿直到进入火力
		if self.inVisualRange and not self.dx and not self.inFireRange  then
			self.class.super.moveTo(self,self.target.x,self.target.y)
			self.target.exploiter=self
		end

		if self.inFireRange then
			self:hold()
		end
	end
end

function ship:moveTo(x,y)
	self.class.super.moveTo(self,x,y)
	--self.state="battle"
	if self.target then 
		self.target.exploiter=nil
		self.target=nil
	end
	if self.mine then 
		self.mine.exploiter=nil
		self.mine.freeze=false
		self.mine=nil
	end
end



function ship:update(dt)
	self.class.super.update(self,dt)
	self:moveToTarget()
	self.rot=self.moveRot
end

function ship:draw()
	self.class.super.draw(self)
	if self.mine then
		self.mine.x=self.x+math.sin(-self.rot+math.pi/2)*(self.r+self.mine.r)
		self.mine.y=self.y+math.cos(-self.rot+math.pi/2)*(self.r+self.mine.r)
		self.mine:draw()
	end
end

return ship

