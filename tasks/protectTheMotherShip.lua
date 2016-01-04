local task={}
local enermyCD=15
local enermyTime=-1
local wave=0

function task:new()
	for i=1,200 do
		Rock(love.math.random(1,5000),love.math.random(1,5000))
	end
	game.mum[1]=Mum("blue",2500,2500)
	for i=1,20 do 
		local ship=G1:new(game.mum[1],2500,2500)
		ship.parent=game.mum[1]
		game:toDeployment(game.mum[1],ship)
	end
	for i=1,5 do 
		local miner=Miner(game.mum[1],2500,2500)
		miner.parent=game.mum[1]
		game:toDeployment(game.mum[1],miner)
		miner.state="mine"
	end	

	
	game.bg.cam:lookAt(2500,2500)
	task:newWave()
end

function task:newWave()
	wave=wave+1
	local tab={}
	for i=1, math.ceil(wave/10) do
		local rnd = love.math.random()*2*Pi
		local x,y=2500+2500*math.sin(rnd),2500+2500*math.cos(rnd)
		local mod=Rnd:new("green",x,y)
		for i=1,5+wave do
			local ship=Rnd:new("green",x,y,nil,mod)
			game:shipMove(ship,x,y,true)
			table.insert(tab, ship)
			ship.destroyCallback=function() game.money=game.money+1 end
		end
		local group = game.groupCtrl:new(tab,nil,{{2500,2500}})
		group.strategy="pursuit"
	end

end


function task:update(dt)
	enermyTime=enermyTime-dt
	if enermyTime<0 then
		enermyTime=enermyCD
		task:newWave()
	end
	if game.mum[1].dead and not task.over then
		task.over=true
		task:gameover()
	end
end

function task:gameover()
	local frame = loveframes.Create("frame")
	frame:SetName("Custom State")
	frame:SetWidth(500)
	frame:Center()
	frame:ShowCloseButton(false)
	
	local text = loveframes.Create("text", frame)
	text:SetText({ {color = color.green,font=res.font_25},"Game Over"})
	text:SetMaxWidth(490)
	text:SetPos(5, 30)
	
	local button = loveframes.Create("button", frame)
	button:SetWidth(490)
	button:SetText("ok")
	button:Center()
	button.OnClick = function(object, x, y)
		loveframes.SetState("none")
		frame:Remove()
	end
	
	button:SetY(text:GetHeight() + 35)
	frame:SetHeight(text:GetHeight() + 65)
	frame:SetState("newstate")
	
	loveframes.SetState("newstate")


end

return task