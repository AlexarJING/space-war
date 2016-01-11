local ui={}

function ui:init()
	ui.panal=loveframes.Create("panel")
		:SetSize(0.25*h,0.25*h)
		:SetPos(0, 0.75*h)
	ui.map= require "scr/ui/miniMap"
end

function ui:reset()

	ui.panal:SetSize(0.25*h,0.25*h):SetPos(0, 0.75*h)

end

function ui:show(bool)
	ui.panel:SetVisible(bool)
	ui.map.visible=false
end

function ui:update()
	ui.map:update()
end

return ui