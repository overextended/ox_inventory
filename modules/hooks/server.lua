if not lib then return end

local eventHooks = {}
local microtime = os.microtime

local function itemFilter(filter, item, secondItem)
	local itemName = item?.name

	if not itemName or not filter[itemName] then
		if type(secondItem) ~= 'table' or not filter[secondItem.name] then
			return false
		end
	end

	return true
end

local function inventoryFilter(filter, inventory, secondInventory)
	for i = 1, #filter do
		local pattern = filter[i]

		if inventory:match(pattern) or (secondInventory and secondInventory:match(pattern)) then
			return true
		end
	end

	return false
end

function TriggerEventHooks(event, payload)
    local hooks = eventHooks[event]

    if hooks then
		local fromInventory = payload.fromInventory and tostring(payload.fromInventory) or payload.inventoryId and tostring(payload.inventoryId)
		local toInventory = payload.toInventory and tostring(payload.toInventory)

        for i = 1, #hooks do
			local hook = hooks[i]

			if hook.itemFilter and not itemFilter(hook.itemFilter, payload.fromSlot or payload.item, payload.toSlot) then
				goto skipLoop
			end

			if hook.inventoryFilter and not inventoryFilter(hook.inventoryFilter, fromInventory, toInventory) then
				goto skipLoop
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

			if event == 'createItem' then
				if type(response) == 'table' then
					payload.metadata = response
				end
			elseif response == false then
                return false
            end

			::skipLoop::
        end
    end

	if event == 'createItem' then
		return payload.metadata
	end

    return true
end

local hookId = 0

exports('registerHook', function(event, cb, options)
    if not eventHooks[event] then
        eventHooks[event] = {}
    end

	local mt = getmetatable(cb)
	mt.__index = nil
	mt.__newindex = nil
   	cb.resource = GetInvokingResource()
	hookId += 1
	cb.hookId = hookId

	if options then
		for k, v in pairs(options) do
			cb[k] = v
		end
	end

    eventHooks[event][#eventHooks[event] + 1] = cb
	return hookId
end)

local function removeResourceHooks(resource, id)
    for _, hooks in pairs(eventHooks) do
        for i = #hooks, 1, -1 do
			local hook = hooks[i]

            if hook.resource == resource and (not id or hook.id == id) then
                table.remove(hooks, i)
            end
        end
    end
end

AddEventHandler('onResourceStop', removeResourceHooks)

exports('removeHooks', function(id)
	removeResourceHooks(GetInvokingResource() or cache.resource, id)
end)
