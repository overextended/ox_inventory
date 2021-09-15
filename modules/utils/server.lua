local M = module('utils', true)

local ServerCallbacks = {}

local TriggerServerCallback = function(name, source, cb, ...)
	if ServerCallbacks[name] then
		ServerCallbacks[name](source, cb, ...)
	end
end

RegisterServerEvent('ox:TriggerServerCallback', function(name, ...)
	local source = source
	TriggerServerCallback(name, source, function(...)
		TriggerClientEvent(name, source, ...)
	end, ...)
end)

M.RegisterServerCallback = function(name, cb)
	ServerCallbacks[('cb:%s'):format(name)] = cb
end

return M