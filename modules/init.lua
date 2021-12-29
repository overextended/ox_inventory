function ox.print(...) print(string.strjoin(' ', ...)) end
function ox.info(...) ox.print('^2[info]^7', ...) end
function ox.warning(...) ox.print('^3[warning]^7', ...) end
function ox.error(...) error('\n^1[error] '.. ... ..'^7', 2) end

-- Not really necessary since it's set as a dependency
if not SetInterval or not import then
	ox.error('Ox Inventory requires the pe-lualib resource, refer to the documentation.')
else
	local version = GetResourceMetadata('pe-lualib', 'version', 0)
	if version < '1.2.0' then
		ox.error('A more recent version of pe-lualib is required.')
	end
end

-- Disable qtarget compatibility if it isn't running
if ox.qtarget and GetResourceState('qtarget') ~= 'started' then
	ox.qtarget = false
	ox.info('qtarget is not running; disabled compatibility mode')
end

function data(name)
	local func, err = load(LoadResourceFile(ox.resource, ('data/%s.lua'):format(name)))
	if err then error('^1'..err..'^0', 0) end
	return func()
end

local Locales = data('locales/'..ox.locale)
function ox.locale(string, ...)
	if not string then return Locales end
	if Locales[string] then return Locales[string]:format(...) end
	return string
end
