local ctrl={}
ctrl.camSpeed=0
--design mode single mode team mode fleet mode
function ctrl:inUi()
	local h=resolution[2]
	if (game.my>0 and game.my<0.05*h) or (game.my<h-1 and game.my>0.75*h )  then 
		game.cursorMode="normal"
		return true 
	end
end

function ctrl:setLocate()
	if game.isLocating then
		game.cursorMode="select"
		if  self.click then
			if ctrl:inUi() then 
				return true
			end
			local target=game.pointTest()
			if #target~=0 then
				game.locatedTarget=target
			else
				game.locatedTarget={game.bx,game.by}
			end
		end
		game.isSelected=true --如果已经选择 但是没有初点的话 就会放弃这次选择
		return true
	end
end

function ctrl:scale()
	if game.wheelMove==1 then
		game.bg.cam.scale=game.bg.cam.scale+0.05
		game.bg.scale=(game.bg.cam.scale-1)/5+1
		if game.bg.cam.scale>1.5 then game.bg.cam.scale=1.5 end
		if game.bg.scale>1.1 then game.bg.scale=1.1 end
	elseif game.wheelMove==-1 then
		game.bg.cam.scale=game.bg.cam.scale-0.05
		game.bg.scale=(game.bg.cam.scale-1)/5+1
		if game.bg.cam.scale<0.5 then game.bg.cam.scale=0.5 end
		if game.bg.scale<0.9 then game.bg.scale=0.9 end
	end
	game.wheelMove=0
end

function ctrl:clickCtrl()
	self.click=false
	if love.mouse.isDown("l") and not self.lisDown then
		self.lisDown=true
		self.click=true
		game.cursorAura=20
		game.cPosX,game.cPosY=game.mx,game.my
	elseif not love.mouse.isDown("l") then
		self.lisDown=false
	end

end

function ctrl:update()

	if game.mouseLock then return end
	if ctrl:setLocate() then return end
	if  ctrl:inUi() then return end
	self:clickCtrl()	
	self:scale()
	if self[self.mode] then self[self.mode]() end
	

end


function ctrl:design()


end

function ctrl:single()
	if not game.ctrlGroup[1] then return end
	if love.mouse.isDown("l") then 
		game:teamMove(game.ctrlGroup,game.bx,game.by)
	end
	if love.mouse.isDown("r") then
		for i,v in ipairs(game.ctrlGroup) do
			--v.rot=-Pi/2
		end
	end

	if game.wheelMove==1 then
		local s=game.focus
		for i,v in ipairs(game.ctrlGroup) do
			v.rot=v.rot+math.sign(s.x-v.x)*(math.getDistance(s.x,s.y,v.x,v.y)/32)*Pi/30
		end
		game.wheelMove=0
	end

	if game.wheelMove==-1 then
		local s=game.focus
		for i,v in ipairs(game.ctrlGroup) do
			v.rot=v.rot-math.sign(s.x-v.x)*(math.getDistance(s.x,s.y,v.x,v.y)/32)*Pi/30
		end
		game.wheelMove=0
	end
end

