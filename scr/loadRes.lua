love.graphics.setDefaultFilter("nearest", "nearest")
sheet = love.graphics.newImage("res/ships_t.png")
sheet2 =love.graphics.newImage("res/icon.png")
sheet3 = love.graphics.newImage("res/asteroid32.png")
res={}
--(img,fx,fy,w,h,offx,offy,lx,ly,delay,count) 

---All the animations are classes so use it by call it.
res.asteroid=Class("as",Animation)
function res.asteroid:initialize()
	Animation.initialize(self,sheet3,0,0,32,32,0,0,2047,31,0.4)
end


res.engineFire={}
for i=1,4 do
	local c=Class("ef"..tostring(i),Animation)
	res.engineFire[i]=c
	function c:initialize()
		Animation.initialize(self,sheet,28,468+(i-1)*12,8,8,4,4,71,511,0.1,4)
	end
end
---------------------------------------
res.debris={}
for i=1,2 do 
	local c=Class("de"..tostring(i),Animation)
	res.debris[i]=c
	function c:initialize()
		Animation.initialize(self,sheet,134,468+(i-1)*12,8,8,4,4,177,487,0.1,4)
	end
end
-------------------------------

for i=1,1 do 
	local c=Class("ex"..tostring(i),Animation)
	res.explosion=c
	function c:initialize()
		Animation.initialize(self,sheet,201,468+(i-1)*12,16,16,4,4,297,487,0.05,4)
	end
end
----------------------

res.asteroids={}
for i=1,5 do
	res.asteroids[i] = love.graphics.newQuad(621+(i-1)*20, 468, 16, 16, 1000, 620)
end
---------------------------------------
res.stars={}

for i=1,6 do
	local c=Class("st"..tostring(i),Animation)
	res.stars[i]=c 
	function c:initialize()
		Animation.initialize(self,sheet,134,468+(i-1)*12,8,8,4,4,177,487,0.1,4)
	end
end
------------------------------------------
res.missile=love.graphics.newQuad(26, 428, 16, 16, 1000, 620)


-------
res.ships={}
res.ships.blue={}
local k=0
for x=1,5 do
	for y=1,19 do
		k=k+1
		res.ships.blue[k]=love.graphics.newQuad(28+(x-1)*20, 42+(y-1)*20, 16, 16, 1000, 620)
	end
end
res.ships.green={}
local k=0
for x=1,5 do
	for y=1,19 do
		k=k+1
		res.ships.green[k]=love.graphics.newQuad(138+(x-1)*20, 42+(y-1)*20, 16, 16, 1000, 620)
	end
end

res.ships.red={}
local k=0
for x=1,5 do
	for y=1,19 do
		k=k+1
		res.ships.red[k]=love.graphics.newQuad(248+(x-1)*20, 42+(y-1)*20, 16, 16, 1000, 620)
	end
end

res.ships.yellow={}
local k=0
for x=1,5 do
	for y=1,19 do
		k=k+1
		res.ships.red[k]=love.graphics.newQuad(358+(x-1)*20, 42+(y-1)*20, 16, 16, 1000, 620)
	end
end

res.ships.purple={}
local k=0
for x=1,5 do
	for y=1,19 do
		k=k+1
		res.ships.purple[k]=love.graphics.newQuad(468+(x-1)*20, 42+(y-1)*20, 16, 16, 1000, 620)
	end
end

res.bullet={}

res.font_25 = love.graphics.newFont("res/lcd.ttf", 25)
res.font_20 = love.graphics.newFont("res/lcd.ttf", 20)
res.font_15 = love.graphics.newFont("res/lcd.ttf", 15)
res.font_5 = love.graphics.newFont("res/lcd.ttf", 5)

res.shipClass={}
local dir="obj/ships"
local files = love.filesystem.getDirectoryItems( dir )
for k, file in ipairs(files) do
    local dot=string.find(file, "%.")
    local name=string.sub(file,1,dot-1)
    res.shipClass[name]= require (dir.."/"..name)
end


res.weaponClass={}
local dir="obj/weapons"
local files = love.filesystem.getDirectoryItems( dir )
for k, file in ipairs(files) do
    local dot=string.find(file, "%.")
    local name=string.sub(file,1,dot-1)
    res.weaponClass[name]= require (dir.."/"..name)
end

res.otherClass={}
local dir="obj/others"
local files = love.filesystem.getDirectoryItems( dir )
for k, file in ipairs(files) do
    local dot=string.find(file, "%.")
    local name=string.sub(file,1,dot-1)
    res.otherClass[name]= require (dir.."/"..name)
end
--[[
Ship_base = require "obj.ship"
Bullet = require "obj.bullet"
Frag = require "obj.frag"

Laser= require "obj.laser"
Missile= require "obj.missile"
Tesla= require "obj.tesla"
Impulse= require "obj.impulse"
Proton= require "obj.proton"
Spark= require "obj.spark"

Ghost = require "obj.ghost"
G1= require "obj.g1"
G2= require "obj.g2"
G3= require "obj.g3"
Mum= require "obj.motherShip"
Miner = require "obj.miner"
Rnd = require "obj.rnd"

Rock= require "obj.rock"]]
local imageData = love.image.newImageData("res/icon.png")
local function pixelFunction(x, y, r, g, b, a)
    return r, g, b,r
end
imageData:mapPixel( pixelFunction )
sheet2 =love.graphics.newImage(imageData)

res.icon={}
for x=1,13 do 
	res.icon[x]={}
	for y=1,22 do
		res.icon[x][y]=love.graphics.newQuad((32+4)*(x-1), (32+2)*(y-1), 32, 32, 468, 748)
	end
end

res.cursor= love.graphics.newImage("res/cursor.png")
res.cursorSelect= love.graphics.newImage("res/cursorLocating.png")