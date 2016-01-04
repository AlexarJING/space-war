local designer={}
designer.ui={}


function designer:createUI()
	self.ui.property=loveframes.Create("frame")
					:SetPos(w-200,0)
					:SetSize(200,h)
					:SetName("Basic Property")

	self.ui.propertyList=loveframes.Create("columnlist", self.ui.property)
		:SetColumnHeight(30)
		:AddColumn("Key")
		:AddColumn("Value")
		:SetPos(1,25)
		:SetSize(200,h-25)
	self.ui.propertyList.OnRowClicked = function(parent, row, rowdata)
			self:editProperty(rowdata[1],rowdata[2])
		end
end
local keys={"name","hpMax","energy","shieldMax","armorMax","skin","size","speedMax","speedAcc","visualRange","fireRange"}

function designer:updateList()
	local tag=self.tag
	self.ui.propertyList:Clear()
	if tag=="basic" then
		for i,key in ipairs(keys) do
			self.ui.propertyList:AddRow(key, self.target[key])
		end
	elseif tag=="fire" then


	elseif tag=="engine" then

	end

end


function designer:new()
	game.ui:setVisible(false)
	game.showFog=false
	game.showAll=true
	self.target=G1("blue",500,500)
	game.bg.cam:lookAt(500,500)
	self:createUI()
	self.tag="basic"
	self:updateList()
end

function modifyProp()


end


function designer:update()

end

function designer:editProperty(key,value)
	local obj=self.target
	local frame = loveframes.Create("frame")
	frame:SetName(key.."--edit mode")
	frame:SetSize(500, 90)
	frame:CenterWithinArea(0,0,w,h)
	
	local textinput = loveframes.Create("textinput", frame)
	textinput:SetPos(5, 30)
	textinput:SetWidth(490)
	textinput:SetText(value)
	textinput.OnEnter = function(object)
		local t=type(obj[key])
		if t=="number" then
			obj[key]=tonumber(textinput:GetText())
		elseif t=="string" then
			obj[key]=textinput:GetText()
		elseif t=="boolean" then
			obj[key]= textinput:GetText()=="true"
		else
			print("not support edit type")
		end
		obj:reset()
		frame:Remove()
		designer:updateList(designer.tag)
	end
end

return designer
