local ship=Class("mum",Ship_base) --这个 要改“”中的名称 跟飞机名字对应就行了

function ship:initialize(sideOrParent,x,y,rot)
	Ship_base.initialize(self,sideOrParent,x,y,rot)  --x,y 不用管

	self.hp=1000
	self.shield=1000 --护盾  能够吸收能量武器的攻击  激光 电磁
	self.armor=1000 --护甲 吸收实体武器的攻击 脉冲 导弹  质子忽略一切攻击  对撞双方扣减所有防御措施少者的数值 并护盾护甲清零
	self.hpMax=1000
	self.shieldMax=1000 --护盾  能够吸收能量武器的攻击  激光 电磁
	self.armorMax=1000 

	self.isMum=true	
	self.name="ship" --飞船的名字，
	self.id=25
	self.quad = res.ships[self.side][self.id] --side是 blue,green,red,yellow,purple中的一种 这里不用改 数字是类型1~19*5 从上到下从左到右顺序
	self.size=10 --飞机大小 也不用改
	self.r=8*self.size --不管它
	
	self.speedRush=12 -- 对于冲刺型的飞机有用
	self.speedMax=0.5 --最大速度
	self.speedAcc=0.3 --每帧加速度

	self.isSP=true
	self.visualRange=1000 --侦测范围  先不管
	self.fireRange=300
	--posX,Y 是 开火的位置 相对于每个小飞机图片中心的
	--rot 相对飞机正方形的开火方向
	--type 类型 有--impulse laser missile tesla proton no 脉冲 镭射 导弹 电磁 质子 无 几个种类 目前还没写 不过可以先设计
	--level 火炮级别 控制攻击力等等 
	--cd 火炮冷却时间 每秒50帧的话 cd=100就是2秒一炮
	--heat 当前热度 不用管

	self.deployment=self
	self.ctrlCount=0
	self.child={}

	self.fireSys={
		{
			posX=5*self.size,
			posY=0*self.size,
			rot=0,
			type="missile",
			level=20,
			cd=80,
			heat=0,
			speed=8,
		},
	}

	--posX,Y 是 引擎火焰的位置 相对于每个小飞机图片中心的
	--rot 相对飞机正方形的引擎方向 不过注意火焰图片是个正方形 旋转中心在0,4 所以转的时候要注意对齐
	--anim 火焰动画类型 只改数字 1~4 数字越大火焰越大
	self.engineSys={
		{posX=-9*self.size,
		posY=0,
		rot=0,
		anim=res.engineFire[4]()
		}
	}

	--火焰和引擎 有几个就添加几个{}格式同上，每个用逗号分隔
	self:getCanvas() --这个不用管

local buildbtn={ --队列方法
		during=3, --队列时长
		time=0, --当前时间
		text="building G1 ship", 
		icon=res.ships.blue[1],
		func=function(mum) --自带母舰的参数  
				local ship=G1:new(mum,mum.x,mum.y)
				game:toDeployment(mum,ship)
			
		end,
		}

local upgrade={
		during=5,
		time=0,
		text="ungrade all existed units x1.1 and repair",
		icon=self.quad,
		func=function(ship) 
			
			for i,v in ipairs(game.ship) do
				if v.parent==ship.parent then
					ship.hpMax=ship.hpMax*1.1
					ship.armorMax=ship.armorMax*1.1
					ship.shieldMax=ship.shieldMax*1.1
					ship.hp=ship.hpMax
					ship.armor=ship.armorMax
				end
			end
				
		end,
		}


local miner={
		during=3,
		time=0,
		text="building Miner ship",
		icon=res.ships.blue[90],
		func=function(mum) 
			local ship=Miner:new(mum,mum.x,mum.y)
			game:toDeployment(mum,ship)
			ship.state="mine"	
		end,	
}

	--------------------技能-----------------位置 6,7,8,9是给飞机的
	self.abilities={
		{
			caster=self, --自身
			pos=7, --在右侧控制框的位置6~9
			text="build G1", --技能名称
			icon=res.ships.blue[1], ---技能图标
			func=function(obj,x,y,arg) --技能函数
				if #arg.caster.child<game.rule.unitLimit and game:pay(arg.caster,"mineral",10) then
					arg.caster:addToQueue(arg)
				end
			end,
			arg=buildbtn, --函数参数
			type="active"

		},
		{
			caster=self, --自身
			pos=8, --在右侧控制框的位置6~9
			text="build Miner", --技能名称
			icon=res.ships.blue[90], ---技能图标
			func=function(obj,x,y,arg) --技能函数
				if game:pay(arg.caster,"mineral",10) then
					arg.caster:addToQueue(arg)
				end
			end,
			arg=miner, --函数参数
			type="active"

		},
		{
			caster=self, --自身
			pos=6, --在右侧控制框的位置6~9
			--icon=res.ships.blue[1], ---技能图标 如果是数组则放在sheet2 {x,y}里
			quad={4,16},
			text="set deployment point",
			func=function() 
				game.cmd="setPoint"  
			end,
			tiny2=true, --预设的conf
			arg={},
			type="active" --函数参数
		},
		{
			caster=self, --自身
			pos=9, --在右侧控制框的位置6~9
			text="upgrade", --技能名称
			quad={4,15}, ---技能图标
			func=function(obj,x,y,arg) --技能函数
				if #arg.caster.child<game.rule.unitLimit and game:pay(arg.caster,"mineral",100) then
				 	arg.caster:addToQueue(arg)
				end
			end,
			arg=upgrade, --函数参数
			tiny2=true,
			type="active" --对图标的处理

		},
	}
	-------------------------队列---------------------------
	self.queue={
		

	}
	self.mineral=01
end

function ship:addToQueue(cmd)
	if #self.queue==8 then return end
	if not cmd then return end
	local new={}
	for k,v in pairs(cmd) do
		new[k]=v
	end
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



return ship

