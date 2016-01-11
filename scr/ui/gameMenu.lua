local ui={}

function ui:init()

	ui.frame=loveframes.Create("frame")
				:SetPos(w/2,150,true)
				:SetSize(350,450)
				:SetName("Game Menu")
				:SetState("menu")
				:ShowCloseButton(false)
	ui.list=loveframes.Create("list",ui.frame)
		:SetPos(0,25)
		:SetSize(350,425)
		:SetPadding(80)
		:SetSpacing(20)
		:SetDisplayType("vertical")
		:EnableHorizontalStacking(true)
		ui.list.oneline=true
	local txt=loveframes.Create("text")
		:SetSize(180,30)
		:SetText({ {color = {0,255,0},font =res.font_20}, "        game paused"})	
	ui.list:AddItem(txt)

	local btn=loveframes.Create("button")
		:SetSize(180,30)
		:SetText("score")	
	ui.list:AddItem(btn)
	local btn=loveframes.Create("button")
		:SetSize(180,30)
		:SetText("surrender")	
	ui.list:AddItem(btn)
	local btn=loveframes.Create("button")
		:SetSize(180,30)
		:SetText("save")	
	ui.list:AddItem(btn)
	local btn=loveframes.Create("button")
		:SetSize(180,30)
		:SetText("load")	
	ui.list:AddItem(btn)
	local btn=loveframes.Create("button")
		:SetSize(180,30)
		:SetText("exit to desktop")	
	ui.list:AddItem(btn)
	local txt=loveframes.Create("text")
		:SetText({ {color = {0,255,0},font =res.font_20}, "        "})	
	ui.list:AddItem(txt)
	local btn=loveframes.Create("button")
		:SetSize(180,30)
		:SetText("return to game")
		btn.OnClick=function() 
			loveframes.SetState("none");
			game.uiCtrl.ui.gameMenu.frame:SetVisible(not game.uiCtrl.ui.gameMenu.frame.visible) ;
			game.mouseLock=false 
			game.pause=false
		end	
	ui.list:AddItem(btn)

	ui.frame:SetVisible(false)
end

function ui:reset()

end


return ui