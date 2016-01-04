local base=Class("base")

function base:initialize(x,y,size,collGroup)
	self.x=x
	self.y=y
	self.size=size
	self.r=self.size*8
	self.collGroup=1 --user for 1 neut for 2 npc for -1
	table.insert(game.coll, self)
end

return base