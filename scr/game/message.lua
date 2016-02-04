local msg={}
msg.content={}
msg.pos={5,0.3*h,350,200}--{l,t,w,h}
msg.font = love.graphics.newFont("res/chinese.ttf", 11)
msg.font2=love.graphics.newFont("res/chinese.ttf", 12)
msg.caretPos={5,520,5,540}
msg.caretAlpha=0
msg.input=""
msg.countOneLine=math.floor(msg.pos[3]/msg.font2:getWidth("一"))
msg.wordHeight=msg.font2:getHeight("一")
msg.language="chinese"
local function lookForShort(word)
	for i=utf8.len(word),1,-1 do
		local sub=utf8.sub(word,1,i)
		if msg.font2:getWidth(sub)<msg.pos[3]-10 and (utf8.sub(sub,i,i)==" " and msg.language~="chinese") then
			return i
		end
	end
end

function msg:send(diag)
	local word=diag.who..": "..diag.what
	local len=diag.who=="" and 0 or utf8.len(diag.who..": ")
	
	if msg.font2:getWidth(word)>self.pos[3]-10 then
		local pos=lookForShort(word)
		local newTab={
			who="",
			what=utf8.sub(diag.what,pos+1-len),
			time=0,
			color={unpack(diag.color)},
			step=diag.step
		}
		diag.what=utf8.sub(diag.what,1,pos-len)
		newTab.loc=-utf8.len(diag.what)
		
		table.insert(self.content, diag)
		if #self.content>10 then table.remove(self.content,1)end
		self:send(newTab)
	else
		table.insert(self.content, diag)
		if #self.content>10 then table.remove(self.content,1)end
	end
end


function msg:say(who,what,step)
	local diag={
		who=who,
		what=what,
		time=0,
		color={0,255,0,255},
		step=step or 0.3
	}
	msg:send(diag)
end

function msg:shout(who,what,step)
	local diag={
		who=who,
		what=what,
		time=0,
		color={255,0,0,255},
		step=step or 0.3
	}
	msg:send(diag)
end

function msg:sys(what,step)
	local diag={
		who="System",
		what=what,
		time=0,
		color={255,255,0,255},
		step=step or 0.3
	}
	msg:send(diag)
end

function msg:update()


end

function msg:draw()
	if self.isEdit then
		self.alpha=1
	else
		self.alpha=0.3
	end
	love.graphics.setColor(0, 255,0, 30*self.alpha)
	love.graphics.rectangle("fill", unpack(self.pos))
	love.graphics.setColor(0, 255,0, 50*self.alpha)
	love.graphics.line(self.pos[1],self.caretPos[2],self.pos[1]+self.pos[3],self.caretPos[2])

	for i,line in ipairs(self.content) do
		local what
		if line.step then
			line.loc=line.loc or 0
			line.loc=line.loc+line.step 
			if line.loc>utf8.len(line.what) then
				line.step=nil
			end
			if line.loc>0 then
				what=utf8.sub(line.what,1,math.floor(line.loc/2)*2)
			else
				what=""
			end
		else
			what=line.what
		end

		love.graphics.setFont(self.font2)
		love.graphics.setColor(line.color[1],line.color[2],line.color[3],line.color[4])
		if line.who=="" then
			love.graphics.print(what, self.pos[1]+5, self.pos[2]+self.wordHeight*(i-1)+5)
		else
			love.graphics.print(line.who..": "..what, self.pos[1]+5, self.pos[2]+self.wordHeight*(i-1)+5)
		end
		if i==#self.content then 
			if what==self.lastWhat then
				self.bigAlpha=self.bigAlpha-3
				if self.bigAlpha<0 then self.bigAlpha=0 end
			else
				self.bigAlpha=line.color[4]
			end
			love.graphics.setColor(line.color[1],line.color[2],line.color[3],self.bigAlpha)

			local what_up

			if line.who=="" then
				what_up=self.content[i-1].who..": "..utf8.sub(self.content[i-1].what,1,math.floor(self.content[i-1].loc)) 
				love.graphics.print(what_up, 0.3*w, 0.55*h,0,2,2)
				love.graphics.print(what, 0.3*w, 0.6*h,0,2,2)
			else
				love.graphics.print(line.who..": "..what, 0.3*w, 0.6*h,0,2,2)
			end
			if what=="" then what=what_up end
			self.lastWhat=what
		end
	end


	if self.isEdit then
		self.caretAlpha=self.caretAlpha+5
		love.graphics.setColor(255,255,255,255-self.caretAlpha)
		love.graphics.line(unpack(msg.caretPos))
	end

	love.graphics.setColor(255, 100, 255,255*self.alpha)
	love.graphics.setFont(self.font)
	love.graphics.print(self.input, self.pos[1],self.caretPos[2])

end

function msg:calCaretPos()
	local left=msg.pos[1]+msg.font:getWidth(self.input)
	self.caretPos[1]=left
	self.caretPos[3]=left
	self.caretPos[2]=self.pos[2]+self.pos[4]-20
	self.caretPos[4]=self.pos[2]+self.pos[4]-1
end

function msg.textinput(t)
    if msg.isEdit then
    	msg.input=msg.input..t
    	msg:calCaretPos()
    end
end

function msg.keypressed(key)
	if key=="return" then
		if msg.isEdit then
			msg:say("player",msg.input,0.3)
			msg.input=""
			msg:calCaretPos()
		else
			msg.isEdit=true
			game.ctrlLock=true
		end
	end

	if key=="backspace" and msg.isEdit then
		msg.input=utf8.sub(msg.input,1,-2)
		msg:calCaretPos()
	end
end

local function inRect()
	if game.mx<msg.pos[1] then return end
	if game.mx>msg.pos[1]+msg.pos[3] then return end
	if game.my<msg.pos[2]+msg.pos[4]*0.8 then return end
	if game.my>msg.pos[2]+msg.pos[4] then return end
	return true
end

function msg.mousepressed(key)

	if key=="l" then
		if inRect() then
			if not msg.isEdit then
				msg.isEdit=true
				game.keyLock=true
			end
		elseif msg.isEdit then
			msg.isEdit=false
			game.keyLock=false
		end
	end
end




msg:calCaretPos()
return msg