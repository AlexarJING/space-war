
local col={}
local dist=m.getDistance
col.body={}

col.currentCallback=function()  end
col.preColCallback=function() print("precol")end

function col:addBody(x,y,size,parent)
	local body={
		x=x,
		y=y,
		r=size,
		parent=parent,
		vx=0,
		vy=0	
	}
	table.insert(self.body,body)

	return body
end



function col:pointTest(x,y,b) --if col return true
	if m.abs(b.x-x)> b.r or --简易计算
		m.abs(b.y-y)> b.r then return false end	
	return dist(x,y,b.x,b.y)<= b.r
end

function col:bodyTest(b1,b2)
	if m.abs(b1.x-b2.x)> b1.r+b2.r or --简易计算
		m.abs(b1.y-b2.y)> b1.r+b2.r then return false end
	return dist(b1.x,b1.y,b2.x,b2.y)<=b1.r+b2.r
end

function col:bodyPreTest(b1,b2)
	local x1=b1.x+b1.vx/30
	local y1=b1.y+b1.vy/30
	local x2=b2.x+b2.vx/30
	local y2=b2.y+b2.vy/30
	if m.abs(x1-x2)> b1.r+b2.r or --简易计算
		m.abs(y1-y2)> b1.r+b2.r then return false end
	return dist(x1,y1,x2,y2)<=b1.r+b2.r
end

function col:current()
	for _,body1 in ipairs(self.body) do
		for _,body2 in ipairs(self.body) do
			if body1~=body2 then
				if self:bodyTest(body1,body2) then
					col.currentCallback(body1,body2)
					body1.vx,body1.vy=0,0
					body2.vx,body2.vy=0,0
				end
			end
		end
	end

end

function col:preCol()
	for _,body1 in ipairs(self.body) do
		for _,body2 in ipairs(self.body) do
			if body1~=body2 then
				if self:bodyPreTest(body1,body2) then
					col.preColCallback(body1,body2)
					body1.vx,body1.vy=0,0
					body2.vx,body2.vy=0,0
				end
			end
		end
	end
end


function col:update(dt)
	
	self:current()
	self:preCol()
	for _,body in ipairs(self.body) do
		body.x=body.x+body.vx*dt
		body.y=body.y+body.vy*dt
	end
end

return col