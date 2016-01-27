game={}
game.ship={}
game.trace={}
game.bullet={}
game.frag={}
game.spark={}
game.msg=require "scr/game/message"
game.bg=require "scr/map/bg_quad"

game.userSide="blue"
game.cursorAura=0
game.ctrlMode="turn" --move or turn 
game.teamCtrl=false
game.ctrlGroup=nil
game.wheelMove=0
game.ctrlTrace={}
game.ctrl=require "scr/game/ctrlMode"
game.groupCtrl= require "scr/game/groupCtrl"
game.ctrl.mode="fleet"

game.uiCtrl= require("scr/ui/gameUI"):init()
game.mum={}--母舰

game.isLocating=false

game.selectedTarget=nil
game.cmdCtrl=require "scr/game/cmd"
game.locatedTarget=nil

--game.rule=require "tasks/protectTheMotherShip"
--game.rule=require "tasks/designer"
game.rule=require "tasks/encounter"
---game.debug=true
game.money=0
game.rock={}
game.fog={}
game.fogRate=100
game.fogChroma=5
game.showFog=true
game.showAll=false
game.groupStore={}

game.event=require "scr/game/event"
game.time=0
for i=1,game.fogRate do  --二维数组,每次更新先清空 
	game.fog[i]={}
	for j=1,game.fogRate do
		game.fog[i][j]=255
	end
end

function game:new()
	game.rule:new()
end






function game:newBullet(parent,type,x,y,rot,level,speed,type)
	error("removed")
	if type=="impulse" then
		table.insert(self.bullet, res.weaponClass.impulse(parent,level,x,y,rot,speed))
	elseif type=="laser" then
		table.insert(self.bullet, res.weaponClass.laser(parent,level,x,y,rot))
	elseif type=="missile" then
		table.insert(self.bullet, res.weaponClass.missile(parent,level,x,y,rot))
	elseif type=="tesla" then
		table.insert(self.bullet, res.weaponClass.tesla(parent,level,x,y))
	elseif type=="proton" then
		table.insert(self.bullet, res.weaponClass.proton(parent,level,x,y,rot))
	end
end

function game:newSpark(x,y)
	table.insert(self.spark, res.otherClass.spark(x,y))
end

function game:pay(who,energy,mineral)
	mineral =mineral or 0
	if who.energy>=energy and who.mineral>=mineral then
		who.energy=who.energy-energy
		who.mineral=who.mineral-mineral
		return true
	end
	return false
