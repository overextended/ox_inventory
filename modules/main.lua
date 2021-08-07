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
