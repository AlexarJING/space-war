local ui={}

function ui:init()
	ui.frame=loveframes.Create("frame")
				:SetPos(w/2,h/5,true)
				:SetSize(350,500)
				:SetName("Options Menu")
				:SetState("opt")
				:ShowCloseButton(false)
	ui.grid=loveframes.Create("grid",ui.frame)
		:SetPos(0,35)
		:SetRows(8)
		:SetColumns(2)
		:SetCellWidth(350/2.2)
		:SetCellHeight(50)
		:SetCellPadding(2)
		:SetItemAutoSize(false)
		ui.grid.leftRange=15

	local txt=loveframes.Create("text")
		:SetText({ {color = {0,255,0},font =res.font_20}, "resolution"})	
	ui.grid:AddItem(txt,1,1)
	local multichoice = loveframes.Create("multichoice")
	multichoice:SetSize(350/2.5,500/15)
	multichoice:AddChoice("1920x1080")
	multichoice:AddChoice("1280x760")
	multichoice:SetChoice("1280x760")
	multichoice.OnChoiceSelected = function(object, choice)
    	if choice=="1920x1080" then
    		love.window.setMode( 1920, 1080 )
    	else
    		love.window.setMode( 1280, 760 )
    	end
	end
	ui.grid:AddItem(multichoice,1,2)


	local checkbox = loveframes.Create("checkbox")
	checkbox:SetText("fullscreen")
	checkbox.OnChanged=function(obj,toggle) 
		game.fullscreen=toggle
		if game.fullscreen then 
			love.window.setMode( _, _,{fullscreen=true}) 
		else
			love.window.setMode( 1280, 720) 
		end
		resolution={ love.graphics.getDimensions() }
		w=resolution[1]
		h=resolution[2]
		game.uiCtrl.ui.miniMap.map:reSize()
		game.uiCtrl:uiReset()
		ui.frame:SetPos(w/2,h/2,true)
	end
	ui.grid:AddItem(checkbox,2,1)


	local checkbox = loveframes.Create("checkbox")
	checkbox:SetText("Auto Save the game every minuts")
	ui.grid:AddItem(checkbox,3,1)


	local checkbox = loveframes.Create("checkbox")
	checkbox:SetText("Limit mouse to the window")
	checkbox.OnChanged=function(obj,toggle)
		love.mouse.setRelativeMode( toggle )
	end
	ui.grid:AddItem(checkbox,4,1)

	local checkbox = loveframes.Create("checkbox")
	checkbox:SetText("Mute")
	ui.grid:AddItem(checkbox,2,2)


	local txt=loveframes.Create("text")
		:SetText({ {color = {0,255,0},font =res.font_20}, "system volume"})	
	ui.grid:AddItem(txt,5,1)

	local slider = loveframes.Create("slider")
	slider:SetWidth(120)
	slider:SetMinMax(0, 100)
	slider:SetValue(100)
	ui.grid:AddItem(slider,5,2)

	local txt=loveframes.Create("text")
		:SetText({ {color = {0,255,0},font =res.font_20}, "music volume"})	
	ui.grid:AddItem(txt,6,1)

	local slider = loveframes.Create("slider")
	slider:SetWidth(120)
	slider:SetMinMax(0, 100)
	slider:SetValue(100)
	ui.grid:AddItem(slider,6,2)


	local txt=loveframes.Create("text")
		:SetText({ {color = {0,255,0},font =res.font_20}, "effect volume"})	
	ui.grid:AddItem(txt,7,1)

	local slider = loveframes.Create("slider")
	slider:SetWidth(120)
	slider:SetMinMax(0, 100)
	slider:SetValue(100)
	ui.grid:AddItem(slider,7,2)

	local btn=loveframes.Create("button")
		:SetSize(150,30)
		:SetText("default")	
		btn.OnClick=function() loveframes.SetState("none");game.uiCtrl.ui.options.frame:SetVisible(false);game.mouseLock=false end
	ui.grid:AddItem(btn,8,1)

	local btn=loveframes.Create("button")
		:SetSize(150,30)
		:SetText("save")
		btn.OnClick=function() loveframes.SetState("none");game.uiCtrl.ui.options.frame:SetVisible(false);game.mouseLock=false end	
	ui.grid:AddItem(btn,8,2)

	ui.frame:SetVisible(false)
end


return ui