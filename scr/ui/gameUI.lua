local uiCtrl={}
uiCtrl.miniMap=require "scr/ui/miniMap"
function uiCtrl.uiReset()
	
	uiCtrl.ui.topInfo:SetSize(w,0.05*h):SetPos(0,0)
	uiCtrl.ui.mainInfo:SetSize(w-0.5*h,0.20*h):SetPos(0.25*h,0.8*h)
	uiCtrl.ui.ctrlGrid:SetPos(w-0.25*h,0.75*h):SetCellWidth(0.083*h):SetCellHeight(0.083*h)
	uiCtrl.ui.miniMap:SetSize(0.25*h,0.25*h):SetPos(0, 0.75*h)			
	for i=1,9 do
		uiCtrl.ui.ctrlGrid:GetItem(math.ceil(i/3), i%3+1)
			:SetSize(0.08*h,0.08*h)
			:SetColor(50,255,50)
			:SetOptions(0,0,0, 0.08*h/32,0.08*h/32)
	end
	uiCtrl.lastMenuTarget=nil
	for i=1,4 do
		uiCtrl.ui.menu[i]:SetSize(0.15*h,0.04*h):SetPos(0.02*h+0.18*h*(i-1),0.005*h)
	end

	uiCtrl.ui.resText:SetSize(h,0.3*h):SetPos(w/2+0.1*h,0.01*h)

	uiCtrl.ui.caractor:SetSize(0.15*h,0.15*h):SetPos(0.01*h,0.025*h):SetOptions(h/14,h/13,-Pi/2, h/120,h/120,8,8)


	for i=1,10 do
		uiCtrl.ui.groupIndex[i]:SetSize(0.06*h,0.04*h):SetPos(0.5*w+0.08*h*(i-1)-0.64*h,-0.05*h)
	end

	uiCtrl.ui.groupInfo:SetPos(0.3*h,0.015*h):SetSize(w-0.81*h,0.17*h)
	
	for i,b in ipairs(uiCtrl.ui.groupInfo.children) do
		b:SetSize(0.075*h,0.075*h)
		b:SetText("")
		b:SetOptions(h/25,h/25,-Pi/2, h/240,h/240,8,8)
	end

	uiCtrl.ui.targetBref:SetSize(0.15*h,0.01*h):SetPos(0.17*h,0.02*h)

	uiCtrl.ui.targetInfo:SetPos(0.3*h,0.015*h):SetSize(w-0.81*h,0.17*h):SetCellWidth((w-0.81*h)/7.4):SetCellHeight(h*0.025)
		
	uiCtrl.ui.progress:SetSize(w-0.81*h,0.16*h):SetPos(0.3*h,0.015*h)

	uiCtrl.ui.progressIcon:SetPos(0.01*h, 0.02*h):SetSize(0.12*h,0.12*h):SetOptions(h/16.5,h/16.5,-Pi/2, h/140,h/140,8,8)

	uiCtrl.ui.progressBar:SetPos(0.3*h, 0.03*h):SetSize(w-1.2*h,0.03*h)

	uiCtrl.ui.progressText:SetSize(h/6,h):SetPos(0.14*h, 0.03*h)
	
	local size=0.07*h
	local step
	repeat
		step=0.07*h+(w-1.47*h)/7
		size=size*0.9
	until step>size*1.1
	for i=1,7 do
		uiCtrl.ui.progressQueue[i]:SetPos(0.16*h+(i-1)*step, 0.08*h):SetSize(size,size)
		:SetOptions(size/2,size/2,-Pi/2, size/15,size/15,8,8)
	end
end
function uiCtrl:setVisible(bool)
	uiCtrl.ui.topInfo:SetVisible(bool) 	
	uiCtrl.ui.miniMap:SetVisible(bool)
	uiCtrl.ui.mainInfo:SetVisible(bool)
	uiCtrl.ui.ctrlGrid:SetVisible(bool)
end


