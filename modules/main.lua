local Modules = {}

ox = {
	server = IsDuplicityVersion(),
	trim = function(string) return string:match("^%s*(.-)%s*$") end,
	concat = function(...)
		if type(...) == 'string' then
			local args, ret = {...}, {}
			for i=1, #args do
				ret[i] = args[i]
			end
			return table.concat(ret, ' ')
		end
	end
}

if ox.server then
	ox.error = function(...) print(ox.concat('^1[error]^7', ...)) end
	ox.info = function(...) print(ox.concat('^2[info]^7', ...)) end
	ox.warning = function(...) print(ox.concat('^3[warning]^7', ...)) end
else
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
		local resourceFile = LoadResourceFile(Config.Resource, path)
		local func, err = load(resourceFile, path, 't', _G)
		assert(func, err == nil or '\n^1'..err..'^7')
		Modules[file] = func()
	end
	return Modules[file]
end
