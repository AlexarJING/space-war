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
				game.msg:sys("good! then press escape or click to an empty place to remove the selection")
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
				local ship=res.shipClass.bee(self.target,0,0)
				ship:moveTo(w/2-100,h/2)
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
					local ship=res.shipClass.bee(self.target,0,0)
					game:shipMove(ship,w/2,h/2,true)
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

	local ind
	game.event:new(self.target,
			"story",
			function()
				return game.ctrlGroup and #game.ctrlGroup.units==10
			end,
			_,
			function()
				game.msg:sys("ok! now you know how to select units! and now let's try some moving control !")
				delay:new(3,_,game.msg.sys,game.msg,"select a target and right click some where to move. select a unit and move to the indicator!")
				delay:new(3,_,function()
					for i,v in ipairs(game.ship) do
						if v~=self.target then
							v:destroy()
						end
					end 
				end)
				ind=res.otherClass.indicator(100,100,30)
			end,
			_,
			true
	)

	game.event:new(self.target,
			"story",
			function()
				return  math.getDistance(self.target.x,self.target.y,100,100)<30
			end,
			_,
			function()
				ind:destroy()
				game.msg:sys("yes! that's it!")
				delay:new(3,_,game.msg.sys,game.msg,"now try some group control; select a group and right click. try to move to the indicator")
				ind=res.otherClass.indicator(800,100,30)
				for i=1,5 do
					local ship=res.shipClass.bee(self.target,0,0)
					game:shipMove(ship,w/2,h/2,true)
				end
			end,
			_,
			true
	)

	game.event:new(self.target,
			"story",
			function()
				return  math.getDistance(self.target.x,self.target.y,800,100)<30 and (game.ctrlGroup and #game.ctrlGroup.units>1)
			end,
			_,
			function()
				ind:destroy()
				game.msg:sys("ok!")
				delay:new(3,_,game.msg.sys,game.msg,"well, to concentrate a group, just press key c, and try it !")
				ind=res.otherClass.indicator(800,100,30)
			end,
			_,
			true
	)


	game.event:new(self.target,
			"story",
			function()
				return  game.cmd=="concentrate"
			end,
			_,
			function()
				game.msg:sys("fantastic.")
				delay:new(3,_,game.msg.sys,game.msg,"to change the form of a group, you have to press f,and draw a line on the screen.")
			end,
			_,
			true
	)

	game.event:new(self.target,
			"story",
			function()
				return  game.cmd=="form"
			end,
			_,
			function()
				delay:new(10,_,game.msg.sys,game.msg,"all right. that's all of this section. well done!")
				delay:new(15,_,mission.gameover,mission,"mission complete!")
			end,
			_,
			true
	)
end

function mission:update()
	game.event:check("story")
end

function mission:gameover(word)
	local frame = loveframes.Create("frame")
	frame:SetName("Game Over")
	frame:SetWidth(500)
	frame:Center()
	frame:ShowCloseButton(false)
	
	local text = loveframes.Create("text", frame)
	text:SetText({ {color = color.green,font=res.font_25},word})
	text:SetMaxWidth(490)
	text:SetPos(5, 30)
	
	local button = loveframes.Create("button", frame)
	button:SetWidth(490)
	button:SetText("ok")
	button:Center()
	button.OnClick = function(object, x, y)
		loveframes.SetState("none")
		frame:Remove()
	end
	
	button:SetY(text:GetHeight() + 35)
	frame:SetHeight(text:GetHeight() + 65)
	frame:SetState("newstate")
	
	loveframes.SetState("newstate")


end

return mission