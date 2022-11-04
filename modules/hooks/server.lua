if not lib then return end

local eventHooks = {}
local microtime = os.microtime

function TriggerEventHooks(event, payload)
    local hooks = eventHooks[event]

    if hooks then
		local fromInventory = payload.fromInventory and tostring(server.inventory(payload.fromInventory).id)
		local toInventory = payload.toInventory and tostring(server.inventory(payload.toInventory).id)

        for i = 1, #hooks do
			local hook = hooks[i]
			local itemFilter = hook.itemFilter

			if itemFilter then
				if not itemFilter[payload.fromSlot.name] then
					if type(payload.toSlot) ~= 'table' or not itemFilter[payload.toSlot.name] then
						goto skipLoop
					end
				end
			end

			local inventoryFilter = hook.inventoryFilter

			if inventoryFilter then
				local matchedPattern

				for j = 1, #inventoryFilter do
					local pattern = inventoryFilter[j]

					if fromInventory:match(pattern) or toInventory:match(pattern) then
						matchedPattern = true
						break
					end
				end

				if not matchedPattern then goto skipLoop end
			end

			if hook.print then
				shared.info(('Triggering event hook "%s:%s:%s".'):format(hook.resource, event, i))
			end

			local start = microtime()
            local _, response = pcall(hooks[i], payload)
			local executionTime = microtime() - start

			if executionTime >= 100000 then
				shared.warning(('Execution of event hook "%s:%s:%s" took %.2fms.'):format(hook.resource, event, i, executionTime / 1e3))
			end

            if response == false then
                return false
            end

			::skipLoop::
        end
    end

    return true
end

exports('registerHook', function(event, cb, options)
    if not eventHooks[event] then
        eventHooks[event] = {}
    end

    rawset(cb, 'resource', GetInvokingResource())

	if options then
		for k, v in pairs(options) do
			rawset(cb, k, v)
		end
	end

    eventHooks[event][#eventHooks[event] + 1] = cb
end)

AddEventHandler('onResourceStop', function(resource)
    for _, hooks in pairs(eventHooks) do
        for i = #hooks, 1, -1 do
            if hooks[i].resource == resource then
                table.remove(hooks, i)
            end
        end
    end
end)
