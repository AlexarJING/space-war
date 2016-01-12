local ui={}

function ui:init()
	ui.panel=loveframes.Create("panel")
		:SetSize(w-0.5*h,0.20*h)
		:SetPos(0.25*h,0.8*h)

	ui.avatar=loveframes.Create("imagebutton",ui.panel)
		:SetSize(0.15*h,0.15*h)
		:SetPos(0.01*w,0.015*w)
		:SetText("")


	ui.groupIndex={}
	for i=1,10 do
		ui.groupIndex[i]=loveframes.Create("button",ui.panel)
			:SetSize(0.05*w,0.04*h)
			:SetPos(0.03*w+0.06*w*(i-1),-0.05*h)
			:SetText(tostring(i))
			:SetEnabled(false)
		ui.groupIndex[i].OnClick=function()
			game:swithGroup(game.groupStore[i])
		end
	end

	ui.groupInfo=loveframes.Create("list", ui.panel)
		:SetPos(0.22*w,0.02*h)
		:SetSize(0.48*w,0.17*h)
		:SetPadding(5)
		:SetSpacing(5)
		:EnableHorizontalStacking(true)


	ui.targetBref= loveframes.Create("text",ui.panel)
		:SetText({ {color = {0,255,0},font=res.font_15}, ""})
		:SetSize(0.145*w,0.01*h)
		:SetPos(0.1*w,0)

	ui.targetInfo=loveframes.Create("grid",ui.panel)
		:SetPos(w/4.8,0.02*h)
		:SetSize(0.48*w,0.17*h)
		:SetRows(4)
		:SetColumns(6)
		:SetCellWidth(w/14)
		:SetCellHeight(w/80)
	ui.targetInfo.showOuterBorder=true




	ui.progress=loveframes.Create("panel",ui.panel)
		:SetSize(w/2,0.16*h)
		:SetPos(0.2*w,0.02*h)
	ui.progressIcon=loveframes.Create("imagebutton",ui.progress)
		:SetPos(0.01*w, 0.02*h)
		:SetSize(0.12*h,0.12*h)
		:SetText("")

	ui.progressIcon.OnClick=function() 
		if game.ctrlGroup.units[1].queue[1] then
			table.remove(game.ctrlGroup.units[1].queue,1)
		end
	end

	ui.progressBar=loveframes.Create("progressbar",ui.progress)
		:SetPos(0.26*w, 0.03*h)
		:SetSize(w/5,0.025*h)
		:SetLerpRate(10)
		:SetMax(100)
		:SetValue(10)
	ui.progressText=loveframes.Create("text",ui.progress)
		:SetSize(w/6,h)
		:SetPos(0.09*w, 0.03*h)
		:SetText({ {color = {0,255,0},font=res.font_15}, "upgrading: armor lv.3"})

	ui.progressQueue={}
	for i=1,7 do
		ui.progressQueue[i]=loveframes.Create("imagebutton",ui.progress)
		:SetPos(0.09*w+(i-1)*0.1*h, 0.08*h)
		:SetSize(0.07*h,0.07*h)
		:SetText("")
		ui.progressQueue[i].OnClick=function() 
			if game.ctrlGroup.units[1].queue[i+1] then
				table.remove(game.ctrlGroup.units[1].queue,i+1)
			end
		end
	end

	ui.progress:SetVisible(false)
	ui.showQueue=false
end

function ui:reset()
	ui.panel:SetSize(w-0.5*h,0.20*h):SetPos(0.25*h,0.8*h)
	ui.avatar:SetSize(0.15*h,0.15*h):SetPos(0.01*h,0.025*h)
	for i=1,10 do
		ui.groupIndex[i]:SetSize(0.06*h,0.04*h):SetPos(0.5*w+0.08*h*(i-1)-0.64*h,-0.05*h)
	end
	ui.groupInfo:SetPos(0.3*h,0.015*h):SetSize(w-0.81*h,0.17*h)
	for i,b in ipairs(ui.groupInfo.children) do
		b:SetSize(0.075*h,0.075*h)
		b:SetText("")
		b:SetOptions(h/25,h/25,-Pi/2, h/240,h/240,8,8)
	end
	ui.targetBref:SetSize(0.15*h,0.01*h):SetPos(0.17*h,0.02*h)
	ui.targetInfo:SetPos(0.3*h,0.015*h):SetSize(w-0.81*h,0.17*h):SetCellWidth((w-0.81*h)/7.4):SetCellHeight(h*0.025)

	ui.progress:SetSize(w-0.81*h,0.16*h):SetPos(0.3*h,0.015*h)
	ui.progressIcon:SetPos(0.01*h, 0.02*h):SetSize(0.12*h,0.12*h):SetOptions(h/16.5,h/16.5,-Pi/2, h/140,h/140,8,8)
	ui.progressBar:SetPos(0.3*h, 0.03*h):SetSize(w-1.2*h,0.03*h)
	ui.progressText:SetSize(h/6,h):SetPos(0.14*h, 0.03*h)
	local size=0.07*h
	local step
	repeat
		step=0.07*h+(w-1.47*h)/7
		size=size*0.9
	until step>size*1.1
	for i=1,7 do
		ui.progressQueue[i]:SetPos(0.16*h+(i-1)*step, 0.08*h):SetSize(size,size)
			:SetOptions(size/2,size/2,-Pi/2, size/15,size/15,8,8)
	end
end


function ui:show(bool)
	ui.panel:SetVisible(bool)
end