uiCtrl.ui={}
uiCtrl.ui.topInfo=loveframes.Create("panel")
	:SetSize(w,0.05*h)
	:SetPos(0,0)

uiCtrl.ui.miniMap=loveframes.Create("panel")
	:SetSize(0.25*h,0.25*h)
	:SetPos(0, 0.75*h)

uiCtrl.ui.mainInfo=loveframes.Create("panel")
	:SetSize(w-0.5*h,0.20*h)
	:SetPos(0.25*h,0.8*h)

uiCtrl.ui.ctrlGrid=loveframes.Create("grid")
	:SetPos(w-0.25*h,0.75*h)
	:SetRows(3)
	:SetColumns(3)
	:SetCellWidth(0.083*h)
	:SetCellHeight(0.083*h)
	:SetCellPadding(0)
	:SetItemAutoSize(false)
--uiCtrl.ui.mumCtrl.showOuterBorder=true
---uiCtrl.ui.mumCtrl.showInnerBorder=true
for i=1,9 do
	local btn=loveframes.Create("imagebutton")
	--btn:SetImage(sheet2,res.icon[i][i])
	btn:SetText("")
		:SetSize(0.08*h,0.08*h)
		:SetColor(50,255,50)
		:SetOptions(0,0,0, 0.08*h/32,0.08*h/32)
	uiCtrl.ui.ctrlGrid:AddItem(btn, math.ceil(i/3), i%3+1)
	btn.tip = loveframes.Create("tooltip")
		:SetObject(btn)
		:SetText("")
end
-----------------------mission object----------------------------
	uiCtrl.ui.object=loveframes.Create("frame")
				:SetPos(5,h/18)
				:SetSize(350,150)
				:SetName(" Mission Object")

	uiCtrl.ui.objectList=loveframes.Create("list", uiCtrl.ui.object)
		:SetPos(0,23)
		:SetSize(350,127)
		:SetPadding(2)

	for i=1,5 do
		local txt=loveframes.Create("text")
			:SetDefaultColor(0,255,0)
			:SetText("("..i.."),".."kill all the enemies" )
		uiCtrl.ui.objectList:AddItem(txt)
	end
	uiCtrl.ui.object:SetVisible(false)
