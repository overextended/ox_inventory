local Modules = {}

ox.concat = function(d, ...)
	if type(...) == 'string' then
		local args, ret = {...}, {}
		for i=1, #args do
			ret[i] = args[i]
		end
		return table.concat(ret, d)
	end
end

module = function(file, shared)
	local name = shared and '_'..file or file
	if not Modules[name] then
		local path = 'modules/'..file..'/'..(shared and 'shared.lua' or ox.server and 'server.lua' or 'client.lua')
		local func, err = load(LoadResourceFile(ox.name, path), path, 't')
		assert(func, err == nil or '\n^1'..err..'^7')
		Modules[name] = func()
	end
	return Modules[name]
end

data = function(file, name)
	return load(LoadResourceFile(ox.name, 'data/'..file..'.lua')..'return Data', file, 't')()
end

if ox.server then
	ox.error = function(...) print(ox.concat(' ', '^1[error]^7', ...)) end
	ox.info = function(...) print(ox.concat(' ', '^2[info]^7', ...)) end
	ox.warning = function(...) print(ox.concat(' ', '^3[warning]^7', ...)) end

	ox.ServerCallbacks = {}
	RegisterServerEvent('ox:triggerServerCallback', function(name, ...)
		ox.TriggerServerCallback(name, source, function(...)
			TriggerClientEvent(name, source, ...)
		end, ...)
	end)

	ox.RegisterServerCallback = function(name, cb)
		ox.ServerCallbacks[('cb:%s'):format(name)] = cb
	end
	
	ox.TriggerServerCallback = function(name, source, cb, ...)
		if ox.ServerCallbacks[name] then
			ox.ServerCallbacks[name](source, cb, ...)
		end
	end
else
	ox.TriggerServerCallback = function(event, cb, ...)
		local event = ('cb:%s'):format(event)
		TriggerServerEvent('ox:triggerServerCallback', event, ...)
		local p = promise.new()
		event = RegisterNetEvent(event, function(...)
			cb(...)
			p:resolve()
			RemoveEventHandler(event)
		end)
		Citizen.Await(p)
	end

	ox.playAnim = function(wait, ...)
		local args = {...}
		RequestAnimDict(args[1])
		CreateThread(function()
			repeat Wait(10) until HasAnimDictLoaded(args[1])
			TaskPlayAnim(ESX.PlayerData.ped, table.unpack(args))
			Wait(wait)
			ClearPedSecondaryTask(ESX.PlayerData.ped)
			RemoveAnimDict(args[1])
		end)
	end
end