local mission={}
mission.name="tutorial_1"
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
	local ind
	game.event:new(self.target,
			"story",
			function(timer)
				return timer>=3
			end,
			_,
			function()
				game.msg:sys("welcome to space war control tutorial part 1 !")
			end,
			_,
			true
	)
	game.event:new(self.target,
			"story",
			function(timer)
				return timer>=5
			end,
			_,
			function()
				game.msg:sys("in this mission you will learn some basic control stuff")
			end,
			_,
			true
	) 

	game.event:new(self.target,
			"story",
			function(timer)
				return timer>=5
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
				game.msg:sys("ok! you can also press down the left button and drag the mouse to multi-select units")
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
				game.msg:sys("excellent! you can double-click to select all the units in same type")
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
				for i=1,5 do
					local ship=res.shipClass.wasp(self.target,0,0)
					game:shipMove(ship,w/2,h/2,true)
				end
			end,
			_,
			true
	)


	game.event:new(self.target,
			"story",
			function()
				return game.ctrlGroup and #game.ctrlGroup.units==12
			end,
			_,
			function()
				
				game.msg:sys("ok! now you know how to select units! and now let's try some moving control !")
				delay:new(6,_,game.msg.sys,game.msg,"select a target and right click some where to move. select a unit and move to the indicator!")
				delay:new(2,_,function()
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
				return  math.getDistance(self.target.x,self.target.y,800,100)<100 and (game.ctrlGroup and #game.ctrlGroup.units>1)
			end,
			_,
			function()
				ind:destroy()
				game.msg:sys("ok!")
				delay:new(3,_,game.msg.sys,game.msg,"well, to concentrate a group, just press key c, and try it !")
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
				delay:new(10,_,game.msg.sys,game.msg,"all right. to record the group. use ctrl + number key, now record it to the No.1")
			end,
			_,
			true
	)

	game.event:new(self.target,
			"story",
			function()
				return  game.groupStore[1]~=nil
			end,
			_,
			function()
				game.msg:sys("fantastic. from now on, you can press number key to recall your stored group.")
			end,
			_,
			true
	)

	game.event:new(self.target,
			"story",
			function(timer)
				return timer>=5
			end,
			_,
			function()
				game.msg:sys("welcome to space war control tutorial part 2 !")
			end,
			_,
			true
	)
	game.event:new(self.target,
			"story",
			function(timer)
				return timer>=5
			end,
			_,
			function()
				game.msg:sys("you will learn some camera control")
			end,
			_,
			true
	) 

	game.event:new(self.target,
			"story",
			function(timer)
				return timer>=5
			end,
			_,
			function()
				game.msg:sys("move your mouse to the edge of screen to move the camera,now move to the right-bottom corner!")
			end,
			_,
			true
	) 

	game.event:new(self.target,
			"story",
			function()
				local x,y=game.bg.cam:position()
				return math.getDistance(x,y,5000,5000)<300
			end,
			_,
			function()
				game.msg:sys("good! now click the blue dot in the mini map on the left-bottom corner. that's your ships.")
			end,
			_,
			true
	) 

	game.event:new(self.target,
			"story",
			function()
				local x,y=game.bg.cam:position()
				return math.getDistance(x,y,500,500)<300
			end,
			_,
			function()
				game.msg:sys("all right. you can move your unit by clicking on the miniMap. go to the circle!")
				ind=res.otherClass.indicator(2000,2000,30)
				delay:new(8,_,game.msg.sys,game.msg,"during moving, you can press space key to let the camera follow the units")
			end,
			_,
			true
	)

	game.event:new(self.target,
			"story",
			function()
				local x,y=self.target.x,self.target.y
				return  math.getDistance(x,y,2000,2000)<300
			end,
			_,
			function()
				ind:destroy()
				delay:new(1,_,game.msg.sys,game.msg,"ok! now let's do some shooting practice")
				delay:new(10,_,game.msg.sys,game.msg,"move your ships near the targets, they will attack automaticly")
				delay:new(15,_,game.msg.sys,game.msg,"but don't crash into enemies. the collision will damage both sides")
				delay:new(20,_,game.msg.sys,game.msg,"kill them all!")
				local d=0
				for x=1,10 do
					for y=1,10 do
						d=d+0.05
						delay:new(d,_,res.shipClass.probe,"red",1500+x*20,1500+y*20)
					end
				end		
			end,
			_,
			true
	)

	game.event:new(self.target,
			"story",
			function(timer)
				if timer<20 then return false end
				for i,v in ipairs(game.ship) do
					if v.side=="red" then return false end 
				end
				return true
			end,
			_,
			function()
				delay:new(5,_,game.msg.sys,game.msg,"that's all for this time. well done!")
				delay:new(10,_,mission.gameover,mission,"mission complete!")
			end,
			_,
			true
	)
end

function mission:update()
	game.event:check("story")
end

function mission:gameover(word)
	game.keyLock=true
	game.mouseLock=true
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