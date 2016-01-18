local ui={}

function ui:init()

	ui.grid=loveframes.Create("grid")
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
		ui.grid:AddItem(btn, math.ceil(i/3), i%3+1)
		btn.tip = loveframes.Create("tooltip")
			:SetObject(btn)
			:SetText("")
	end
end

function ui:reset()
	ui.grid:SetPos(w-0.25*h,0.75*h):SetCellWidth(0.083*h):SetCellHeight(0.083*h)
	for i=1,9 do
		ui.grid:GetItem(math.ceil(i/3), i%3+1)
			:SetSize(0.08*h,0.08*h)
			:SetColor(50,255,50)
			:SetOptions(0,0,0, 0.08*h/32,0.08*h/32)
	end
	ui.lastMenuTarget=nil
end

function ui:show(bool)
	ui.grid:SetVisible(bool)
end

function ui:update()
	ui:updateCtrlGrid()
end


local menuList={"mum","single","team","miner","upgrade","jounior","senior","special"}
local menu={}
for i,v in ipairs(menuList) do
	menu[v]=require "scr/ui/ctrlMenu" (v)
end


function ui:newMenu(tab,units)

	for i=1,9 do
		local index=tostring(i)
		local setting=tab[index]
		local btn=ui.grid:GetItem(math.ceil(i/3), i%3==0 and 3 or i%3)
		
		if setting then
			if type(setting.icon)=="number" then
				btn:SetImage(sheet2,res.icon[setting.icon])
			elseif setting.icon then
				btn:SetImage(sheet,setting.icon)
			end
			
			---------------call back----------
			if units then
				btn.OnClick=function(obj,x,y,arg)					
					for i,ship in ipairs(units) do
						if arg then arg.caster=ship end
						setting.func(obj,x,y,arg)
					end
				end
			else
				btn.OnClick=setting.func
			end

			btn.tip:SetText(setting.text,setting.text2)
			

			if setting.arg then
				
				btn.callbackArg=setting.arg
				btn.callbackArg.caster=self.target[1] 

			end

		else
			btn:SetImage(nil)
			btn.OnClick=nil
		end
	end
end

function ui:fillEmptyMenu(tab)
	local new={}
	for i=1,9 do
		new[tostring(i)]=nil
	end

	for index,v in pairs(tab) do
		new[index]={}
		for key,value in pairs(v) do
			new[index][key]=value
		end
	end

	return new
end


function ui:makeSingleMenu(ship)
	local new=table.copy(menu["single"])
	if not ship.abilities  then return new end
	for index,v in pairs(ship.abilities) do
		new[index]={}
		for k,v2 in pairs(v) do
			new[index][k]=v2
		end
	end

	return new
end

function ui:updateCtrlGrid()
	if ui.newGridMenu then
		self:newMenu(ui.newGridMenu)
		ui.newGridMenu=nil
		return
	end

	local target=game.ctrlGroup and game.ctrlGroup.units or nil
	if target==ui.lastTarget then return end
	self.target=target
	ui.lastTarget=target
	if not target then 
		self:newMenu({})
		return
	end
	
	local name
	local sameName=true
	local hasAb=false
	for i,v in ipairs(target) do
		name=name or v.name
		if not table.isEmpty(v.abilities)  then hasAb=true end

		if name~=v.name then sameName=false;break end
		
	end

	if sameName then
		if hasAb then
			local singleMenu=self:makeSingleMenu(target[1])
			self:newMenu(singleMenu,target)
		else
			self:newMenu(menu.team)
		end

	else
		self:newMenu(menu.team)
	end
end

return ui