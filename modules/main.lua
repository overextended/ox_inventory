-- ESX.ServerCallbacks does not exist in the Overextended fork of ESX, so throw an error
if not ESX or ESX.ServerCallbacks then
	error('Ox Inventory requires a modified version of ESX, refer to the documentation.')
end

-- Not really necessary since it's set as a dependency
if not SetInterval or not import then
	error('Ox Inventory the pe-lualib resource, refer to the documentation.')
end

-- Disable qtarget compatibility if it isn't running
if ox.qtarget and GetResourceState('qtarget') ~= 'started' then
	ox.qtarget = false
	ox.info('qtarget is not running; disabled compatibility mode')
end

function ox.print(...) print(string.strjoin(' ', ...)) end
function ox.info(...) ox.print('^2[info]^7', ...) end
function ox.warning(...) ox.print('^3[warning]^7', ...) end

local function loadfile(path)
	local func, err = load(LoadResourceFile(ox.resource, path), ('@@ox_inventory/%s'):format(path), 't')
	if err then error('^1'..err..'^0', 0) end
	return func()
end

function data(name)
	return loadfile(('data/%s.lua'):format(name))
end

function shared(name)
	return loadfile(('modules/%s/shared.lua'):format(name))
end

local Locales = data('locales/'..ox.locale)
function ox.locale(string, ...)
	if not string then return Locales end
	if Locales[string] then return Locales[string]:format(...) end
	return string
end
