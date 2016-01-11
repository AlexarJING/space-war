local ship=Class("g1",res.shipClass.base) --这个 要改“”中的名称 跟飞机名字对应就行了

function ship:initialize(side,x,y,rot)
	self.class.super.initialize(self,side,x,y,rot)  --x,y 不用管


	self.energyMax=300 --能量，有能量时，自动产生护盾抵御攻击，同时使用技能也会消耗能量。
	self.armorMax=100 --护甲，无法自动恢复，在没有能量护盾的时候会扣减，如果为0则摧毁


	self.name="g1" --飞船的名字，
	self.skin=1
	self.quad = res.ships[self.side][self.skin] --side是 blue,green,red,yellow,purple中的一种 这里不用改 数字是类型1~19*5 从上到下从左到右顺序
	self.icon = self.quad
	self.size=2 --飞机大小 也不用改

	self.speedMax=5 --最大速度
	self.speedAcc=0.3 --每帧加速度


	self.visualRange=500 --侦测范围  先不管
	self.fireRange=200

	self.fireSys={
		{
			posX=3,
			posY=5,
			rot=0,
			type="impulse",
			level=5,
			cd=20,
			speed=12,
		},
		{
			posX=3,
			posY=-5,
			rot=0,
			type="impulse",
			level=5,
			cd=20,
			speed=12,
		}
	}

	--posX,Y 是 引擎火焰的位置 相对于每个小飞机图片中心的
	--rot 相对飞机正方形的引擎方向 不过注意火焰图片是个正方形 旋转中心在0,4 所以转的时候要注意对齐
	--anim 火焰动画类型 只改数字 1~4 数字越大火焰越大
	self.engineSys={
		{posX=-9,
		posY=0,
		rot=0,
		anim=1
		}
	}

	--火焰和引擎 有几个就添加几个{}格式同上，每个用逗号分隔
	self:reset()
end

return ship

