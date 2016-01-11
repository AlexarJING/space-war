local proton=Class("proton")

function proton:initialize(parent,x,y,rot)
	self.x=x
	self.y=y
	self.speed=3
	self.rot=rot
	self.parent=parent
	self.r=20
	self.life_max=100
	self.life=self.life_max
	self.cr=0

	self.frags={}
	self.frag_cd=1
	self.frag_time=0
	self.frag_max=100
	self.frag_speed=5
	self.frag_acc=0.1
	self.roll_speed=Pi/20
	self.frag_rate=1

	self.sept=1
end


function proton:generate()
	self.frag_time=self.frag_time-1
	if self.frag_time<0 then
		for i=1,self.frag_rate do
			self.frag_time=self.frag_cd
			local r = love.math.random()*Pi*2
			table.insert(self.frags, {math.cos(r)*self.r*2,math.sin(r)*self.r*2,0,0})
			if #self.frags>self.frag_max then
				table.remove(self.frags, 1)
			end
		end
	end
end

function proton:collision(t)
	if math.getDistance(self.x,self.y,t.x,t.y)<=t.size*8+self.cr then
		return true
	end
end

function proton:hitTest()
	for i,v in ipairs(game.ship) do
		if v.side~=self.parent.side and self:collision(v) then
			--爆炸 减血
			--v:destroy()
			self.destroy=true
			self.target=v
		end		
	end

end



function proton:update()

	if self.destroy and not self.dead then 
		self.target.size=self.target.size-0.1
		self.target.rot=self.target.rot+0.3
		if self.target.size<0.3 then
			self.target:destroy()
			self.dead=true
		end
	elseif self.destroy then	
		return 
	end
	self:hitTest()
	self:generate()
	for i,v in ipairs(self.frags) do
		v[3]=v[3]+0.1
		if v[3]>self.frag_speed then v[3]=self.frag_speed end
		v[5]=v[1]
		v[6]=v[2]
		if v[1]>0 then v[1]=v[1]-v[3] end
		if v[1]<0 then v[1]=v[1]+v[3] end
		if v[2]>0 then v[2]=v[2]-v[3] end
		if v[2]<0 then v[2]=v[2]+v[3] end
		v[4]=v[4]+10
		if v[4]>255 then v[4]=255 end
		v[1],v[2]= math.axisRot(v[1],v[2],self.roll_speed)
	end

	self.x =self.x + math.cos(self.rot)*self.speed
	self.y =self.y + math.sin(self.rot)*self.speed
	self.life=self.life-1
	if self.life<0 then 
		self.destroy=true 
		self.dead=true
		if self.sept>0 then
			local p=Proton(self.parent,self.x,self.y,self.rot+math.pi/4)
			p.sept=self.sept-1
			p.life_max=self.life_max/2
			p.life=p.life_max
			p.cr=self.cr/4
			table.insert(game.bullet, p)
			local p=Proton(self.parent,self.x,self.y,self.rot-math.pi/4)
			p.sept=self.sept-1
			p.life_max=self.life_max/2
			p.life=p.life_max

			p.cr=self.cr/4
			table.insert(game.bullet, p)
			table.insert(game.frag, Frag:new(self.x,self.y,self.rot))
		end
	end
end



function proton:draw()
	if self.destroy and not self.dead  then 
		self.cr=self.cr-1
		if self.cr<0.1 then self.cr=0.1 end
		love.graphics.setColor(color.black)
		love.graphics.circle("fill", self.x, self.y, self.cr)
	elseif self.destroy then
		return
	end
	love.graphics.setPointSize(self.parent.size)
	love.graphics.setLineWidth(3)
	for i,v in ipairs(self.frags) do
		love.graphics.setColor(v[4],v[4]/255,v[4]/255)
		--love.graphics.point(v[1]+self.x, v[2]+self.y)
		love.graphics.line(v[1]+self.x, v[2]+self.y,v[5]+self.x, v[6]+self.y)

	end
	self.cr=self.cr+0.1
	if self.cr>self.r then self.cr=self.r end
	love.graphics.setColor(color.black)
	love.graphics.circle("fill", self.x, self.y, self.cr)
	love.graphics.setLineWidth(1)
	love.graphics.setColor(155, 0, 0)
	love.graphics.circle("line", self.x, self.y, self.cr)

end


return proton