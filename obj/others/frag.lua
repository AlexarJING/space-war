local frag=Class("frag")

function frag:initialize(x,y,rot,canvas,size)	
	self.during=2
	self.life=self.during
	self.speed=0.2
	self.selfRot=0
	self.rate=4
	self.canvas=canvas
	self.quads={}
	self.x=x
	self.y=y
	self.rot=rot
	size=size or 16
	if canvas then
		self.sw=canvas:getWidth()
		self.sh=canvas:getHeight()
		self.sizeX=self.sw/self.rate
		self.sizeY=self.sh/self.rate
		self:separate()
		self:setSpeed()
		--game.bg:camShake()
	end
	self.sw=self.sw or size
	self.sh=self.sh or size
	self.explosionAnim=res.explosion()
	self.explosionAnim.mode=1
end

function frag:separate()
	for x= 1,self.rate do
		self.quads[x]={}
		for y= 1,self.rate do
			self.quads[x][y]  = love.graphics.newQuad((x-1)*self.sizeX,(y-1)*self.sizeY,
												self.sizeX, self.sizeY, self.sw, self.sh)
		end
	end
end

function frag:setSpeed()
	self.qX={}
	self.qY={}
	self.qSpeedX={}
	self.qSpeedY={}
	self.qSRot={}
	self.qSRotSpeed={}
	for x= 1,self.rate do
		self.qSpeedX[x]={}
		self.qSpeedY[x]={}
		self.qSRotSpeed[x]={}
		self.qSRot[x]={}
		self.qX[x]={}
		self.qY[x]={}

		for y= 1,self.rate do
			self.qSRotSpeed[x][y] = love.math.random()*0.3
			self.qSRot[x][y] = 0
			self.qX[x][y]=self.x-self.sw/2+self.sizeX*x-0.5*self.sizeX
			self.qY[x][y]=self.y-self.sh/2+self.sizeY*y-0.5*self.sizeY
			self.qX[x][y],self.qY[x][y]=math.axisRot_P(self.qX[x][y],self.qY[x][y],self.x,self.y,self.rot)
			self.qSpeedX[x][y]=(self.qX[x][y]-self.x)*self.speed*love.math.random()
			self.qSpeedY[x][y]=(self.qY[x][y]-self.y)*self.speed*love.math.random()			
			self.qSRot[x][y] = self.rot
		end
	end	

end

function frag:update(dt)
	if self.destroy then return end
	self.life=self.life -1/60
	if self.life<0 then 
		self.destroy=true 
		self.dead=true
	end
	if self.canvas then
		for x= 1,self.rate do
			for y= 1,self.rate do
				self.qX[x][y]=self.qX[x][y]+self.qSpeedX[x][y]
				self.qY[x][y]=self.qY[x][y]+self.qSpeedY[x][y]
				self.qSRot[x][y]=self.qSRot[x][y]+self.qSRotSpeed[x][y]		
			end
		end
	end
	self.explosionAnim:update(dt)
end


function frag:draw()
	if self.destroy then return end
	if self.canvas then
		love.graphics.setColor(255, 255, 255, 255*self.life/self.during)
		for x= 1,self.rate do
			for y= 1,self.rate do
				love.graphics.draw(self.canvas, self.quads[x][y],self.qX[x][y], self.qY[x][y], self.qSRot[x][y],1,1,self.sizeX/2,self.sizeY/2)			
			end
		end
	end
	if self.explosionAnim.isPlay then
		love.graphics.setColor(255,255,255)
		self.explosionAnim:draw(self.x,self.y,0,self.sw/16,self.sh/16,8,8)
	end
end


return frag