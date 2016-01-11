local ship=Class("g1123",res.shipClass.base)
local param=
{
	["isMum"]=false,
	["speedAcc"]=0.3,
	["size"]=2,
	["engineSys"]={
		[1]={
			["posX"]=-9,
			["rot"]=0,
			["anim"]=1,
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
	["energyMax"]=300,
	["visualRange"]=500,
	["speedMax"]=5,
	["armorMax"]=100,
	["name"]="g1123",
	["skin"]=1,
}
function ship:initialize(side,x,y,rot)
	res.shipClass.base.initialize(self,side,x,y,rot)
	self:setParam(param)
	self:reset()
	self:getCanvas()
end

return ship