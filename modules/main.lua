Modules = {}

module = function(file)
	local path = IsDuplicityVersion() and 'server/'..file or 'client/'..file
	if not Modules[file] then
		Modules[file] = load(LoadResourceFile(Config.Resource, 'modules/'..path..'.lua'))()
	end
	return Modules[file]
end

shared = function(file)
	if not Modules[file] then
		Modules[file] = load(LoadResourceFile(Config.Resource, 'modules/'..file..'.lua'))()
	end
	return Modules[file]
end
