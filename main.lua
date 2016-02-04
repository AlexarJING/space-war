--if arg[2]=="-debug" then require('mobdebug').start() end

_,version= love.getVersion( )
MOUSE_LEFT=version==9 and "l" or 1
MOUSE_RIGHT=version==9 and "r" or 2
local compatibility= require "scr/game/compatibility"
require "lib/util"
path=arg[1]
utf8=require "lib/utf8"
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
    if type(button)=="number" then
        return love.mousepressed(x,y,compatibility[button])
    end
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
    if type(button)=="number" then
        return love.mousereleased(x,y,compatibility[button])
    end
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


function love.wheelmoved(x, y)
    if y > 0 then
        love.mousepressed(0,0,"wu")
    elseif y < 0 then
        love.mousepressed(0,0,"wd")
    end
end