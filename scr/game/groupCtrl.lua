local groupCtrl={}

groupCtrl.groups={
	
}

function groupCtrl:checkGroup(units)
	local name
	local sameName=true
	for i,v in ipairs(units) do
		name=name or v.name
		if name~=v.name then sameName=false;break end
	end

	if #units>1 and not sameName then
		for i=#units,1,-1 do
			local ship=units[i]
			if ship.isSP and ship.state~="battle" then
				ship.isSelected=false
				table.remove(units,i)
			end
		end
	elseif #units==1 or sameName then
		for i,ship in ipairs(units) do
			if ship.isSP and ship.switchState then
				ship:switchState("battle")
			end
		end
	end
	return units
end


function groupCtrl:new(units,form,waypoint)
	
	units=self:checkGroup(units)
	if #units==0 then return end


	local group={}
	group.units={unpack(units)}
	group.form=form and {unpack(form)} or self:newForm(group)
	group.waypoint=waypoint
	group.checkpoint=1
	group.step=1
	group.lastMoveX=0
	group.lastMoveY=0
	group.lastPosX=0
	group.lastPosY=0
	for i,ship in ipairs(group.units) do --每个单位只能拥有一个group
		if ship.group then
			table.removeItem(ship.group.units,ship)
		end
		ship.group=group
		ship.lockTarget=nil
	end
	group.strategy="pursuit"
	local index=#self.groups+1
	self.groups[index]=group
	return group
end

function groupCtrl:checkDead(group)
	for i=#group.units,1,-1 do
		if group.units[i].dead then
			table.remove(group.units, i)
			table.remove(group.form, i)
		end
	end
end


function groupCtrl:checkEmpty()
	for i=#self.groups,1,-1 do
		local group=self.groups[i]
		self:checkDead(group)
		if #group.units==0 then
			table.remove(self.groups, i)
		end
	end
end

function groupCtrl:checkInBattle(group)
	local tar=#group.units/3
	local count=0
	for i,unit in ipairs(group.units) do
		if unit.inFireRange then
			if count>tar then
				return true
			end
		end
	end

end


function groupCtrl:checkInSight(group)
	for i,unit in ipairs(group.units) do
		if unit.inVisualRange then
			return unit
		end
	end

end

function groupCtrl:pursuit()	
	for i,group in ipairs(groupCtrl.groups) do
		if group.strategy=="pursuit"  then
			local unit=groupCtrl:checkInBattle(group)
			if unit then --如果发现有进入战斗的则队伍重新排列
				if not group.inBattle then
					groupCtrl:reGroup(group,unit)
					group.inBattle=true
					group.inSight=true
				end
			else --如果都不在战斗则标记
				group.inBattle=false
			end
			if not group.inBattle then
				local unit=groupCtrl:checkInSight(group)
				if unit then --如果视野内有敌人则移动至敌人
					if not group.inSight or groupCtrl:CheckAllStop(group.units) then
						group.lastMoveX=0 --清除最后移动，避免导致无法移动
						group.lastMoveY=0
						groupCtrl:groupMove(group,unit.target.x,unit.target.y)
						group.leavePoint=group.leavePoint or {unit.x,unit.y}
						group.inSight=true
					end
				else
					group.inSight=false
				end
			end
		end

	end
end

