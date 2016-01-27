local ship=res.shipClass.surveillant




function ship:fire()
	
	if self.stopFire then return end
	if not self.fireSys then
		return
	end
	for i,v in ipairs(self.fireSys) do
		if v.heat<0 and not v.dx then
			v.heat=v.cd
			local offx,offy=math.axisRot(v.posX,v.posY,self.rot)
			local wpnClass=v.wpn
			if not self.focusTarget then 
				self.focusTarget=self.target
				self.defaultDamage=v.wpn.static.damage
			elseif self.target==self.focusTarget then
				v.wpn.static.damage=v.wpn.static.damage+0.1
			elseif self.target~=self.focusTarget then
				self.focusTarget=self.target
				v.wpn.static.damage=self.defaultDamage
			end
			table.insert(game.bullet, v.wpn(self,self.x+offx,self.y+offy,self.rot+v.rot))
		end
	end
end