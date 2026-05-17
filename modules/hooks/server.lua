if not lib then return end

local eventHooks = {}
local microtime = os.microtime

local function itemFilter(filter, item, secondItem)
	local itemName = type(item) == 'table' and item.name or item

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

local function typeFilter(filter, type)
	return filter[type] or false
end

local function triggerPostEvents(hookIds, success, payload)
	payload.hookId = nil

	for i = 1, #hookIds do
		TriggerEvent(hookIds[i], success, payload)
	end
end

local function TriggerEventHooks(event, payload)
    local hooks = eventHooks[event]
	local result = setmetatable({ ok = false }, {
		__close = function(self, err)
			if err then
				self.success = false
			end

			triggerPostEvents(self, self.success, payload)
		end
	})

    if hooks then
		local fromInventory = payload.fromInventory and tostring(payload.fromInventory) or payload.inventoryId and tostring(payload.inventoryId) or payload.shopType and tostring(payload.shopType)
		local toInventory = payload.toInventory and tostring(payload.toInventory)

        for i = 1, #hooks do
			local hook = hooks[i]
			payload.hookId = hook.hookId

			if hook.itemFilter and not itemFilter(hook.itemFilter, payload.fromSlot or payload.item or payload.itemName or payload.recipe, payload.toSlot) then
				goto continue
			end

			if hook.inventoryFilter and not inventoryFilter(hook.inventoryFilter, fromInventory, toInventory) then
				goto continue
			end

			if hook.typeFilter and not typeFilter(hook.typeFilter, payload.inventoryType or payload.shopType or payload.fromType) then
				goto continue
			end

			if hook.print then
				shared.info(('Triggering event hook "%s".'):format(hook.hookId))
			end

			if hook.__call then
				local start = microtime()
				local _, response = pcall(hook, payload)
				local executionTime = microtime() - start

				if executionTime >= 10000 then
					warn(('Execution of event hook "%s" took %.2fms.'):format(hook.hookId, executionTime / 1e3))
				end

				if event == 'createItem' then
					if type(response) == 'table' then
						payload.metadata = response
					end
				elseif response == false then
					return result
				end
			end

			result[#result + 1] = hook.hookId

			::continue::
        end
    end


	if event == 'createItem' then
		result.result = payload.metadata
	end

	result.success = true

    return result
end

exports('registerHook', function(event, ref, options)
    if not eventHooks[event] then
        eventHooks[event] = {}
    end

	local mt = ref and getmetatable(ref)
	local idx = #eventHooks[event] + 1
	local resource = GetInvokingResource()

	if mt then
		mt.__index = mt
		mt.__newindex = nil
	end

	if not ref then
		ref = options or {}
		options = nil
	end

   	ref.resource = resource
	ref.hookId = ('%s:%s:%s'):format(resource, event, idx)

	if options then
		for k, v in pairs(options) do
			ref[k] = v
		end
	end

    eventHooks[event][idx] = ref

	return ref.hookId
end)

local function removeResourceHooks(resource, id)
    for _, hooks in pairs(eventHooks) do
        for i = #hooks, 1, -1 do
			local hook = hooks[i]

            if hook.resource == resource and (not id or hook.hookId == id) then
                table.remove(hooks, i)
            end
        end
    end
end

AddEventHandler('onResourceStop', removeResourceHooks)

exports('removeHooks', function(id)
	removeResourceHooks(GetInvokingResource() or cache.resource, id)
end)

return TriggerEventHooks
