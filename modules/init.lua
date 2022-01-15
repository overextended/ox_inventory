function shared.print(...) print(string.strjoin(' ', ...)) end
function shared.info(...) shared.print('^2[info]^7', ...) end
function shared.warning(...) shared.print('^3[warning]^7', ...) end
function shared.error(...) error('\n^1[error] '.. ... ..'^7', 2) end

function data(name)
	if shared.server and shared.ready == nil then return {} end
	local file = ('data/%s.lua'):format(name)
	local datafile = LoadResourceFile(shared.resource, file)
	local func, err = load(datafile, ('@@ox_inventory/%s'):format(file))

	if err then
		shared.ready = false
		error('^1'..err..'^0', 0)
	end

	return func()
end

do
	if not SetInterval or not import then
		shared.error('Ox Inventory requires the pe-lualib resource, refer to the documentation.')
	else
		local version = GetResourceMetadata('pe-lualib', 'version', 0) or 0
		if version < '1.3.0' then
			shared.error('A more recent version of pe-lualib is required.')
		end
	end

	local version = GetResourceMetadata('oxmysql', 'version', 0) or 0
	if version < '1.9.0' then
		shared.error('A more recent version of oxmysql is required.')
	end

	if not LoadResourceFile(shared.resource, 'web/build/index.html') then
		shared.error('Unable to locate ox_inventory/web/build, refer to the documentation or download a release build.')
	end
end

-- Checks if the passed job is allowed to use police-only features
function shared.isPolice(job)
	return shared.police == job or shared.police?[job] ~= nil
end

-- Disable qtarget compatibility if it isn't running
if shared.qtarget and GetResourceState('qtarget') ~= 'started' then
	shared.qtarget = false
	shared.info('qtarget is not running; disabled compatibility mode')
end

if shared.server then shared.ready = false end

local Locales = data('locales/'..shared.locale)
function shared.locale(string, ...)
	if not string then return Locales end
	if Locales[string] then return Locales[string]:format(...) end
	return string
end