function groupCtrl:CheckAllStop(units)
	
	local focus=units[math.ceil(#units/2)]
	if focus.dx then return false else return true end
end 


function groupCtrl:patrol()
	for i,group in ipairs(groupCtrl.groups) do
		if not group.inSight and (group.waypoint or group.leavePoint) then --如果进入战斗则不巡逻
			
			local allstop=groupCtrl:CheckAllStop(group.units)
			if allstop and group.leavePoint then --如果所有单位停止 且 有返回点 则向返回点移动
				groupCtrl:groupMove(group,group.leavePoint[1],group.leavePoint[2])
				group.leavePoint=nil
			elseif allstop and (not group.leavePoint) and (#group.waypoint~=0) then --如果所有单位停止 且无返回点则走下一个路径点
				group.checkpoint=group.checkpoint+group.step
				if group.checkpoint>=#group.waypoint or  group.checkpoint<=1 then
					group.step=-group.step
				end
				if #group.waypoint==1 then group.step=0;group.checkpoint=1 end
				groupCtrl:groupMove(group,group.waypoint[group.checkpoint][1],group.waypoint[group.checkpoint][2])
			end
		end
	end
end

function groupCtrl:reGroup(group,staticShip) --静止单位静止 并找碰撞位置
	for i,unit in ipairs(group.units) do
		unit:hold()
	end
	staticShip.dx=staticShip.x
	staticShip.dy=staticShip.y
	for i,unit in ipairs(group.units) do
		
		if unit~=staticShip then
			game:shipMove(unit,unit.x,unit.y,true,group)
		end
	end

end


function groupCtrl:hold(group)
	groupCtrl:normState(group)
	for i,ship in ipairs(group.units) do
		ship:hold()
	end
	group.lastMoveX=0
	group.lastMoveY=0
end

function groupCtrl:stop(group)
	groupCtrl:normState(group)
	for i,ship in ipairs(group.units) do
		ship:stop()
	end
	group.lastMoveX=0
	group.lastMoveY=0
end


function groupCtrl:moveTo(group,x,y,strategy)
	if not group then return end
	groupCtrl:normState(group)
	group.strategy=strategy --pursuit/direct
	groupCtrl:groupMove(group,x,y)
end

function  groupCtrl:lockTarget(group,target)
	for i,v in ipairs(group) do
		v.lockTarget=target
	end
	groupCtrl:moveTo(group,target.x,target.y,"pursuit")
	group.isLock=true
end

function groupCtrl:normState(group)
	group.waypoint=nil
	group.checkpoint=1
	for i,v in ipairs(group.units) do
		v.lockTarget=nil
		v.disable=false
	end
end

function groupCtrl:update()
	groupCtrl:checkEmpty()
	groupCtrl:pursuit()
	groupCtrl:patrol()
end

function groupCtrl:newForm(group,pos,relative) --如果是相对位置则计目标位置 否则计当前位置
	local form={}
	local units=group.units
	local focus=units[math.ceil(#units/2)]
	local fx,fy=focus.x,focus.y
	for i,v in ipairs(units) do
		local tx,ty
		if type(pos)=="table" then
			local p=i%#pos==0 and #pos or i%#pos
			tx,ty=pos[p][1],pos[p][2]
		elseif type(pos)=="bool" then
			tx,ty=v.dx,v.dy
		else
			tx,ty=v.x,v.y
		end
		form[i]= {tx-fx,ty-fy}
	end
	group.form=form
	return form
end

function groupCtrl:addToGroup(unit,group)
	if not group then return end
	if not unit then return end
	if unit.group then table.removeItem(unit.group,unit) end
	unit.group=group
	table.insert(group.units, unit)
	groupCtrl:newForm(group,group.form)
	return group
end


function groupCtrl:groupMove(group,x,y,form) --pos为预设队形位置
	if not group.units then return end
	x,y=game:inLimit(x,y)
	form=form or group.form

	local focus=math.ceil(#group.units/2)
	if form==group.form and #form==#group.form
	and x==group.lastMoveX and y==group.lastMoveY  then return end --如果一个队伍去的是同一个地方则不重复

	for i,v in ipairs(group.units) do --按队形移动
		game:shipMove(v,x+form[i][1]-form[focus][1],y+form[i][2]-form[focus][2],true)
	end
	group.lastMoveX=x
	group.lastMoveY=y
end

function groupCtrl:noMove(group)
	for i,v in ipairs(group) do
		v.dx=nil
		v.speed=0
	end
end


function groupCtrl:formByTrace(group)
	--先排列一下
	local units=group.units
	local count=1 --飞机数量
	local place=1 --位置
	local tempPos={}
	local pos
	groupCtrl:noMove(units)
	for i=1,#game.trace do
		local ship=units[count]
		if game:isEnoughPlace(ship,game.trace[i][1],game.trace[i][2],group) then	
			tempPos[count]={game.trace[i][1],game.trace[i][2]}
			game:shipMove(ship,game.trace[i][1],game.trace[i][2])
			if count==#units then --飞机排列完了
				break
			end
			count=count+1
		end
	end

	--groupCtrl:noMove(units)
	--第一次排列

	if count==#units then --如果飞机先用完则扩大间距
		local step=1
		local savePos
		repeat
			groupCtrl:noMove(units)
			tempPos={}
			count=1
			step=step+1
			--模拟之前要清空速度
			for i=1,#game.trace,step do
				local ship=units[count]
				if game:isEnoughPlace(ship,game.trace[i][1],game.trace[i][2],group) then
					tempPos[count]={game.trace[i][1],game.trace[i][2]}
					game:shipMove(ship,game.trace[i][1],game.trace[i][2])
					if count==#units then --排列完了
						savePos={unpack(tempPos)}
						break
					end
					count=count+1
				end
			end
		until count<#units or step>#game.trace
		tempPos=savePos or tempPos
		groupCtrl:newForm(group,tempPos)
	else --如果位置先用完则从头再来
		if #tempPos==0 then return end
		groupCtrl:newForm(group,tempPos)
	end
	local i=math.ceil(#units/2)
	local p=i%#tempPos==0 and #tempPos or i%#tempPos
	game.trace={}
	return tempPos[p][1],tempPos[p][2]--返回移动中心

end


return groupCtrl

--[[
local function move() --移动 如有敌人攻击敌人 但不离开路线
end

local function stop() --停止 停止一切行动 直到下达其他指令
end

local function hold() --驻守 停止移动，攻击在攻击范围内敌人
end

local function patrol() --巡逻 按路径巡逻，如视野内有敌人则追击，如偏移路线到离开点+视觉距离 则回归离开点
end

local function attack() --进攻 移动，如视觉范围有敌人则追击，如偏移路线到离开点+视觉距离 则回归离开点
end

local function lock()  --锁定 指定目标，如果是同盟则自毁，否者追击敌人，直到敌人消失，在原地驻守
end

1. 指定某个目标点
2. 一组飞机按指定点、或巡逻路径按队形移动
3. 当任意飞机发现敌人（视觉范围）时，记录离开路径点，
4. 当任意飞机进入战斗（火力范围）时，单体停止，并开火
5. 当任意飞机视觉范围内没有敌人时，移动向同组其他有敌人的可用射击位置，否则（视觉范围有敌人）移动向视觉范围内最近敌人
6. 当同组所有单位均无目标时，返回离开点，并重设队形
7. 如有巡逻路径则走巡逻路径

某单位目标的可用射击范围
1. 记录目标位置
2. 按射击距离为半径寻找可用位置，按目标与单位相对角度 +-一个跟半径相关的step实现，
step可以通过射击距离和单位半径通过三角函数做出，如果没有则缩小一个目标单位半径继续。直到半径为负
3. 如果有位置则返回位置，如果没有位置，则选择同组内其他目标 如无目标则等待

]]