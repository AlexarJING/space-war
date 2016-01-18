local designer={}
designer.ui={}
local fileModule=
[[

function ship:initialize(side,x,y,rot)
	res.shipClass.base.initialize(self,side,x,y,rot)
	self:setParam(param)
	self:reset()
	self:getCanvas()
end

return ship]]

function designer:createUI()
	self.ui.property=loveframes.Create("frame")
					:SetPos(w-200,0)
					:SetSize(200,h)
					:SetName("Basic Property")

	self.ui.propertyList=loveframes.Create("columnlist", self.ui.property)
		:SetColumnHeight(30)
		:AddColumn("Key")
		:AddColumn("Value")
		:SetPos(1,25)
		:SetSize(200,h-25)
	self.ui.propertyList.OnRowClicked = function(parent, row, rowdata)
		self:editProperty(rowdata[1],rowdata[2])
	end
	self.ui.propertyList.OnRowRightClicked = function(parent, row, rowdata)
		if rowdata[1]=="fireSys" then
			self.tag="fire"
			designer:updateList()
		elseif rowdata[1]=="engineSys" then
			self.tag="engine"
			designer:updateList()
		end
	end
end
local keys={"name","isMum","energyMax","armorMax","skin","size","speedMax","speedAcc","visualRange","fireRange"}

function designer:updateList()
	local tag=self.tag
	self.ui.propertyList:Clear()
	if tag=="basic" then
		self.ui.property:SetName("Basic Property")
		for i,key in ipairs(keys) do
			self.ui.propertyList:AddRow(key, self.target[key])
		end
		self.ui.propertyList:AddRow("fireSys", #self.target.fireSys)
		self.ui.propertyList:AddRow("engineSys", #self.target.engineSys)
	elseif tag=="fire" then
		self.ui.property:SetName("Weapon Property")
		for i,gun in ipairs(self.target.fireSys) do
			for k,v in pairs(gun) do
				self.ui.propertyList:AddRow("wpn."..i..","..k, gun[k])
			end
		end

	elseif tag=="engine" then
		self.ui.property:SetName("Engine Property")
		for i,engine in ipairs(self.target.engineSys) do
			for k,v in pairs(engine) do
				self.ui.propertyList:AddRow("ngn."..i..","..k, engine[k])
			end
		end
	end

end


function designer:new()
	game.uiCtrl:setVisible(false)
	game.showFog=false
	game.showAll=true
	self.target=res.shipClass.cruiser("blue",400,500)
	local x=300
	local y=300
	for k,v in pairs(res.shipClass) do
		x=x+100
		if x>1000 then x=300;y=y+100 end
		if v~=res.shipClass.base and v~=res.shipClass.rnd then
			local ship=v("blue",x,y)
			print(ship.name)
		end
	end
	game.bg.cam:lookAt(500,500)
	self:createUI()
	self.tag="basic"
	self:updateList()


	local lastEvent=game.event:new(self.target,
			"always",
			function()
				return game.time>=5
			end,
			_,
			function()
				game.msg:sys("move to the postion 100,100 now!")
				game.indicator={100,100}
			end,
			_,
			true
	) 
	game.event:new(self.target,
			"always",
			function()
				return math.getDistance(self.target.x,self.target.y,100,100)<30
			end,
			_,
			function()
				game.indicator=nil
				game.msg:sys("congratulations! the event works!")
			end,
			_,
			true
	)
	game.event:new(self.target,
			"onEvent",
			function(event)
				return event==lastEvent
			end,
			_,
			function()
				delay:new(2,nil,function()  
					game.msg:sys("this is triggled by the end of event")	
				end)
				
			end,
			_,
			true
	)

end

function modifyProp()


end


function designer:update()
	if love.keyboard.isDown("escape") then
		self.tag="basic"
		self:updateList()
	end

	if love.keyboard.isDown("lctrl") and love.keyboard.isDown("s") then
		local file=io.open(path.."/obj/ships/"..self.target.name..".lua")
		if file then 
			--print("can not overwrite the file!")
		else
			file=io.open(path.."/obj/ships/"..self.target.name..".lua","w")
			local str1='local ship=Class("'..self.target.name..'",res.shipClass.base)\n'		
			file:write(str1 ..table.save(self.target:getParam(),"param")..fileModule)
			file:close()
		end
	end
end

local mod={}
mod.engineSys={posX=-9,posY=0,rot=0,anim=1}
mod.fireSye={posX=5,posY=-3,rot=0,type="impulse",level=1,cd=100,heat=0}


function designer:editProperty(key,value)
	game.ctrlLock=true
	local obj=self.target
	local frame = loveframes.Create("frame")
	frame:SetName(key.."--edit mode")
	frame:SetSize(500, 90)
	frame:CenterWithinArea(0,0,w,h)
	
	local textinput = loveframes.Create("textinput", frame)
	textinput:SetPos(5, 30)
	textinput:SetWidth(490)
	textinput:SetText(value)
	textinput.OnEnter = function(object)
		game.ctrlLock=false
		if string.sub(key,1,3)=="wpn" then
			local no=tonumber(string.sub(key,5,5))
			key=string.sub(key,7)
			obj=obj.fireSys[no]
			
		elseif string.find(key,"ngn") then
			local no=tonumber(string.sub(key,5,5))
			key=string.sub(key,7)
			obj=obj.engineSys[no]
		else

		end
		local t=type(obj[key])

		if t=="number" then
			obj[key]=tonumber(textinput:GetText())
		elseif t=="string" then
			obj[key]=textinput:GetText()
		elseif t=="boolean" or t=="nil" then
			obj[key]= textinput:GetText()=="true"
		elseif t=="table" then
			value=tonumber(textinput:GetText())
			if value>#obj[key] then
				for i=1,value-#obj[key] do
					local tab=table.copy(mod[key])
					table.insert(obj[key], tab)
				end
			else
				for i=1,#obj[key]-value do
					table.remove(obj[key], 1)
				end
			end
		end
		self.target:reset()
		frame:Remove()
		designer:updateList(designer.tag)
	end
end

function designer:addTable(key,value)


end










return designer
