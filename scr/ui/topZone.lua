local ui={}

function ui:init()
	ui.panel=loveframes.Create("panel")
	:SetSize(w,0.05*h)
	:SetPos(0,0)

	ui.buttons={}

	local text={"object [F1]","options [F2]","game menu[F3]","Alliance [F4]"}
	local func={
		function()
			game.uiCtrl.ui.object.frame:SetVisible(not game.uiCtrl.ui.object.frame.visible)
		end,
		function()
			game.uiCtrl.ui.options.frame:SetVisible(not game.uiCtrl.ui.options.frame.visible)
			loveframes.SetState("opt");game.mouseLock=true 
		end,
		function()
			game.uiCtrl.ui.gameMenu.frame:SetVisible(not game.uiCtrl.ui.gameMenu.frame.visible)
			loveframes.SetState("menu");game.mouseLock=true ;game.pause=true 
			end,
		function()
			--uiCtrl.ui.object:SetVisible(not uiCtrl.ui.object.visible) 
		end,
	}

	for i=1,4 do
		ui.buttons[i]=loveframes.Create("button",ui.panel)
			:SetSize(0.1*w,0.04*h)
			:SetPos(0.02*w+0.11*w*(i-1),0.005*h)
			:SetText(text[i])
		ui.buttons[i].OnClick=func[i]
	end

	ui.text=loveframes.Create("text",ui.panel)
		:SetSize(0.5*w,0.04*h)
		:SetPos(0.7*w,0.005*h)
		:SetText({ {color = {0,255,0},font =res.font_20}, "resource:  Mineral 10000 ;  Energy  10000"})	


end




function ui:reset()
	ui.panel:SetSize(w,0.05*h):SetPos(0,0)
	for i=1,4 do
		ui.buttons[i]:SetSize(0.15*h,0.04*h):SetPos(0.02*h+0.18*h*(i-1),0.005*h)
	end
	ui.text:SetSize(h,0.3*h):SetPos(w/2+0.1*h,0.01*h)
end


function ui:show(bool)
	ui.panel:SetVisible(bool)
end

function ui:update()
	if game.mum[1] then
		ui.text:SetText({ {color = {0,255,0},font =res.font_15}, "resource:  Mineral: "..game.mum[1].mineral.." $"})
	end
end

return ui
