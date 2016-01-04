local bg={}
bg.cam=require("lib.camera").new()

bg.texture = love.graphics.newImage("terrain.png")
bg.texture:setWrap( "repeat", "repeat" )
local vertices={
	{0,0,0,0},
	{1024,0,1,0},
	{1024,512,1,1},
	{0,512,0,1}
}
bg.mesh = love.graphics.newMesh( vertices, bg.texture )


function bg:update()
	
	local focus=game.focus
	if not focus then return end
	local cx,cy=focus.x,focus.y
	local ox,oy=self.cam:position()
	local dx,dy=cx-ox,cy-oy
	local rate=0.0005
	bg.mesh:setVertex( 1, {0,0,0+ox*rate,0+oy*rate})
	bg.mesh:setVertex( 2, {1023,0,1+ox*rate,0+oy*rate})
	bg.mesh:setVertex( 3, {1023,511,1+ox*rate,1+oy*rate})
	bg.mesh:setVertex( 4, {0,511,0+ox*rate,1+oy*rate})

	self.cam:move(dx*0.1,dy*0.1)
	self:camUpdate()
end

function bg:draw()
	love.graphics.setColor(color.white)
	love.graphics.draw(bg.mesh,0,0,0,15*self.cam.scale,15*self.cam.scale,self.cam.x,self.cam.y)
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