function ctrl:team()

	if not game.ctrlGroup[1] then return end
	if not game.isSelected and love.mouse.isDown("l") then
		game.isSelected=true
		game.trace={}
		game.traceCD=traceDelay
		table.insert(game.trace,{game.bx,game.by})
	end

	if game.isSelected and love.mouse.isDown("l") then
		local x,y=game.bx,game.by
		local tx,ty=game.trace[#game.trace][1],game.trace[#game.trace][2]
		local dist=math.getDistance(x,y,tx,ty)
		if dist>=12 then --every 12px a road point
			local rad=math.getRot(tx,ty,x,y)
			for i=1,math.floor(dist/12) do
				table.insert(game.trace,{i*4*3*math.sin(rad)+tx,-i*4*3*math.cos(rad)+ty})
			end
		end
	end

	if game.isSelected and not love.mouse.isDown("l") then
		game.isSelected=false	
		game.ctrlTrace=game.trace
		game:setForPos(game.ctrlGroup)
		game:newForm(game.ctrlGroup)
	end

	if love.mouse.isDown("r") then 
		game:teamMove(game.ctrlGroup,game.bx,game.by)
	end
end

function ctrl:camCtrl()
	self.camSpeed=self.camSpeed+0.5
	if game.mx==0 and game.bg.cam.x>game.bg.limit.l-100 then
		game.bg.cam:move(-self.camSpeed,0)
		game.focus=nil
	elseif game.mx==love.graphics.getWidth()-1 and game.bg.cam.x<game.bg.limit.r+100 then
		game.bg.cam:move(self.camSpeed,0)
		game.focus=nil
	elseif game.my==0 and game.bg.cam.y>game.bg.limit.t-100 then
		game.bg.cam:move(0,-self.camSpeed)
		game.focus=nil
	elseif game.my==love.graphics.getHeight()-1 and game.bg.cam.y<game.bg.limit.b+100 then
		game.bg.cam:move(0,self.camSpeed)
		game.focus=nil
	else
		self.camSpeed=0
	end

end

function ctrl:traceCtrl()

	if not game.teamCtrl then return false end
	if (not game.ctrlGroup) or #game.ctrlGroup.units==0  then return false end

	if not game.isSelected and love.mouse.isDown("l") then
		game.isSelected=true
		game.trace={}
		game.traceCD=traceDelay
		table.insert(game.trace,{game.bx,game.by})
	end

	if game.isSelected and love.mouse.isDown("l") then
		local x,y=game.bx,game.by
		local tx,ty=game.trace[#game.trace][1],game.trace[#game.trace][2]
		local dist=math.getDistance(x,y,tx,ty)
		if dist>=12 then --every 12px a road point
			local rad=math.getRot(tx,ty,x,y)
			for i=1,math.floor(dist/12) do
				table.insert(game.trace,{i*4*3*math.sin(rad)+tx,-i*4*3*math.cos(rad)+ty})
			end
		end
	end

	if game.isSelected and not love.mouse.isDown("l") then
		game.isSelected=false
		local x,y=game.groupCtrl:formByTrace(game.ctrlGroup)
		game.groupCtrl:groupMove(game.ctrlGroup,x,y)
	end
	return true
end


function ctrl:fleet()
	
	ctrl:camCtrl()
	if ctrl:traceCtrl() then return end


	if love.mouse.isDown("r") and not game.rIsDown then --右键单击移动
		game.groupCtrl:moveTo(game.ctrlGroup,game.bx,game.by,"direct")
		game.rIsDown=true
		return
	elseif not love.mouse.isDown("r") then
		game.rIsDown=false
	end


	if not game.isSelected and love.mouse.isDown("l") then --初点
		game.isSelected=true
		game.selectLT={game.bx,game.by} --left top
	elseif not game.isSelected and not love.mouse.isDown("l") then
		game.selectLT=nil
		game.selectRB=nil
	end

	if game.isSelected and love.mouse.isDown("l") then --拖动
		game.selectRB={game.bx,game.by}
	end

	if game.isSelected and not love.mouse.isDown("l") then --释放
		if not game.selectLT then 
			game.isSelected=false
			game.selectLT=nil
			game.selectRB=nil
			return 
		end
		game.isSelected=false
		if game.selectedTarget then
			game.selectedTarget.isSelected=false
			game.selectedTarget=nil	
		end
		
		if game.ctrlGroup and game.ctrlGroup.units then
			for i,v in ipairs(game.ctrlGroup.units) do --取消选择
				v.isSelected=false
			end
		end
		
		if math.abs(game.selectLT[1]-game.selectRB[1])*math.abs(game.selectLT[2]-game.selectRB[2])<500 then --如果是单击

			local targets=game:pointTest()
			if #targets==0 then 
				game.ctrlGroup=nil
				return
			end
			local target=targets[1]
			 --单击
			if game.ctrlGroup and #game.ctrlGroup.units==1 and game.ctrlGroup.units[1]==target and not target.isMum then
				local tab={}
				for _,ship in ipairs(target.parent.child) do
					
					if ship.name==target.name then
						table.insert(tab,ship)
					end
				end
				if tab[1] then
					game.ctrlGroup=game.groupCtrl:new(tab)
					for i,v in ipairs(game.ctrlGroup.units) do --取消选择
						v.isSelected=true
					end
				end
				
			else
				target.isSelected=true
				game.selectedTarget=target
				if target.side==game.userSide then
					game.ctrlGroup=game.groupCtrl:new({target})
				else
					game.ctrlGroup=nil
				end
			end
			
			game.selectRB=nil
			return
		end

		game.ctrlGroup=nil
		
		local newGroup=game:areaTest(game.selectLT[1],game.selectLT[2],game.selectRB[1] ,game.selectRB[2])
		if #newGroup==0 then return end 
		local group={}
		for i,v in ipairs(newGroup) do
			if v.side==game.userSide then
				v.isSelected=true
				table.insert(group,v)
			end
		end
		if #group>0 then
			game.ctrlGroup=game.groupCtrl:new(group)
			game.selectedTarget=group[1]
		end
		game.selectRB=nil
	end
	
end


function ctrl:draw()
	
	love.graphics.setColor(100,255,100)
	for i=1,#game.trace-1 do
		local x,y=game:bg2scr(game.trace[i][1],game.trace[i][2])
		
		love.graphics.circle("fill", x,y, 2)
	end
	if game.selectLT and game.selectRB then
		love.graphics.setLineWidth(1)
		love.graphics.rectangle("line",
			(game.selectLT[1]-game.bg.cam.x)*game.bg.cam.scale+resolution[1]/2,
			(game.selectLT[2]-game.bg.cam.y)*game.bg.cam.scale+resolution[2]/2,
			(game.selectRB[1]-game.selectLT[1])*game.bg.cam.scale,(game.selectRB[2]-game.selectLT[2])*game.bg.cam.scale)
	end

	if game.tmpWayPoint then
		for i,v in ipairs(game.tmpWayPoint) do
			local x,y=game:bg2scr(v[1],v[2])
			love.graphics.circle("fill", x, y,2)
			if game.tmpWayPoint[i-1] then
				local ox,oy=game:bg2scr(game.tmpWayPoint[i-1][1],game.tmpWayPoint[i-1][2])
				love.graphics.line(x,y,ox,oy)
			end
		end
		

	end
end


return ctrl