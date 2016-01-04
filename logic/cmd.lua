local cmd={}

function cmd:call(what) --每个循环都会来到这里，并根据cmd内容进入相应程序
	if type(cmd[what])=="function" then
		cmd[what]()
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
	if love.mouse.isDown("l") and game.teamCtrl==false then  
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


function cmd:build()


end


return cmd