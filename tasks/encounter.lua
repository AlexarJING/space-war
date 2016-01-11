local task={}
local enermyCD=15
local enermyTime=-1
local wave=0

function task:new()
	self.unitLimit=30
	for i=1,200 do
		res.otherClass.rock(love.math.random(1,5000),love.math.random(1,5000))
	end
	game.mum[1]=res.shipClass.motherShip("blue",500,500)


	for i=1,5 do 
		local miner=res.shipClass.miner(game.mum[1],500,500)
		game:toDeployment(game.mum[1],miner)
		miner.state="mine"
	end	
	game.bg.cam:lookAt(500,500)

	game.mum[2]=res.shipClass.motherShip("green",4500,4500)

	for i=1,5 do 
		local miner=res.shipClass.miner(game.mum[2],4500,4500)
		game:toDeployment(game.mum[2],miner)
		miner.state="mine"
	end	
	game.mum[1].state="normal"
	game.mum[2].state="normal"
	game.mum[1].enermy=game.mum[2]
	game.mum[2].enermy=game.mum[1]
	--game.mum[1].mineral=500

	--game.showFog=false
	--game.showAll=true
end


function task:enermyAi(index)
	--保持飞机与采集3:1的结构，如果钱>200升级，否则造飞机
	--7 g1 8 miner 9 unpdate

	local mum=game.mum[index]
	local spCount=0
	local attCount=0
	local attTab={}
	if #mum.queue==0 then
		local spCount=0
		for i,v in ipairs(mum.child) do
			if v.isSP then 
				spCount=spCount+1 
			else
				table.insert(attTab,v)
			end
		end
		attCount=#mum.child-spCount

		if mum.mineral>200 and attCount>15 then
			mum:castAbility(4)
		else
			
			if spCount*3<attCount then
				mum:castAbility(2)
			else
				mum:castAbility(1)
			end
		end
	end
	
	if not mum.ctrlGroup and mum.state~="normal" then
		mum.state="normal"
	end

	if mum.inVisualRange and mum.state~="protect mum" then --保护
		mum.ctrlGroup=game.groupCtrl:new(attTab,_,{{mum.target.x,mum.target.y}})
		mum.state="protect mum"
	elseif mum.state=="protect mum" then
		if not mum.inVisualRange then mum.state="normal" end
	end
	

	for i,v in ipairs(attTab) do --防御
		if v.inVisualRange and mum.state=="normal" then
			mum.ctrlGroup=game.groupCtrl:new(attTab,_,{{v.target.x,v.target.y}})
			mum.state="self defend"
		end
	end

	if mum.state=="self defend" then
		local test=false
		for i,v in ipairs(attTab) do --防御
			if v.inVisualRange then
				test=true
				break
			end
		end
		if not test then
			mum.state="normal"
		end
	end



	if attCount>3*spCount and attCount>10 and mum.state=="normal" then --试探性攻击
		mum.ctrlGroup=game.groupCtrl:new(attTab,_,{{mum.enermy.x,mum.enermy.y}})
		mum.state="try"
		
	end
	
	if mum.state=="try" then
		local focus=mum.ctrlGroup.units[math.ceil(#mum.ctrlGroup.units/2)]
		if focus and focus.targetsInRange and #focus.targetsInRange>#mum.ctrlGroup.units then
			mum.state="run away"
			game.groupCtrl:moveTo(mum.ctrlGroup,mum.x,mum.y,"direct")
		end
	end

	if mum.state=="run away" then
		if game.groupCtrl:CheckAllStop(mum.ctrlGroup.units) then
			mum.state="normal"
		end
	end


	if attCount>3*spCount and attCount>40 and mum.state=="normal" then --试探性攻击
		mum.ctrlGroup=game.groupCtrl:new(attTab,_,{{mum.enermy.x,mum.enermy.y}})
		mum.state="attack"
	end

end



function task:update(dt)

	self:enermyAi(2)
	--self:enermyAi(1)
	if game.mum[1].dead and not task.over then
		task.over=true
		task:gameover("you lose!")
	end
	if game.mum[2].dead and not task.over then
		task.over=true
		task:gameover("you win!")
	end
end

function task:gameover(word)
	local frame = loveframes.Create("frame")
	frame:SetName("Game Over")
	frame:SetWidth(500)
	frame:Center()
	frame:ShowCloseButton(false)
	
	local text = loveframes.Create("text", frame)
	text:SetText({ {color = color.green,font=res.font_25},word})
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