local function showSelect(tag,target)
	local toggle1=false
	local toggle2=false
	local toggle3=false

	if tag=="p" then
		toggle1=true
		ui:updateQueue(target)
	elseif tag=="t" then
		toggle2=true
		ui:updateTargetInfo(target)
	elseif tag=="g" then
		ui:updateGroup(target)
		toggle3=true
	elseif tag=="o" then
		toggle2=true
		ui:updateTargetInfo(target)
	end
	ui:updateAvatar(target)
	ui.progress:SetVisible(toggle1)
	ui.targetInfo:SetVisible(toggle2)
	ui.groupInfo:SetVisible(toggle3)
	ui.avatar:SetVisible(tag~=nil)
	ui.targetBref:SetVisible(tag~=nil)
end


function ui:update()
	local target=game.ctrlGroup and game.ctrlGroup.units
	if target==nil then 
		if game.selectedTarget then showSelect("o",game.selectedTarget)
		else showSelect(nil) end
	elseif #target==1 then 
		if target[1].isMum then showSelect("p",target[1])
		else showSelect("t",target[1]) end
	elseif #target>1 then
		showSelect("g",target)
	end

end




function ui:updateAvatar(target)
	if target==nil then return end
	if #target~=0 then target=target[1] end
	local txt=""
	txt=txt.."N: "..target.name.."\n"
	txt=txt.."EN: "..target.energy.."/"..target.energyMax.."\n"
	txt=txt.."Ar: "..target.armor.."/"..target.armorMax.."\n"
	txt=txt.."Lvl: " .. target.level
	ui.targetBref:SetText({ {color = {0,255,0},font=res.font_15}, txt})
	ui.avatar:SetImage(sheet,target.quad)
end



function ui:updateTargetInfo(target)
	ui.targetInfo:RemoveAll()
	local p= loveframes.Create("text")
	p:SetText({ {color = {0,255,0},font=res.font_15},"Max. SPD."})
	ui.targetInfo:AddItem(p, 1, 1)
	local p= loveframes.Create("text")
	p:SetText({ {color = {0,255,0},font=res.font_15},target.speedMax})
	ui.targetInfo:AddItem(p, 1, 2)
	local p= loveframes.Create("text")
	p:SetText({ {color = {0,255,0},font=res.font_15},"ACC. SPD."})
	ui.targetInfo:AddItem(p, 2, 1)
	local p= loveframes.Create("text")
	p:SetText({ {color = {0,255,0},font=res.font_15},target.speedAcc})
	ui.targetInfo:AddItem(p, 2, 2)
	local p= loveframes.Create("text")
	p:SetText({ {color = {0,255,0},font=res.font_15},"Vis. Rng."})
	ui.targetInfo:AddItem(p, 3, 1)
	local p= loveframes.Create("text")
	p:SetText({ {color = {0,255,0},font=res.font_15},target.visualRange})
	ui.targetInfo:AddItem(p, 3, 2)
	local p= loveframes.Create("text")
	p:SetText({ {color = {0,255,0},font=res.font_15},"Fire Rng."})
	ui.targetInfo:AddItem(p, 4, 1)
	local p= loveframes.Create("text")
	p:SetText({ {color = {0,255,0},font=res.font_15},target.fireRange})
	ui.targetInfo:AddItem(p, 4, 2)

	for i,v in ipairs(target.fireSys) do
		local p= loveframes.Create("text")
		p:SetText({ {color = {0,255,0},font=res.font_15},i.." Wpn. Type"})
		ui.targetInfo:AddItem(p, i, 3)
		local p= loveframes.Create("text")
		p:SetText({ {color = {0,255,0},font=res.font_15},v.type})
		ui.targetInfo:AddItem(p, i, 4)
		local p= loveframes.Create("text")
		p:SetText({ {color = {0,255,0},font=res.font_15},i.." Wpn. Lvl"})
		ui.targetInfo:AddItem(p, i, 5)
		local p= loveframes.Create("text")
		p:SetText({ {color = {0,255,0},font=res.font_15},v.level})
		ui.targetInfo:AddItem(p, i, 6)
	end

end

function ui:updateQueue(target)
	local m=target.queue[1]
	if m then
		ui.progressIcon:SetImage(sheet,m.icon)
		ui.progressBar:SetMax(math.floor(m.during*10)/10)
		ui.progressBar:SetValue(math.floor(m.time*10)/10)
		ui.progressText:SetText({ {color = {0,255,0},font=res.font_15}, m.text})
	else
		ui.progressIcon:SetImage(nil)
		ui.progressBar:SetMax(0)
		ui.progressBar:SetValue(0)
		ui.progressText:SetText({ {color = {0,255,0},font=res.font_15}, "empty"})
	end
	for i=2,8 do
		local m=target.queue[i]
		if m then
			ui.progressQueue[i-1]:SetImage(sheet,m.icon)
		else
			ui.progressQueue[i-1]:SetImage(nil)
		end
	end

end




function ui:updateGroup(target)
	
	ui.groupInfo:RemoveItem("all")
	for i,v in ipairs(target) do
		local b=loveframes.Create("imagebutton")
		b:SetImage(sheet,v.quad)
		b:SetSize(0.075*h,0.075*h)
		b:SetText("")
		b:SetOptions(h/25,h/25,-Pi/2, h/240,h/240,8,8)
		b.userdata=v
		b.OnClick = function(object)
			game:select(object.userdata)
		end
		ui.groupInfo:AddItem(b)
	end
end


return ui