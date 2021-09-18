ox = {server = IsDuplicityVersion(), name = GetCurrentResourceName()}
local func, err = load(LoadResourceFile(ox.name, 'config.lua')..'return Config', 'config.lua', 't')
assert(func, err == nil or '\n^1'..err..'^7')
func()

data = function(name)
    local func, err = load(LoadResourceFile(ox.name, 'data/'..name..'.lua'), name, 't')
    assert(func, err == nil or '\n^1'..err..'^7')
    return func()
end

local Modules = {}
module = function(name, shared)
	if not Modules[name] then
		local path = ('modules/%s/%s'):format(name, shared and 'shared.lua' or ox.server and 'server.lua' or 'client.lua')
		local func, err = load(LoadResourceFile(ox.name, path), path, 't')
		assert(func, err == nil or '\n^1'..err..'^7')
		if shared then return func() else Modules[name] = func() end
	end
	return Modules[name]
end

if ox.server then
	ox.error = function(...) print(string.strjoin(' ', '^1[error]^7', ...)) end
	ox.info = function(...) print(string.strjoin(' ', '^2[info]^7', ...)) end
	ox.warning = function(...) print(string.strjoin(' ', '^3[warning]^7', ...)) end
end

local Locales = data('locales/'..Config.Locale)
ox.locale = function(string, ...)
	if Locales[string] then return Locales[string]:format(...) end
	return string
end

local func, err = load(LoadResourceFile(ox.name, ox.server and 'server.lua' or 'client.lua'), ox.server and 'server.lua' or 'client.lua', 't')
assert(func, err == nil or '\n^1'..err..'^7')
func()
data, module = nil, nil