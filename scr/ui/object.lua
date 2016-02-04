local ui={}

function ui:init()
	ui.frame=loveframes.Create("frame")
				:SetPos(5,h/18)
				:SetSize(350,150)
				:SetName(" Mission Object")

	ui.list=loveframes.Create("list", ui.frame)
		:SetPos(0,23)
		:SetSize(350,127)
		:SetPadding(2)

	for i=1,5 do
		local txt=loveframes.Create("text")
			:SetDefaultColor(0,255,0)
			:SetText("("..i.."),".."kill all the enemies" )
		ui.list:AddItem(txt)
	end
	ui.frame:SetVisible(false)
end

function ui:update()
	if not game.rule.object then return end
	self.list:RemoveItem("all")
	for i,mission in pairs(game.rule.object) do
		local txt=loveframes.Create("text")
		if mission.state==nil then
			txt:SetDefaultColor(0,255,255)
		elseif mission.state==true then
			txt:SetDefaultColor(0,255,0)
		elseif mission.state==false then
			txt:SetDefaultColor(255,0,0)
		end 
		txt:SetText("("..i..") "..mission.name )
		ui.list:AddItem(txt)
	end
	if self.temp then
		self.temp=self.temp-love.timer.getDelta()
		if self.temp<0 then
			self.temp=nil
			self.frame:SetVisible(false)
		end
	end
end

function ui:showTemp(time)
	if self.frame:GetVisible() then return end
	self.frame:SetVisible(true)
	self.temp=time or 3
end

return ui