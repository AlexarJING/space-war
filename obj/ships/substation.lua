local ship=Class("mother_2",res.shipClass.base)
local param=
{
	["isMum"]=true,
	["speedAcc"]=0.3,
	["size"]=4,
	["engineSys"]={
		[1]={
			["posX"]=-11,
			["rot"]=0,
			["anim"]=3,
			["posY"]=0,
		},
	},
	["fireSys"]={
		[1]={
			["posX"]=3,
			["level"]=5,
			["posY"]=5,
			["type"]="impulse",
			["rot"]=0,
			["cd"]=20,
			["speed"]=12,
		},
		[2]={
			["posX"]=3,
			["level"]=5,
			["posY"]=-5,
			["type"]="impulse",
			["rot"]=0,
			["cd"]=20,
			["speed"]=12,
		},
	},
	["fireRange"]=200,
	["energyMax"]=500,
	["visualRange"]=500,
	["speedMax"]=1,
	["armorMax"]=500,
	["name"]="mother_2",
	["skin"]=90,
}
function ship:initialize(side,x,y,rot)
	res.shipClass.base.initialize(self,side,x,y,rot)
	self:setParam(param)
	self:reset()
	self:getCanvas()
end

return ship