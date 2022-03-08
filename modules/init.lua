IsDuplicityVersion = IsDuplicityVersion()
shared = {
	resource = GetCurrentResourceName(),
	framework = GetConvar('inventory:framework', 'esx'),
	locale = GetConvar('inventory:locale', 'en'),
	playerslots = GetConvarInt('inventory:slots', 50),
	playerweight = GetConvarInt('inventory:weight', 30000),
	autoreload = GetConvar('inventory:autoreload', 'false') == 'true',
	trimplate = GetConvar('inventory:trimplate', 'true') == 'true',
	qtarget = GetConvar('inventory:qtarget', 'false') == 'true',
	police = json.decode(GetConvar('inventory:police', '["police", "sheriff"]')),
}

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
	PlayerData = {}
	client = {
		screenblur = GetConvar('inventory:screenblur', 'true') == 'true',
		keys = json.decode(GetConvar('inventory:keys', '["F2", "K", "TAB"]')),
		enablekeys = json.decode(GetConvar('inventory:enablekeys', '[249]')),
		aimedfiring = GetConvar('inventory:aimedfiring', 'false') == 'true'
	}
end

function shared.print(...) print(string.strjoin(' ', ...)) end
function shared.info(...) shared.print('^2[info]^7', ...) end
function shared.warning(...) shared.print('^3[warning]^7', ...) end

-- People like ignoring errors for some reason
local function spamError(err)
	lib = nil
	shared.ready = false
	CreateThread(function()
		while true do
			Wait(2000)
			CreateThread(function()
				error(err)
			end)
		end
	end)
	error(err)
end

function data(name)
	if shared.server and shared.ready == nil then return {} end
	local file = ('data/%s.lua'):format(name)
	local datafile = LoadResourceFile(shared.resource, file)
	local func, err = load(datafile, ('@@ox_inventory/%s'):format(file))

	if err then
		shared.ready = false
		spamError(err)
	end

	return func()
end

if not lib then
	spamError('Ox Inventory requires the ox_lib resource, refer to the documentation.')
end

if not lib.checkDependency('oxmysql', '2.0.0') or not lib.checkDependency('ox_lib', '2.0.1') then
	spamError('Dependencies do not match the required versions (check oxmysql and ox_lib)')
end

if not LoadResourceFile(shared.resource, 'web/build/index.html') then
	spamError('UI has not been built, refer to the documentation or download a release build.')
end

-- Disable qtarget compatibility if it isn't running
if shared.qtarget and not GetResourceState('qtarget'):find('start') then
	shared.qtarget = false
	shared.warning(("qtarget is '%s' - ensure it is starting before ox_inventory"):format(GetResourceState('qtarget')))
end

if shared.server then shared.ready = false end

local Locales = data('locales/'..shared.locale)
function shared.locale(string, ...)
	if not string then return Locales end
	if Locales[string] then return Locales[string]:format(...) end
	return string
end
