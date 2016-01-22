local uiCtrl={}

function uiCtrl:init()
	uiCtrl.ui={}
	uiCtrl.ui.topInfo=require "scr/ui/topZone"
	uiCtrl.ui.miniMap=require "scr/ui/miniMap_panel"
	uiCtrl.ui.mainInfo=require "scr/ui/mainInfo"
	uiCtrl.ui.ctrlGrid=require "scr/ui/ctrlGrid"
	uiCtrl.ui.object= require "scr/ui/object"
	uiCtrl.ui.options= require "scr/ui/options"
	uiCtrl.ui.gameMenu= require "scr/ui/gameMenu"
	uiCtrl:uiInit()
	uiCtrl:uiReset()
	return self
end

function uiCtrl:uiInit()
	for k,v in pairs(self.ui) do
		v:init()
	end
end


function uiCtrl:uiReset()
	for k,v in pairs(self.ui) do
		if v.reset then
			v:reset()
		end
	end
end

function uiCtrl:setVisible(bool)
	for k,v in pairs(self.ui) do
		if v.show then
			v:show(bool)
		end
	end
end








function uiCtrl:update(dt)
	
	for k,v in pairs(self.ui) do
		if v.tween then
			v.tween:update(dt)
		end
		if v.update then
			v:update(dt)
		end
	end

	
end

function uiCtrl:draw()
	loveframes.draw()
	self.ui.ctrlGrid:draw()
	self.ui.miniMap.map:draw()
end








return uiCtrl
