local Modules = {}

if ox.server then
	ox.error = function(...) print(string.strjoin(' ', '^1[error]^7', ...)) end
	ox.info = function(...) print(string.strjoin(' ', '^2[info]^7', ...)) end
	ox.warning = function(...) print(string.strjoin(' ', '^3[warning]^7', ...)) end

	ox.ServerCallbacks = {}
	RegisterServerEvent('ox:triggerServerCallback', function(name, ...)
		local playerId = source
	
		ox.TriggerServerCallback(name, playerId, function(...)
			TriggerClientEvent(name, playerId, ...)
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
		repeat RequestAnimDict(args[1])
			Wait(5)
		until HasAnimDictLoaded(args[1])
		CreateThread(function()
			TaskPlayAnim(ESX.PlayerData.ped, table.unpack(args))
			Wait(wait)
			ClearPedSecondaryTask(ESX.PlayerData.ped)
			RemoveAnimDict(args[1])
		end)
	end
end

module = function(file, shared)
	if not Modules[file] then
		local path = shared and file or ox.server and 'server/'..file or 'client/'..file
		path = 'modules/'..path..'.lua'
		local func, err = load(LoadResourceFile(ox.name, path), path, 't')
		assert(func, err == nil or '\n^1'..err..'^7')
		Modules[file] = func()
	end
	return Modules[file]
end

RegisterCommand('clock', function()
	local time = os.clock()
	local str
	for i=1, 10000 do
		print(string.strjoin(' ', 'aaaaaaaaaaaaaaa','bbbbbbbbbbbbb','cccccccccccc','dddddddddd'))
	end
	print(os.clock() - time)
end)
