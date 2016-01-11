local bg={}
bg.cam=require("lib.camera").new()

bg.texture = love.graphics.newImage("res/space.jpg")
bg.texture:setWrap( "repeat", "repeat" )
bg.rate=0.2 --背景画面与现实缩放比例
bg.scale=1 --背景画面整体缩放比例
bg.quad = love.graphics.newQuad(1, 1, resolution[1]*bg.rate, resolution[2]*bg.rate, bg.texture:getWidth(), bg.texture:getHeight())
bg.x=1;bg.y=1
bg.w=resolution[1]*bg.rate;bg.h=resolution[2]*bg.rate

bg.limit={l=0,t=0,r=5000,b=5000}



function bg:update()
	
	local focus=game.focus
	local ox,oy=self.cam:position()
	if focus then 
		local cx,cy=focus.x, focus.y+h/5 		
		local dx,dy=cx-ox,cy-oy
		self.cam:move(dx*0.1,dy*0.1)
	end
	self:camUpdate()

	
	self.w=resolution[1]*bg.rate/self.scale;  --视窗大小
	self.h=resolution[2]*bg.rate/self.scale

	self.x=(ox-resolution[1]/2)*self.rate; --视窗
	self.x=self.x+(self.scale-1)*self.w/2
	self.y=(oy-resolution[2]/2)*self.rate
	self.y=self.y+(self.scale-1)*self.h/2

	self.quad:setViewport(self.x,self.y,self.w, self.h)
end

function bg:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.texture, self.quad, resolution[1]/2, resolution[2]/2, 0, 
		self.scale/self.rate, self.scale/self.rate,
		self.w/2, self.h/2)
end


function bg:camUpdate()
	if game.shake==true then 
        local maxShake = 5
        local atenuationSpeed = 4
        game.shakeIntensity = math.max(0 , game.shakeIntensity - atenuationSpeed * 0.02)
        
        if game.shakeIntensity > 0 then
            local x,y = self.cam:position()
            local dx,dy=(100 - 200*love.math.random()) * 0.02*game.shakeIntensity,
            (100 - 200*love.math.random()) * 0.02*game.shakeIntensity
            x = x + dx
            y = y + dy       
            self.cam:lookAt(x,y)
        else
            game.shake=false
        end
    end

end


function bg:camShake(int)
	int=int or 5
	game.shake=true
    game.shakeIntensity=int

end

return bg