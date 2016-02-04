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
				game.msg:sys("欢迎进入星际战争教学指引!")
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
				game.msg:sys("在这个任务中，我们会学到一些基本操作。")
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
				game.msg:sys("左键单击飞船来选择它")
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
				game.msg:sys("很好！取消选择可以按esc键或左键单击空白处")
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
				game.msg:sys("正是这样，你可以拖动鼠标框选单位来实现复选。")
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
				game.msg:sys("太棒了，同时，你还可以双击某个单位来选择所有同型单位")
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
				game.msg:sys("就是这样，用ctrl+a你可以选择所有的战斗单位。")
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
				
				game.msg:sys("ok! 好的，现在我们来学习下如何移动单位")
				delay:new(6,_,game.msg.sys,game.msg,"选择一个单位，右键点击到指定地点。现在请将飞机移动到指定位置。")
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
				game.msg:sys("不错哦！")
				delay:new(3,_,game.msg.sys,game.msg,"现在来尝试下队伍移动，选择所有单位，并移动到指定位置。")
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
				delay:new(3,_,game.msg.sys,game.msg,"现在是队形控制，按c键来集中选中的所有单位。")
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
				game.msg:sys("正确！")
				delay:new(3,_,game.msg.sys,game.msg,"改变单位的队形，可以按f键后，在屏幕上画线，飞机将沿线排列。")
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
				delay:new(10,_,game.msg.sys,game.msg,"很好，接下来按ctrl+1来记录队伍。")
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
				game.msg:sys("是的，以后你就可以按数字键来快速选择队伍了。")
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
				game.msg:sys("选在是星际战争教学的第二部分")
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
				game.msg:sys("这里你可以学到一些镜头控制")
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
				game.msg:sys("把鼠标移动到屏幕边缘，镜头就会移动。现在把镜头移动到右下角")
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
				game.msg:sys("很好，在屏幕坐下角有小地图，看到上面的蓝点了么？左键点击它来移动到你的飞机旁。")
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
				game.msg:sys("很好，现在用右键点击小地图的指示位置。飞机将移动到那里。")
				ind=res.otherClass.indicator(2000,2000,30)
				delay:new(8,_,game.msg.sys,game.msg,"在移动过程中，你可以按空格键来将镜头锁定到选中单位")
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
				delay:new(1,_,game.msg.sys,game.msg,"很好！下面是射击训练。")
				delay:new(10,_,game.msg.sys,game.msg,"将飞机移动到敌人旁，它将自动攻击。")
				delay:new(15,_,game.msg.sys,game.msg,"但是不要撞到对方飞机身上，不然敌我双方均会收到伤害。")
				delay:new(20,_,game.msg.sys,game.msg,"消灭所有敌人")
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
				delay:new(5,_,game.msg.sys,game.msg,"今天的训练就到这了，做得好!")
				delay:new(10,_,mission.gameover,mission,"任务结束！")
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