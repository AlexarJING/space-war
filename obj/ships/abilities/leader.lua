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

local core=	{
		name="energy core",
		description="increase the energy maximum volume by 10%",
		price_e=300,
		price_m=300,
		price_t=5,
		cd=80,
		icon=260,
		func=function(ship)
			ship.class.static.energyMax=ship.class.static.energyMax*1.1
			for i,v in ipairs(game.ship) do
				if v.side==ship.side then
					v.energyMax=v.energyMax*1.1
				end
			end
		end
	}

local arm=	{
		name="armor material",
		description="increase the armor maximum volume by 10%",
		price_e=300,
		price_m=300,
		price_t=5,
		cd=80,
		icon=204,
		func=function(ship)
			ship.class.static.armorMax=ship.class.static.armorMax*1.1
			for i,v in ipairs(game.ship) do
				if v.side==ship.side then
					v.armorMax=v.armorMax*1.1
				end
			end
		end
	}


local function makeUpgradeButton(tar)
	

	local btn={}
	btn.text=tar.name.."; Cost: "..tar.price_e.." Energy, "..tar.price_m.." Mineral"
	btn.text2=tar.description 
	btn.icon=tar.icon
	btn.cd=tar.cd
	
	local up={}
	up.during=tar.price_t
	up.text="upgrading "..tar.name
	up.icon=btn.icon
	up.func=tar.func
	
	btn.func=function(obj,x,y,ship)
		if game:pay(ship,tar.price_e,tar.price_m) then
			ship:addToQueue(up)
		end
	end
	return btn

end

local e2m={
	text="convert e-m",
	text2="convert energy to matirial by 3:1",
	icon=166,
	cd=1, 
	func=function(obj,x,y,ship) 
		if game:pay(ship,300) then
			ship.mineral=ship.mineral+100
		end
	end,
}

local m2e={
	text="convert m-e",
	text2="convert material to energy by 3:1",
	icon=167,
	cd=1, 
	func=function(obj,x,y,ship) 
		if game:pay(ship,0,300) then
			ship.energy=ship.energy+100
			if ship.energy>ship.energyMax then ship.energy=ship.energyMax end
		end
	end,
}

local see=	{
		name="detect",
		description="detect an area for 5 seconds",
		cd=120,
		icon=164,
		func=function(obj,x,y,ship)
			if game:pay(ship,0,300) then
				game.cmd="see"
			else
				obj.timer=0
			end
		end
	}



local nuclear=	{
		name="nuclear attack",
		description="select one place and drop a nuclear bomb in 5 seconds",
		cd=120,
		icon=19,
		func=function(obj,x,y,ship)
			if game:pay(ship,300,300) then
				game.cmd="atom"
				game.cmd_arg=ship
			end
		end
	}


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

local upgrade={}
upgrade["1"]=makeUpgradeButton(core)
upgrade["2"]=makeUpgradeButton(arm)
upgrade["3"]=m2e
upgrade["4"]=e2m
upgrade["5"]=see
upgrade["6"]=nuclear
upgrade["9"]=cancelButton




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
		text="upgrade & spec", 
		icon=195, 
		func=function(obj,x,y,ship) 
			local tab=game.uiCtrl.ui.ctrlGrid:fillEmptyMenu(upgrade)
			game.uiCtrl.ui.ctrlGrid:newMenu(tab)
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
			侦测	立即开启某区域的视野3秒
			核弹	指定一个点，10秒后在已侦测区域内造成巨量伤害。指定点敌我双方可见。			
]]