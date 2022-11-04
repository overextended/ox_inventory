if not lib then return end

local eventHooks = {}
local microtime = os.microtime

function TriggerEventHooks(event, payload)
    local hooks = eventHooks[event]

    if hooks then
        for i = 1, #hooks do
			local start = microtime()
            local _, response = pcall(hooks[i], payload)
			local executionTime = microtime() - start

			if executionTime >= 100000 then
				shared.warning(('Execution of event hook "%s:%s:%s" took %.2fms.'):format(hook.resource, event, i, executionTime / 1e3))
			end

            if response == false then
                return false
            end
        end
    end

    return true
end

exports('registerHook', function(event, cb)
    if not eventHooks[event] then
        eventHooks[event] = {}
    end

    rawset(cb, 'resource', GetInvokingResource())
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
