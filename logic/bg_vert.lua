local bg={}
love.window.setMode( 500,800 )
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


bg.x=500
bg.y=0
function bg:update()
	
	self.y=self.y-3
	local ox,oy=self.x,self.y
	local rate=0.0001
	bg.mesh:setVertex( 1, {0,0,0+ox*rate,0+oy*rate})
	bg.mesh:setVertex( 2, {1023,0,1+ox*rate,0+oy*rate})
	bg.mesh:setVertex( 3, {1023,511,1+ox*rate,1+oy*rate})
	bg.mesh:setVertex( 4, {0,511,0+ox*rate,1+oy*rate})

	self:camUpdate()
end

function bg:draw()
	love.graphics.setColor(color.white)
	love.graphics.draw(bg.mesh,0,0,0,8,8)
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