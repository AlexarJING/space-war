local ship=Class("mum",res.shipClass.base) --这个 要改“”中的名称 跟飞机名字对应就行了

function ship:initialize(sideOrParent,x,y,rot)
	self.class.super.initialize(self,sideOrParent,x,y,rot)  --x,y 不用管

	self.energyMax=1000 --护盾  能够吸收能量武器的攻击  激光 电磁
	self.armorMax=1000 

	self.isMum=true	
	self.name="motherShip" --飞船的名字，
	self.skin=95
	self.size=10 --飞机大小 也不用改
	
	self.speedMax=0.5 --最大速度
	self.speedAcc=0.3 --每帧加速度

	self.isSP=true
	self.visualRange=1000 --侦测范围  先不管
	self.fireRange=300

	self.deployment=self
	self.ctrlCount=0
	self.child={}

	self.fireSys={
		{
			posX=5,
			posY=0,
			rot=0,
			type="missile",
			level=20,
			cd=80,
			speed=8,
		},
	}

	--posX,Y 是 引擎火焰的位置 相对于每个小飞机图片中心的
	--rot 相对飞机正方形的引擎方向 不过注意火焰图片是个正方形 旋转中心在0,4 所以转的时候要注意对齐
	--anim 火焰动画类型 只改数字 1~4 数字越大火焰越大
	self.engineSys={
		{posX=-11,
		posY=0,
		rot=0,
		anim=4
		}
	}




	--------------------技能-----------------位置 6,7,8,9是给飞机的
	self.abilities={
		["7"]={
			caster=self, --自身
			--pos=7, --在右侧控制框的位置6~9
			text="build", --技能名称
			icon=148, ---技能图标
			func=function(obj,x,y,arg) --技能函数
				local tab=game.uiCtrl.ui.ctrlGrid:fillEmptyMenu(arg.caster.build1)
				game.uiCtrl.ui.ctrlGrid:newMenu(tab)
			end,
			arg={}, --函数参数
			type="active"

		},
		
		["6"]={
			caster=self, --自身
			--pos=6, --在右侧控制框的位置6~9
			--icon=res.ships.blue[1], ---技能图标 如果是数组则放在sheet2 {x,y}里
			icon=199,
			text="set deployment point",
			func=function() 
				game.cmd="setPoint"  
			end,
			tiny2=true, --预设的conf
			arg={},
			type="active" --函数参数
		},
		["9"]={
			caster=self, --自身
			--pos=9, --在右侧控制框的位置6~9
			text="upgrade;Cost 100$", --技能名称
			icon=148, ---技能图标
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
	self.queue={}
	self.mineral=0
	self:reset()
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



local buildbtn={ --队列方法
		during=3, --队列时长
		time=0, --当前时间
		text="building G1 ship", 
		icon=res.ships.blue[1],
		func=function(mum) --自带母舰的参数  
				local ship=res.shipClass.g1(mum,mum.x,mum.y)
				game:toDeployment(mum,ship)
		end,
		}

local upgrade={
		during=5,
		time=0,
		text="ungrade all existed units x1.1 and repair",
		icon=ship.quad,
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
			local ship=res.shipClass.miner(mum,mum.x,mum.y)
			game:toDeployment(mum,ship)
			ship.state="mine"	
		end,	
}


ship.build1={
	["1"]={
			text="build G1;Cost 10$", --技能名称
			icon=res.ships.blue[1], ---技能图标
			func=function(obj,x,y,arg) --技能函数
				if #arg.caster.child<game.rule.unitLimit and game:pay(arg.caster,"mineral",10) then
					arg.caster:addToQueue(arg)
				end
			end,
			arg=buildbtn, --函数参数
			type="active"

	},
	["2"]={
		text="build Miner;Cost 10$", --技能名称
		icon=res.ships.blue[90], ---技能图标
		func=function(obj,x,y,arg) --技能函数
			if game:pay(arg.caster,"mineral",10) then
				arg.caster:addToQueue(arg)
			end
		end,
		arg=miner, --函数参数
		type="active"

	},	
	["9"]={
		text="cancel", --技能名称
		icon=150, ---技能图标
		func=function(obj,x,y,arg) --技能函数
			local tab=game.uiCtrl.ui.ctrlGrid:makeSingleMenu(arg.caster)
			game.uiCtrl.ui.ctrlGrid:newMenu(tab)
		end,
		arg=miner, --函数参数
		type="active"

	},
}

return ship

--[[--------------------------------------
技能类型
激活立即型，需要传入一个参数，包括激活者，目标等
激活延迟型，同上，但是程序持续，激活时执行一个程序，并每帧返回一个剩余时间，当时间结束时再执行另一个程序，并停止。
激活条件型，同上，达到条件时截止。
状态型，不需要激活，达到时间截止。



---------------------------------------]]