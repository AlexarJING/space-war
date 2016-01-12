local menu={}



menu.single={
	["1"]={
		icon=142,
		text="move",
		text2="move: rightclick to the map to move, will ignore the enenies on the way.",
		func=function(obj) 
			game.cmd="move"
		end,
	},
	["2"]={
		icon=143,
		text="stop",
		func=function(obj) 
			game.cmd="stop"
		end,
	},
	["3"]={
		icon=144,
		text="hold",
		func=function(obj) 
			game.cmd="hold"
		end,
	},
	["4"]={
		icon=168,
		text="patrol",
		func=function(obj) 
			game.cmd="patrol"
		end,
	},
	["5"]={
		icon=169,
		text="attack",
		func=function(obj) 
			game.cmd="attack" 
		end,
	},
	["6"]=nil,
	["7"]=nil,
	["8"]=nil,
	["9"]=nil

}

menu.team={
	["1"]={
		icon=142,
		text="move",
		text2="move: rightclick to the map to move, will ignore the enenies on the way.",
		func=function(obj) 
			game.cmd="move"
		end,
	},
	["2"]={
		icon=143,
		text="stop",
		func=function(obj) 
			game.cmd="stop"
		end,
	},
	["3"]={
		icon=144,
		text="hold",
		func=function(obj) 
			game.cmd="hold"
		end,
	},
	["4"]={
		icon=168,
		text="patrol",
		func=function(obj) 
			game.cmd="patrol"
		end,
	},
	["5"]={
		icon=169,
		text="attack",
		func=function(obj) 
			game.cmd="attack" 
		end,
	},

	["7"]={
		icon=222,
		text="concentrate",
		func=function(obj) 
			game.cmd="concentrate" 
		end,
	},
	["8"]={
		icon=225,
		text="form",
		func=function(obj) 
			game.cmd="form" 
		end,
	},
}




return function(type) 
	return menu[type]
end