end
function game:getFocus()
	if not game.ctrlGroup then  
		game.focus=game.mum[1]
	else
		game.focus=game.ctrlGroup.units[math.ceil(#game.ctrlGroup.units/2)],math.ceil(#game.ctrlGroup.units/2)
	end
	
	return game.focus
end

function game:scr2bg(x,y)
	return game.bg.cam.x+(x-resolution[1]/2)/game.bg.cam.scale, --对应实际坐标
	game.bg.cam.y+(y-resolution[2]/2)/game.bg.cam.scale
end

function game:bg2scr(x,y)
	return (x-game.bg.cam.x)*game.bg.cam.scale+resolution[1]/2,
	(y-game.bg.cam.y)*game.bg.cam.scale+resolution[2]/2
end

function game:bg2mini(x,y)
	return x*game.uiCtrl.miniMap.map.w/(game.bg.limit.r-game.bg.limit.l)+game.uiCtrl.miniMap.map.x, 
		y*game.uiCtrl.miniMap.map.h/(game.bg.limit.r-game.bg.limit.l)+game.uiCtrl.miniMap.map.y
end

function game:mini2bg(x,y)
	return (x-game.uiCtrl.miniMap.map.x)*(game.bg.limit.r-game.bg.limit.l)/game.uiCtrl.miniMap.map.w,
	(y-game.uiCtrl.miniMap.map.y)*(game.bg.limit.b-game.bg.limit.t)/game.uiCtrl.miniMap.map.h
end


local function updateTab(tab,dt)
	for i=#tab,1,-1 do
		tab[i]:update(dt)
		if tab[i].dead then table.safeRemove(tab,i) end
	end
end

function game:swithGroup(to)
	if not to then return end
	if game.ctrlGroup then
		for _,v in ipairs(game.ctrlGroup.units) do
			v.isSelected=false
		end
	end

	for i,v in ipairs(to.units) do
		v.isSelected=true
	end
	game.ctrlGroup=to
end

function game:select(target)
	for i,v in ipairs(game.ctrlGroup.units) do
		v.isSelected=false
	end
	if target==nil or #target==0 then
		game.selectedTarget=nil
		game.ctrlGroup=nil
		return
	end

	if target[1] then
		for i,v in ipairs(target) do
			v.isSelected=true
		end
		game.ctrlGroup=game.groupCtrl:new(target)
	else
		target.isSelected=true
		game.ctrlGroup=game.groupCtrl:new({target})
	end
end



function game:update(dt)

	game.time=game.time+dt
	game.event:check("always")
	game.rule:update(dt)
	game.mx,game.my=love.mouse.getPosition() --鼠标屏幕坐标
	game.bx,game.by= game:scr2bg(game.mx,game.my)
	if game.pause then return end
	game.cmdCtrl:call(game.cmd)
	
	self.ctrl:update()

	self.groupCtrl:update()
	if game.freeze then return end
	--------------------------for update things-----------------------

	updateTab(self.ship,dt)
	updateTab(self.bullet,dt)
	updateTab(self.frag,dt)
	updateTab(self.spark,dt)
	updateTab(self.rock,dt)


	self.bg:update()
	self.uiCtrl:update(dt)
	self:updateFog()
end


function game:draw()
	self.bg:draw()
	self.bg.cam:draw(function()
		for i,v in ipairs(self.rock) do
			v:draw()
		end

		for i,v in ipairs(self.ship) do
			v:draw()
		end
		for i,v in ipairs(self.bullet) do
			v:draw()
		end
		for i,v in ipairs(self.frag) do
			v:draw()
		end
		for i,v in ipairs(self.spark) do
			v:draw()
		end

		game:frameDraw()
		if game.showFog then game:fogDraw() end
		love.graphics.setColor(255, 0,0)
		love.graphics.rectangle("line", self.bg.limit.l,self.bg.limit.t,game.bg.limit.r-game.bg.limit.l,game.bg.limit.b-game.bg.limit.t)
	end)

	self.ctrl:draw()
	
	self.msg:draw()
	self.uiCtrl:draw()
	self:drawCursor()	
	if self.indicator then
		self.indicatorAura=self.indicatorAura or 50
		local x,y=game:bg2scr(unpack(self.indicator))
		if self.indicatorAura>0 then
			love.graphics.setColor(0,255,0)
			love.graphics.getLineWidth(1)
			love.graphics.circle("line", x,y,self.indicatorAura)
			self.indicatorAura=self.indicatorAura-3
		else
			self.indicatorAura=50
		end
	end
	
end


function game:drawCursor()
	love.graphics.setColor(255,255,255)
	if game.cursorMode=="select" then
		if love.mouse.isDown("l") or love.mouse.isDown("r") then
			love.graphics.setColor(255,0,0)
		end
		love.graphics.draw(res.cursorSelect,self.mx,self.my,0,1,1,15,15)
	else
		if love.mouse.isDown("l") or love.mouse.isDown("r") then
			love.graphics.draw(res.cursor,self.mx+3,self.my+3,0,1,1,2,2)
		else
			love.graphics.draw(res.cursor,self.mx,self.my,0,1,1,2,2)
		end
	end
	

	if game.cursorAura>0 then
		love.graphics.setColor(0,255,0)
		love.graphics.getLineWidth(1)
		love.graphics.circle("line", self.cPosX,self.cPosY,game.cursorAura)
		game.cursorAura=game.cursorAura-3
	end
end



function game:collision(x,y,tx,ty,dist)
	if math.abs(tx-x)>dist then return false end
	if math.abs(ty-y)>dist then return false end
	if math.getDistance(x,y,tx,ty)>dist then return false end
	return true
end



function game:isEnoughPlace(ship,x,y,group)

	if not ship then return end
	if group then --仅计算组内的

		for i,v in ipairs(group.units) do
			if v~=ship and v.dx then
				if game:collision(x,y,v.dx,v.dy,ship.r+v.r) then
					return false
				end
			end
		end
	else --计算全局的
		for i,v in ipairs(self.ship) do
			if v~=ship and v.side==ship.side then
				local tx,ty
				if ship.group and v.group==ship.group then
					tx=v.dx
					ty=v.dy
				else
					tx=v.dx or v.x
					ty=v.dy or v.y
				end
				if tx then
					if game:collision(x,y,tx,ty,ship.r+v.r) then
						return false
					end
				end
			end
		end
	end
	return true
end






function game:pointTest()
	local ret={}
	for i,v in ipairs(game.ship) do --单击
		if v:mouseTest() then
			table.insert(ret, v)
		end
	end
	return ret
end

function game:areaTest(l,t,r,b)
	local ret={}
	for i,v in ipairs(game.ship) do
		if v.x>l and v.x<r and v.y>t and v.y<b then
			table.insert(ret,v)
		end
	end
	return ret
end

function game:toDeployment(mother,newShip)

	if #mother.deployment==2 then
		game:shipMove(newShip,mother.deployment[1],mother.deployment[2],true)
	else
		if mother.deployment.dead then
			mother.deployment=mother
		end
		game:shipMove(newShip,mother.deployment.x,mother.deployment.y,true)
		--game.groupCtrl:addToGroup(newShip,mother.deployment.group)
	end
end


function game:shipMove(ship,x,y,coll,group)
	x,y=game:inLimit(x,y)
	if coll then
		local px,py=self:LookForPlace(ship,x,y,group)
		ship:moveTo(px,py)
	else
		ship:moveTo(x,y)
	end
end

function game:LookForPlace(ship,x,y,group)
	local t=0
	while true do
		t=t+1
		for i=0,2*Pi,Pi/3/t do 
			local tx,ty=x+math.sin(i)*t*ship.r,y+math.cos(i)*t*ship.r
			if self:isEnoughPlace(ship,tx,ty) then
				return tx,ty
			end
		end
	end
end



function game:mousepressed(key)
	game.msg.mousepressed(key)
	if key=="wu" then
		self.wheelMove=1
	elseif key=="wd" then
		self.wheelMove=-1
	end
end

function game:keypressed(key)
	
	game.msg.keypressed(key)
	if game.keyLock then return end
	if key=="escape" then
		game.cmd=nil
		game.isLocating=false
		game.cursorMode="normal"
		game.locatedTarget=nil
		game.selectedTarget=nil
		if game.ctrlGroup then
			for i,v in ipairs(game.ctrlGroup.units) do
				v.isSelected=false
			end
		end
		game.ctrlGroup=nil
	end

	if key=="f" then
		game.cmd="form"
	end

	if key==" "  then
		game:getFocus()
	end

	if key=="c" then
		game.cmd="concentrate"
	end

	if key=="f9" then
		game.fullscreen=not game.fullscreen
		if game.fullscreen then 
			love.window.setMode( 1600, 900,{fullscreen=true,fullscreentype="normal"}) 
		else
			love.window.setMode( 1280, 720) 
		end
		resolution={ love.graphics.getDimensions() }
		scaleX=resolution[1]/designResolution[1]
		scaleY=resolution[2]/designResolution[2]
		w=resolution[1]
		h=resolution[2]
		game.uiCtrl.ui.miniMap.map:reSize()
		game.uiCtrl:uiReset()
	end

	if key=="a" and  love.keyboard.isDown("lctrl") then
		if game.ctrlGroup and game.ctrlGroup.units then
			for i,v in ipairs(game.ctrlGroup.units) do --取消选择
				v.isSelected=false
			end
		end
		local group={}
		for i,v in ipairs(game.ship) do
			if v.side==game.userSide and not v.isSP then
				v.isSelected=true
				table.insert(group,v)
			end
		end
		if #group>0 then
			game.ctrlGroup=game.groupCtrl:new(group)
		end
	end

	local index=tonumber(key)
	if index and index>0 and index<11 and love.keyboard.isDown("lctrl") then
		if game.ctrlGroup then
			game.uiCtrl.ui.mainInfo.groupIndex[index]:SetEnabled(true)
			game.groupStore[index]=game.ctrlGroup
		end
	end

	if index and index>0 and index<11 and not love.keyboard.isDown("lctrl") then
		game:swithGroup(game.groupStore[index])
	end
end


function game:inLimit(x,y)
	if x<self.bg.limit.l then x=self.bg.limit.l end
	if x>self.bg.limit.r then x=self.bg.limit.r end
	if y<self.bg.limit.t then y=self.bg.limit.t end
	if y>self.bg.limit.b then y=self.bg.limit.b end
	return x,y
end


function game:updateFog()
	for i=1,game.fogRate do  --二维数组,每次更新先清空 
		--game.fog[i]={}
		for j=1,game.fogRate do
			game.fog[i][j]=game.fog[i][j]==255 and 255 or 200
		end
	end

	local w=(game.bg.limit.r-game.bg.limit.l)/game.fogRate
	local h=(game.bg.limit.b-game.bg.limit.t)/game.fogRate
	for i,v in ipairs(self.ship) do
		local x=math.ceil(v.x/w)
		local y=math.ceil(v.y/h)
		if v.side==game.userSide then
			local r=math.ceil(v.visualRange/w)
			for xx=x-r,x+r do
				for yy=y-r,y+r do
					if self.fog[xx] and self.fog[xx][yy] then
						self.fog[xx][yy]=self.fog[xx][yy]-self.fogChroma*(r-math.abs(x-xx))*(r-math.abs(y-yy))
					end
				end
			end
		end
	end
end

function game:getVisualAlpha(obj)
	if game.showAll then return 255 end
	local w=(game.bg.limit.r-game.bg.limit.l)/game.fogRate
	local h=(game.bg.limit.b-game.bg.limit.t)/game.fogRate
	local x=math.ceil(obj.x/w)
	local y=math.ceil(obj.y/h)
	if not game.fog[x] or not game.fog[x][y] then return 0 end
	return game.fog[x][y]>199 and 0 or 255
end


function game:fogDraw()
	local w=(game.bg.limit.r-game.bg.limit.l)/game.fogRate
	local h=(game.bg.limit.b-game.bg.limit.t)/game.fogRate
	
	local l,r,t,b=
	math.ceil((game.bg.cam.x-resolution[1]/2/game.bg.cam.scale)/w),
	math.ceil((game.bg.cam.x+resolution[1]/2/game.bg.cam.scale)/w),
	math.ceil((game.bg.cam.y-resolution[2]/2/game.bg.cam.scale)/h),
	math.ceil((game.bg.cam.y+resolution[2]/2/game.bg.cam.scale)/h)
	
	l=l>1 and l or 1
	r=r<game.fogRate and r or game.fogRate
	t=t>1 and t or 1
	b=b<game.fogRate and b or game.fogRate

	
	for i=l,r do  --二维数组,每次更新先清空
		for j=t,b do
			local alpha=self.fog[i][j]>0 and self.fog[i][j] or 0
			love.graphics.setColor(50,50,50,alpha)
			love.graphics.rectangle("fill",(i-1)*w, (j-1)*h,w,h)
			
		end
	end

end


function game:frameDraw()
	love.graphics.setLineWidth(1)
	for i,v in ipairs(self.ship) do
		if v.isSelected then
			love.graphics.setColor(0,255,0)
			love.graphics.line(v.x-v.r,v.y-v.r*0.8,v.x-v.r,v.y-v.r,v.x-v.r*0.8,v.y-v.r)
			love.graphics.line(v.x+v.r,v.y+v.r*0.8,v.x+v.r,v.y+v.r,v.x+v.r*0.8,v.y+v.r)
			love.graphics.line(v.x-v.r,v.y+v.r*0.8,v.x-v.r,v.y+v.r,v.x-v.r*0.8,v.y+v.r)
			love.graphics.line(v.x+v.r*0.8,v.y-v.r,v.x+v.r,v.y-v.r,v.x+v.r,v.y-v.r*0.8)
			
			local top=v.y-v.r-5*v.size
			

			local energy=v.energy/v.energyMax
			local armor=v.armor/v.armorMax


			love.graphics.setColor(0,255,0)
			love.graphics.rectangle("fill",v.x-v.r,top,2*v.r*armor,v.size*2)
			local boxCount=math.floor(v.armorMax/50)
			local boxLenth=2*v.r/boxCount
			for i=1,boxCount do
				love.graphics.setColor(0,0,0)
				love.graphics.rectangle("line", v.x-v.r+(i-1)*boxLenth, top, boxLenth,v.size*2)
			end

			top=top+v.size*2
			love.graphics.setColor(255,0,255)
			love.graphics.rectangle("fill",v.x-v.r,top,2*v.r*energy,v.size*2)
			local boxCount=math.floor(v.energyMax/50)
			local boxLenth=2*v.r/boxCount
			for i=1,boxCount do
				love.graphics.setColor(0,0,0)
				love.graphics.rectangle("line", v.x-v.r+(i-1)*boxLenth, top, boxLenth,v.size*2)
			end
		end
	end
	
end


