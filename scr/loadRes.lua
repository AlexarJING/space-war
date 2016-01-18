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
res.missile=love.graphics.newQuad(26, 428, 16, 16, 999, 619)


-------
local color={"blue","green","red","yellow","purple"}
res.ships={}
	for i,v in ipairs(color) do
		local k=0
		res.ships[v]={}
		for y=1,19 do
			for x=1,5 do
				k=k+1
				res.ships[v][k]=love.graphics.newQuad((i-1)*110+28+(x-1)*20, 42+(y-1)*20, 16, 16, 999, 619)
			end
		end
	end
	

res.bullet={}

res.font_25 = love.graphics.newFont("res/lcd.ttf", 25)
res.font_20 = love.graphics.newFont("res/lcd.ttf", 20)
res.font_15 = love.graphics.newFont("res/lcd.ttf", 15)
res.font_5 = love.graphics.newFont("res/lcd.ttf", 5)



res.weaponClass={}
local dir="obj/weapons"
local files = love.filesystem.getDirectoryItems( dir )
for k, file in ipairs(files) do
    local dot=string.find(file, "%.")
    local name=string.sub(file,1,dot-1)
    res.weaponClass[name]= require (dir.."/"..name)
end



res.shipClass={}
res.shipClass.base= require "obj/ships/base"
local dir="obj/ships"
local files = love.filesystem.getDirectoryItems( dir )
for k, file in ipairs(files) do
    local dot=string.find(file, "%.")
    local name=string.sub(file,1,dot-1)
    res.shipClass[name]= require (dir.."/"..name)
end




res.otherClass={}
local dir="obj/others"
local files = love.filesystem.getDirectoryItems( dir )
for k, file in ipairs(files) do
    local dot=string.find(file, "%.")
    local name=string.sub(file,1,dot-1)
    res.otherClass[name]= require (dir.."/"..name)
end


sheet2 =love.graphics.newImage("res/icon.png")

local k=0
res.icon={}
for y=1,22 do 
	for x=1,13 do
		k=k+1
		res.icon[k]=love.graphics.newQuad((32+4)*(x-1), (32+2)*(y-1), 32, 32, 468, 748)
	end
end

res.cursor= love.graphics.newImage("res/cursor.png")
res.cursorSelect= love.graphics.newImage("res/cursorLocating.png")