local wayPoint={}
local chaseDist=500

local npc={}
npc.group={} --组，包含飞机
npc.trace={}
npc.checkPoint={} --巡逻位置
npc.inBattle={} --是否进入战斗状态
npc.leavePoint={} --进入战斗时的位置 用于脱离战斗后归位
npc.groupIndex=0 --组索引 以字符串计
npc.form={}

function npc:newGroup(group,wayPoint)
	self.groupIndex=self.groupIndex+1
	local id=tostring(self.groupIndex)
	self.group[id]={}
	for i,v in ipairs(group) do
		self.group[id][i]=v
	end
	self.trace[id]=wayPoint
	self.checkPoint[id]=0
	self.inBattle[id]=false
	self.form[id]=game:newForm(self.group[id])
end

function npc:findTarget(group,id)
	for i,ship in ipairs(group) do
		if ship:findTarget() then
			game:teamMove(group, ship.target.x,ship.target.y,self.form[id]) --到射程就自动开火了
			npc.leavePoint[id]=npc.leavePoint[id] or {group[1].x,group[1].y}
			self.inBattle[id]=true
			return true
		end
	end
	self.inBattle[id]=false
end

function npc:outOfRange(group,id)
	if not self.inBattle[id] then return end  --进入战斗才有可能离开
	local ship=group[math.ceil(#group/2)]
	if math.getDistance(ship.x,ship.y,self.leavePoint[id][1],self.leavePoint[id][2])>chaseDist then
		game:teamMove(group,self.leavePoint[id][1],self.leavePoint[id][2],self.form[id])
		self.leavePoint[id]=nil
		self.inBattle[id]=false
	end

end

function npc:patrol(group,id)
	if self.inBattle[id] then return end --只有不进入战斗才巡逻
	local allstop=true
	for i,v in ipairs(group) do
		if v.dx then
			allstop=false
		end
	end

	if allstop then --如果飞机停了 就走下个路径点
		npc.checkPoint[id]=npc.checkPoint[id]+1
		if npc.checkPoint[id]>#npc.trace[id] then
			npc.checkPoint[id]=1
		end
		game:teamMove(group,self.trace[id][self.checkPoint[id]][1],self.trace[id][self.checkPoint[id]][2],self.form[id])
	end
end

function npc:clear(group,id)
	if #group==0 then
		self.group[id]=nil
	end
	for i=#group,1,-1 do
		if group[i].dead then
			table.remove(group,i)
		end
	end
end


function npc:update()
	for id,group in pairs(self.group) do
		self:findTarget(group,id)
		self:outOfRange(group,id)
		self:patrol(group,id)
		self:clear(group,id)
	end
end


--[[
	队伍ai优先级
	探测可是范围内敌人
	如果有敌人则队伍移动向敌人
	如果射程范围内则开火
	如果无敌人则按路线循环

]]

return npc