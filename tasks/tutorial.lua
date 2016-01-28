local mission={}
mission.name="tutorial"
mission.object={
	["learn how to select units"]=false,
	["learn to move"]=false,
	["learn to Ctrl Groups"]=false,
}


function mission:new()
	self.target=res.shipClass.bee("blue",w/2,h/2)
	self.parent=self
	game.showFog=false
	game.showAll=true
	game.keyLock=true
	game.mouseLock=true
	
	game.event:new(self.target,
			"story",
			function()
				return game.time>=2
			end,
			_,
			function()
				game.msg:sys("welcome to space war controle tutorial !")
			end,
			_,
			true
	)
	game.event:new(self.target,
			"story",
			function()
				return game.time>=6
			end,
			_,
			function()
				game.msg:sys("in this mission you will learn some basic controle stuff")
			end,
			_,
			true
	) 

	game.event:new(self.target,
			"story",
			function()
				return game.time>=12
			end,
			_,
			function()
				game.msg:sys("now you just click the spaceship to select it")
				game.mouseLock=false
			end,
			_,
			true
	) 

	game.event:new(self.target,
			"story",
			function()
				return game.selectedTarget and game.ctrlGroup.units[1]==self.target
			end,
			_,
			function()
				game.msg:sys("good! then press escape to remove the selection")
				game.keyLock=false
			end,
			_,
			true
	) 
	game.event:new(self.target,
			"story",
			function()
				return not game.selectedTarget
			end,
			_,
			function()
				game.msg:sys("ok! you can also click the left button and drag the mouse to multi-select units")
				game:toDeployment(self.target,res.shipClass.bee(self.target,w/2,h/2))
			end,
			_,
			true
	)  
	

	game.event:new(self.target,
			"story",
			function()
				return game.selectedTarget and #game.ctrlGroup.units==2
			end,
			_,
			function()
				game.msg:sys("excellent! you can click a selected target to select all the units in same type")
				for i=1,5 do
					game:toDeployment(self.target,res.shipClass.bee(self.target,w/2,h/2))
				end
			end,
			_,
			true
	) 

	game.event:new(self.target,
			"story",
			function()
				return game.ctrlGroup and #game.ctrlGroup.units==7
			end,
			_,
			function()
				game.msg:sys("that's right ! you can use ctrl+a to select all the battle units in differnt types")
				for i=1,3 do
					game:toDeployment(self.target,res.shipClass.wasp(self.target,w/2,h/2))
				end
			end,
			_,
			true
	)

	game.event:new(self.target,
			"story",
			function()
				return game.ctrlGroup and #game.ctrlGroup.units==10
			end,
			_,
			function()
				game.msg:sys("ok! now you know how to select units!")

			end,
			_,
			true
	)
end

function mission:update()
	game.event:check("story")
end



return mission