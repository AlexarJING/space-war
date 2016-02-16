local mission={}
mission.name="standard mission demo"
mission.object={
	{name="build 10 bees",state=nil}, --state的三种状态nil表示未完成 true为完成 false为失败
	{name="move the leader to the indicator",state=nil},
	{name="kill all enermies",state=nil},
}

function mission:new()
	self.unitLimit=100 --游戏单位上线

	for i=1,200 do --在战场上填充200个随机陨石
		res.otherClass.rock(love.math.random(1,5000),love.math.random(1,5000))
	end

	game.mum[1]=res.shipClass.leader("blue",500,500)  --制造一个母舰
	self.target=game.mum[1] --方便用的一个快捷方式而已
	game.mum[1].mineral=5000 --方便测试用的

	for i=1,5 do 
		local miner=res.shipClass.miner(game.mum[1],500,500) --制造5个矿工
		game:toDeployment(game.mum[1],miner)
	end

	game.focus=game.mum[1] --设置镜头看向母舰
	--game.bg.cam:lookAt(500,500) --或者自己设置镜头位置


	game.mum[2]=res.shipClass.leader("green",4500,4500) --同上，制造敌人

	for i=1,5 do 
		local miner=res.shipClass.miner(game.mum[2],4500,4500)
		game:toDeployment(game.mum[2],miner)
		miner.state="mine"
	end	

	--下面是方便ai确定敌人的
	game.mum[1].state="normal"
	game.mum[2].state="normal"
	game.mum[1].enermy=game.mum[2] 
	game.mum[2].enermy=game.mum[1]
	--game.mum[1].mineral=500

	--game.showFog=false --这里可以控制是否显示战争迷雾
	--game.showAll=true --这里可以控制是否显示敌方视野单位

	local function parol(delay,who,what) --这里建立个快捷方式来控制对话的
		game.event:new(self.target,
			"story", 
			function(timer)
				return timer>=delay
			end,
			_,
			function()
				game.msg:say(who,what)
			end,
			_,
			true
		) 
	end


	game.event:new(self.target,
			"story", --story类型的事件始终只检测最早加入的，按故事线顺序进行判断
			function(timer) --story类型时间的判断回调有个默认的timer，方便对话设置的
				return timer>=3
			end,
			_,
			function()
				game.msg:sys("this is standard mission module")
			end,
			_,
			true
	) 
	
	parol(5,"Mike","今天天气不错嘛！") --使用对话的快捷方式
	parol(5,"Tom","是啊！")
	parol(5,"Tom","不管那么多了，先造10个小飞机再说！")
	local ind --这里创建 是为了后面把他删除用的 相当于一个句柄
	game.event:new(self.target,
			"story",
			function() --下面的方法是对bee来计数 
				local count=0
				for i,v in ipairs(game.ship) do
					if v.side=="blue" and v.name=="bee" then
						count=count+1
					end
				end
				if count>9 then return true end
			end,
			_,
			function()
				mission.object[1].state=true --如果任务成功了就绿了
				game.msg:sys("把leader移动到1000，1000处，地图上有指示")
				ind=res.otherClass.indicator(1000,1000,50) --建立个指示器
				
			end,
			_,
			true --这个参数是自动事件删除的，true就是一次性的执行上面的func，否则将持续执行，直到手动停止
	)


	game.event:new(self.target,
		"always", --这个在每帧都会判断
		function() 
			return math.getDistance(self.target.x,self.target.y,1000,1000)<30
		end,
		_,
		function()
			ind:destroy()
			mission.object[2].state=true --如果任务成功了就绿了
		end,
		_,
		true --这个参数是自动事件删除的，true就是一次性的执行上面的func，否则将持续执行，直到手动停止
	)

	game.event:new(self.target,
			"story",
			function(timer)
				if timer<20 then return false end
				for i,v in ipairs(game.ship) do
					if v.side=="green" then return false end  --如果有敌人就是否
				end
				return true
			end,
			_,
			function()
				mission.object[3].state=true --第三个任务完成 
				delay:new(5,_,game.msg.sys,game.msg,"that's all for this time. well done!") --这里是用延迟命令的
				delay:new(10,_,mission.gameover,mission,"mission complete!") --mission.gameover就是任务结束用的
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
