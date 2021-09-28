local M = module('utils', true)

local ServerCallbacks = {}

M.RegisterServerCallback = function(name, cb)
	ServerCallbacks['cb:'..name] = cb
end

RegisterServerEvent('ox_inventory:ServerCallback', function(name, ...)
	if ServerCallbacks[name] then
		ServerCallbacks[name](source, function(...)
			TriggerClientEvent(name, source, ...)
		end, ...)
	end
end)

return M