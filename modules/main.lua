if ox.server then
	server = {}
else
	client = {}
end

ox.info = function(...) print(string.strjoin(' ', '^2[info]^7', ...)) end
ox.warning = function(...) print(string.strjoin(' ', '^3[warning]^7', ...)) end

if Config.Target and GetResourceState('qtarget') ~= 'started' then
	Config.Target = false
	ox.info('qtarget is not running; disabled compatibility mode')
end

local function loadfile(path)
	local func, err = load(LoadResourceFile(ox.name, path), ('@@ox_inventory/%s'):format(path), 't')
	if err then error('^1'..err..'^0', 0) end
	return func()
end

function data(name)
	return loadfile(('data/%s.lua'):format(name))
end

function shared(name)
	return loadfile(('modules/%s/shared.lua'):format(name))
end

if ESX == nil or SetInterval == nil then error('Ox Inventory requires a modified version of ESX, refer to the documentation.') end

local Locales = data('locales/'..Config.Locale)
ox.locale = function(string, ...)
	if not string then return Locales end
	if Locales[string] then return Locales[string]:format(...) end
	return string
end
