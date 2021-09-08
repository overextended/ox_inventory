ox = {server = IsDuplicityVersion(), name = GetCurrentResourceName()}
local func, err = load(LoadResourceFile(ox.name, 'config.lua')..'return Config', 'config.lua', 't')
assert(func, err == nil or '\n^1'..err..'^7')
local Config = func()

ox.concat = function(d, ...)
	if type(...) == 'string' then
		local args, ret = {...}, {}
		for i=1, #args do
			ret[i] = args[i]
		end
		return table.concat(ret, d)
	end
end

ox.trim = function(string)
	return string:match("^%s*(.-)%s*$")
end

data = function(file)
	return load(LoadResourceFile(ox.name, 'data/'..file..'.lua')..'return Data', file, 't')()
end

local Modules = {}
module = function(file, shared)
	local name = shared and '_'..file or file
	if not Modules[name] then
		local path = 'modules/'..file..'/'..(shared and 'shared.lua' or ox.server and 'server.lua' or 'client.lua')
		local func, err = load(LoadResourceFile(ox.name, path), path, 't')
		assert(func, err == nil or '\n^1'..err..'^7')
		if shared then return func() else Modules[name] = func() end
	end
	return Modules[name]
end

if ox.server then
	ox.error = function(...) print(ox.concat(' ', '^1[error]^7', ...)) end
	ox.info = function(...) print(ox.concat(' ', '^2[info]^7', ...)) end
	ox.warning = function(...) print(ox.concat(' ', '^3[warning]^7', ...)) end

	ox.ServerCallbacks = {}
	RegisterServerEvent('ox:TriggerServerCallback', function(name, ...)
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
	ox.AwaitServerCallback = function(event, ...)
		local event = ('cb:%s'):format(event)
		TriggerServerEvent('ox:TriggerServerCallback', event, ...)
		local p = promise.new()
		event = RegisterNetEvent(event, function(...)
			p:resolve({...})
			RemoveEventHandler(event)
		end)
		return table.unpack(Citizen.Await(p))
	end

	ox.TriggerServerCallback = function(event, cb, ...)
		local event = ('cb:%s'):format(event)
		TriggerServerEvent('ox:TriggerServerCallback', event, ...)
		event = RegisterNetEvent(event, function(...)
			cb(...)
			RemoveEventHandler(event)
		end)
	end
end

local Locales = data('locales/'..Config.Locale)
ox.locale = function(string, ...)
	if Locales[string] then return Locales[string]:format(...) end
	return string
end

local func, err = load(LoadResourceFile(ox.name, ox.server and 'server.lua' or 'client.lua'), ox.server and 'server.lua' or 'client.lua', 't')
assert(func, err == nil or '\n^1'..err..'^7')
func()