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
		local ship=res.shipClass[tar.name](mum.parent,mum.x,mum.y)
		game:toDeployment(mum,ship)
	end
	
	btn.func=function(obj,x,y,ship)
		if #ship.child<game.rule.unitLimit and game:pay(ship.parent,tar.price_e,tar.price_m) then
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



	["6"]={
		icon=199,
		text="set deployment point",
		func=function() 
			game.cmd="setPoint"  
		end,
	},
}

return abilities 