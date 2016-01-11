local miniMap={}

miniMap.x=0.015*love.graphics.getHeight()
miniMap.y=0.765*love.graphics.getHeight()
miniMap.w=0.22*love.graphics.getHeight()
miniMap.h=0.22*love.graphics.getHeight()
miniMap.rate=miniMap.w/5000
miniMap.inSight = love.graphics.newCanvas(miniMap.w,miniMap.h)
miniMap.explored = love.graphics.newCanvas(miniMap.w,miniMap.h)
love.graphics.setCanvas(miniMap.explored)
love.graphics.setColor(0,255,0,100)
love.graphics.rectangle("fill", 0, 0, miniMap.w, miniMap.h)
love.graphics.setCanvas()
function miniMap:update()
	self.visible=game.uiCtrl.ui.miniMap.visible
	if game.mx>self.x and game.mx<self.x+self.w  --在miniMap内部
		and game.my>self.y and game.my<self.y+self.h then
		if love.mouse.isDown("l") or love.mouse.isDown("r") then
			local x=(game.mx-self.x)*(game.bg.limit.r-game.bg.limit.l)/self.w
			local y=(game.my-self.y)*(game.bg.limit.b-game.bg.limit.t)/self.h
			game.bg.cam.x=x
			game.bg.cam.y=y
			game.focus=nil
		end
	end
end

function miniMap:reSize()
	local nx,ny,nw,nh=0.015*h,0.765*h,0.22*h,0.22*h
	local rate=nw/self.w
	local nInSight=love.graphics.newCanvas(nw,nh)
	local nExplored = love.graphics.newCanvas(nw,nh)
	love.graphics.setCanvas(nInSight)
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.inSight, 0, 0, 0, rate, rate)
	love.graphics.setCanvas()
	love.graphics.setCanvas(nExplored)
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.explored, 0, 0, 0, rate, rate)
	love.graphics.setCanvas()
	self.inSight=nInSight
	self.explored=nExplored
	self.x=nx
	self.y=ny
	self.w=nw
	self.h=nh
	self.rate=self.w/5000
end

function miniMap:draw()
	if not self.visible then return end
	if not game.showAll then
		love.graphics.setColor(255, 255,255)
		love.graphics.draw(self.explored, self.x, self.y)
		love.graphics.draw(self.inSight, self.x, self.y)
	end

	self.inSight:clear()
	love.graphics.setCanvas(self.inSight)
	love.graphics.setColor(0,255,0,100)
	love.graphics.rectangle("fill", 0, 0, self.w, self.h)
	love.graphics.setCanvas()

	love.graphics.setColor(0,255,0)
	love.graphics.setLineWidth(2)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
	for _,ship in ipairs(game.ship) do
		local c=color[ship.side];c[4]=ship.alpha
		local x=ship.x*miniMap.w/(game.bg.limit.r-game.bg.limit.l)
		local y=ship.y*miniMap.h/(game.bg.limit.r-game.bg.limit.l)
		love.graphics.setColor(c)
		love.graphics.circle("fill", x+miniMap.x, y+miniMap.y, ship.size>5 and 5 or ship.size/2)
		if ship.side==game.userSide then
			love.graphics.setCanvas(self.inSight)
			love.graphics.setColor(0,0,0,250)
			love.graphics.circle("fill", x, y, ship.visualRange*self.rate)
			love.graphics.setCanvas()


			love.graphics.setCanvas(self.explored)
			love.graphics.setColor(0,0,0,250)
			love.graphics.circle("fill", x, y, ship.visualRange*self.rate)
			love.graphics.setCanvas()
		end
	end
	
	
	for _,rock in ipairs(game.rock) do
		local a=rock.alpha
		local x=rock.x*miniMap.w/(game.bg.limit.r-game.bg.limit.l)
		local y=rock.y*miniMap.h/(game.bg.limit.r-game.bg.limit.l)
		love.graphics.setColor(255,255,0,a)
		love.graphics.circle("fill", x+miniMap.x, y+miniMap.y, rock.size>3 and 3 or rock.size/3)
	end
	love.graphics.setColor(color.blue)
	love.graphics.setLineWidth(1)
	local w=self.w*resolution[1]/2/(game.bg.limit.r-game.bg.limit.l)/game.bg.cam.scale
	local h=self.h*resolution[2]/2/(game.bg.limit.b-game.bg.limit.t)/game.bg.cam.scale
	local x=self.w*game.bg.cam.x/(game.bg.limit.r-game.bg.limit.l)+self.x
	local y=self.h*game.bg.cam.y/(game.bg.limit.b-game.bg.limit.t)+self.y
	local l,t,r,b=x-w,y-h,x+w,y+h
	if l<self.x then l=self.x end
	if r>self.w+self.x then r=self.w+self.x end
	if t<self.y then t=self.y end
	if b>self.h+self.y then t=self.h+self.y end
	love.graphics.line(l,t,r,t,r,b,l,b,l,t)
end


return miniMap
	