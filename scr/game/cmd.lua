local cmd={}

function cmd:call(what,arg) --每个循环都会来到这里，并根据cmd内容进入相应程序
	if type(cmd[what])=="function" then
		if arg then
			cmd[what](self,arg)
		else
			cmd[what](self)
		end
	end
end

function cmd:move()
	if not game.locatedTarget then
		game.isLocating=true
	else
		if #game.locatedTarget==2 then --目标是位置
			game.groupCtrl:moveTo(game.ctrlGroup,game.locatedTarget[1],game.locatedTarget[2],"direct")
		else --目标是单位
			game.groupCtrl:moveTo(game.ctrlGroup,game.locatedTarget[1].x,game.locatedTarget[1].y,"direct")
		end
		game.cmd=nil
		game.locatedTarget=nil
		game.isLocating=false
		game.cursorMode="normal"
	end
end

function cmd:stop()
	game.groupCtrl:stop(game.ctrlGroup)
	game.cmd=nil
end

function cmd:hold()
	game.groupCtrl:hold(game.ctrlGroup)
	game.cmd=nil
end

function cmd:patrol()
	game.isLocating=true
	if love.keyboard.isDown("lshift") then  
		game.tmpWayPoint=game.tmpWayPoint or {}
		if game.locatedTarget then
			local p
			if #game.locatedTarget==2 then --目标是位置
				p={game.locatedTarget[1],game.locatedTarget[2]}
			else 
				p={game.locatedTarget[1].x,game.locatedTarget[1]}
			end
			table.insert(game.tmpWayPoint, p)
			game.locatedTarget=nil
		end
	else
		if game.tmpWayPoint and #game.tmpWayPoint>1 then
			game.isLocating=false
			game.cursorMode="normal"
			game.ctrlGroup.waypoint=game.tmpWayPoint
			game.tmpWayPoint=nil
			game.cmd=nil
			game.ctrlGroup.checkpoint=1
		else
			--任何事情都没做
		end
	end
end


function cmd:attack()
	if not game.locatedTarget then
		game.isLocating=true
	else
		if #game.locatedTarget==2 then --目标是位置
			game.groupCtrl:moveTo(game.ctrlGroup,game.locatedTarget[1],game.locatedTarget[2],"pursuit")
		else --目标是单位
			game.groupCtrl:moveTo(game.ctrlGroup,game.locatedTarget[1].x,game.locatedTarget[1].y,"pursuit")
		end
		game.cmd=nil
		game.locatedTarget=nil
		game.isLocating=false
		game.cursorMode="normal"
	end

end

function cmd:concentrate()
	if not game.ctrlGroup then
		game.cmd=nil
		return
	end
	local c=game.ctrlGroup.units[math.ceil(#game.ctrlGroup.units/2)]
	game.trace={{c.dx or c.x,c.dy or c.y}}
	local x,y=game.groupCtrl:formByTrace(game.ctrlGroup)
	game.groupCtrl:groupMove(game.ctrlGroup,x,y)
	game.cmd=nil
end

function cmd:form()
	game.cursorMode="select"
	if love.mouse.isDown(MOUSE_LEFT) and game.teamCtrl==false then  
		game.isSelected=false
		game.teamCtrl=true
	else
		if game.isSelected==false and game.teamCtrl==true then
			game.cmd=nil
			game.teamCtrl=false
			game.isLocating=false
			game.cursorMode="normal"
		end
	end
end


function cmd:setPoint()

	game.cursorMode="select"
	if not game.locatedTarget then
		game.isLocating=true
	else
		if #game.locatedTarget==2 then --目标是位置
			game.ctrlGroup.units[1].deployment={game.locatedTarget[1],game.locatedTarget[2]}
		else --目标是单位 （）实际上是只有一个元素的tab
			game.ctrlGroup.units[1].deployment=game.locatedTarget[1]
		end
		game.cmd=nil
		game.locatedTarget=nil
		game.isLocating=false
		game.cursorMode="normal"
	end
end

local timer

function cmd:see()
	if not game.locatedTarget then
		if game.seePos then
			if not timer then timer=5 end
			timer=timer- love.timer.getDelta()
			if timer<0 then
				game.cmd=nil
				game.seePos=nil
				timer=nil				
			end
		else
			game.isLocating=true
		end
		
	else
		if #game.locatedTarget==2 then --目标是位置
			game.seePos={game.locatedTarget[1],game.locatedTarget[2]}
		else --目标是单位
			game.seePos={game.locatedTarget[1].x,game.locatedTarget[1].y}
		end
		game.locatedTarget=nil
		game.isLocating=false
		game.cursorMode="normal"
		
	end

end

local function attack(ship)
	local range=200
	local damage=500
	res.otherClass.frag(ship.atomPos[1],ship.atomPos[2],0,_,range)
	for i,v in ipairs(game.ship) do
		if math.getDistance(ship.atomPos[1],ship.atomPos[2],v.x,v.y)<range then
			v:getDamage(ship,"real",damage)
			res.otherClass.frag(v.x,v.y,0,_,v.r/2)
		end
	end


end
local ind
function cmd:atom(who)
	
	if not game.locatedTarget then
		if who.atomPos then
			if not timer then timer=5 end
			timer=timer- love.timer.getDelta()
			if timer<0 then
				attack(who)
				game.cmd=nil
				game.atomPos=nil
				timer=nil
				ind:destroy()				
			end
		else
			game.isLocating=true
		end
		
	else
		if #game.locatedTarget==2 then --目标是位置
			who.atomPos={game.locatedTarget[1],game.locatedTarget[2]}
		else --目标是单位
			who.atomPos={game.locatedTarget[1].x,game.locatedTarget[1].y}
		end
		
		game.locatedTarget=nil
		game.isLocating=false
		game.cursorMode="normal"
		
		ind=res.otherClass.indicator(who.atomPos[1],who.atomPos[2],150)
	end

end


function cmd:build()


end


function cmd:showMessage(message)


end


return cmd