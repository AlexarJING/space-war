--if arg[2]=="-debug" then require('mobdebug').start() end
path=arg[1]
require "lib/util"
Tween=require "lib/tween"
Class=require "lib/middleclass"
Gamestate = require "lib/gamestate"
delay= require "lib/delay"
loveframes=require "lib.loveframes/init"
Animation = require "lib.animation"

resolution={ love.graphics.getDimensions() }
w=resolution[1]
h=resolution[2]
require "scr/loadRes"
--loveframes.config["DEBUG"]=true
love.mouse.setVisible(false)
--love.mouse.setRelativeMode( true )
--love.mouse.setGrabbed( true )
function love.load()
  state={}
  state.start=require("scene/start")
  Gamestate.registerEvents()
  Gamestate.switch(state.start)
end

function love.draw()
    
end
function love.update(dt) 
    delay:update(dt)
    love.window.setTitle(tostring(love.timer.getFPS()))
end 

function love.keypressed(key,isrepeat)
    loveframes.keypressed(key, isrepeat)
    game:keypressed(key)
end

function love.mousepressed(x, y, button) 
    loveframes.mousepressed(x, y, button)
    game:mousepressed(button)
end


function love.keyreleased(key)
    loveframes.keyreleased(key) 
end

function love.textinput(text)
    loveframes.textinput(text)
    game.msg.textinput(text)
end

function love.mousereleased(x, y, button)
    loveframes.mousereleased(x, y, button)
    game.cPosX,game.cPosY=game.mx,game.my
end

function love.resize()
    resolution={ love.graphics.getDimensions() }
    w=resolution[1]
    h=resolution[2]
    game.uiCtrl.ui.miniMap.map:reSize()
    game.uiCtrl:uiReset()
end