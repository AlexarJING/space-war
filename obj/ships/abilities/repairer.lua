return {
	["7"]={
		text="repaire/battle", --技能名称
		icon=145, ---技能图标
		func=function(obj,x,y,ship) --技能函数
			local state=ship.state=="repaire"  and "battle" or "repaire"
			obj.toggle=obj.toggle=="on" and "off" or "on"
			ship:switchState(state)
		end,
	}
}