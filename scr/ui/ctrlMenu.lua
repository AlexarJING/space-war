local menu={}



menu.single={
	["1"]={
		quad={12,11},
		text="move",
		text2="move: rightclick to the map to move, will ignore the enenies on the way.",
		func=function(obj) 
			game.cmd="move"
		end,
		small=true
	},
	["2"]={
		quad={13,11},
		text="stop",
		func=function(obj) 
			game.cmd="stop"
		end,
		small=true
	},
	["3"]={
		quad={1,12},
		text="hold",
		func=function(obj) 
			game.cmd="hold"
		end,
		small=true
	},
	["4"]={
		quad={12,13},
		text="patrol",
		func=function(obj) 
			game.cmd="patrol"
		end,
		small=true
	},
	["5"]={
		quad={13,13},
		text="attack",
		func=function(obj) 
			game.cmd="attack" 
		end,
		small=true
	},
	--[[
	["6"]={
		quad={4,16},
		text="set deployment point",
		func=function(obj) 
			game.cmd="setPoint"  
		end,
		tiny2=true
	},
	["7"]={
		quad={5,12},
		text="construction_1",
		func=function(obj) 
			game.cmd="construction_1"
		end,
		tiny=true
	},
	["8"]={
		quad={6,12},
		text="construction_2",
		func=function(obj) 
			game.cmd="construction_2"  
		end,
		tiny=true
	},
	["9"]={
		quad={2,12},
		text="upgrade",
		func=function(obj) 
			game.cmd="upgrade"  
		end,
		tiny2=true
	},]]
}

menu.team={
	["1"]={
		quad={12,11},
		text="move",
		func=function(obj) 
			game.cmd="move"
			--game.isLocating=true  
		end,
		small=true
	},
	["2"]={
		quad={13,11},
		text="stop",
		func=function(obj) 
			game.cmd="stop"
		end,
		small=true
	},
	["3"]={
		quad={1,12},
		text="hold",
		func=function(obj) 
			game.cmd="hold"
		end,
		small=true
	},
	["4"]={
		quad={12,13},
		text="patrol",
		func=function(obj) 
			game.cmd="patrol"
		end,
		small=true
	},
	["5"]={
		quad={13,13},
		text="attack",
		func=function(obj) 
			game.cmd="attack" 
		end,
		small=true
	},

	["7"]={
		quad={1,18},
		text="concentrate",
		func=function(obj) 
			game.cmd="concentrate" 
		end,
		tiny=true
	},
	["8"]={
		quad={4,18},
		text="form",
		func=function(obj) 
			game.cmd="form" 
		end,
		tiny=true
	},
}




return function(type) 
	return menu[type]
end