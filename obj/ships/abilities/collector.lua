return {
	["7"]={
		text="exploit/battle", --技能名称
		icon=147, ---技能图标
		func=function(obj,x,y,ship) --技能函数
			local state=ship.state=="mine"  and "battle" or "mine"
			ship:switchState(state)
		end,
	}
}