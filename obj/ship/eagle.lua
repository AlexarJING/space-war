local eagle=Class("eagle",Ship_base) --这个 要改“”中的名称 跟飞机名字对应就行了

function eagle:initialize(side,x,y)
	Ship_base:initialize(x,y)  --x,y 不用管
	self.name="eagle" --飞船的名字，
	self.quad = res.ships[side][2] --side是 blue,green,red,yellow,purple中的一种 这里不用改 数字是类型1~19*5 从上到下从左到右顺序
	self.size=3 --飞机大小 也不用改
	self.r=8*self.size --不管它
	
	self.speedRush=12 -- 对于冲刺型的飞机有用
	self.speedMax=8 --最大速度
	self.speedAcc=0.1 --每帧加速度
	self.group=1 --飞机组别 如果是敌人就用负数组吧

	self.visualRange=5 --侦测范围  先不管

	--posX,Y 是 开火的位置 相对于每个小飞机图片中心的
	--rot 相对飞机正方形的开火方向
	--type 类型 有--impulse laser missile tesla proton no 脉冲 镭射 导弹 电磁 质子 无 几个种类 目前还没写 不过可以先设计
	--level 火炮级别 控制攻击力等等 
	--cd 火炮冷却时间 每秒50帧的话 cd=100就是2秒一炮
	--heat 当前热度 不用管

	self.fireSys={
		{
			posX=3*self.size,
			posY=2.5*self.size,
			rot=0,
			type="impulse",
			level=1,
			cd=100,
			heat=0
		},
		{
			posX=3*self.size,
			posY=-2.5*self.size,
			rot=0,
			type="impulse",
			level=1,
			cd=100,
			heat=0
		}
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

--	self:getCanvas() --这个不用管
end

return eagle

