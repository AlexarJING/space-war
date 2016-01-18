local ab={}

ab.move={
		icon=142,
		text="move",
		text2="move: rightclick to the map to move, will ignore the enenies on the way.",
		func=function(obj) 
			game.cmd="move"
		end,
	}
ab.stop={
		icon=143,
		text="stop",
		func=function(obj) 
			game.cmd="stop"
		end,
	}
ab.hold={
		icon=144,
		text="hold",
		func=function(obj) 
			game.cmd="hold"
		end,
	}
ab.patrol={
		icon=168,
		text="patrol",
		func=function(obj) 
			game.cmd="patrol"
		end,
	}
ab.attack={
		icon=169,
		text="attack",
		func=function(obj) 
			game.cmd="attack" 
		end,
	}

ab.concentrate={
		icon=222,
		text="concentrate",
		func=function(obj) 
			game.cmd="concentrate" 
		end,
	}
ab.form={
		icon=225,
		text="form",
		func=function(obj) 
			game.cmd="form" 
		end,
	}





return ab