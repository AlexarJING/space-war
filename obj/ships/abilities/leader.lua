local function makeBuildButton(name)
	local tar=res.shipParam[name].ship
	local btn={}
	btn.text=tar.name.."; Cost: "..tar.price_e.." Energy, "..tar.price_m.." Mineral"
	btn.text2=tar.description 
	btn.icon=res.ships.blue[tar.skin]
	btn.cd=tar.cd
	
	local build={}
	build.during=tar.price_t
	build.text="building "..tar.name
	build.icon=btn.icon
	build.func=function(mum) --自带母舰的参数  
		local ship=res.shipClass[tar.name](mum,mum.x,mum.y)
		game:toDeployment(mum,ship)
	end
	
	btn.func=function(obj,x,y,ship)
		if #ship.child<game.rule.unitLimit and game:pay(ship,tar.price_e,tar.price_m) then
			ship:addToQueue(build)
		end
	end
	return btn
end

local cancelButton={
		text="cancel", 
		icon=150, 
		func=function(obj,x,y,ship) 
			local tab=game.uiCtrl.ui.ctrlGrid:makeSingleMenu(ship)
			game.uiCtrl.ui.ctrlGrid:newMenu(tab)
		end,
	}



local build1={}
build1["1"]=makeBuildButton("miner")
build1["2"]=makeBuildButton("bee")
build1["3"]=makeBuildButton("observer")
build1["4"]=makeBuildButton("wasp")
build1["5"]=makeBuildButton("raider")
build1["6"]=makeBuildButton("fighter")
build1["7"]=makeBuildButton("destroyer")
build1["9"]=cancelButton

local build2={}
build2["1"]=makeBuildButton("substation")
build2["2"]=makeBuildButton("collector")
build2["3"]=makeBuildButton("annihilator")
build2["4"]=makeBuildButton("cruiser")
build2["5"]=makeBuildButton("fearless")
build2["6"]=makeBuildButton("generator")
build2["7"]=makeBuildButton("repairer")
build2["8"]=makeBuildButton("surveillant")
build2["9"]=cancelButton

local power={
	["enter"]=function(self,ship) 
		self.dtspeed=ship.speedMax; 
		ship.speedMax=10*ship.speedMax;
		self.dtspeed=ship.speedMax-self.dtspeed 
		self.time=3
	end,
	["update"]=function(self,ship,dt)
		self.time=self.time-dt
		if self.time<0 then
			return true
		end
	end,
	["leave"]=function(self,ship) 
		ship.speedMax=ship.speedMax-self.dtspeed
	end
}

local weapon=Class("mum's big bang",res.weaponClass.missile)
local prop={
			damage=5,
			life=150,
			speed=0.1,
			speedMax=10,
			visualRange=300,
			AOERange=50,
			AOEDamage=3,
			size=3}

weapon.static=prop


function weapon:initialize(parent,x,y,rot)
	self.class.super.initialize(self,parent,x,y,rot)
	for k,v in pairs(prop) do
		self[k]=v
	end
end


local charge={
	["enter"]=function(self,ship) 
		self.charge=3;
		ship.isCharging=true
	end,
	["update"]=function(self,ship,dt)
		self.charge=self.charge-dt
		if self.charge<0 then
			ship.isCharging=false
			return true
		end
	end,
	["leave"]=function(self,ship) 
		for i=1,6 do
			table.insert(game.bullet, weapon(ship,ship.x,ship.y,ship.rot+i*2*Pi/6))
		end
	end
}



local abilities={
	["7"]={
		text="build basic units", 
		icon=148, 
		func=function(obj,x,y,ship) 
			local tab=game.uiCtrl.ui.ctrlGrid:fillEmptyMenu(build1)
			game.uiCtrl.ui.ctrlGrid:newMenu(tab)
		end,
	},
	["8"]={
		text="build advanced units", 
		icon=149, 
		func=function(obj,x,y,ship) 
			local tab=game.uiCtrl.ui.ctrlGrid:fillEmptyMenu(build2)
			game.uiCtrl.ui.ctrlGrid:newMenu(tab)
		end,
	},	

	["9"]={
		text="speed up !!", 
		icon=151, 
		cd=3,
		func=function(obj,x,y,ship) 
			ship:addBuff(charge)
		end,
	},


	["6"]={
		icon=199,
		text="set deployment point",
		func=function() 
			game.cmd="setPoint"  
		end,
	},
}

return abilities 


--[[
母舰技能：	能源核心升级 提升所有单位的能量回复速度1~4级
			能源晶格升级 提升所有单位的能量上限1~4级
			护甲材质升级 提升所有单位的护甲上限1~4级
			核弹	指定一个点，10秒后在已侦测区域内造成巨量伤害。指定点敌我双方可见。			


]]