-------------------options----------------------------
	uiCtrl.ui.optionMenu=loveframes.Create("frame")
				:SetPos(w/2,150,true)
				:SetSize(350,500)
				:SetName("Options Menu")
				:SetState("opt")
				:ShowCloseButton(false)
	uiCtrl.ui.optionGrid=loveframes.Create("grid",uiCtrl.ui.optionMenu)
		:SetPos(0,35)
		:SetRows(8)
		:SetColumns(2)
		:SetCellWidth(350/2.2)
		:SetCellHeight(50)
		:SetCellPadding(2)
		:SetItemAutoSize(false)
		uiCtrl.ui.optionGrid.leftRange=15

	local txt=loveframes.Create("text")
		:SetText({ {color = {0,255,0},font =res.font_20}, "resolution"})	
	uiCtrl.ui.optionGrid:AddItem(txt,1,1)
	local multichoice = loveframes.Create("multichoice")
	multichoice:SetSize(350/2.5,500/15)
	multichoice:AddChoice("800x600")
	multichoice:AddChoice("1280x760")
	multichoice:SetChoice("800x600")
	uiCtrl.ui.optionGrid:AddItem(multichoice,1,2)

	local checkbox = loveframes.Create("checkbox")
	checkbox:SetText("fullscreen")
	uiCtrl.ui.optionGrid:AddItem(checkbox,2,1)

	local checkbox = loveframes.Create("checkbox")
	checkbox:SetText("Auto Save the game every minuts")
	uiCtrl.ui.optionGrid:AddItem(checkbox,3,1)


	local checkbox = loveframes.Create("checkbox")
	checkbox:SetText("Limit mouse to the window")
	uiCtrl.ui.optionGrid:AddItem(checkbox,4,1)

	local checkbox = loveframes.Create("checkbox")
	checkbox:SetText("Mute")
	uiCtrl.ui.optionGrid:AddItem(checkbox,2,2)


	local txt=loveframes.Create("text")
		:SetText({ {color = {0,255,0},font =res.font_20}, "system volume"})	
	uiCtrl.ui.optionGrid:AddItem(txt,5,1)
	local slider = loveframes.Create("slider")
	slider:SetWidth(120)
	slider:SetMinMax(0, 100)
	slider:SetValue(100)
	uiCtrl.ui.optionGrid:AddItem(slider,5,2)

	local txt=loveframes.Create("text")
		:SetText({ {color = {0,255,0},font =res.font_20}, "music volume"})	
	uiCtrl.ui.optionGrid:AddItem(txt,6,1)
	local slider = loveframes.Create("slider")
	slider:SetWidth(120)
	slider:SetMinMax(0, 100)
	slider:SetValue(100)
	uiCtrl.ui.optionGrid:AddItem(slider,6,2)


	local txt=loveframes.Create("text")
		:SetText({ {color = {0,255,0},font =res.font_20}, "effect volume"})	
	uiCtrl.ui.optionGrid:AddItem(txt,7,1)
	local slider = loveframes.Create("slider")
	slider:SetWidth(120)
	slider:SetMinMax(0, 100)
	slider:SetValue(100)
	uiCtrl.ui.optionGrid:AddItem(slider,7,2)

	local btn=loveframes.Create("button")
		:SetSize(150,30)
		:SetText("default")	
		btn.OnClick=function() loveframes.SetState("none");uiCtrl.ui.optionMenu:SetVisible(false);game.mouseLock=false end
	uiCtrl.ui.optionGrid:AddItem(btn,8,1)

	local btn=loveframes.Create("button")
		:SetSize(150,30)
		:SetText("save")
		btn.OnClick=function() loveframes.SetState("none");uiCtrl.ui.optionMenu:SetVisible(false);game.mouseLock=false end	
	uiCtrl.ui.optionGrid:AddItem(btn,8,2)
	uiCtrl.ui.optionMenu:SetVisible(false)
--------------------game menu---------------------------------
	uiCtrl.ui.gameMenu=loveframes.Create("frame")
				:SetPos(w/2,150,true)
				:SetSize(350,450)
				:SetName("Game Menu")
				:SetState("menu")
				:ShowCloseButton(false)
	uiCtrl.ui.gameList=loveframes.Create("list",uiCtrl.ui.gameMenu)
		:SetPos(0,25)
		:SetSize(350,425)
		:SetPadding(80)
		:SetSpacing(20)
		:SetDisplayType("vertical")
		:EnableHorizontalStacking(true)
		uiCtrl.ui.gameList.oneline=true
	local txt=loveframes.Create("text")
		:SetSize(180,30)
		:SetText({ {color = {0,255,0},font =res.font_20}, "        game paused"})	
	uiCtrl.ui.gameList:AddItem(txt)

	local btn=loveframes.Create("button")
		:SetSize(180,30)
		:SetText("score")	
	uiCtrl.ui.gameList:AddItem(btn)
	local btn=loveframes.Create("button")
		:SetSize(180,30)
		:SetText("surrender")	
	uiCtrl.ui.gameList:AddItem(btn)
	local btn=loveframes.Create("button")
		:SetSize(180,30)
		:SetText("save")	
	uiCtrl.ui.gameList:AddItem(btn)
	local btn=loveframes.Create("button")
		:SetSize(180,30)
		:SetText("load")	
	uiCtrl.ui.gameList:AddItem(btn)
	local btn=loveframes.Create("button")
		:SetSize(180,30)
		:SetText("exit to desktop")	
	uiCtrl.ui.gameList:AddItem(btn)
	local txt=loveframes.Create("text")
		:SetText({ {color = {0,255,0},font =res.font_20}, "        "})	
	uiCtrl.ui.gameList:AddItem(txt)
	local btn=loveframes.Create("button")
		:SetSize(180,30)
		:SetText("return to game")
		btn.OnClick=function() loveframes.SetState("none");uiCtrl.ui.gameMenu:SetVisible(true) ;game.mouseLock=false end	
	uiCtrl.ui.gameList:AddItem(btn)
	uiCtrl.ui.gameMenu:SetVisible(false)
