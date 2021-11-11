data = function(name)
    local func, err = load(LoadResourceFile(ox.name, 'data/'..name..'.lua'), '@@data/'..name, 't')
    assert(func, err == nil or '\n^1'..err..'^7')
    return func()
end

local Modules = {}
include = function(name, shared)
	if not Modules[name] then
		local path = ('modules/%s/%s'):format(name, shared and 'shared.lua' or ox.server and 'server.lua' or 'client.lua')
		local func, err = load(LoadResourceFile(ox.name, path), '@@'..path, 't')
		assert(func, err == nil or '\n^1'..err..'^7')
		if shared then return func() else Modules[name] = func() end
	end
	return Modules[name]
end

if ox.server then
	ox.info = function(...) print(string.strjoin(' ', '^2[info]^7', ...)) end
	ox.warning = function(...) print(string.strjoin(' ', '^3[warning]^7', ...)) end
end

if ESX == nil or SetInterval == nil or import == nil then error('Unable to locate dependencies - refer to the documentation') end

local Locales = data('locales/'..Config.Locale)
ox.locale = function(string, ...)
	if not string then return Locales end
	if Locales[string] then return Locales[string]:format(...) end
	return string
end

local func, err = load(LoadResourceFile(ox.name, ox.server and 'server.lua' or 'client.lua'), ox.server and '@@server.lua' or '@@client.lua', 't')
assert(func, err == nil or '\n^1'..err..'^7')
func()
