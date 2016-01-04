local scene = Gamestate.new()



function scene:init()
	require "logic/game"
	game:new()
end

function scene:enter()

end



function scene:draw()
	game:draw()
	
end

function scene:update(dt)
    
    game:update(dt)
    loveframes.update(dt)

end 

function scene:leave()
	
end



return scene