--------------------------------------------
local text={"object [F1]","options [F2]","game menu[F3]","Alliance [F4]"}
local func={
	function()uiCtrl.ui.object:SetVisible(not uiCtrl.ui.object.visible)end,
	function()uiCtrl.ui.optionMenu:SetVisible(not uiCtrl.ui.optionMenu.visible);loveframes.SetState("opt");game.mouseLock=true end,
	function()uiCtrl.ui.gameMenu:SetVisible(not uiCtrl.ui.gameMenu.visible);loveframes.SetState("menu");game.mouseLock=true  end,
	function()uiCtrl.ui.object:SetVisible(not uiCtrl.ui.object.visible) end,
}
uiCtrl.ui.menu={}


for i=1,4 do
	uiCtrl.ui.menu[i]=loveframes.Create("button",uiCtrl.ui.topInfo)
		:SetSize(0.1*w,0.04*h)
		:SetPos(0.02*w+0.11*w*(i-1),0.005*h)
		:SetText(text[i])
	uiCtrl.ui.menu[i].OnClick=func[i]
end

uiCtrl.ui.resText=loveframes.Create("text",uiCtrl.ui.topInfo)
	:SetSize(0.5*w,0.04*h)
	:SetPos(0.7*w,0.005*h)
	:SetText({ {color = {0,255,0},font =res.font_20}, "resource:  Mineral 10000 ;  Energy  10000"})	


uiCtrl.ui.caractor=loveframes.Create("imagebutton",uiCtrl.ui.mainInfo)
	:SetSize(0.15*h,0.15*h)
	:SetPos(0.01*w,0.015*w)
	--:SetImage(sheet,res.ships.blue[1])
	:SetText("")
	:SetOptions(h/14,h/13,-Pi/2, h/120,h/120,8,8)

uiCtrl.ui.groupIndex={}
for i=1,10 do
	uiCtrl.ui.groupIndex[i]=loveframes.Create("button",uiCtrl.ui.mainInfo)
		:SetSize(0.05*w,0.04*h)
		:SetPos(0.03*w+0.06*w*(i-1),-0.05*h)
		:SetText(tostring(i))
		:SetEnabled(false)
	uiCtrl.ui.groupIndex[i].OnClick=function()
			game:swithGroup(game.groupStore[i])
	end
end

uiCtrl.ui.groupInfo=loveframes.Create("list", uiCtrl.ui.mainInfo)
	:SetPos(0.22*w,0.02*h)
	:SetSize(0.48*w,0.17*h)
	:SetPadding(5)
	:SetSpacing(5)
	:EnableHorizontalStacking(true)
--uiCtrl.ui.groupInfo:SetVisible(false) 	


uiCtrl.ui.targetBref= loveframes.Create("text",uiCtrl.ui.mainInfo)
	:SetText({ {color = {0,255,0},font=res.font_15}, ""})
	:SetSize(0.145*w,0.01*h)
	:SetPos(0.1*w,0.02*h)

uiCtrl.ui.targetInfo=loveframes.Create("grid",uiCtrl.ui.mainInfo)
	:SetPos(w/4.8,0.02*h)
	:SetSize(0.48*w,0.17*h)
	:SetRows(4)
	:SetColumns(6)
	:SetCellWidth(w/14)
	:SetCellHeight(w/80)
	--:SetCellPadding(w/100)
uiCtrl.ui.targetInfo.showOuterBorder=true




