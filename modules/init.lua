IsDuplicityVersion = IsDuplicityVersion()
shared = {
	resource = GetCurrentResourceName(),
	framework = GetConvar('inventory:framework', ''),
	locale = GetConvar('inventory:locale', 'en'),
	playerslots = GetConvarInt('inventory:slots', 50),
	playerweight = GetConvarInt('inventory:weight', 30000),
	autoreload = GetConvar('inventory:autoreload', 'false') == 'true',
	trimplate = GetConvar('inventory:trimplate', 'true') == 'true',
	qtarget = GetConvar('inventory:qtarget', 'false') == 'true',
	police = json.decode(GetConvar('inventory:police', '["police", "sheriff"]')),
}

if shared.framework == '' and GetResourceState('es_extended'):find('start') then
	shared.framework = 'esx'
end

do
	if type(shared.police) == 'string' then
		shared.police = {shared.police}
	end

	local police = table.create(0, #shared.police)

	for i = 1, #shared.police do
		police[shared.police[i]] = 0
	end
	shared.police = police
end

if IsDuplicityVersion then
	server = {
		randomprices = GetConvar('inventory:randomprices', 'false') == 'true',
		versioncheck = GetConvar('inventory:versioncheck', 'true') == 'true',
		randomloot = GetConvar('inventory:randomloot', 'true') == 'true',
		evidencegrade = GetConvarInt('inventory:evidencegrade', 2),
		clearstashes = GetConvar('inventory:clearstashes', '6 MONTH'),
		vehicleloot = json.decode(GetConvar('inventory:vehicleloot', [[
			[
				["cola", 1, 1],
				["water", 1, 1],
				["garbage", 1, 2, 50],
				["panties", 1, 1, 5],
				["money", 1, 50],
				["money", 200, 400, 5],
				["bandage", 1, 1]
			]
		]])),
		dumpsterloot = json.decode(GetConvar('inventory:dumpsterloot', [[
			[
				["mustard", 1, 1],
				["garbage", 1, 3],
				["money", 1, 10],
				["burger", 1, 1]
			]
		]])),
	}
else
	client = {
		screenblur = GetConvar('inventory:screenblur', 'true') == 'true',
		keys = json.decode(GetConvar('inventory:keys', '["F2", "K", "TAB"]')),
		enablekeys = json.decode(GetConvar('inventory:enablekeys', '[249]')),
	}
end

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
