local Modules = {}

module = function(file, shared)
	if not Modules[file] then
		local path = shared and file or IsDuplicityVersion() and 'server/'..file or 'client/'..file
		path = 'modules/'..path..'.lua'
		local resourceFile = LoadResourceFile(Config.Resource, path)
		local func, err = load(resourceFile, path, 't', _G)
		assert(func, err == nil or '\n^1'..err..'^7')
		Modules[file] = func()
	end
	return Modules[file]
end