uiCtrl.ui.progress=loveframes.Create("panel",uiCtrl.ui.mainInfo)
	:SetSize(w/2,0.16*h)
	:SetPos(0.2*w,0.02*h)
uiCtrl.ui.progressIcon=loveframes.Create("imagebutton",uiCtrl.ui.progress)
	--:SetImage(sheet,res.ships.blue[1])
	:SetPos(0.01*w, 0.02*h)
	:SetSize(0.12*h,0.12*h)
	:SetText("")
	:SetOptions(h/16.5,h/16.5,-Pi/2, h/140,h/140,8,8)
uiCtrl.ui.progressIcon.OnClick=function(object) 
	if game.ctrlGroup.units[1].queue[1] then
		table.remove(game.ctrlGroup.units[1].queue,1)
	end
end
uiCtrl.ui.progressBar=loveframes.Create("progressbar",uiCtrl.ui.progress)
	:SetPos(0.26*w, 0.03*h)
	:SetSize(w/5,0.025*h)
	:SetLerpRate(10)
	:SetMax(100)
	:SetValue(10)
uiCtrl.ui.progressText=loveframes.Create("text",uiCtrl.ui.progress)
	:SetSize(w/6,h)
	:SetPos(0.09*w, 0.03*h)
	:SetText({ {color = {0,255,0},font=res.font_15}, "upgrading: armor lv.3"})
uiCtrl.ui.progressQueue={}
for i=1,7 do
	uiCtrl.ui.progressQueue[i]=loveframes.Create("imagebutton",uiCtrl.ui.progress)
	:SetPos(0.09*w+(i-1)*0.1*h, 0.08*h)
	:SetSize(0.07*h,0.07*h)
	:SetText("")
	:SetOptions(h/28,h/28,-Pi/2, h/280,h/280,8,8)
	uiCtrl.ui.progressQueue[i].OnClick=function(object) 
		if game.ctrlGroup.units[1].queue[i+1] then
			table.remove(game.ctrlGroup.units[1].queue,i+1)
		end
	end
end
uiCtrl.ui.progress:SetVisible(false)


uiCtrl.uiReset()

function uiCtrl:update(dt)
	self.miniMap:update()
	for k,v in pairs(self.ui) do
		if v.tween then
			v.tween:update(dt)
		end
	end
	uiCtrl:updateChar()
	uiCtrl:groupSelect()
	uiCtrl:updateTargetInfo()
	uiCtrl:updateQueue(dt)
	uiCtrl:updateCtrl()
	if game.mum[1] then
		uiCtrl.ui.resText:SetText({ {color = {0,255,0},font =res.font_15}, "resource:  Mineral: "..game.mum[1].mineral.." $"})
	end
end

function uiCtrl:draw()
	loveframes.draw()
	self.miniMap:draw()
end

function uiCtrl:groupSelect()
	if game.ctrlGroup==uiCtrl.lastGroup then 
		if game.ctrlGroup and #game.ctrlGroup.units~=uiCtrl.lastCount then
			--重设
		else
			return 
		end		
	end

	if not game.ctrlGroup or #game.ctrlGroup.units<2  then
		uiCtrl.ui.groupInfo:RemoveItem("all")
		uiCtrl.ui.groupInfo:SetVisible(false)
		return
	end 
	uiCtrl.ui.groupInfo:SetVisible(true)
	uiCtrl.ui.groupInfo:RemoveItem("all")
	for i,v in ipairs(game.ctrlGroup.units) do
		local b=loveframes.Create("imagebutton")
		b:SetImage(sheet,v.quad)
		b:SetSize(0.075*h,0.075*h)
		b:SetText("")
		b:SetOptions(h/25,h/25,-Pi/2, h/240,h/240,8,8)
		b.userdata=v
		b.OnClick = function(object)
			for i,v in ipairs(game.ctrlGroup.units) do
				v.isSelected=false
			end
			object.userdata.isSelected=true
			game.ctrlGroup={game.groupCtrl:new({v})}
		end
		uiCtrl.ui.groupInfo:AddItem(b)
	end
	uiCtrl.lastGroup=game.ctrlGroup
	uiCtrl.lastCount=#game.ctrlGroup.units
