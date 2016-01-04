local ship=Class("miner",Ship_base) --这个 要改“”中的名称 跟飞机名字对应就行了

function ship:initialize(side,x,y,rot)
	Ship_base.initialize(self,side,x,y,rot)  --x,y 不用管
	self.hpMax=100
	self.hp=100
	self.shieldMax=100
	self.shield=100 --护盾  能够吸收能量武器的攻击  激光 电磁
	self.armorMax=100
	self.armor=100 --护甲 吸收实体武器的攻击 脉冲 导弹  质子忽略一切攻击  对撞双方扣减所有防御措施少者的数值 并护盾护甲清零


	self.name="miner" --飞船的名字，
	self.id=90
	self.quad = res.ships[self.side][self.id] --side是 blue,green,red,yellow,purple中的一种 这里不用改 数字是类型1~19*5 从上到下从左到右顺序
	self.size=2 --飞机大小 也不用改
	self.r=8*self.size --不管它
	
	self.speedRush=12 -- 对于冲刺型的飞机有用
	self.speedMax=3 --最大速度
	self.speedAcc=0.3 --每帧加速度

	self.state="mine"
	self.isSP=true  --特殊单位
	self.visualRange=500 --侦测范围  先不管
	self.fireRange=50
	self.testRange=5000
	--posX,Y 是 开火的位置 相对于每个小飞机图片中心的
	--rot 相对飞机正方形的开火方向
	--type 类型 有--impulse laser missile tesla proton no 脉冲 镭射 导弹 电磁 质子 无 几个种类 目前还没写 不过可以先设计
	--level 火炮级别 控制攻击力等等 
	--cd 火炮冷却时间 每秒50帧的话 cd=100就是2秒一炮
	--heat 当前热度 不用管

	self.fireSys={
		{
			posX=3*self.size,
			posY=5*self.size,
			rot=0,
			type="tesla",
			level=1,
			cd=20,
			heat=0,
			speed=12,
		},
	}

	--posX,Y 是 引擎火焰的位置 相对于每个小飞机图片中心的
	--rot 相对飞机正方形的引擎方向 不过注意火焰图片是个正方形 旋转中心在0,4 所以转的时候要注意对齐
	--anim 火焰动画类型 只改数字 1~4 数字越大火焰越大
	self.engineSys={
		{posX=-9*self.size,
		posY=0,
		rot=0,
		anim=res.engineFire[2]()
		}
	}

	--火焰和引擎 有几个就添加几个{}格式同上，每个用逗号分隔
	self:getCanvas() --这个不用管


	--------------------技能-----------------位置 6,7,8,9是给飞机的
	self.abilities={
		{
			caster=self, --自身
			pos=7, --在右侧控制框的位置6~9
			text="exploit", --技能名称
			icon=res.ships.blue[1], ---技能图标
			func=function(obj,x,y,arg) --技能函数
				local ship=arg.caster
				ship.state=ship.state=="mine"  and "battle" or "mine"
				if ship.mine then 
					ship.exploiter=nil
					ship.mine.freeze=false 
				end
				ship.target=nil
				ship.mine=nil
				ship:hold()
			end,
			arg={}, --函数参数
			conf={h/25,h/25,-Pi/2, h/240,h/240,8,8}, --对图标的处理
			type="active"

		}}
end
function ship:findTarget ()
	
	if self.target and self.target.dead  then 
		self.target=nil 
		self.rot=self.moveRot
		return false
	end
	if self.mine then return end

	local dist
	local pos
	local tar= self.state=="battle" and game.ship or game.rock
	for i,v in ipairs(tar) do
		local range=math.getDistance(self.x,self.y,v.x,v.y)
		local test=range<self.testRange and range or nil 
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
		if range>self.testRange then
			self.target=nil
			return false
		else
			return true
		end
	else
		return false
	end
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
			Ship_base.moveTo(self,self.parent.x,self.parent.y)
		end
	else --如果未得到 则飞向矿直到进入火力
		if self.inVisualRange and not self.dx and not self.inFireRange  then
			Ship_base.moveTo(self,self.target.x,self.target.y)
			self.target.exploiter=self
		end

		if self.inFireRange then
			self:hold()
		end
	end
end

function ship:moveTo(x,y)
	Ship_base.moveTo(self,x,y)
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
	Ship_base.update(self,dt)
	self:moveToTarget()
	self.rot=self.moveRot
end

function ship:draw()
	Ship_base.draw(self)
	if self.mine then
		self.mine.x=self.x+math.sin(-self.rot+math.pi/2)*(self.r+self.mine.r)
		self.mine.y=self.y+math.cos(-self.rot+math.pi/2)*(self.r+self.mine.r)
		self.mine:draw()
	end
end

return ship

