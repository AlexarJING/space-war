local event={}
event.always={} --check everyframe
event.onSelect={} --
event.onHit={}
event.onGotHit={}
event.onClick={}
event.onKill={}
event.onDestroy={}



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
end


function event:check(eventType)
	for id=#self[eventType],1 do
		local ev=self[eventType][id]
		if ev and ev:cond(ev.cond_arg) then
			ev:act(ev.act_arg)
			if ev.isOver then
				table.remove(self[eventType], id)
			end
		end

	end

end



return event