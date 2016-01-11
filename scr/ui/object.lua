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


return ui