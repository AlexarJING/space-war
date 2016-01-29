local event={}
event.always={} --check everyframe
event.onHit={}
event.onGotHit={}
event.onKill={}
event.onDestroy={}
event.onEvent={}
event.story={}
event.storyIndex=0
event.storyTimer=0

function event:new(obj,type,cond,cond_arg,act,act_arg,isOver) --参数引发物件，事件类型，条件，条件参数，行为，行为参数，是否为单次行为
	local new={
		obj=obj,
		cond=cond,
		cond_arg=cond_arg,
		act=act,
		act_arg=act_arg,
		isOver=isOver
	}
	table.insert(self[type],new)
	return new
end


function event:check(eventType,arg)
	if eventType=="story" then
		self.storyTimer=self.storyTimer+ love.timer.getDelta()
		local ev=self[eventType][1]
		if ev and ev.cond(self.storyTimer) then
			ev:act(ev.act_arg)
			if ev.isOver then
				event:check("onEvent",ev)
				table.remove(self[eventType], 1)
				self.storyTimer=0
			end
		end
		return
	end

	for id=#self[eventType],1,-1 do
		local ev=self[eventType][id]
		if eventType=="onEvent" then ev.cond_arg=arg end
		if ev and ev.cond(ev.cond_arg) then
			ev:act(ev.act_arg)
			if ev.isOver then
				event:check("onEvent",ev)
				table.remove(self[eventType], id)
			end
		end

	end

end



return event