end

function uiCtrl:updateTargetInfo()
	local target=game.selectedTarget  or (game.ctrlGroup and #game.ctrlGroup.units==1 and game.ctrlGroup.units[1])
	if not target or target.isMum then 
		uiCtrl.ui.targetInfo:RemoveAll()
		uiCtrl.ui.targetInfo:SetVisible(false)
		return 
	end

	if uiCtrl.lastTarget==target then return end
	
	local p= loveframes.Create("text")
	p:SetText({ {color = {0,255,0},font=res.font_15},"Max. SPD."})
	uiCtrl.ui.targetInfo:AddItem(p, 1, 1)
	local p= loveframes.Create("text")
	p:SetText({ {color = {0,255,0},font=res.font_15},target.speedMax})
	uiCtrl.ui.targetInfo:AddItem(p, 1, 2)
	local p= loveframes.Create("text")
	p:SetText({ {color = {0,255,0},font=res.font_15},"ACC. SPD."})
	uiCtrl.ui.targetInfo:AddItem(p, 2, 1)
	local p= loveframes.Create("text")
	p:SetText({ {color = {0,255,0},font=res.font_15},target.speedAcc})
	uiCtrl.ui.targetInfo:AddItem(p, 2, 2)
	local p= loveframes.Create("text")
	p:SetText({ {color = {0,255,0},font=res.font_15},"Vis. Rng."})
	uiCtrl.ui.targetInfo:AddItem(p, 3, 1)
	local p= loveframes.Create("text")
	p:SetText({ {color = {0,255,0},font=res.font_15},target.visualRange})
	uiCtrl.ui.targetInfo:AddItem(p, 3, 2)
	local p= loveframes.Create("text")
	p:SetText({ {color = {0,255,0},font=res.font_15},"Fire Rng."})
	uiCtrl.ui.targetInfo:AddItem(p, 4, 1)
	local p= loveframes.Create("text")
	p:SetText({ {color = {0,255,0},font=res.font_15},target.fireRange})
	uiCtrl.ui.targetInfo:AddItem(p, 4, 2)

	for i,v in ipairs(target.fireSys) do
		local p= loveframes.Create("text")
		p:SetText({ {color = {0,255,0},font=res.font_15},i.." Wpn. Type"})
		uiCtrl.ui.targetInfo:AddItem(p, i, 3)
		local p= loveframes.Create("text")
		p:SetText({ {color = {0,255,0},font=res.font_15},v.type})
		uiCtrl.ui.targetInfo:AddItem(p, i, 4)
		local p= loveframes.Create("text")
		p:SetText({ {color = {0,255,0},font=res.font_15},i.." Wpn. Lvl"})
		uiCtrl.ui.targetInfo:AddItem(p, i, 5)
		local p= loveframes.Create("text")
		p:SetText({ {color = {0,255,0},font=res.font_15},v.level})
		uiCtrl.ui.targetInfo:AddItem(p, i, 6)
	end

	uiCtrl.ui.targetInfo:SetVisible(true)
	uiCtrl.lastTarget=target
end

function uiCtrl:updateQueue(dt)
	local target=game.ctrlGroup and game.ctrlGroup.units[1]
	if (not target) or (not target.isMum) or (#game.ctrlGroup.units>1)then 
		uiCtrl.ui.progress:SetVisible(false)
		return 
	end 
	uiCtrl.ui.progress:SetVisible(true)
	local m=target.queue[1]
	if m then
		uiCtrl.ui.progressIcon:SetImage(sheet,m.icon)
		uiCtrl.ui.progressBar:SetMax(math.floor(m.during*10)/10)
		uiCtrl.ui.progressBar:SetValue(math.floor(m.time*10)/10)
		uiCtrl.ui.progressText:SetText({ {color = {0,255,0},font=res.font_15}, m.text})
	else
		uiCtrl.ui.progressIcon:SetImage(nil)
		uiCtrl.ui.progressBar:SetMax(0)
		uiCtrl.ui.progressBar:SetValue(0)
		uiCtrl.ui.progressText:SetText({ {color = {0,255,0},font=res.font_15}, "empty"})
	end
	for i=2,8 do
		local m=target.queue[i]
		if  m then
			uiCtrl.ui.progressQueue[i-1]:SetImage(sheet,m.icon)
		else
			uiCtrl.ui.progressQueue[i-1]:SetImage(nil)
		end
	end
end
function uiCtrl:updateChar()
	local target=game.selectedTarget or (game.ctrlGroup and game.ctrlGroup.units[1])
	if not target then 
		return 
	end
	if target==uiCtrl.lastUnit then return end
	uiCtrl.lastUnit=target
	local txt=""
	txt=txt.."N: "..target.name.."\n"
	txt=txt.."EN: "..target.energy.."/"..target.energyMax.."\n"
	txt=txt.."Ar: "..target.armor.."/"..target.armorMax.."\n"
	txt=txt.."Lvl: " .. target.level
	uiCtrl.ui.targetBref:SetText({ {color = {0,255,0},font=res.font_15}, txt})
	uiCtrl.ui.caractor:SetImage(sheet,target.quad)
end

local menuList={"mum","single","team","miner","upgrade","jounior","senior","special"}
local menu={}
for i,v in ipairs(menuList) do
	menu[v]=require "logic/ctrlMenu" (v)
end


local function newMenu(tab)
	for i=1,9 do
		local index=tostring(i)
		local setting=tab[index]
		local btn=uiCtrl.ui.ctrlGrid:GetItem(math.ceil(i/3), i%3==0 and 3 or i%3)
		
		if setting then
			if setting.quad then
				btn:SetImage(sheet2,res.icon[setting.quad[1]][setting.quad[2]])
			else
				btn:SetImage(sheet,setting.icon)
			end
			btn.OnClick=setting.func
			btn.tip:SetText(setting.text,setting.text2)
			if setting.arg then
				btn.callbackArg=setting.arg
				btn.callbackArg.caster=setting.caster 
			end

			if setting.small then
				btn:SetOptions(0,0,0, 0.08*h/28,0.08*h/28)
			elseif setting.tiny then
				btn:SetOptions(2,5,0, 0.08*h/27,0.08*h/27)
			elseif setting.tiny2 then
				btn:SetOptions(3,5,0, 0.08*h/30,0.08*h/30)
			elseif setting.icon then
				btn:SetOptions(h/25,h/25,-Pi/2, h/240,h/240,8,8)
			else
				btn:SetOptions(0,0,0, 0.08*h/32,0.08*h/32)
			end

		else
			btn:SetImage(nil)
			btn.OnClick=nil
		end
	end
end

local function makeSingleMenu(ship)
	local new=menu["single"]
	for i=6,9 do
		new[tostring(i)]=nil
	end

	if not ship.abilities or #ship.abilities==0 then return new end
	for i,v in ipairs(ship.abilities) do
		local index=tostring(v.pos)
		new[index]={}
		for k,v2 in pairs(v) do
			new[index][k]=v2
		end
	end

	return new
end

function uiCtrl:updateCtrl()
	local target=game.ctrlGroup and game.ctrlGroup.units or nil
	if target==uiCtrl.lastMenuTarget then return end
	uiCtrl.lastMenuTarget=target
	if not target then 
		newMenu({})
		return
	end
	if uiCtrl.targetMenu then
		newMenu(uiCtrl.targetMenu)
		return
	end
	
	if #target==1 then
		local singleMenu=makeSingleMenu(target[1])
		
		newMenu(singleMenu)

	elseif #target>1 then
		newMenu(menu.team)
	end
end






return uiCtrl
